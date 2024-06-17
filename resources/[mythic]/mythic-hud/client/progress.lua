template_action = {
	name = "",
	duration = 0,
	label = "",
	useWhileDead = false,
	canCancel = true,
	ignoreModifier = false,
	disarm = true,
	controlDisables = {
		disableMovement = false,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	},
	-- animation = {
	-- 	animDict = nil,
	-- 	anim = nil,
	-- 	flags = 0,
	-- 	task = nil,
	-- },
	-- prop = {
	-- 	model = nil,
	-- 	bone = nil,
	-- 	coords = { x = 0.0, y = 0.0, z = 0.0 },
	-- 	rotation = { x = 0.0, y = 0.0, z = 0.0 },
	-- },
	-- propTwo = {
	-- 	model = nil,
	-- 	bone = nil,
	-- 	coords = { x = 0.0, y = 0.0, z = 0.0 },
	-- 	rotation = { x = 0.0, y = 0.0, z = 0.0 },
	-- },
}
local progress_action = nil

local _mdfr = 1.0

local disableMouse = false
local wasCancelled = false
local wasFinished = false
local isAnim = false
local isProp = false
local isPropTwo = false
local prop_net = nil
local propTwo_net = nil
local _runProgressThread = false

function runMdfr(duration)
	local c = 0
	CreateThread(function()
		while LocalPlayer.state.loggedIn and c < duration / 1000 do
			c = c + 1
			Wait(1000)
		end
		_mdfr = 1.0
	end)
end


PROGRESS = {
	_required = {
		"CurrentAction",
		"Progress",
		"ProgressWithStartEvent",
		"ProgressWithTickEvent",
		"ProgressWithStartAndTick",
		"Cancel",
		"Fail",
	},
	CurrentAction = function(self)
		return progress_action.name
	end,
	Progress = function(self, action, finish)
		_doProgress(action, nil, nil, finish)
	end,
	ProgressWithStartEvent = function(self, action, start, finish)
		_doProgress(action, start, nil, finish)
	end,
	ProgressWithTickEvent = function(self, action, tick, finish)
		_doProgress(action, nil, tick, finish)
	end,
	ProgressWithStartAndTick = function(self, action, start, tick, finish)
		_doProgress(action, start, tick, finish)
	end,
	Modifier = function(self, p, t)
		if _mdfr ~= 1.0 then return false end
		_mdfr = p / 100.0
		runMdfr(t)
		return true
	end,
	Cancel = function(self, force)
		if progress_action == nil then
			return
		end
		if progress_action.canCancel or force then
			wasCancelled = true
			_doFinish()
			SendNUIMessage({
				type = "CANCEL_PROGRESS",
			})
		end
	end,
	Fail = function(self)
		wasCancelled = true
		_doFinish()
		SendNUIMessage({
			type = "FAIL_PROGRESS",
		})
	end,
	Finish = function(self)
		wasFinished = true
		_doFinish()
	end,
}

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if not LocalPlayer.state.doingAction then
		return
	end
	Progress:Cancel()
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Progress", PROGRESS)
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	Progress:Cancel()
end)

function normalizePAct(passed)
	local c = deepcopy(template_action)
	for k, v in pairs(passed) do
		c[k] = v
	end
	return c
end

function _doProgress(action, start, tick, finish)
	local player = LocalPlayer.state.ped
	progress_action = normalizePAct(action)
	if (not IsEntityDead(player) and not LocalPlayer.state.isDead) or action.useWhileDead then
		if not LocalPlayer.state.doingAction then
			_doActionStart(player, progress_action)

			LocalPlayer.state.doingAction = true
			wasCancelled = false
			isAnim = false
			isProp = false
			wasCancelled = false
			wasFinished = false

			if not action.ignoreModifier then
				action.duration = action.duration * _mdfr
			end

			SendNUIMessage({
				type = "START_PROGRESS",
				data = {
					duration = action.duration,
					label = action.label,
				},
			})

			CreateThread(function()
				if start ~= nil then
					start()
				end

				if tick ~= nil then
					CreateThread(function()
						while LocalPlayer.state.doingAction do
							if action.tickrate ~= nil then
								Wait(action.tickrate)
							else
								Wait(0)
							end

							if LocalPlayer.state.doingAction and not (wasCancelled or wasFinished) then
								tick()
							end
						end
					end)
				end

				while LocalPlayer.state.doingAction do
					Wait(1)
					if IsEntityDead(player) and not action.useWhileDead or not LocalPlayer.state.loggedIn then
						Progress:Cancel()
					end
				end

				if finish ~= nil then
					finish(wasCancelled)
				end
			end)
		else
			Notification:Error("Already Doing An Action", 5000)
		end
	else
		Notification:Error("Already Doing An Action", 5000)
	end
end

function _doActionStart(player, action)
	_runProgressThread = true

	CreateThread(function()
		while _runProgressThread do
			_disableInput(player, action.controlDisables)
			Wait(1)
		end
	end)

	CreateThread(function()
		while _runProgressThread do
			if LocalPlayer.state.doingAction then
				if not isAnim then
					if action.animation then
						if action.animation.task ~= nil then
							if GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
								TaskStartScenarioInPlace(player, action.animation.task, 0, true)
							end
						elseif action.animation.animDict ~= nil and action.animation.anim ~= nil then
							if action.animation.flags == nil then
								action.animation.flags = 1
							end

							if DoesEntityExist(player) and not LocalPlayer.state.isDead then
								loadAnimDict(action.animation.animDict)
								TaskPlayAnim(
									player,
									action.animation.animDict,
									action.animation.anim,
									3.0,
									1.0,
									-1,
									action.animation.flags,
									0,
									0,
									0,
									0
								)
							end

							CreateThread(function()
								while LocalPlayer.state.doingAction do
									if
										LocalPlayer.state.doingAction
										and not IsEntityPlayingAnim(
											player,
											action.animation.animDict,
											action.animation.anim,
											3
										)
									then
										TaskPlayAnim(
											player,
											action.animation.animDict,
											action.animation.anim,
											3.0,
											1.0,
											-1,
											action.animation.flags,
											0,
											0,
											0,
											0
										)
									end
									Wait(1000)
								end
							end)
						elseif action.animation.anim ~= nil then
							Animations.Emotes:Play(action.animation.anim, false, action.duration, true)
						else
							if GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
								TaskStartScenarioInPlace(player, "PROP_HUMAN_BUM_BIN", 0, true)
							end
						end
					end

					if action.disarm then
						Weapons:UnequipIfEquippedNoAnim()
					end

					isAnim = true
				end
				if not isProp and action.prop ~= nil and action.prop.model ~= nil then
					RequestModel(action.prop.model)

					while not HasModelLoaded(GetHashKey(action.prop.model)) do
						Wait(0)
					end

					local pCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 0.0)
					local modelSpawn = CreateObject(
						GetHashKey(action.prop.model),
						pCoords.x,
						pCoords.y,
						pCoords.z,
						true,
						true,
						true
					)

					local netid = ObjToNet(modelSpawn)
					SetNetworkIdExistsOnAllMachines(netid, true)
					NetworkSetNetworkIdDynamic(netid, true)
					SetNetworkIdCanMigrate(netid, false)
					if action.prop.bone == nil then
						action.prop.bone = 60309
					end

					if action.prop.coords == nil then
						action.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
					end

					if action.prop.rotation == nil then
						action.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
					end

					AttachEntityToEntity(
						modelSpawn,
						player,
						GetPedBoneIndex(player, action.prop.bone),
						action.prop.coords.x,
						action.prop.coords.y,
						action.prop.coords.z,
						action.prop.rotation.x,
						action.prop.rotation.y,
						action.prop.rotation.z,
						1,
						1,
						0,
						1,
						0,
						1
					)
					prop_net = netid

					isProp = true

					if not isPropTwo and action.propTwo ~= nil and action.propTwo.model ~= nil then
						RequestModel(action.propTwo.model)

						while not HasModelLoaded(GetHashKey(action.propTwo.model)) do
							Wait(0)
						end

						local pCoords = GetEntityCoords(player)
						local modelSpawn = CreateObject(
							GetHashKey(action.propTwo.model),
							pCoords.x,
							pCoords.y,
							pCoords.z,
							true,
							true,
							true
						)

						local netid = ObjToNet(modelSpawn)
						SetNetworkIdExistsOnAllMachines(netid, true)
						NetworkSetNetworkIdDynamic(netid, true)
						SetNetworkIdCanMigrate(netid, false)
						if action.propTwo.bone == nil then
							action.propTwo.bone = 60309
						end

						if action.propTwo.coords == nil then
							action.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
						end

						if action.propTwo.rotation == nil then
							action.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
						end

						AttachEntityToEntity(
							modelSpawn,
							player,
							GetPedBoneIndex(player, action.propTwo.bone),
							action.propTwo.coords.x,
							action.propTwo.coords.y,
							action.propTwo.coords.z,
							action.propTwo.rotation.x,
							action.propTwo.rotation.y,
							action.propTwo.rotation.z,
							1,
							1,
							0,
							1,
							0,
							1
						)
						propTwo_net = netid

						isPropTwo = true
					end
				end

				if action.vehicle and not IsPedInAnyVehicle(player) then
					Progress:Fail()
				end
			end
			Wait(0)
		end
	end)
end

function _doFinish()
	LocalPlayer.state.doingAction = false
	_doCleanup(progress_action)
end

function _doCleanup(action)
	DeleteEntity(prop_net)
	DeleteEntity(propTwo_net)
	DeleteEntity(NetToObj(prop_net))
	DeleteEntity(NetToObj(propTwo_net))
	
	if action and action.animation then
		if action.animation.animDict ~= nil and action.animation.anim ~= nil then
			StopAnimTask(LocalPlayer.state.ped, action.animation.animDict, action.animation.anim, 1.0)
		elseif action.animation.anim ~= nil then
			Animations.Emotes:ForceCancel()
		else
			if action.animation.task ~= nil and not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
				ClearPedTasksImmediately(LocalPlayer.state.ped)
			end
		end
	end
	prop_net = nil
	propTwo_net = nil
	_runProgressThread = false
	progress_action = nil
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function _disableInput(ped, disables)
	if disables.disableMouse then
		DisableControlAction(0, 1, true) -- LookLeftRight
		DisableControlAction(0, 2, true) -- LookUpDown
		DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
	end

	if disables.disableMovement then
		DisableControlAction(0, 22, true) -- INPUT_JUMP
		DisableControlAction(0, 30, true) -- disable left/right
		DisableControlAction(0, 31, true) -- disable forward/back
		DisableControlAction(0, 36, true) -- INPUT_DUCK
		DisableControlAction(0, 21, true) -- disable sprint
		DisableControlAction(0, 44, true) -- disable cover
	end

	if disables.disableCarMovement then
		DisableControlAction(0, 63, true) -- veh turn left
		DisableControlAction(0, 64, true) -- veh turn right
		DisableControlAction(0, 71, true) -- veh forward
		DisableControlAction(0, 72, true) -- veh backwards
		DisableControlAction(0, 75, true) -- disable exit vehicle
	end

	if disables.disableCombat then
		DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
		DisableControlAction(0, 24, true) -- disable attack
		DisableControlAction(0, 25, true) -- disable aim
		DisableControlAction(1, 37, true) -- disable weapon select
		DisableControlAction(0, 47, true) -- disable weapon
		DisableControlAction(0, 58, true) -- disable weapon
		DisableControlAction(0, 140, true) -- disable melee
		DisableControlAction(0, 141, true) -- disable melee
		DisableControlAction(0, 142, true) -- disable melee
		DisableControlAction(0, 143, true) -- disable melee
		DisableControlAction(0, 263, true) -- disable melee
		DisableControlAction(0, 264, true) -- disable melee
		DisableControlAction(0, 257, true) -- disable melee
	end
end
