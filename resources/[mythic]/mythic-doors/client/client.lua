initLoaded = false
_showingDoorInfo = false
_lookingAtDoor = false
_lookingAtDoorCoords = nil
_lookingAtDoorRadius = nil
DOORS_STATE = false
DOORS_IDS = {}
ELEVATOR_STATE = false
_newDuty = false

DOORS_PERMISSION_CACHE = {}

AddEventHandler("Doors:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Menu = exports["mythic-base"]:FetchComponent("Menu")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Doors = exports["mythic-base"]:FetchComponent("Doors")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Doors", {
		"Logger",
		"Callbacks",
		"Game",
		"Utils",
		"Menu",
		"Notification",
		"Action",
		"Jobs",
		"Targeting",
		"ListMenu",
		"Progress",
		"Keybinds",
		"UISounds",
		"Sounds",
		"Doors",
		"Properties",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Keybinds:Add('doors_garage_fob', 'f10', 'keyboard', 'Doors - Use Garage Keyfob', function()
			DoGarageKeyFobAction()
		end)

		CreateGaragePolyZones()
		CreateElevators()
		Citizen.Wait(1000)
		InitDoors()
	end)
end)

function InitDoors()
	if initLoaded then return; end
	initLoaded = true
	DOORS_STATE = {}
	ELEVATOR_STATE = {}
	Callbacks:ServerCallback('Doors:Fetch', {}, function(fetchedDoors, fetchedElevators)

		for k, v in ipairs(_doorConfig) do
			if v.id and not DOORS_IDS[v.id] then
				DOORS_IDS[v.id] = k
			end

			local doorData = v
			doorData.id = v.id or k
			doorData.doorId = k

			doorData.locked = fetchedDoors[k].locked

			AddDoorToSystem(k, doorData.model, doorData.coords.x, doorData.coords.y, doorData.coords.z)

			if type(doorData.autoRate) == "number" and doorData.autoRate > 0.0 then
				DoorSystemSetAutomaticRate(k, doorData.autoRate + 0.0, 0, 1)
			end

			if type(doorData.autoDist) == "number" and doorData.autoDist > 0.0 then
				DoorSystemSetAutomaticDistance(k, doorData.autoDist + 0.0, 0, 1)
			end

			DoorSystemSetDoorState(k, doorData.locked and 1 or 0)

			if doorData.holdOpen then
				DoorSystemSetHoldOpen(k, true)
			end

			if fetchedDoors[k].forcedOpen then
				DoorSystemSetOpenRatio(k, -1.0)
				DoorSystemSetDoorState(k, 1)
			end

			DOORS_STATE[k] = doorData
		end

		for k, v in ipairs(_elevatorConfig) do
			for k2, v2 in pairs(v.floors) do
				v2.locked = fetchedElevators[k].floors[k2].locked
			end
			ELEVATOR_STATE[k] = v
		end

		CreateElevators()
	end)
end

function CreateElevators()
	if ELEVATOR_STATE then
		for k, v in pairs(ELEVATOR_STATE) do
			if v.floors then
				for floorId, floorData in pairs(v.floors) do
					if floorData.zone then
						if #floorData.zone > 0 then
							for j, b in ipairs(floorData.zone) do
								CreateElevatorFloorTarget(b, k, floorId, j)
							end
						else
							CreateElevatorFloorTarget(floorData.zone, k, floorId, 1)
						end
					end
				end
			end
		end
	end
end

function CreateElevatorFloorTarget(zoneData, elevatorId, floorId, zoneId)
	Targeting.Zones:AddBox(
		('elevators_'.. elevatorId .. '_level_'.. floorId .. '_' .. zoneId),
		'elevator',
		zoneData.center,
		zoneData.length,
		zoneData.width,
		{
			heading = zoneData.heading,
			minZ = zoneData.minZ,
			maxZ = zoneData.maxZ,
		},
		{
			{ 
				icon = 'elevator', 
				text = 'Use Elevator', 
				event = 'Doors:Client:OpenElevator',
				data = {
					elevator = elevatorId,
					floor = floorId,
				},
				minDist = 3.0,
				isEnabled = function()
					return (not LocalPlayer.state.Character:GetData("ICU") or LocalPlayer.state.Character:GetData("ICU").Released) and not LocalPlayer.state.isCuffed
				end,
			}
		},
		3.0,
		true
	)
end

DOORS = {
	IsLocked = function(self, doorId)
		if type(doorId) == "string" then
			doorId = DOORS_IDS[doorId]
		end

		if DOORS_STATE and DOORS_STATE[doorId] and DOORS_STATE[doorId].locked then
			return true
		end
		return false
	end,
	CheckRestriction = function(self, doorId)
		if not DOORS_STATE then
			return false
		end

		if type(doorId) == "string" then
			doorId = DOORS_IDS[doorId]
		end

		local doorData = DOORS_STATE[doorId]
		if doorData and LocalPlayer.state.Character then

			if type(doorData.restricted) ~= 'table' then
				return true
			end

			if Jobs.Permissions:HasJob('dgang', false, false, 99, true) then
				return true
			end

			local stateId = LocalPlayer.state.Character:GetData('SID')

			for k, v in ipairs(doorData.restricted) do
				if v.type == 'character' then
					if stateId == v.SID then
						return true
					end
				elseif v.type == 'job' then
					if v.job then
						if Jobs.Permissions:HasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.jobPermission) then
							return true
						end
					elseif v.jobPermission then
						if Jobs.Permissions:HasPermission(v.jobPermission) then
							return true
						end
					end
				elseif v.type == 'propertyData' then
					if Properties.Keys:HasAccessWithData(v.key, v.value) then
						return true
					end
				end
			end
		end
		return false
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Doors", DOORS)
end)

function CheckDoorAuth(doorId)
	if DOORS_STATE[doorId].hasPermission == nil or (GetGameTimer() - DOORS_STATE[doorId].lastPermissionCheck) >= 60000 or DOORS_STATE[doorId].lastDutyCheck ~= _newDuty then
		DOORS_STATE[doorId].hasPermission = Doors:CheckRestriction(doorId)
		DOORS_STATE[doorId].lastPermissionCheck = GetGameTimer()
		DOORS_STATE[doorId].lastDutyCheck = LocalPlayer.state.onDuty
		return DOORS_STATE[doorId].hasPermission
	end
	return DOORS_STATE[doorId].hasPermission
end

function StopShowingDoorInfo()
	if not _showingDoorInfo then
		return
	end
	Action:Hide()
	_showingDoorInfo = false
end

function StartShowingDoorInfo(doorId)
	_showingDoorInfo = doorId

	local actionMsg = "{keybind}primary_action{/keybind} "
		.. (
			DOORS_STATE[doorId].locked and "Unlock Door"
			or "Lock Door"
		)
	Action:Show(actionMsg)
end

function StartCharacterThreads()
	ResetLockpickAttempts()
	GLOBAL_PED = PlayerPedId()

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			GLOBAL_PED = PlayerPedId()
			Citizen.Wait(5000)
		end
	end)
end

function UselessWrapper()
	local p = promise.new()
	Citizen.CreateThread(function()
		p:resolve(DoorSystemGetActive())
	end)
	return Citizen.Await(p)
end

AddEventHandler('Targeting:Client:TargetChanged', function(entity)
	if DOORS_STATE and entity and IsEntityAnObject(entity) then
		local allSystemDoors = UselessWrapper()
		if not allSystemDoors then 
			return
		end

		for k,v in ipairs(allSystemDoors) do
			if v[2] == entity then
				local doorId = v[1]
				if DOORS_STATE[doorId] then
					_lookingAtDoor = doorId
					_lookingAtDoorCoords = GetEntityCoords(v[2])
					_lookingAtDoorRadius = DOORS_STATE[doorId].maxDist or 2.0
					_lookingAtDoorSpecial = DOORS_STATE[doorId].special

					if not _lookingAtDoorSpecial then
						Citizen.CreateThread(function()
							while _lookingAtDoor == doorId do
								local dist = #(_lookingAtDoorCoords - GetEntityCoords(GLOBAL_PED))
								local canSee = dist <= _lookingAtDoorRadius and CheckDoorAuth(_lookingAtDoor)
								if not _showingDoorInfo and canSee then
									StartShowingDoorInfo(_lookingAtDoor)
								elseif _showingDoorInfo and not canSee then
									StopShowingDoorInfo()
								end
								Citizen.Wait(500)
							end
							StopShowingDoorInfo()
						end)
					end
				end
			end
		end
	elseif _lookingAtDoor then
		_lookingAtDoor = false
		_lookingAtDoorCoords = nil
		StopShowingDoorInfo()
	end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _lookingAtDoor and _showingDoorInfo then
		StopShowingDoorInfo()
		DoorAnim()
		Callbacks:ServerCallback('Doors:ToggleLocks', _lookingAtDoor, function(success, newState)
			if success then
				Sounds.Do.Play:One('doorlocks.ogg', 0.2)
			end
		end)
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	StartCharacterThreads()
	StopShowingDoorInfo()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	StopShowingDoorInfo()
end)

-- RegisterNetEvent("Characters:Client:SetData")
-- AddEventHandler("Characters:Client:SetData", function(cData)
-- 	showing = false
-- end)

RegisterNetEvent("Doors:Client:UpdateState", function(door, state)
	if DOORS_STATE and DOORS_STATE[door] then
		DOORS_STATE[door].locked = state

		if DOORS_STATE[door].forcedOpen then
			DoorSystemSetDoorState(door, 0)
			Citizen.Wait(250)
			DoorSystemSetOpenRatio(door, 0.0)
			DOORS_STATE[door].forcedOpen = false
		end

		DoorSystemSetDoorState(door, state and 1 or 0)

		if _showingDoorInfo == door then
			StartShowingDoorInfo(door)
		end
	end
end)

RegisterNetEvent("Doors:Client:SetForcedOpen", function(door)
	if DOORS_STATE and DOORS_STATE[door] then
		DOORS_STATE[door].forcedOpen = true

		DoorSystemSetOpenRatio(door, -1.0)
		DoorSystemSetDoorState(door, 1)
	end
end)

RegisterNetEvent('Doors:Client:UpdateElevatorState', function(elevator, floor, state)
	if ELEVATOR_STATE[elevator] and ELEVATOR_STATE[elevator].floors and ELEVATOR_STATE[elevator].floors[floor] then
		--ELEVATOR_STATE[elevator].locked = state

		ELEVATOR_STATE[elevator].floors[floor].locked = state
	end
end)

function DoorAnim()
	Citizen.CreateThread(function()
		while not HasAnimDictLoaded('anim@heists@keycard@') do
			RequestAnimDict('anim@heists@keycard@')
			Wait(10)
		end

		TaskPlayAnim(LocalPlayer.state.ped, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 48, 0, 0, 0, 0)
		Citizen.Wait(750)
        StopAnimTask(LocalPlayer.state.ped, 'anim@heists@keycard@', 'exit', 1.0)
	end)
end

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	_newDuty = state
end)