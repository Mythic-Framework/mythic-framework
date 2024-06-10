local cam = nil

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Spawn' then
        exports['mythic-base']:ExtendComponent(component, SPAWN)
    end
end)

SPAWN = {
    SpawnToWorld = function(self, data, cb)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Citizen.Wait(10) end
        Callbacks:ServerCallback('Ped:CheckPed', {}, function(hasPed)
            data.Ped = hasPed.ped
            if not hasPed.existed then
                cb()
                Ped.Creator:Start(data)
            else
                cb()
                Spawn:PlacePedIntoWorld(data)
            end
        end)
    end,
    PlacePedIntoWorld = function(self, data)
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Citizen.Wait(10) end

        local player = PlayerPedId()
        SetTimecycleModifier('default')

        local model = `mp_f_freemode_01`
        if tonumber(data.Gender) == 0 then
            model = `mp_m_freemode_01`
        end

        if data.Ped.model ~= "" then
            model = GetHashKey(data.Ped.model)
        end

        RequestModel(model)

        while not HasModelLoaded(model) do
          Citizen.Wait(500)
        end
        SetPlayerModel(PlayerId(), model)
        player = PlayerPedId()
        LocalPlayer.state.ped = player
        SetPedDefaultComponentVariation(player)
        SetEntityAsMissionEntity(player, true, true)
        SetModelAsNoLongerNeeded(model)

        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)

        NetworkSetEntityInvisibleToNetwork(player, false)
        SetEntityVisible(player, true)
        SetPlayerInvincible(player, false)

        cam = nil

        SetCanAttackFriendly(player, true, true)
        NetworkSetFriendlyFireOption(true)

        SetEntityMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), data.HP or 200)
        DisplayHud(true)
        SetNuiFocus(false, false)

        LocalPed = LocalPlayer.state.Character:GetData("Ped")
        Ped:ApplyToPed(LocalPed)
        if data.action ~= nil then
            FreezeEntityPosition(player, false)
            TriggerEvent(data.action, data.data)
        else
            SetEntityCoords(player, data.spawn.location.x + 0.0, data.spawn.location.y + 0.0, data.spawn.location.z + 0.0)

            Citizen.Wait(200)
            SetEntityHeading(player, data.spawn.location.h)

            local time = GetGameTimer()
            while (not HasCollisionLoadedAroundEntity(player) and (GetGameTimer() - time) < 10000) do
                Citizen.Wait(100)
            end

            FreezeEntityPosition(player, false)

            DoScreenFadeIn(500)
        end

        Citizen.SetTimeout(500, function()
            SetPedArmour(player, data.Armor)
        end)

        TransitionFromBlurred(500)
    end
}

