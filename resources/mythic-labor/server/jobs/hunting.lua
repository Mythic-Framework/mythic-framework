local _JOB = "Hunting"
local _joiners = {}
local _hunting = {}

local _baitCds = {}

local _saleData = {
	[1] = { rep = 3, price = 1000, item = "hide_tier1" },
	[2] = { rep = 4, price = 2000, item = "hide_tier2" },
	[3] = { rep = 5, price = 4000, item = "hide_tier3" },
	[4] = { rep = 6, price = 8000, item = "hide_tier4" },
}

AddEventHandler("Labor:Server:Startup", function()
	RegisterHuntingItems()

	Middleware:Add("Characters:Spawning", function(source)
		TriggerClientEvent("Hunting:Client:Polys", source, HuntingConfig)
	end)

	Callbacks:RegisterServerCallback("Hunting:StartJob", function(source, data, cb)
		if _hunting[data] ~= nil and _hunting[data].state == 0 then
			_hunting[_joiners[source]].state = 1
			Labor.Offers:Start(_joiners[source], _JOB, "Harvest Animals", 6)
			TriggerClientEvent(string.format("Hunting:Client:%s:Startup", data), -1)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Hunting:FinishJob", function(source, data, cb)
		if _joiners[source] ~= nil and _hunting[_joiners[source]].state == 2 then
			_hunting[_joiners[source]].state = 3
			TriggerClientEvent(string.format("Hunting:Client:%s:FinishJob", _joiners[source]), -1)
			Labor.Offers:ManualFinish(_joiners[source], _JOB)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Hunting:HarvestAnimal", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local luck = math.random(100)
		if
			char:GetData("TempJob") ~= _JOB
			or _joiners[source] == nil
			or (_joiners[source] ~= nil and _hunting[_joiners[source]]) ~= nil
		then
			luck = luck - 25
		end

		if luck >= 90 then
			Inventory:AddItem(char:GetData("SID"), "hide_tier4", 1, {}, 1)
		elseif luck >= 80 then
			Inventory:AddItem(char:GetData("SID"), "hide_tier3", 1, {}, 1)
		elseif luck >= 70 then
			Inventory:AddItem(char:GetData("SID"), "hide_tier2", 1, {}, 1)
		elseif luck >= 50 then
			Inventory:AddItem(char:GetData("SID"), "hide_tier1", 1, {}, 1)
		end

		if #HuntingSrvConfig.Loot[data] > 0 then
			Loot:CustomSetWithCount(HuntingSrvConfig.Loot[data], char:GetData("SID"), 1)
		end

		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _hunting[_joiners[source]] ~= nil then
			if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
				_hunting[_joiners[source]].state = 2
				Labor.Offers:Task(_joiners[source], _JOB, "Talk To The Shop Owner")
				TriggerClientEvent(string.format("Hunting:Client:%s:Finish", _joiners[source]), -1)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Hunting:GenerateAnimal", function(source, data, cb)
		Callbacks:ClientCallback(source, "Polyzone:GetZonePlayerIn", {}, function(zone)
			if zone and string.sub(zone.id, 1, string.len("hunting")) == "hunting" then
				local zoneId = tonumber(string.sub(zone.id, string.len("hunting") + 1))
				if HuntingConfig.Zones[zoneId] ~= nil then
					local anims = {}
					for k, v in ipairs(HuntingConfig.Baits[data].animals) do
						local animData = HuntingConfig.Animals[v]
						if not animData.Illegal or (animData.Illegal and HuntingConfig.Zones[zoneId].illegal) then
							table.insert(anims, animData)
						end
					end
					local animal = anims[math.random(#anims)]
					cb({
						animal = animal,
						isIllegal = HuntingConfig.Zones[zoneId].illegal,
					})
				else
					Execute:Client(source, "Notification", "Error", "Not Allowed To Hunt Here")
				end
			else
				Execute:Client(source, "Notification", "Error", "Not Allowed To Hunt Here")
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Hunting:Sell", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local repLvl = Reputation:GetLevel(source, _JOB)

		if _saleData[data] ~= nil then
			if repLvl >= _saleData[data].rep then
				local count = Inventory.Items:GetCount(char:GetData("SID"), 1, _saleData[data].item) or 0
				if (count) > 0 then
					if Inventory.Items:Remove(char:GetData("SID"), 1, _saleData[data].item, count) then
						Wallet:Modify(source, _saleData[data].price * count)
					end
				else
					Execute:Client(source, "Notification", "Error", "You Have No Hides Of That Tier")
				end
			else
				Execute:Client(source, "Notification", "Error", "You Must Prove Yourself First")
			end
		end
	end)
end)

function RegisterHuntingItems()
	for k, v in pairs(HuntingConfig.Baits) do
		Inventory.Items:RegisterUse(k, "Hunting", function(source, item)
			if
				_baitCds[source] == nil
				or (os.time() - _baitCds[source]) >= HuntingConfig.Baits[item.Name].cooldown * 60
			then
				local char = Fetch:Source(source):GetData("Character")
				Callbacks:ClientCallback(source, "Polyzone:GetZonePlayerIn", {}, function(zone)
					if zone and string.sub(zone.id, 1, string.len("hunting")) == "hunting" then
						local zoneId = tonumber(string.sub(zone.id, string.len("hunting") + 1))
						if HuntingConfig.Zones[zoneId] ~= nil then
							Callbacks:ClientCallback(source, "Hunting:PlaceTrap", item.Name, function(successful)
								if successful then
									_baitCds[source] = os.time()
									Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
								end
							end)
						else
							Execute:Client(source, "Notification", "Error", "Not Allowed To Hunt Here")
						end
					else
						Execute:Client(source, "Notification", "Error", "Not Allowed To Hunt Here")
					end
				end)
			else
				Execute:Client(source, "Notification", "Error", "You Cannot Use Bait Yet")
			end
		end)
	end
end

AddEventHandler("Hunting:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_hunting[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
	TriggerClientEvent("Hunting:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Talk To The Shop Owner")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:Source(v.ID):GetData("Character")
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
			TriggerClientEvent("Hunting:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Hunting:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Hunting:Client:OffDuty", source)
end)

AddEventHandler("Hunting:Server:FinishJob", function(joiner)
	_hunting[joiner] = nil
end)
