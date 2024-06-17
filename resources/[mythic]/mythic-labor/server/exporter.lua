local _items = {
	perishable = {
		{ section = "perishable", item = "lettuce", price = 1 },
		{ section = "perishable", item = "cucumber", price = 1 },
		{ section = "perishable", item = "tomato", price = 1 },
		{ section = "perishable", item = "potato", price = 1 },
		{ section = "perishable", item = "orange", price = 1 },
		{ section = "perishable", item = "peas", price = 1 },
	},
	crafting = {
		{ section = "crafting", item = "rubber", price = 1 },
		{ section = "crafting", item = "plastic", price = 1 },
		{ section = "crafting", item = "copperwire", price = 1 },
		{ section = "crafting", item = "glue", price = 1 },
		{ section = "crafting", item = "heavy_glue", price = 1 },
		{ section = "crafting", item = "scrapmetal", price = 1 },
		{ section = "crafting", item = "ironbar", price = 1 },
	},
}

AddEventHandler("Labor:Server:Startup", function()
	Wait(10000)
	local menu = {
		main = {
			label = "Goods Exporter",
			items = {
				{
					label = "Perishable Goods",
					submenu = "perishable",
				},
				{
					label = "Crafting Goods",
					submenu = "crafting",
				},
			},
		},
	}

	menu.perishable = {
		label = "Perishable Goods",
		items = {},
	}

	for k, v in ipairs(_items.perishable) do
		local itemData = Inventory.Items:GetData(v.item)
		table.insert(menu.perishable.items, {
			label = itemData.label,
			description = string.format("Export Price: $%s/unit", v.price),
			event = "Labor:Client:Export:Sell",
			data = v,
		})
	end

	menu.crafting = {
		label = "Crafting Goods",
		items = {},
	}

	for k, v in ipairs(_items.crafting) do
		local itemData = Inventory.Items:GetData(v.item)
		table.insert(menu.crafting.items, {
			label = itemData.label,
			description = string.format("Export Price: $%s/unit", v.price),
			event = "Labor:Client:Export:Sell",
			data = v,
		})
	end

	GlobalState["LaborExporter"] = menu

	Callbacks:RegisterServerCallback("Labor:Exporter:Sell", function(source, data, cb)
		local plyr = Fetch:Source(source)

		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if _items[data.section] ~= nil then
					for k, v in ipairs(_items[data.section]) do
						if data.item == v.item then
							local itemData = Inventory.Items:GetData(v.item)
							local count = Inventory.Items:GetCount(char:GetData("SID"), 1, v.item)
							if (count or 0) > 0 then
								if Inventory.Items:Remove(char:GetData("SID"), 1, v.item, count) then
									Banking.Balance:Deposit(
										Banking.Accounts:GetPersonal(char:GetData("SID")).Account,
										count * v.price,
										{
											type = "deposit",
											title = "Goods Export",
											description = string.format(
												"Sold %s x%s at $%s/unit",
												itemData.label,
												count,
												v.price
											),
										}
									)
								else
									Execute:Client(
										source,
										"Notification",
										"Error",
										string.format("Unable To Remove %s", itemData.label)
									)
								end
							else
								Execute:Client(
									source,
									"Notification",
									"Error",
									string.format("You Have No %s", itemData.label)
								)
							end
							return
						end
					end
				end
			end
		end
	end)
end)
