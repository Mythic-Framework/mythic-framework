local _JOB = "Coke"

local _joiners = {}
local _active = nil

AddEventHandler("Labor:Server:Startup", function()
	GlobalState["CokeRuns"] = vector4(425.063, -231.299, 54.968, 269.634)
	GlobalState["CokeRunActive"] = false
	GlobalState["CokeRunCD"] = false

	WaitList:Create("coke_import", "individual_time", {
		event = "Labor:Server:Coke:Queue",
		--delay = (1000 * 60) * 5,
		delay = 10000,
	})

	Callbacks:RegisterServerCallback("Coke:StartWork", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Wallet:Has(source, 100000) then
					if not GlobalState["CokeRunActive"] and _active == nil then
						if not GlobalState["CokeRunCD"] or os.time() > GlobalState["CokeRunCD"] then
							Labor.Duty:On("Coke", source, true)
						else
							Execute:Client(source, "Notification", "Error", "Someone Has Already Done This Recently")
						end
					else
						Execute:Client(source, "Notification", "Error", "Someone Else Is Already Doing This")
					end
				else
					Execute:Client(source, "Notification", "Error", "You Don't Have Enough Cash, Come Back When You Do")
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Coke:Abort", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if _active ~= nil and _active.joiner == source then
					if _active.state == 0 then
						Labor.Duty:Off("Coke", source, false, false)
						Wallet:Modify(source, 100000)

						GlobalState["CokeRunActive"] = false
						GlobalState["CokeRunCD"] = false
						char:SetData("CokeCD", os.time())
						_active = nil
					else
						Execute:Client(source, "Notification", "Error", "Too Late, You Cannot Cancel This Now")
					end
				end
			end
		end
	end)

    Callbacks:RegisterServerCallback("Coke:ArriveAtCayo", function(source, data, cb)
        if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 1 then
            _active.state = 2
            Vehicles:SpawnTemp(
                source,
                `squaddie`,
                vector3(4504.899, -4510.600, 4.367),
                19.409,
                function(veh)
					Vehicles.Keys:Add(_joiners[source], Entity(veh).state.VIN)
					if _active.isWorkgroup then
						if #_active.members > 0 then
							for k, v in ipairs(_active.members) do
								Vehicles.Keys:Add(v.ID, Entity(veh).state.VIN)
							end
						end
					end
                end
            )

            Vehicles:SpawnTemp(
                source,
                _active.drop.vehicle,
                vector3(_active.drop.coords[1], _active.drop.coords[2], _active.drop.coords[3]),
                _active.drop.coords[4],
                function(veh)
					Entity(veh).state.Locked = false
					Entity(veh).state.noLockpick = true
					SetVehicleDoorsLocked(veh, 1)
                    _active.entity = veh
                    _active.VIN = Entity(veh).state.VIN
                    Inventory:AddItem(_active.VIN, "coke_brick", 4, {}, 4)
                    TriggerClientEvent(string.format("Coke:Client:%s:GoTo", _joiners[source]), -1)
                end
            )
        end
    end)

    Callbacks:RegisterServerCallback("Coke:StartHeist", function(source, data, cb)
        if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 2 then
            _active.state = 3
            Labor.Offers:Task(_joiners[source], _JOB, "Locate The Target Vehicle", {
                title = "Unknown",
                label = "Unknown",
                icon = "question",
                color = "transparent",
            })
            TriggerClientEvent(string.format("Coke:Client:%s:SetupHeist", _joiners[source]), -1, _active.drop)
        end
    end)

    Callbacks:RegisterServerCallback("Coke:ArrivedAtPoint", function(source, data, cb)
        if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 3 then
            _active.state = 4
            cb()
            Labor.Offers:Task(_joiners[source], _JOB, "Retreive Contraband From Vehicle", {
                title = "Unknown",
                label = "Unknown",
                icon = "question",
                color = "transparent",
            })
            TriggerClientEvent(string.format("Coke:Client:%s:DoShit", _joiners[source]), -1)
        end
    end)

    Callbacks:RegisterServerCallback("Coke:LeftCayo", function(source, data, cb)
        if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 5 then
            _active.state = 6

            DeleteEntity(_active.entity)
            Vehicles:SpawnTemp(
                source,
                `bison`,
                vector3(1293.300, -3168.405, 4.906),
                61.642,
                function(veh)
					Entity(veh).state.Locked = false
					Entity(veh).state.noLockpick = true
					SetVehicleDoorsLocked(veh, 1)
                    _active.entity = veh
                    TriggerClientEvent(string.format("Coke:Client:%s:SetupFinish", _joiners[source]), -1)
                end
            )
        end
    end)

    Callbacks:RegisterServerCallback("Coke:Finish", function(source, data, cb)
        if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 6 then
            DeleteEntity(_active.entity)
            Labor.Offers:ManualFinish(_joiners[source], _JOB)
        end
    end)
end)

AddEventHandler("Inventory:Server:Opened", function(source, owner, type)
    if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 4 then
        if owner == _active.VIN and type == 4 then
            _active.state = 5
            Labor.Offers:Task(_joiners[source], _JOB, "Meet Contact Back In Los Santos", {
                title = "Unknown",
                label = "Unknown",
                icon = "question",
                color = "transparent",
            })
            TriggerClientEvent(string.format("Coke:Client:%s:GoBack", _joiners[source]), -1)
        end
    end
end)

AddEventHandler("Labor:Server:Coke:Queue", function(source, data)
	if _joiners[source] ~= nil and _active.joiner == _joiners[source] and _active.state == 0 then
		_active.state = 1
		_active.drop = cokeDrops[math.random(#cokeDrops)]

		TriggerClientEvent(string.format("Coke:Client:%s:Receive", _joiners[source]), -1)

		Labor.Offers:Task(_joiners[source], _JOB, "Speak To The Contact At Cayo Perico", {
			title = "Unknown",
			label = "Unknown",
			icon = "question",
			color = "transparent",
		})
	end
end)

AddEventHandler("Coke:Server:OnDuty", function(joiner, members, isWorkgroup)
	if _active ~= nil then
		Phone.Notification:Add(joiner, "Unknown", "No Jobs Available", os.time() * 1000, 6000, {
			title = "Unknown",
			label = "Unknown",
			icon = "question",
			color = "transparent",
		})
	else
		local plyr = Fetch:Source(joiner)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local cd = char:GetData("CokeCD") or os.time()
				if cd > os.time() then
					Phone.Notification:Add(
						joiner,
						"Unknown",
						"Your Group Is Not Eligible. Please Wait",
						os.time() * 1000,
						6000,
						{
							title = "Unknown",
							label = "Unknown",
							icon = "question",
							color = "transparent",
						}
					)

					if isWorkgroup then
						if #members > 0 then
							for k, v in ipairs(members) do
								Phone.Notification:Add(
									v.ID,
									"Unknown",
									"Your Group Is Not Eligible. Please Wait",
									os.time() * 1000,
									6000,
									{
										title = "Unknown",
										label = "Unknown",
										icon = "question",
										color = "transparent",
									}
								)
							end
						end
					end
					return
				end
			else
				return
			end
		else
			return
		end

		Wallet:Modify(joiner, -100000)
		GlobalState["CokeRunCD"] = os.time() + (60 * 60 * 6)
		_joiners[joiner] = joiner
		_active = {
			joiner = joiner,
			isWorkgroup = isWorkgroup,
			members = members,
			started = os.time(),
			state = 0,
		}
		GlobalState["CokeRunActive"] = true

		local char = Fetch:Source(joiner):GetData("Character")
		char:SetData("TempJob", _JOB)
		char:SetData("CokeCD", os.time() + (60 * 60 * 24 * 3))

		TriggerClientEvent("Coke:Client:OnDuty", joiner, joiner, os.time())
		if #members > 0 then
			for k, v in ipairs(members) do
				_joiners[v.ID] = joiner
				local member = Fetch:Source(v.ID):GetData("Character")
				member:SetData("TempJob", _JOB)
				TriggerClientEvent("Coke:Client:OnDuty", v.ID, joiner, os.time())
			end
		end

		Labor.Offers:Task(joiner, _JOB, "Wait For Contact", {
			title = "Unknown",
			label = "Unknown",
			icon = "question",
			color = "transparent",
		})

		WaitList.Interact:Add("coke_import", joiner, {
			joiner = joiner,
		})
	end
end)

AddEventHandler("Coke:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Coke:Client:OffDuty", source)
	WaitList.Interact:Remove("coke_import", source)
end)

AddEventHandler("Coke:Server:FinishJob", function(joiner)
	_active = nil
	GlobalState["CokeRunActive"] = false
end)
