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
	Admin = exports['mythic-base']:FetchComponent('Admin')
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
		"Admin",
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

AddEventHandler("Wardrobe:Client:shareOutfit", function(data)
	Callbacks:ServerCallback("Wardrobe:getOutfitById", data.index, function(outfit)

		if not outfit then
			Notification:Error('Outfit cannot be shared.')
			return
		end

		Callbacks:ServerCallback('Wardrobe:ExportClothing', outfit, function(exported, errorMsg)
			if not exported then
				Notification:Error(errorMsg or 'Something bad happened, please try again.')
				return
			end

			Notification:Success('Exported clothing outfit, the code was copied to the clipboard.')

			Admin:CopyClipboard(tostring(exported))
		end)
	end)
end)

AddEventHandler("Wardrobe:Client:ApplySharedOutfit", function(Label, Code)
	Callbacks:ServerCallback("Wardrobe:GetExportClothingByCode", Code, function(outfit)

		if not outfit then
			Notification:Error('Code does not exist')
			return
		end
		
		local data = {
			label = Label,
			outfitdata = outfit,
		}

		Callbacks:ServerCallback("Wardrobe:SaveFromExportedOutfit", data, function(done)
			if not done then
				Notification:Error('Fail to add outfit to wardrobe , try again.')
				return
			end
		end)

		Notification:Success('Outfit Added to wardrobe.')
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
								icon = "rotate",
								event = "Wardrobe:Client:SaveExisting",
							},
							{
								icon = "shirt",
								event = "Wardrobe:Client:Equip",
							},
							{
								icon = "upload",
								event = "Wardrobe:Client:shareOutfit",
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