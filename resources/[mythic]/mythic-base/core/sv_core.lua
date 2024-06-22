COMPONENTS.Core = {
	Shutdown = function(self, reason)
		COMPONENTS.Logger:Critical("Core", "Shutting Down Core, Reason: " .. reason, {
			console = true,
			file = true,
		})

		Wait(1000) -- Need wait period so logging can finish
	    os.exit()
	end,
	DropAll = function(self)
		for k, v in pairs(COMPONENTS.Players) do
			if v ~= nil then
				DropPlayer(
					v:GetData("Source"),
					"⛔ Server Restarting ⛔ Due to a pending restart, you've been dropped from the server. Please ❗❗❗RESTART FIVEM❗❗❗ and reconnect in a few minutes."
				)
			end
		end
	end,
}

AddEventHandler("Core:Server:ForceAllSave", function()
	COMPONENTS.Queue.Utils:CloseAndDrop()
	COMPONENTS.Core.DropAll()
	TriggerEvent("Core:Server:ForceSave")
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	if eventData.secondsRemaining <= 60 then
		COMPONENTS.Queue.Utils:CloseAndDrop()
		COMPONENTS.Core.DropAll()
		TriggerEvent("Core:Server:ForceSave")
	elseif not GlobalState["RestartLockdown"] and eventData.secondsRemaining <= (60 * 30) then
		GlobalState["RestartLockdown"] = true
	end

	-- COMPONENTS.Chat.Send.System:Broadcast( -- TX Admin Sends them
	-- 	string.format("Server Restart In %s Minutes", math.floor(eventData.secondsRemaining / 60))
	-- )
end)

AddEventHandler("Core:Server:StartupReady", function()
	CreateThread(function()
		while not exports or exports[GetCurrentResourceName()] == nil do
			Wait(1)
		end

		TriggerEvent(
			"Database:Server:Initialize",
			COMPONENTS.Convar.AUTH_URL.value,
			COMPONENTS.Convar.AUTH_DB.value,
			COMPONENTS.Convar.GAME_URL.value,
			COMPONENTS.Convar.GAME_DB.value
		)
		while not COMPONENTS.Proxy.DatabaseReady do
			Wait(1)
		end

		TriggerEvent("Proxy:Shared:RegisterReady")
		for k, v in pairs(COMPONENTS) do
			TriggerEvent("Proxy:Shared:ExtendReady", k)
		end

		Wait(1000)

		COMPONENTS.Proxy.ExportsReady = true
		TriggerEvent("Proxy:Shared:ExportsReady")

		SetupAPIHandler()
		return
	end)
end)

CreateThread(function()
	while true do
		GlobalState["OS:Time"] = os.time()
		Wait(1000)
	end
end)

AddEventHandler("Database:Server:Ready", function(db)
	if COMPONENTS.Database == nil and db ~= nil then
		COMPONENTS.Database = db
	end
	COMPONENTS.Proxy.DatabaseReady = true
	TriggerEvent("Core:Shared:Ready")
end)

RegisterNetEvent("Core:Server:ResourceStopped", function(resource)
	local src = source
	if resource == "mythic-pwnzor" then
		COMPONENTS.Punishment.Ban:Source(src, -1, "Pwnzor Resource Stopped", "Pwnzor")
	end
end)
