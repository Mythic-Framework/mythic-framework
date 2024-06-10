local _JOB = "WeedRun"

local _joiners = {}
local _sellers = {}

AddEventHandler("Labor:Server:Startup", function()
	WaitList:Create("weedrun", "individual_time", {
		event = "Labor:Server:WeedRun:Queue",
		delay = (1000 * 60) * 3,
	})

	Crafting:RegisterBench("WeedPackaging", "Weed Processing", {
		actionString = "Packaging",
		icon = "cannabis",
		poly = {
			coords = vector3(1056.47, -2450.58, 23.29),
			w = 2.8,
			l = 1.0,
			options = {
				name = "WeedPackaging",
				heading = 0,
				--debugPoly=true,
				minZ = 21.89,
				maxZ = 24.29,
			},
		},
	}, {}, {
		shared = true,
	}, {
		{
			result = { name = "weed_brick", count = 1 },
			items = {
				{ name = "plastic_wrap", count = 2 },
				{ name = "weed_bud", count = 200 },
			},
			time = 8000,
			animation = "mechanic",
		},
		{
			result = { name = "weed_baggy", count = 1 },
			items = {
				{ name = "baggy", count = 1 },
				{ name = "weed_bud", count = 2 },
			},
			time = 2000,
			animation = "mechanic",
		},
	})

	Callbacks:RegisterServerCallback("WeedRun:Enable", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local states = char:GetData("States") or {}
		if not hasValue(states, "SCRIPT_WEED_RUN") then
			table.insert(states, "SCRIPT_WEED_RUN")
			char:SetData("States", states)
			Phone.Notification:Add(
				source,
				"New Job Available",
				"A new job is available, check it out.",
				os.time() * 1000,
				6000,
				"labor",
				{}
			)
		end
	end)

	Callbacks:RegisterServerCallback("WeedRun:Disable", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local states = char:GetData("States") or {}
		if hasValue(states, "SCRIPT_WEED_RUN") then
			for k, v in ipairs(states) do
				if v == "SCRIPT_WEED_RUN" then
					table.remove(states, k)
					char:SetData("States", states)
					break
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("WeedRun:StartDropoff", function(source, data, cb)
		if _joiners[source] ~= nil then
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "oxysale")
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("WeedRun:DoDropoff", function(source, data, cb)
		if _joiners[source] ~= nil then
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if Inventory.Items:Remove(char:GetData("SID"), 1, "weed_brick", 1) then
						local repLevel = Reputation:GetLevel(source, "WeedRun") or 0
						local calcLvl = repLevel
						if calcLvl < 1 then
							calcLvl = 1
						end

						local itemData = Inventory.Items:GetData("weed_brick")

						local rand = math.random(100)
						if rand >= (100 - (3 * calcLvl)) then
							Inventory:AddItem(char:GetData("SID"), "moneyband", math.random(8, 10 + calcLvl), {}, 1)
						elseif rand >= (55 - (2 * calcLvl)) then
							Inventory:AddItem(
								char:GetData("SID"),
								"moneyroll",
								math.random(90, 100 + (2 * calcLvl)),
								{},
								1
							)
						else
							Wallet:Modify(source, itemData.price + (30 * calcLvl))
						end

						_sellers[_joiners[source]].state = 2
						_offers[_joiners[source]].noExpire = true

						for k, v in pairs(_Jobs[_JOB].OnDuty) do
							if v.Joiner == _joiners[source] then
								if v.Group then
									for k2, v2 in pairs(_Groups) do
										if v2.Creator.ID == _joiners[source] then
											for k3, v3 in ipairs(v2.Members) do
												Labor.Offers:Complete(v3.ID, _JOB)
											end
										end
									end
								end

								Labor.Offers:Complete(_joiners[source], _JOB)
							end
						end

						Labor.Offers:Task(_joiners[source], _JOB, "Wait For Next Delivery")
						WaitList.Interact:Inactive("weedrun", _joiners[source])

						cb(true)
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

AddEventHandler("WeedRun:Server:OnDuty", function(joiner, members, isWorkgroup)
	local plyr = Fetch:Source(joiner)
	local char = plyr:GetData("Character")
	if char == nil then
		Labor.Offers:Cancel(joiner, _JOB)
		Labor.Duty:Off(_JOB, joiner, false, true)
		return
	end

	_joiners[joiner] = joiner
	_sellers[joiner] = {
		joiner = joiner,
		members = members,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)
	TriggerClientEvent("WeedRun:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Wait For A Delivery")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:Source(v.ID):GetData("Character")
			member:SetData("TempJob", _JOB)
			TriggerClientEvent("WeedRun:Client:OnDuty", v.ID, joiner, os.time())
		end
	end

	_offers[joiner].noExpire = true
	WaitList.Interact:Add("weedrun", joiner, {
		joiner = joiner,
	})
end)

AddEventHandler("WeedRun:Server:OffDuty", function(source, joiner)
	WaitList.Interact:Remove("weedrun", _joiners[source])
	_joiners[source] = nil
	TriggerClientEvent("WeedRun:Client:OffDuty", source)
end)

AddEventHandler("Labor:Server:WeedRun:Queue", function(source, data)
	if _joiners[source] ~= nil then
		_sellers[_joiners[source]].state = 1
		_sellers[_joiners[source]].location = _weedSaleLocations[math.random(#_weedSaleLocations)]
		_offers[_joiners[source]].noExpire = false
		Labor.Offers:Task(_joiners[source], _JOB, "Deliver The Package")
		TriggerClientEvent(
			string.format("WeedRun:Client:%s:Receive", _joiners[source]),
			-1,
			_sellers[_joiners[source]].location,
			PedModels[math.random(#PedModels)]
		)
	end

	WaitList.Interact:Active("weedrun", _joiners[source])
end)
