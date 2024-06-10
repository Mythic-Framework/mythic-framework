AddEventHandler("Input:Shared:DependencyUpdate", RetrieveInputComponents)
function RetrieveInputComponents()
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Input = exports["mythic-base"]:FetchComponent("Input")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Input", {
		"UISounds",
		"Input",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveInputComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Input", INPUT)
end)

-- RegisterNetEvent("Input:Client:Test", function()
-- 	Input:Show(
-- 		"Test Input",
-- 		"Input Label",
-- 		{
-- 			{
-- 				id = "test",
-- 				type = "text",
-- 				options = {
-- 					inputProps = {
-- 						maxLength = 2,
-- 					},
-- 				},
-- 			},
-- 			{
-- 				id = "test2",
-- 				type = "number",
-- 				options = {
-- 					inputProps = {
-- 						maxLength = 2,
-- 					},
-- 				},
-- 			},
-- 			{
-- 				id = "test3",
-- 				type = "multiline",
-- 				options = {},
-- 			},
-- 		},
-- 		"Input:Client:InputTest",
-- 		{
-- 			test = "penis",
-- 		}
-- 	)
-- end)

-- AddEventHandler("Input:Client:InputTest", function(values, data)
-- 	print(json.encode(values))
-- 	print(json.encode(data))
-- end)

RegisterNUICallback("Input:Submit", function(data, cb)
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerEvent(data.event, data.values, data.data)
	Input:Close()
	cb("ok")
end)

RegisterNUICallback("Input:Close", function(data, cb)
	UISounds.Play:FrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	Input:Close()
	TriggerEvent("Input:Closed")
	cb("ok")
end)

INPUT = {
	Show = function(self, title, label, inputs, event, data)
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = "SHOW_INPUT",
			data = {
				title = title,
				label = label,
				inputs = inputs,
				event = event,
				data = data,
			},
		})
	end,
	Close = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "CLOSE_INPUT",
		})
	end,
}
