local _JOB = "Farming"

local _joiners = {}
local _farming = {}

AddEventHandler("Labor:Server:Startup", function()
	Callbacks:RegisterServerCallback("Farming:StartJob", function(source, data, cb)
		if _farming[data] ~= nil and _farming[data].state == 0 then
			local randJob = math.random(#availableJobs)

			_farming[data].job = deepcopy(availableJobs[randJob])
			_farming[data].jobs = deepcopy(availableJobs)
			_farming[data].tasks = 0
			_farming[data].nodes = deepcopy(
				availableJobs[randJob].locationSets[math.random(#availableJobs[randJob].locationSets)]
			)

			table.remove(_farming[data].jobs, randJob)
			_farming[data].job.locationSets = nil

			Labor.Offers:Start(data, _JOB, _farming[data].job.objective, #_farming[data].nodes)
			TriggerClientEvent(
				string.format("Farming:Client:%s:Startup", data),
				-1,
				_farming[data].nodes,
				_farming[data].job.action,
				_farming[data].job.durationBase,
				_farming[data].job.animation
			)

			_farming[data].state = 1
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Farming:CompleteNode", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _farming[_joiners[source]] ~= nil then
			for k, v in ipairs(_farming[_joiners[source]].nodes) do
				if v.id == data then
					Loot:CustomSetWithCount(_farming[_joiners[source]].job.loot, char:GetData("SID"), 1)
					TriggerClientEvent(string.format("Farming:Client:%s:Action", _joiners[source]), -1, data)
					table.remove(_farming[_joiners[source]].nodes, k)
					if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
						_farming[_joiners[source]].tasks = _farming[_joiners[source]].tasks + 1

						if _farming[_joiners[source]].tasks < 2 then
							local randJob = math.random(#_farming[_joiners[source]].jobs)
							_farming[_joiners[source]].job = deepcopy(_farming[_joiners[source]].jobs[randJob])
							_farming[_joiners[source]].nodes = deepcopy(
								_farming[_joiners[source]].job.locationSets[math.random(
									#_farming[_joiners[source]].job.locationSets
								)]
							)
							table.remove(_farming[_joiners[source]].jobs, randJob)
							_farming[_joiners[source]].job.locationSets = nil
							Labor.Offers:Start(
								_joiners[source],
								_JOB,
								_farming[_joiners[source]].job.objective,
								#_farming[_joiners[source]].nodes
							)
							TriggerClientEvent(
								string.format("Farming:Client:%s:NewTask", _joiners[source]),
								-1,
								_farming[_joiners[source]].nodes,
								_farming[_joiners[source]].job.action,
								_farming[_joiners[source]].job.durationBase,
								_farming[_joiners[source]].job.animation
							)
						else
							TriggerClientEvent(string.format("Farming:Client:%s:EndFarming", _joiners[source]), -1)
							_farming[_joiners[source]].state = 2
							Labor.Offers:Task(_joiners[source], _JOB, "Return To The Farm Supervisor")
						end
					end
					return
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Farming:TurnIn", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _farming[_joiners[source]] ~= nil then
			Labor.Offers:ManualFinish(_joiners[source], _JOB)
			cb(true)
		else
			Execute:Client(source, "Notification", "Error", "Unable To Turn In Ore")
			cb(false)
		end
	end)
end)

AddEventHandler("Farming:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_farming[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
	TriggerClientEvent("Farming:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Speak With The Farm Supervisor")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:Source(v.ID):GetData("Character")
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
			TriggerClientEvent("Farming:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Farming:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Farming:Client:OffDuty", source)
end)

AddEventHandler("Farming:Server:FinishJob", function(joiner)
	_farming[joiner] = nil
end)
