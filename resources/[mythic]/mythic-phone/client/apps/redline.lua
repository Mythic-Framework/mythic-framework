--[[
	This code is probably a steaming pile of shit, I beg someone
	that still has a few functioning brain cells to rewrite this
	so it isn't as much of a steaming pile of shit.

	Send Help.
]]
local _creator = false
local _size = 20.0
local _pendingTrack = {}

local _activeRace = {}
local _activeTrack = {}
local _inRace = false

local raceBlips = {}
local raceObjs = {}
local checkpointMarkers = {}

local MAX_SIZE = 75.0
local MIN_SIZE = 10.0

local tempCheckpointObj = {
	l = false,
	r = false,
}

RegisterNetEvent("Phone:Client:Spawn", function(data)
	SendNUIMessage({
		type = "EVENT_SPAWN",
		data = data,
	})
end)

RegisterNetEvent("Characters:Client:Logout", function()
	-- TODO: Cleanup if logged out while joined in race
end)

RegisterNetEvent("Phone:Client:Redline:CreateRace", function(race)
	SendNUIMessage({
		type = "ADD_PENDING_RACE",
		data = race,
	})
end)

RegisterNetEvent("Phone:Client:Redline:CancelRace", function(id)
	SendNUIMessage({
		type = "CANCEL_RACE",
		data = {
			race = id,
			myRace = id == _activeRace._id,
		},
	})
	if id == _activeRace._id then
		Cleanup()
	end
end)

RegisterNetEvent("Phone:Client:Redline:FinishRace", function(id, race)
	SendNUIMessage({
		type = "FINISH_RACE",
		data = {
			index = id,
			race = race,
		},
	})
end)

RegisterNetEvent("Phone:Client:Redline:StartRace", function(id)
	SendNUIMessage({
		type = "STATE_UPDATE",
		data = {
			race = id,
			state = 1,
		},
	})

	if _activeRace ~= nil and id == _activeRace._id then
		Cleanup()
		StartRace()
	end
end)

RegisterNetEvent("Phone:Client:Redline:JoinRace", function(id, racer)
	SendNUIMessage({
		type = "JOIN_RACE",
		data = {
			race = id,
			racer = racer,
		},
	})
end)

RegisterNetEvent("Phone:Client:Redline:LeaveRace", function(id, racer)
	SendNUIMessage({
		type = "LEAVE_RACE",
		data = {
			race = id,
			racer = racer,
		},
	})
end)

RegisterNetEvent("Phone:Redline:NotifyDNFStart", function(id, time)
	SendNUIMessage({
		type = "DNF_START",
		data = {
			time = time,
		},
	})
end)

RegisterNetEvent("Phone:Redline:NotifyDNF", function(id)
	_activeRace.dnf = true
	Cleanup()
	UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
	SendNUIMessage({
		type = "RACE_DNF",
	})
end)

RegisterNUICallback("CreateRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:CreateRace", data, function(res)
		if res == nil or res.failed then
			_activeRace = nil
			cb(res or false)
		else
			_activeRace = res
			AddRaceBlip(_activeRace.trackData.Checkpoints[1])
			SetNewWaypoint(
				_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
				_activeRace.trackData.Checkpoints[1].coords.y + 0.0
			)
			cb(true)
		end
	end)
end)

RegisterNUICallback("CancelRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:CancelRace", data, function(res)
		cb(res)
	end)
end)

RegisterNUICallback("PracticeTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:GetTrack", data, function(res)
		cb(res ~= nil)
		if res ~= nil then
			SetupTrack(res)
			_activeRace = res
		end
	end)
end)

RegisterNUICallback("JoinRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:JoinRace", data, function(res)
		if res then
			_activeRace = res

			AddRaceBlip(_activeRace.trackData.Checkpoints[1])
			SetNewWaypoint(
				_activeRace.trackData.Checkpoints[1].coords.x + 0.0,
				_activeRace.trackData.Checkpoints[1].coords.y + 0.0
			)
		end
		cb(res ~= nil)
	end)
end)

RegisterNUICallback("LeaveRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:LeaveRace", data, function(res)
		if _activeRace ~= nil then
			_activeRace.dnf = true
			Cleanup()
			UISounds.Play:FrontEnd(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
			SendNUIMessage({
				type = "RACE_DNF",
			})
		end
		cb(res)
	end)
end)

RegisterNUICallback("CreateTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		cb(res)
		if res then
			_creator = true
			CreatorThread()
		end
	end)
end)

RegisterNUICallback("FinishCreator", function(data, cb)
	_creator = false
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			if #_pendingTrack.Checkpoints > 2 then
				_pendingTrack.Name = data.name
				_pendingTrack.Type = data.type
				_pendingTrack.Distance = 0
				for i = 1, #_pendingTrack.Checkpoints do
					if i == #_pendingTrack.Checkpoints and data.type ~= "p2p" then
						_pendingTrack.Distance = _pendingTrack.Distance
							+ #(
								vector3(
									_pendingTrack.Checkpoints[i].coords.x,
									_pendingTrack.Checkpoints[i].coords.y,
									_pendingTrack.Checkpoints[i].coords.z
								)
								- vector3(
									_pendingTrack.Checkpoints[1].coords.x,
									_pendingTrack.Checkpoints[1].coords.y,
									_pendingTrack.Checkpoints[1].coords.z
								)
							)
					elseif i < #_pendingTrack.Checkpoints then
						_pendingTrack.Distance = _pendingTrack.Distance
							+ #(
								vector3(
									_pendingTrack.Checkpoints[i].coords.x,
									_pendingTrack.Checkpoints[i].coords.y,
									_pendingTrack.Checkpoints[i].coords.z
								)
								- vector3(
									_pendingTrack.Checkpoints[i + 1].coords.x,
									_pendingTrack.Checkpoints[i + 1].coords.y,
									_pendingTrack.Checkpoints[i + 1].coords.z
								)
							)
					end
				end
				_pendingTrack.Distance = quickMaths((_pendingTrack.Distance / 1609.34)) .. " Miles"
				Callbacks:ServerCallback("Phone:Redline:SaveTrack", _pendingTrack, function(res2)
					cb(res2)
				end)
			else
				Notification:Error("Not Enough Checkpoints")
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("DeleteTrack", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			Callbacks:ServerCallback("Phone:Redline:DeleteTrack", data, function(res2)
				cb(res2)
			end)
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("ResetTrackHistory", function(data, cb)
	Callbacks:ServerCallback("Phone:Permissions", {
		redline = { "create" },
	}, function(res)
		if res then
			Callbacks:ServerCallback("Phone:Redline:ResetTrackHistory", data, function(res2)
				cb(res2)
			end)
		else
			cb(false)
		end
	end)
end)

RegisterNUICallback("StopCreator", function(data, cb)
	cb("OK")
	_creator = false
end)

RegisterNUICallback("StartRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:StartRace", _activeRace._id, cb)
end)

RegisterNUICallback("EndRace", function(data, cb)
	Callbacks:ServerCallback("Phone:Redline:EndRace", data, cb)
end)

RegisterNUICallback("LapDetails", function(data, cb)
	cb("OK")
	if IsInRacePD() then
		LapDetailsPD(data)
	else
		Callbacks:ServerCallback("Phone:Redline:SaveLaptimes", data)
		if not _activeRace.dnf then
			local veh = GetVehiclePedIsIn(PlayerPedId())

			local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
			local vehEnt = Entity(veh)
			if vehEnt and vehEnt.state and vehEnt.state.Make and vehEnt.state.Model then
				vehName = vehEnt.state.Make .. " " .. vehEnt.state.Model
			end

			TriggerServerEvent(
				"Phone:Redline:FinishRace",
				NetworkGetNetworkIdFromEntity(veh),
				_activeRace._id,
				data,
				GetVehicleNumberPlateText(veh),
				vehName
			)
		else
			SendNUIMessage({
				type = "I_RACE",
				data = {
					state = false,
				},
			})
			_inRace = false
		end
		_activeRace = nil
	end
end)

function SetupTrack(skipBlip)
	Cleanup()
	for k, v in ipairs(_activeRace.trackData.Checkpoints) do
		if not skipBlip then
			AddRaceBlip(v)
		end
	end
end

-- This is a fucking mess that somehow functions? Someone that is sane pls rewrite
function StartRace()
	local cCp = 1
	local sCp = -1
	local cLp = 1
	local myPed = PlayerPedId()
	local cCps = {}

	_inRace = true
	SetupTrack()

	local countdownMax = tonumber(_activeRace.countdown) or 20
	local countdown = 0
	while countdown < countdownMax do
		Notification:Info(string.format("Race Starting In %s", countdownMax - countdown))
		UISounds.Play:FrontEnd(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET")
		countdown = countdown + 1
		Wait(1000)
	end

	CreateThread(function()
		Notification:Info("Race Started")
		UISounds.Play:FrontEnd(-1, "GO", "HUD_MINI_GAME_SOUNDSET")
		SendNUIMessage({
			type = "RACE_START",
			data = {
				totalCheckpoints = #_activeRace.trackData.Checkpoints,
				totalLaps = _activeRace.laps,
				track = _activeRace.trackData,
			},
		})
		while _activeRace ~= nil and _loggedIn do
			local myPos = GetEntityCoords(myPed)
			local cp = _activeRace.trackData.Checkpoints[cCp]
			if cp == nil then
				cp = _activeRace.trackData.Checkpoints[1]
			end

			local dist = #(vector3(cp.coords.x, cp.coords.y, cp.coords.z) - myPos)

			if dist <= cp.size or sCp == -1 then
				local blip = raceBlips[cCp]
				if cCp == 1 and #cCps == #_activeRace.trackData.Checkpoints and _activeRace.trackData.Type ~= "p2p" then
					cLp = cLp + 1
					cCps = {}
					if cLp <= tonumber(_activeRace.laps) then
						Notification:Info(string.format("Lap %s", cLp))
						UISounds.Play:FrontEnd(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET")
						SendNUIMessage({
							type = "RACE_LAP",
						})
					end
				end

				if sCp ~= -1 then
					SetBlipColour(blip, 0)
					SetBlipScale(blip, 0.75)
					table.insert(cCps, cCp)
					UISounds.Play:FrontEnd(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET")
					if cCp < #_activeRace.trackData.Checkpoints then
						cCp = cCp + 1
						SendNUIMessage({
							type = "RACE_CP",
							data = {
								cp = #cCps,
							},
						})
					elseif _activeRace.trackData.Type ~= "p2p" then
						cCp = 1
						SendNUIMessage({
							type = "RACE_CP",
							data = {
								cp = #_activeRace.trackData.Checkpoints,
							},
						})
					end
				end

				if
					_activeRace.trackData.Type == "p2p" and #cCps == #_activeRace.trackData.Checkpoints
					or cLp > tonumber(_activeRace.laps)
				then
					Notification:Info("Race Finished")
					Cleanup()
					UISounds.Play:FrontEnd(-1, "FIRST_PLACE", "HUD_MINI_GAME_SOUNDSET")
					SendNUIMessage({
						type = "RACE_END",
					})
					SendNUIMessage({
						type = "I_RACE",
						data = {
							state = false,
						},
					})
					_inRace = false
					return
				end

				cp = _activeRace.trackData.Checkpoints[cCp]
				blip = raceBlips[cCp]
				SetBlipColour(blip, 6)
				SetBlipScale(blip, 1.3)
				SetBlipColour(raceBlips[cCp + 1], 6)
				SetBlipScale(raceBlips[cCp + 1], 1.15)

				-- Like what the fuck is this code?
				local ftr = nil
				if cCp + 1 > #_activeRace.trackData.Checkpoints then
					ftr = _activeRace.trackData.Checkpoints[1]
				else
					ftr = _activeRace.trackData.Checkpoints[cCp + 1]
				end

				if
					cLp > tonumber(_activeRace.laps)
					or (_activeRace.trackData.Type == "p2p" and cCp == #_activeRace.trackData.Checkpoints)
				then
					ftr = cp
				end

				local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
				if v ~= 0 and GetPedInVehicleSeat(v) then
					SetNewWaypoint(ftr.coords.x, ftr.coords.y)
				end
				sCp = cCp
			end

			if not IsWaypointActive() then
				local ftr = nil
				if cCp + 1 > #_activeRace.trackData.Checkpoints then
					ftr = _activeRace.trackData.Checkpoints[1]
				else
					ftr = _activeRace.trackData.Checkpoints[cCp + 1]
				end
				local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
				if v ~= 0 and GetPedInVehicleSeat(v) then
					SetNewWaypoint(ftr.coords.x, ftr.coords.y)
				end
			end

			Wait(1)
		end
	end)
end

function Cleanup()
	DeleteWaypoint()
	ClearGpsMultiRoute()
	for k, v in ipairs(raceBlips) do
		RemoveBlip(v)
	end
	raceBlips = {}
	for k, v in pairs(raceObjs) do
		for k2, v2 in ipairs(v) do
			DeleteObject(v2)
		end
	end

	for k, v in pairs(tempCheckpointObj) do
		if v then
			DeleteObject(v)
		end
	end
end

function quickMaths(num)
	return tonumber(string.format("%.2f", num))
end

function AddRaceBlip(data)
	local newBlip = AddBlipForCoord(data.coords.x + 0.0, data.coords.y + 0.0, data.coords.z + 0.0)
	SetBlipAsFriendly(newBlip, true)
	local sprite = 1
	if data.isStart then
		sprite = 38
	end
	SetBlipScale(newBlip, 0.75)
	SetBlipSprite(newBlip, sprite)

	if not data.isStart then
		ShowNumberOnBlip(newBlip, #raceBlips)
	end

	BeginTextCommandSetBlipName("STRING")
	local str = string.format("Checkpoint %s", #raceBlips)
	if data.isStart then
		str = "Start Line"
	end
	SetBlipAsShortRange(newBlip, true)
	AddTextComponentString(str)
	EndTextCommandSetBlipName(newBlip)

	table.insert(raceBlips, newBlip)

	local objData = {}

	if data.isStart then
		local l = CreateObject(
			GetHashKey("prop_beachflag_le"),
			data.left.x,
			data.left.y,
			data.left.z,
			false,
			true,
			false
		)
		local r = CreateObject(
			GetHashKey("prop_beachflag_le"),
			data.right.x,
			data.right.y,
			data.right.z,
			false,
			true,
			false
		)
		PlaceObjectOnGroundProperly(l)
		PlaceObjectOnGroundProperly(r)
		table.insert(objData, l)
		table.insert(objData, r)
	else
		local l = CreateObject(
			GetHashKey("prop_offroad_tyres02"),
			data.left.x,
			data.left.y,
			data.left.z,
			false,
			true,
			false
		)
		local r = CreateObject(
			GetHashKey("prop_offroad_tyres02"),
			data.right.x,
			data.right.y,
			data.right.z,
			false,
			true,
			false
		)
		PlaceObjectOnGroundProperly(l)
		PlaceObjectOnGroundProperly(r)
		table.insert(objData, l)
		table.insert(objData, r)
	end

	table.insert(raceObjs, objData)
end

function rotateVector(vector, degrees)
	local rads = math.rad(degrees)
	local x = math.cos(rads) * vector.x - math.sin(rads) * vector.y
	local y = math.sin(rads) * vector.x + math.cos(rads) * vector.y
	return { x = x, y = y, z = vector.z }
end

function enlargeVector(vectorOrigin, vectorAngle, distance)
	local distanceVector = vector3(
		(vectorAngle.x - vectorOrigin.x) * distance,
		(vectorAngle.y - vectorOrigin.y) * distance,
		(vectorAngle.z - vectorOrigin.z) * distance
	)
	return {
		x = quickMaths(vectorOrigin.x + distanceVector.x),
		y = quickMaths(vectorOrigin.y + distanceVector.y),
		z = quickMaths(vectorOrigin.z),
	}
end

function CreateCheckpoint()
	local pPed = PlayerPedId()
	local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
	facingVector = {
		x = fX,
		y = fY,
		z = fZ,
	}
	local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

	local lcp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]
	local dist = -1

	if lcp ~= nil then
		dist = #(vector3(pX, pY, pZ) - vector3(lcp.coords.x, lcp.coords.y, lcp.coords.z))
	end

	if lcp == nil or dist > 5 then
		local fuckme = rotateVector(facingVector, 90)
		local left = enlargeVector(
			{ x = pX, y = pY, z = pZ },
			{ x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
			_size / 2
		)
		local fuckme2 = rotateVector(facingVector, -90)
		local right = enlargeVector(
			{ x = pX, y = pY, z = pZ },
			{ x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
			_size / 2
		)
		-- _pendingTrack.Checkpoints[(#_pendingTrack.Checkpoints + 1)] = {
		-- 	coords = {
		-- 		x = quickMaths(pX),
		-- 		y = quickMaths(pY),
		-- 		z = quickMaths(pZ),
		-- 	},
		-- 	facingVector = facingVector,
		-- 	left = left,
		-- 	leftrv = rotateVector(facingVector, 90),
		-- 	right = right,
		-- 	rightrv = rotateVector(facingVector, -90),
		-- 	isStart = #_pendingTrack.Checkpoints == 0,
		-- 	size = _size / 2,
		-- }

		table.insert(_pendingTrack.Checkpoints, {
			coords = {
				x = quickMaths(pX),
				y = quickMaths(pY),
				z = quickMaths(pZ),
			},
			facingVector = facingVector,
			left = left,
			leftrv = rotateVector(facingVector, 90),
			right = right,
			rightrv = rotateVector(facingVector, -90),
			isStart = #_pendingTrack.Checkpoints == 0,
			size = _size / 2,
		})

		AddRaceBlip(_pendingTrack.Checkpoints[#_pendingTrack.Checkpoints])
	else
		Notification:Error("Point Too Close To Last Point")
	end
end

function RemoveCheckpoint()
	if #_pendingTrack.Checkpoints > 0 then
		local cp = _pendingTrack.Checkpoints[#_pendingTrack.Checkpoints]

		RemoveBlip(raceBlips[#_pendingTrack.Checkpoints])
		table.remove(raceBlips, #_pendingTrack.Checkpoints)

		for k, v in ipairs(raceObjs[#_pendingTrack.Checkpoints]) do
			DeleteObject(v)
			table.remove(raceObjs, #_pendingTrack.Checkpoints)
		end

		table.remove(_pendingTrack.Checkpoints, #_pendingTrack.Checkpoints)
	end
end

function DisplayTempCheckpoint()
	local pPed = PlayerPedId()
	local fX, fY, fZ = table.unpack(GetEntityForwardVector(pPed))
	facingVector = {
		x = fX,
		y = fY,
		z = fZ,
	}
	local pX, pY, pZ = table.unpack(GetEntityCoords(pPed))

	local fuckme = rotateVector(facingVector, 90)
	local left = enlargeVector(
		{ x = pX, y = pY, z = pZ },
		{ x = pX + fuckme.x, y = pY + fuckme.y, z = pZ + fuckme.z },
		_size / 2
	)
	local fuckme2 = rotateVector(facingVector, -90)
	local right = enlargeVector(
		{ x = pX, y = pY, z = pZ },
		{ x = pX + fuckme2.x, y = pY + fuckme2.y, z = pZ + fuckme2.z },
		_size / 2
	)

	if not tempCheckpointObj.l then
		tempCheckpointObj.l = CreateObject(
			GetHashKey("prop_offroad_tyres02"),
			left.x,
			left.y,
			left.z,
			false,
			true,
			false
		)

		tempCheckpointObj.r = CreateObject(
			GetHashKey("prop_offroad_tyres02"),
			right.x,
			right.y,
			right.z,
			false,
			true,
			false
		)
	end

	SetEntityCoords(tempCheckpointObj.l, left.x, left.y, left.z)
	SetEntityCoords(tempCheckpointObj.r, right.x, right.y, right.z)
	for k, v in pairs(tempCheckpointObj) do
		PlaceObjectOnGroundProperly(v)
		SetEntityCollision(v, false, true)
		FreezeEntityPosition(v, true)
	end
end

function CreatorThread()
	_size = 20.0
	_pendingTrack = {
		Checkpoints = {},
		History = {},
	}

	tempCheckpointObj = {
		l = false,
		r = false,
	}

	CreateThread(function()
		while _creator do
			DisplayTempCheckpoint()

			if IsControlPressed(0, 10) then
				_size = _size + 0.5
				if _size > MAX_SIZE then
					_size = MAX_SIZE
				end
			end

			if IsControlPressed(0, 11) then
				_size = _size - 0.5
				if _size < MIN_SIZE then
					_size = MIN_SIZE
				end
			end

			if IsControlJustReleased(0, 38) then
				if IsControlPressed(0, 21) then
					RemoveCheckpoint()
				else
					CreateCheckpoint()
				end
				Wait(1000)
			end

			Wait(1)
		end
		Cleanup()
		SendNUIMessage({
			type = "RACE_STATE_CHANGE",
			data = {
				state = null,
			},
		})
	end)
end
