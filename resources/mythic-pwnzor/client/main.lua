local _r = false

AddEventHandler("Pwnzor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Pwnzor", {
		"Callbacks",
		"Notification",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		if not _r then
			_r = true
			RegisterEvents()
			RegisterCommands()

			-- Callbacks:ServerCallback("Commands:ValidateAdmin", {}, function(isAdmin)
			-- 	if not isAdmin then
			-- 		Citizen.CreateThread(function()
			-- 			while _r do
			-- 				Citizen.Wait(1)
			-- 				local ped = PlayerPedId()
			-- 				SetPedInfiniteAmmoClip(ped, false)
			-- 				SetEntityInvincible(ped, false)
			-- 				SetEntityCanBeDamaged(ped, true)
			-- 				ResetEntityAlpha(ped)
			-- 				local fallin = IsPedFalling(ped)
			-- 				local ragg = IsPedRagdoll(ped)
			-- 				local parac = GetPedParachuteState(ped)
			-- 				if parac >= 0 or ragg or fallin then
			-- 					SetEntityMaxSpeed(ped, 80.0)
			-- 				else
			-- 					SetEntityMaxSpeed(ped, 7.1)
			-- 				end
			-- 			end
			-- 		end)
			-- 	end
			-- end)
		end
	end)
end)

AddEventHandler("onResourceStart", function(resourceName)
	if GetGameTimer() >= 10000 then
		TriggerServerEvent("Pwnzor:Server:ResourceStarted", resourceName)
	end
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Pwnzor:Server:ResourceStopped", resourceName)
end)
