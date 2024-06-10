AddEventHandler("Confirm:Shared:DependencyUpdate", RetrieveConfirmComponents)
function RetrieveConfirmComponents()
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Confirm = exports["mythic-base"]:FetchComponent("Confirm")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Confirm", {
		"UISounds",
		"Confirm",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveConfirmComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Confirm", CONFIRM)
end)

-- RegisterNetEvent("Confirm:Client:Test", function()
-- 	Confirm:Show(
-- 		"Test Input",
-- 		{
-- 			yes = "Confirm:Test:Yes",
-- 			no = "Confirm:Test:No",
-- 		},
-- 		"This is a test confirm dialog, neat",
-- 		{
-- 			test = "penis",
-- 		}
-- 	)
-- end)

-- AddEventHandler("Confirm:Test:Yes", function(data)
-- 	print("Confirm: Yes")
-- end)

-- AddEventHandler("Confirm:Test:No", function(data)
-- 	print("Confirm: No")
-- end)

RegisterNUICallback("Confirm:Yes", function(data, cb)
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	if data.event then
		TriggerEvent(data.event, data.data)
	end
	Confirm:Close()
	cb("ok")
end)

RegisterNUICallback("Confirm:No", function(data, cb)
	UISounds.Play:FrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	if data and data.event then
		TriggerEvent(data.event, data.data)
	end
	Confirm:Close()
	cb("ok")
end)

CONFIRM = {
	Show = function(self, title, events, description, data, denyLabel, acceptLabel)
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = "SHOW_CONFIRM",
			data = {
				title = title,
				yes = events.yes,
				no = events.no,
				description = description,
				data = data,
				denyLabel = denyLabel,
				acceptLabel = acceptLabel,
			},
		})
	end,
	Close = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "CLOSE_CONFIRM",
		})
	end,
}
