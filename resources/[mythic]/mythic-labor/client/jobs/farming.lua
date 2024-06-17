local _joiner = nil
local _working = false
local _actionLabel = nil
local _actionBaseDur = nil
local _actionAnim = nil
local _finished = false
local _tasks = 0
local _blips = {}
local _blip = nil
local eventHandlers = {}

local _nodes = nil

AddEventHandler("Labor:Client:Setup", function()
	PedInteraction:Add("FarmingJob", `a_m_m_farmer_01`, vector3(2016.165, 4987.541, 41.098), 225.995, 25.0, {
		{
			icon = "wheat-awn",
			text = "Start Work",
			event = "Farming:Client:StartJob",
			tempjob = "Farming",
			isEnabled = function()
				return not _working
			end,
		},
		{
			icon = "clipboard-list",
			text = "Finish Job",
			event = "Farming:Client:TurnIn",
			tempjob = "Farming",
			isEnabled = function()
				return _working and _tasks == 2
			end,
		},
	}, 'helmet-safety', 'WORLD_HUMAN_CLIPBOARD')
end)

local _doing = false
function DoAction(id)
	Progress:ProgressWithTickEvent({
		name = 'farming_action',
		duration = (math.random(10) + _actionBaseDur) * 1000,
		label = _actionLabel,
		tickrate = 1000,
		useWhileDead = false,
		canCancel = true,
		vehicle = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableCombat = true,
		},
		animation = _actionAnim,
	}, function()
		if not _doing then return end
		for k, v in ipairs(_nodes) do
			if v.id == id then
				return
			end
		end
		Progress:Cancel()
	end, function(cancelled)
		_doing = false
		if not cancelled then
			Callbacks:ServerCallback("Farming:CompleteNode", id)
		end
	end)
end

RegisterNetEvent("Farming:Client:OnDuty", function(joiner, time)
	_joiner = joiner
	DeleteWaypoint()
	SetNewWaypoint(2016.165, 4987.541)
	_blip = Blips:Add("FarmingStart", "Farm Supervisor", { x = 2016.165, y = 4987.541, z = 0 }, 480, 2, 1.4)

    eventHandlers["keypress"] = AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
		if _doing then return end
		if _working and not _finished then
			local closest = nil
			for k, v in ipairs(_nodes) do
				local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(v.coords.x, v.coords.y, v.coords.z))
				if dist <= 2.0 then
					if closest == nil or dist < closest.dist then
						closest = {
							dist = dist,
							point = v,
						}
					end
				end
			end

			if closest ~= nil then
				_doing = true
				TaskTurnPedToFaceCoord(LocalPlayer.state.ped, closest.point.coords.x, closest.point.coords.y, closest.point.coords.z, 1.0)
				Wait(1000)
				DoAction(closest.point.id)
			else
				_doing = false
			end
		end
    end)

	eventHandlers["startup"] = RegisterNetEvent(string.format("Farming:Client:%s:Startup", joiner), function(nodes, actionLabel, baseDur, anim)
		Blips:Remove("FarmingStart")

		if _nodes ~= nil then return end
		_actionLabel = actionLabel
		_actionBaseDur = baseDur
		_actionAnim = anim
		_working = true
		_tasks = 0
		_nodes = nodes

		for k, v in ipairs(_nodes) do
            Blips:Add(string.format("FarmingNode-%s", v.id), "Farming Action", v.coords, 594, 0, 0.8)
		end

		CreateThread(function()
			while _working do
				local closest = nil
				for k, v in ipairs(_nodes) do
					local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(v.coords.x, v.coords.y, v.coords.z))
					if dist <= 20 then
						DrawMarker(1, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 112, 209, 244, 250, false, false, 2, false, false, false, false)
					end
				end

				Wait(5)
			end
		end)
	end)

	eventHandlers["actions"] = RegisterNetEvent(string.format("Farming:Client:%s:Action", joiner), function(data)
		for k, v in ipairs(_nodes) do
			if v.id == data then
				Blips:Remove(string.format("FarmingNode-%s", v.id))
				table.remove(_nodes, k)
				break
			end
		end
	end)

	eventHandlers["return"] = RegisterNetEvent(string.format("Farming:Client:%s:EndFarming", joiner), function()
		_tasks = _tasks + 1
		_nodes = {}
		DeleteWaypoint()
		SetNewWaypoint(2016.165, 4987.541)
		_blip = Blips:Add("FarmingStart", "Farm Supervisor", { x = 2016.165, y = 4987.541, z = 0 }, 480, 2, 1.4)
	end)

	eventHandlers["new-task"] = RegisterNetEvent(string.format("Farming:Client:%s:NewTask", joiner), function(nodes, actionLabel, baseDur, anim)
		Blips:Remove("FarmingStart")

		if #_nodes ~= 0 then
			for k, v in ipairs(_nodes) do
				Blips:Remove(string.format("FarmingNode-%s", v.id))
			end
		end

		_actionLabel = actionLabel
		_actionBaseDur = baseDur
		_actionAnim = anim
		_nodes = nodes
		_tasks = _tasks + 1

		for k, v in ipairs(_nodes) do
            Blips:Add(string.format("FarmingNode-%s", v.id), "Farming Action", v.coords, 594, 0, 0.8)
		end
	end)
end)

AddEventHandler("Farming:Client:TurnIn", function()
    Callbacks:ServerCallback('Farming:TurnIn', _joiner)
end)

AddEventHandler("Farming:Client:StartJob", function()
    Callbacks:ServerCallback('Farming:StartJob', _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
    end)
end)

RegisterNetEvent("Farming:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	if _nodes ~= nil then
		for k, v in ipairs(_nodes) do
			Blips:Remove(string.format("FarmingNode-%s", v.id))
		end
	end

	if _blip ~= nil then
		Blips:Remove("FarmingStart")
	end

	_joiner = nil
	_working = false
	_finished = false
	_blips = {}
	eventHandlers = {}
	_nodes = nil
end)