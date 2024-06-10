NOCLIP_ACTIVE = false
local noclipEntity = false
local noclipMode = false

ADMIN.NoClip = {
    Toggle = function(self, mode)
        if mode ~= nil then
            noclipMode = mode
        else
            noclipMode = false
        end

        if NOCLIP_ACTIVE then
            Admin.NoClip:Stop()
        else
            Admin.NoClip:Start()
        end
    end,
    Start = function(self)
        if not NOCLIP_ACTIVE then
            noclipEntity = PlayerPedId()
            if IsPedInAnyVehicle(noclipEntity) then 
                noclipEntity = GetVehiclePedIsIn(noclipEntity, false)
            end

            if not NetworkHasControlOfEntity(noclipEntity) then
                noclipEntity = false
                return
            end

            SetEntityInvincible(noclipEntity, true)
            FreezeEntityPosition(noclipEntity, true)
            SetEntityCollision(noclipEntity, false, false)
            
            if not noclipMode then
                SetEntityVisible(noclipEntity, false, false)
    
                if noclipEntity ~= PlayerPedId() then
                    SetEntityVisible(PlayerPedId(), false, false)
                end
            end
    
            local entityCoords = GetEntityCoords(noclipEntity)
            SetFreecamEnabled(true)
            SetFreecamPosition(entityCoords.x, entityCoords.y, entityCoords.z, not noclipMode)
            NOCLIP_ACTIVE = true
        end
    end,
    Stop = function(self)
        if NOCLIP_ACTIVE then
            FreezeEntityPosition(noclipEntity, false)
            if not LocalPlayer.state.isAdmin or not LocalPlayer.state.isGodmode then
                SetEntityInvincible(noclipEntity, false)
            end
            SetEntityCollision(noclipEntity, true, true)
            SetEntityVisible(noclipEntity, true, false)

            FreezeEntityPosition(playerPed, false)
            if not LocalPlayer.state.isAdmin or not LocalPlayer.state.isGodmode then
                SetEntityInvincible(playerPed, false)
            end
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true, false)

            noclipEntity = false
            SetFreecamEnabled(false)
            noclipEntity = PlayerPedId()
            NOCLIP_ACTIVE = false
        end
    end,
    IsActive = function(self)
        return NOCLIP_ACTIVE
    end,
    GetPos = function(self)
        if NOCLIP_ACTIVE then
            return GetFreecamPosition()
        end
    end,
}

AddEventHandler('FreeCam:Update', function()
    local position = GetFreecamPosition()
    local rotation = GetFreecamRotation()

    if NOCLIP_ACTIVE and noclipEntity and not noclipMode then 
        SetEntityCoordsNoOffset(noclipEntity, position, false, false, false)
        SetEntityRotation(noclipEntity, rotation, 0, true)
    end
end)

RegisterNetEvent('Admin:Client:NoClip', function(mode)
    Callbacks:ServerCallback('Admin:NoClip', {
        active = not Admin.NoClip:IsActive()
    }, function(isAdmin)
        if isAdmin then
            Admin.NoClip:Toggle(mode)
        end
    end)
end)

RegisterNetEvent('Admin:Client:NoClipInfo', function()
    if NOCLIP_ACTIVE then
        local position = GetFreecamPosition()
        local rotation = GetFreecamRotation()
        Logger:Trace('NoClip', 'Rotation: '.. rotation)
        Logger:Trace('NoClip', 'Position: '.. position)
    end
end)