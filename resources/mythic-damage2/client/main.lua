AddEventHandler("Damage:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Status = exports["mythic-base"]:FetchComponent("Status")
	--Hospital = exports["mythic-base"]:FetchComponent("Hospital")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Jail = exports["mythic-base"]:FetchComponent("Jail")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Damage", {
		"Callbacks",
		"Damage",
		"Logger",
		"Notification",
		"Hud",
		"Targeting",
		"Status",
		--"Hospital",
		"Progress",
		"EmergencyAlerts",
		"PedInteraction",
		"Keybinds",
		"Jail",
		"Sounds",
		"Animations",
        "Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

        Callbacks:RegisterClientCallback("Damage:Heal", function(s)
            if s then
                LocalPlayer.state.deadData = {}
            end
            Damage:Revive()
        end)

        Callbacks:RegisterClientCallback("Damage:FieldStabalize", function(s)
            Damage:Revive(true)
        end)

        Callbacks:RegisterClientCallback("Damage:Kill", function()
            ApplyDamageToPed(LocalPlayer.state.ped, 10000)
        end)

        Callbacks:RegisterClientCallback("Damage:Admin:Godmode", function(s)
            TriggerEvent("Status:Client:Update", "godmode", s and 100 or 0)
        end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Damage", DAMAGE)
end)

RegisterNetEvent("Characters:Client:Spawned", function()
    StartThreads()
    Hud:RegisterStatus("godmode", 0, 100, "shield-quartered", "#FFBB04", false, false, {
        hideZero = true,
    })
end)

RegisterNetEvent("Characters:Client:Logout", function()
    Damage:Revive()
end)

RegisterNetEvent("Damage:Client:Heal", function()
    Damage:Revive()
end)

RegisterNetEvent('UI:Client:Reset', function(apps)
    if not LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized then
        Hud.DeathTexts:Hide()
        Hud:Dead(false)
    end
end)

DAMAGE = {
    Revive = function(self, fieldTreat)
        local player = PlayerPedId()

        if LocalPlayer.state.isDead then
            DoScreenFadeOut(1000)
            while not IsScreenFadedOut() do
                Citizen.Wait(10)
            end
        end

        local wasDead = LocalPlayer.state.isDead
        local wasMinor = LocalPlayer.state.deadData?.isMinor

        LocalPlayer.state:set("isDead", false, true)
        LocalPlayer.state:set("deadData", false, true)
        LocalPlayer.state:set("isDeadTime", false, true)
        LocalPlayer.state:set("releaseTime", false, true)

        if IsPedDeadOrDying(player) then
            local playerPos = GetEntityCoords(player, true)
            NetworkResurrectLocalPlayer(playerPos, true, true, false)
        end

        TriggerServerEvent("Damage:Server:Revived", wasMinor, fieldTreat)
        Hud:Dead(false)

        if not LocalPlayer.state.isHospitalized and wasDead then
            Hud.DeathTexts:Hide()
            ClearPedTasksImmediately(player)
            SetEntityInvincible(player, LocalPlayer.state.isAdmin and LocalPlayer.state.isGodmode or false)
        end

        if wasMinor or fieldTreat then
            SetEntityHealth(player, 125)
        else
            SetEntityHealth(player, GetEntityMaxHealth(player))
        end
        SetPlayerSprint(PlayerId(), true)
        ClearPedBloodDamage(player)
        Status:Reset()

        DoScreenFadeIn(1000)

        if not LocalPlayer.state.isHospitalized and wasDead then
            Animations.Emotes:Play("reviveshit", false, 1750, true)
        end
    end,
	Died = function(self)

	end,
	Apply = {
		StandardDamage = function(self, value, armorFirst, forceKill)
            if forceKill and not _hasKO then
                _hasKO = true
            end
            
			ApplyDamageToPed(LocalPlayer.state.ped, value, armorFirst)
		end,
    }
}