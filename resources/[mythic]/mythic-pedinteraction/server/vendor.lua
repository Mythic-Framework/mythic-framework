local _created = {}
local _bought = {}
local _globalBought = {}

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

AddEventHandler("Vendor:Shared:DependencyUpdate", RetrieveVendorComponents)
function RetrieveVendorComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
	Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Vendor", {
		"Fetch",
		"Callbacks",
		"Middleware",
		"Logger",
		"Reputation",
		"Crypto",
		"Wallet",
		"Inventory",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveVendorComponents()

		Middleware:Add("Characters:Spawning", function(source)
			local tmp = {}
			for k, v in pairs(_created) do
				tmp[v.id] = {
					id = v.id,
					type = v.type,
					name = v.name,
					model = v.model,
					position = v.position,
					iconOverride = v.iconOverride,
					labelOverride = v.labelOverride,
				}
			end
			TriggerClientEvent("Vendor:Client:Set", source, tmp)
		end, 5)

		Callbacks:RegisterServerCallback("Vendor:GetItems", function(source, data, cb)
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if _created[data] ~= nil then
						local itms = {}

						local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")
						for k, v in ipairs(_created[data].items) do
							if
								(v.rep == nil or Reputation:GetLevel(source, v.rep) >= (v.repLvl or 1))
								and (not v.vpn or hasVpn)
								and (not _created[data].isUnique or (_bought[data][source] == nil or _bought[data][source][v.item] == nil or _bought[data][source][v.item] < _created[data].isUnique))
								and (not _created[data].isGlobalUnique or _globalBought[data][source] == nil or _globalBought[data][source] < _created[data].isGlobalUnique)
								and (
									not v.requireCurrency
									or v.requireCurrency
										and ((v.coin ~= nil and Crypto:Has(source, v.coin, v.price)) or (v.coin == nil and Wallet:Has(
											source,
											v.price
										)))
								)
							then
								v.index = k
								table.insert(itms, v)
							end
						end

						cb(itms)
					else
						cb({})
					end
				else
					cb({})
				end
			else
				cb({})
			end
		end)

		Callbacks:RegisterServerCallback("Vendor:BuyItem", function(source, data, cb)
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if _created[data.id] ~= nil then
						local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")
						local itemData = _created[data.id].items[data.index]

						if itemData ~= nil and (itemData.qty == -1 or itemData.qty > 0) then
							if
								(
									itemData.rep == nil
									or Reputation:GetLevel(source, itemData.rep) >= (itemData.repLvl or 1)
								)
								and (not itemData.vpn or hasVpn)
								and (not _created[data.id].isUnique or _bought[data.id] == nil or _bought[data.id][source] == nil or _bought[data.id][source][itemData.item] == nil or _bought[data][source][itemData.item] < _created[data.id].isUnique)
								and (not _created[data.id].isGlobalUnique or _globalBought[data.id][source] == nil or _globalBought[data.id][source] < _created[data.id].isGlobalUnique)
								and (
									not _created[data.id].requireCurrency
									or _created[data.id].requireCurrency
										and ((itemData.coin ~= nil and Crypto:Has(source, itemData.coin, itemData.price)) or Wallet:Has(
											source,
											itemData.price
										))
								)
							then
								if itemData.coin ~= nil then
									local coinData = Crypto.Coin:Get(itemData.coin)
									if
										Crypto.Exchange:Remove(
											itemData.coin,
											char:GetData("CryptoWallet"),
											itemData.price
										)
									then
										if itemData.qty ~= -1 then
											_created[data.id].items[data.index].qty = itemData.qty - 1
										end
										_globalBought[data.id][source] = (_globalBought[data.id][source] or 0) + 1
										_bought[data.id][source] = _bought[data.id][source] or {}
										_bought[data.id][source][itemData.item] = (
											_bought[data.id][source][itemData.item] or 0
										) + 1
										cb(Inventory:AddItem(char:GetData("SID"), itemData.item, 1, {}, 1))
									else
										Execute:Client(
											source,
											"Notification",
											"Error",
											string.format("Not Enough %s", coinData.Name)
										)
									end
								else
									if Wallet:Has(source, itemData.price) then
										if Wallet:Modify(source, -itemData.price) then
											if itemData.qty ~= -1 then
												_created[data.id].items[data.index].qty = itemData.qty - 1
											end
											_globalBought[data.id][source] = (_globalBought[data.id][source] or 0) + 1
											_bought[data.id][source] = _bought[data.id][source] or {}
											_bought[data.id][source][itemData.item] = (
												_bought[data.id][source][itemData.item] or 0
											) + 1
											cb(Inventory:AddItem(char:GetData("SID"), itemData.item, 1, {}, 1))
										end
									else
										Execute:Client(source, "Notification", "Error", "Not Enough Cash")
									end
								end
							end
						else
							Execute:Client(source, "Notification", "Error", "Item Not In Stock")
						end
					else
						cb({})
					end
				else
					cb({})
				end
			else
				cb({})
			end
		end)
	end)
end)

_VENDORS = {
	Create = function(self, id, type, name, model, position, items, iconOverride, labelOverride, isUnique, isGlobalUnique)
		_created[id] = {
			id = id,
			type = type,
			name = name,
			model = model,
			position = position,
			items = items,
			iconOverride = iconOverride,
			labelOverride = labelOverride,
			isUnique = isUnique,
			isGlobalUnique = isGlobalUnique,
		}
		_bought[id] = {}
		_globalBought[id] = {}
		TriggerClientEvent(
			"Vendor:Client:Add",
			-1,
			id,
			type,
			name,
			model,
			position,
			iconOverride,
			labelOverride,
			isUnique,
			isGlobalUnique
		)
	end,
	Remove = function(self, id)
		_created[id] = nil
		TriggerClientEvent("Vendor:Client:Remove", -1, id)
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Vendor", _VENDORS)
end)
