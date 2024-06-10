local _created = {}

AddEventHandler("Vendor:Shared:DependencyUpdate", RetrieveVendorComponents)
function RetrieveVendorComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Vendor", {
		"Callbacks",
		"Logger",
		"PedInteraction",
		"Targeting",
		"ListMenu",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveVendorComponents()
	end)
end)

RegisterNetEvent("Vendor:Client:Set", function(vendors)
	for k, v in pairs(vendors) do
		_created[v.id] = {
			name = v.name,
			type = v.type,
		}

		if v.type == "ped" then
			PedInteraction:Add(v.id, v.model, v.position.coords, v.position.heading, 50.0, {
				{
					icon = v.iconOverride or "question",
					text = v.labelOverride or "Buy Items",
					event = "Vendor:Client:GetItems",
					data = {
						id = v.id,
					},
					minDist = 2.0,
				},
			}, v.iconOverride or "question", v.position.scenario or false, v.position.anim or nil)
		elseif v.type == "poly" then
			Targeting.Zones:AddBox(
				v.id,
				v.iconOverride or "question",
				v.position.coords,
				v.position.length,
				v.position.width,
				v.position.options,
				{
					{
						icon = v.iconOverride or "question",
						text = v.labelOverride or "Buy Items",
						event = "Vendor:Client:GetItems",
						data = {
							id = v.id,
						},
						minDist = 2.0,
						jobs = false,
					},
				},
				3.0,
				true
			)
		end
	end
end)

RegisterNetEvent(
	"Vendor:Client:Add",
	function(id, name, type, model, position, iconOverride, labelOverride, isUnique, isGlobalUnique)
		if LocalPlayer.state.loggedIn then
			_created[id] = {
				name = name,
				type = type,
				isUnique = isUnique,
				isGlobalUnique = isGlobalUnique,
			}

			if type == "ped" then
				PedInteraction:Add(id, model, position.coords, position.heading, 50.0, {
					{
						icon = iconOverride or "question",
						text = labelOverride or "Buy Items",
						event = "Vendor:Client:GetItems",
						data = {
							id = id,
						},
						minDist = 2.0,
						jobs = false,
					},
				}, iconOverride or "question", position.scenario or false, position.anim or false)
			elseif type == "poly" then
				Targeting.Zones:AddBox(
					id,
					iconOverride or "question",
					position.coords,
					position.length,
					position.width,
					position.options,
					{
						{
							icon = iconOverride or "question",
							text = labelOverride or "Buy Items",
							event = "Vendor:Client:GetItems",
							data = {
								id = id,
							},
							minDist = 2.0,
							jobs = false,
						},
					},
					3.0,
					true
				)
			end
		end
	end
)

RegisterNetEvent("Vendor:Client:Remove", function(id)
	if LocalPlayer.state.loggedIn then
		if _created[id].type == "ped" then
			PedInteraction:Remove(id)
		elseif _created[id].type == "poly" then
			Targeting.Zones:RemoveZone(id)
		end

		_created[id] = nil
	end
end)

AddEventHandler("Vendor:Client:GetItems", function(entity, data)
	Callbacks:ServerCallback("Vendor:GetItems", data.id, function(items)
		local itemList = {}

		if #items > 0 then
			for k, v in ipairs(items) do
				local itemData = Inventory.Items:GetData(v.item)
				if v.qty == -1 or v.qty > 0 then
					local stockStr = _created[data.id].isUnique and "Stock: 1 Per Person, Per Tsunami"
						or (v.qty == -1 and "Stock: ∞" or string.format("Stock: %s", v.qty))
					local priceStr = v.coin ~= nil and string.format("%s $%s", v.price, v.coin)
						or string.format("$%s", v.price)
					local descStr = string.format("%s | %s", stockStr, priceStr)

					table.insert(itemList, {
						label = itemData.label,
						description = descStr,
						event = "Vendor:Client:BuyItem",
						data = {
							id = data.id,
							index = v.index,
						},
					})
				else
					table.insert(itemList, {
						label = itemData.label,
						description = "Sold Out",
					})
				end
			end
		end

		if #itemList <= 0 then
			table.insert(itemList, {
				label = "No Items Available",
			})
		end

		ListMenu:Show({
			main = {
				label = _created[data.id].name,
				items = itemList,
			},
		})
	end)
end)

AddEventHandler("Vendor:Client:BuyItem", function(data)
	Callbacks:ServerCallback("Vendor:BuyItem", data)
end)
