AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Input = exports["mythic-base"]:FetchComponent("Input")
	Confirm = exports["mythic-base"]:FetchComponent("Confirm")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("ListMenu", {
		"Callbacks",
		"Notification",
		"Utils",
		"ListMenu",
		"Input",
		"Confirm",
		"Sounds",
		"Wardrobe",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveWardrobeComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Wardrobe", WARDROBE)
end)

AddEventHandler("Wardrobe:Client:SaveNew", function(data)
	Input:Show("Outfit Name", "Outfit Name", {
		{
			id = "name",
			type = "text",
			options = {
				inputProps = {
					maxLength = 24,
				},
			},
		},
	}, "Wardrobe:Client:DoSave", data)
end)

AddEventHandler("Wardrobe:Client:SaveExisting", function(data)
	Callbacks:ServerCallback("Wardrobe:SaveExisting", data.index, function(state)
		if state then
			Notification:Success("Outfit Saved")
			Wardrobe:Show()
		else
			Notification:Error("Unable to Save Outfit")
		end
	end)
end)

AddEventHandler("Wardrobe:Client:DoSave", function(values, data) 
	Callbacks:ServerCallback("Wardrobe:Save", {
		index = data,
		name = values.name,
	}, function(state)
		if state then
			Notification:Success("Outfit Saved")
			Wardrobe:Show()
		else
			Notification:Error("Unable to Save Outfit")
		end
	end)
end)

AddEventHandler("Wardrobe:Client:Delete", function(data)
	Confirm:Show(string.format("Delete %s?", data.label), {
		yes = "Wardrobe:Client:Delete:Yes",
		no = "Wardrobe:Client:Delete:No",
	}, "", data.index)
end)

AddEventHandler("Wardrobe:Client:Delete:Yes", function(data)
	Callbacks:ServerCallback("Wardrobe:Delete", data, function(s)
		if s then
			Notification:Success("Outfit Deleted")
			Wardrobe:Show()
		end
	end)
end)

AddEventHandler("Wardrobe:Client:Equip", function(data)
	Callbacks:ServerCallback("Wardrobe:Equip", data.index, function(state)
		if state then
			Sounds.Play:One("outfit_change.ogg", 0.3)
			Notification:Success("Outfit Equipped")
		else
			Notification:Error("Unable to Equip Outfit")
		end
	end)
end)

RegisterNetEvent("Wardrobe:Client:ShowBitch", function(eventRoutine)
	Wardrobe:Show()
end)

WARDROBE = {
	Show = function(self)
		Callbacks:ServerCallback("Wardrobe:GetAll", {}, function(data)
			local items = {}
			for k, v in pairs(data) do
				if v.label ~= nil then
					table.insert(items, {
						label = v.label,
						description = string.format("Outfit #%s", k),
						actions = {
							{
								icon = "floppy-disks",
								event = "Wardrobe:Client:SaveExisting",
							},
							{
								icon = "shirt",
								event = "Wardrobe:Client:Equip",
							},
							{
								icon = "x",
								event = "Wardrobe:Client:Delete",
							},
						},
						data = {
							index = k,
							label = v.label,
						},
					})
				end
			end

			table.insert(items, {
				label = "Save New Outfit",
				event = "Wardrobe:Client:SaveNew",
			})

			ListMenu:Show({
				main = {
					label = "Wardrobe",
					items = items,
				},
			})
		end)
	end,
	Close = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "CLOSE_LIST_MENU",
		})
	end,
}
