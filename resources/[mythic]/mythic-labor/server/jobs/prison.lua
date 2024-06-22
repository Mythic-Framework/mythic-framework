local _JOB = "Prison"

local _joiners = {}
local _Prisoners = {}

AddEventHandler("Labor:Server:Startup", function()
	WaitList:Create("prison", "individual_time", {
		event = "Labor:Server:Prison:Queue",
		--delay = (1000 * 60) * 5,
		delay = 10000,
	})

	Callbacks:RegisterServerCallback("Prison:Action", function(source, data, cb)
		if _joiners[source] ~= nil and _Prisoners[_joiners[source]] ~= nil then
			local char = Fetch:Source(source):GetData("Character")
			if
				Labor.Offers:Update(_joiners[source], _JOB, 1, true, {
					title = "Prison Labor",
					label = "Prison",
					icon = "link",
					color = "transparent",
				})
			then
				_Prisoners[_joiners[source]].state = 0
				Wallet:Modify(source, 150)
				TriggerClientEvent(string.format("Prison:Client:%s:Cleanup", _joiners[source]), -1)
				Labor.Offers:Task(_joiners[source], _JOB, "Wait For Work", {
					title = "Prison Labor",
					label = "Prison",
					icon = "link",
					color = "transparent",
				})

				if not Jail:IsReleaseEligible(source) then
					local char = Fetch:Source(source):GetData("Character")
					local jailed = char:GetData("Jailed")
					jailed.Release = jailed.Release - _Prisoners[_joiners[source]].nodes.timeReduce
					char:SetData("Jailed", jailed)
					Execute:Client(
						source,
						"Notification",
						"Info",
						string.format(
							"Your Sentence Has Been Reduced By %s Months",
							math.ceil(_Prisoners[_joiners[source]].nodes.timeReduce / 60)
						)
					)
				end

				WaitList.Interact:Inactive("prison", _joiners[source])
			end
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Prison:TurnIn", function(source, data, cb)
		if _joiners[source] ~= nil and _Prisoners[_joiners[source]].tasks >= 3 then
			local char = Fetch:Source(source):GetData("Character")
			if char:GetData("TempJob") == _JOB then
				Labor.Offers:ManualFinish(_joiners[source], _JOB)
				cb(true)
			else
				Execute:Client(source, "Notification", "Error", "Unable To Finish Job")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "You've Not Completed All Routes")
			cb(false)
		end
	end)
end)

AddEventHandler("Labor:Server:Prison:Queue", function(source, data)
	if _joiners[source] ~= nil and _Prisoners[_joiners[source]] ~= nil and _Prisoners[_joiners[source]].state == 0 then
		local f = math.random(#_prisonJobs)

		while f == _Prisoners[_joiners[source]].jobIndex do
			f = math.random(#_prisonJobs)
			Wait(1)
		end

		_Prisoners[_joiners[source]].state = 1
		_Prisoners[_joiners[source]].jobIndex = f
		_Prisoners[_joiners[source]].nodes = deepcopy(_prisonJobs[f])
		
		TriggerClientEvent(
			string.format("Prison:Client:%s:Receive", _joiners[source]),
			-1,
			_Prisoners[_joiners[source]].nodes
		)
		Labor.Offers:Start(
			_joiners[source],
			_JOB,
			_Prisoners[_joiners[source]].nodes.action,
			#_Prisoners[_joiners[source]].nodes.locations,
			{
				title = "Prison Labor",
				label = "Prison",
				icon = "link",
				color = "transparent",
			}
		)
	end
end)

AddEventHandler("Prison:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner

	_Prisoners[joiner] = {
		joiner = joiner,
		isWorkgroup = false,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)

	TriggerClientEvent("Prison:Client:OnDuty", joiner, joiner, os.time())
	Labor.Offers:Task(joiner, _JOB, "Wait For Work", {
		title = "Prison Labor",
		label = "Prison",
		icon = "link",
		color = "transparent",
	})

	WaitList.Interact:Add("prison", joiner, {
		joiner = joiner,
	})
end)

AddEventHandler("Prison:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Prison:Client:OffDuty", source)
	WaitList.Interact:Remove("prison", source)
end)

AddEventHandler("Prison:Server:FinishJob", function(joiner)
	_Prisoners[joiner] = nil
end)
