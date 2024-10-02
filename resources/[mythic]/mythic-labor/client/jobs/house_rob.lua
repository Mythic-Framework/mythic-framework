local _joiner = nil
local _working = false
local _state = 0
local _blips = {}
local eventHandlers = {}
local _isEntering = false


local actionSpecifics = {
    ['big_tv'] = { 'Unplugging TV', 45 },
    tv = { 'Unplugging TV', 45 },
    microwave = { 'Unplugging Microwave', 30 },
    boombox = { 'Stealing Boombox', 15 },
    golfclubs = { 'Stealing Golf Clubs', 10 },
    ['house_art'] = { 'Removing Painting', 25 },
}


local _p = nil
local _exit = nil
local _nodes = nil
local _stuff = {}

local _lpStage = 0
local _scPass = 1
local _scFails = 0

LocalPlayer.state.inRobbedHouse = false

local _, relHash = AddRelationshipGroup('HOMEOWNER')
SetRelationshipBetweenGroups(5, relHash, `PLAYER`)
SetRelationshipBetweenGroups(5, `PLAYER`, relHash)

local _queueLoc = nil
RegisterNetEvent("Labor:Client:GetLocs", function(locs)
    _queueLoc = locs.houseRobbery or {}
end)

AddEventHandler("Labor:Client:Setup", function()
    while _queueLoc == nil do
        Wait(10)
    end

    if _queueLoc.coords == nil then return end
	PedInteraction:Add("HouseRobbery", `csb_grove_str_dlr`, _queueLoc.coords, _queueLoc.heading, 25.0, {
		{
			icon = "house-chimney-crack",
			text = "Do A Thing",
			event = "HouseRobbery:Client:Enable",
            data = {},
            isEnabled = function()
                return not hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_HOUSE_ROBBERY") and LocalPlayer.state.onDuty ~= "police"
            end,
		},
	}, 'question', 'WORLD_HUMAN_SMOKING')

	Callbacks:RegisterClientCallback("HouseRobbery:Lockpick", function(data, cb)
		_lpStage = 0
		DoLockpick({ timer = 1.0, base = 5 }, data, cb)
        EmergencyAlerts:CreateIfReported(40.0, "bane", true)
	end)

	Callbacks:RegisterClientCallback("HouseRobbery:AdvLockpick", function(data, cb)
		_lpStage = 0
		DoLockpick({ timer = 0.75, base = 8 }, data, cb)
        EmergencyAlerts:CreateIfReported(40.0, "bane", true)
	end)

	Interaction:RegisterMenu("house-robbery", "Enter House", "door-open", function(data)
		Interaction:Hide()
		EnterHouse(data)
	end, function()
        if _working and _p ~= nil and _nodes ~= nil then
            local robberyHouse = GlobalState[string.format("Robbery:InProgress:%s", _p)]
            if robberyHouse then
                return #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(robberyHouse.x, robberyHouse.y, robberyHouse.z)) <= 3.0
            end
        end

        return false
	end)

	Interaction:RegisterMenu("house-robbery-exit", "Exit House", "door-closed", function(data)
		Interaction:Hide()
		ExitHouse()
	end, function()
        if GlobalState[string.format("%s:RobbingHouse", LocalPlayer.state.ID)] ~= nil and _exit ~= nil then
            local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - _exit)
            return dist <= 2.0
        else
            return false
        end
	end)
end)

local _threading = false
function DoAlarm(pId)
    if _threading then return end
    _threading = true
    CreateThread(function()
        while _threading and _working and (not _nodes.states.alarm.disabled and not _nodes.states.alarm.triggered) do
            Sounds.Play:One("alarm_warn.ogg", 0.1)
            Wait(1000)
        end
        Sounds.Stop:One("alarm_warn.ogg")
    end)
end

function ExitHouse()
    Callbacks:ServerCallback("HouseRobbery:Exit", {}, function(propId, intr)
        LocalPlayer.state.inRobbedHouse = false

        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Wait(10)
        end

        Sounds.Stop:One("alarm_warn.ogg")
        Sounds.Stop:One("house_alarm.ogg", 0.1)

        Sounds.Play:One("door_close.ogg", 0.3)
        Wait(200)

        local f = GlobalState[string.format("Robbery:InProgress:%s", propId)]

        SetEntityCoords(
            PlayerPedId(),
            f.x,
            f.y,
            f.z,
            0,
            0,
            0,
            false
        )
        Wait(100)
        SetEntityHeading(PlayerPedId(), f.h)

        if intr then
            for k, v in ipairs(intr.robberies.locations) do
                Targeting.Zones:RemoveZone(string.format("house-robbery-%s", k))
            end
        end

        if _stuff ~= nil then
            for k, v in ipairs(_stuff.pois or {}) do
                Targeting:RemoveEntity(v)
                DeleteObject(v)
            end
        end

        Targeting.Zones:Refresh()

        if _state == 5 then
            _working = false
        end

        TriggerEvent('Interiors:Exit')
		Sync:Start()

        DoScreenFadeIn(1000)
        while not IsScreenFadedIn() do
            Wait(10)
        end

        Wait(1000)

        Polyzone:Remove("property-house-rob-zone")
    end)
end

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "property-house-rob-zone" and LocalPlayer.state.inRobbedHouse and not _isEntering then
        print("Exit Robbery Property By Leaving Polyzone")
		ExitHouse()
    end
end)

function EnterHouse()
    if _p ~= nil and _working then
        Callbacks:ServerCallback("HouseRobbery:BreakIn", _p, function(r, f, exit)
            if r then
                EnterHouseShit(f, exit)
            end
        end)
    end
end

function EnterHouseShit(f, exit)
    _exit = exit

    Sounds.Play:One("door_open.ogg", 0.15)

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    FreezeEntityPosition(PlayerPedId(), true)
    Wait(50)

    SetEntityCoords(PlayerPedId(), f.x, f.y, f.z, 0, 0, 0, false)
    Wait(100)
    SetEntityHeading(PlayerPedId(), f.h)

    local time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 10000) do
        Wait(100)
    end

    FreezeEntityPosition(PlayerPedId(), false)

    Sync:Stop(1)
    TriggerEvent("Interiors:Enter", vector3(f.x, f.y, f.z))

    DoScreenFadeIn(1000)
    while not IsScreenFadedIn() do
        Wait(10)
    end
end

RegisterNetEvent("HouseRobbery:Client:Breach", function(f, exit)
    EnterHouseShit(f, exit)
end)

RegisterNetEvent("HouseRobbery:Client:OnDuty", function(joiner, time)
	_joiner = joiner
    _working = true
    _scPass = 1

	eventHandlers["receive"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Receive", joiner), function(propertyId, data)
        _p = propertyId
        _state = 1

        DeleteWaypoint()
        SetNewWaypoint(data.coords.x, data.coords.y)
        _blip = Blips:Add("HouseRobbery", "Target House", { x = data.coords.x, y = data.coords.y, z = data.coords.z }, 40, 23, 0.9)

        CreateThread(function()
            local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(data.coords.x, data.coords.y, data.coords.z))
            while _working and LocalPlayer.state.loggedIn and dist > 20 do
                Wait(100)
                dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(data.coords.x, data.coords.y, data.coords.z))
            end
            Callbacks:ServerCallback("HouseRobbery:ArrivedNear", {})
        end)
	end)

	eventHandlers["near"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Near", joiner), function(data)
        while _working and _p ~= nil do
            if LocalPlayer.state.inRobbedHouse then
                Wait(100)
            else
                local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(data.x, data.y, data.z))
                if dist < 20 then
                    DrawMarker(1, data.x, data.y, data.z + 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 250, 250, 250, 250, false, false, 2, false, false, false, false)
                    Wait(3)
                else
                    Wait(100 * dist)
                end
            end
        end
	end)

	eventHandlers["lockpicked"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Lockpicked", joiner), function(data)
        _nodes = data
        _state = 4
        Notification:Success("House Has Been Lockpicked")
	end)

	eventHandlers["do-hack"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:HackAlarm", joiner), function(entity, data)
        _scPass = 1
        DoHack(data)
    end)

	eventHandlers["hacked"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:AlarmHacked", joiner), function(data)
        if _working and not _nodes.states.alarm.triggered and not _nodes.states.alarm.disabled and LocalPlayer.state.inRobbedHouse then
            _nodes.states.alarm.disabled = true
        end
	end)

	eventHandlers["actions"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Action", joiner), function(data)
        _nodes.searched[data] = true
	end)

	eventHandlers["alarm-trigger"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:AlarmTriggered", joiner), function(data)
        if _working and not _nodes.states.alarm.triggered and not _nodes.states.alarm.disabled then
            _nodes.states.alarm.triggered = true

            if LocalPlayer.state.inRobbedHouse then
                Sounds.Loop:One("house_alarm.ogg", 0.1)
            end
        end
	end)

	eventHandlers["search"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Search", joiner), function(ent, data)
        if data.id and not _nodes.searched[data.id] then
            Progress:ProgressWithTickEvent({
                name = "robbing_action",
                duration = actionSpecifics[data.type] and (actionSpecifics[data.type][2] * 1000) or ((math.random(15) + 15) * 1000),
                label = actionSpecifics[data.type] and actionSpecifics[data.type][1] or "Searching",
                tickrate = 500,
                useWhileDead = false,
                canCancel = true,
                vehicle = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableCombat = true,
                },
                animation = {
                    anim = 'bumbin',
                },
            }, function()
                if data.id and _nodes and not _nodes.searched[data.id] then
                    return
                end
                Progress:Cancel()
            end, function(cancelled)
                if not cancelled then
                    Status.Modify:Add("PLAYER_STRESS", 3, false, true)
                    Callbacks:ServerCallback("HouseRobbery:Search", data.id)
                end
            end)
        end
    end)

	eventHandlers["end"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:EndRobbery", joiner), function(data)
        _state = 5
	end)

	eventHandlers["exit"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:Exit", joiner), function(obj, data)
        ExitHouse()
    end)

    eventHandlers["inner"] = RegisterNetEvent(string.format("HouseRobbery:Client:%s:InnerStuff", joiner), function(intr)
        _isEntering = true
        while GlobalState[string.format("%s:RobbingHouse", LocalPlayer.state.ID)] == nil do
            Wait(10)
            print("Interior Stuff Waiting, This Shouldn't Spam")
        end

        LocalPlayer.state.inRobbedHouse = true

        _stuff.pois = {}
        if _nodes.chances.alarm then
            local d = intr.robberies.pois.alarm
            local o = CreateObject(d.object, d.coords.x, d.coords.y, d.coords.z, false, true, false)
            FreezeEntityPosition(o, true)
            SetEntityHeading(o, d.heading)

            Targeting:AddEntity(o, "house-circle-exclamation", {
                {
                    icon = "house-circle-exclamation",
                    text = "Disable Alarm",
                    event = string.format("HouseRobbery:Client:%s:HackAlarm", joiner),
                    item = "electronics_kit",
                    data = _p,
                    isEnabled = function(data, entity)
                        return _working and _nodes ~= nil and _state == 4 and _nodes.chances.alarm and not _nodes.states.alarm.disabled and not _nodes.states.alarm.triggered and (_scPass <= 3 and _scFails <= 2)
                    end,
                },
            })
    
            table.insert(_stuff.pois, o)

            if (not _nodes.states.alarm.disabled and not _nodes.states.alarm.triggered) then
                DoAlarm(_p)
            elseif _nodes.states.alarm.triggered then
                Sounds.Play:One("house_alarm.ogg", 0.1)
            end
        end
    
        if _nodes.chances.owner and not IsPedDeadOrDying(_nodes.ownerPed, 1) then
            if isF then
                SetEntityMaxHealth(_nodes.ownerPed, 800)
                SetEntityHealth(_nodes.ownerPed, 800)
            end
    
            SetPedDropsWeaponsWhenDead(_nodes.ownerPed, false)
            SetPedRelationshipGroupDefaultHash(_nodes.ownerPed, relHash)
            SetPedRelationshipGroupHash(_nodes.ownerPed, relHash)
            SetCanAttackFriendly(_nodes.ownerPed, false, true)
        end
    
        for k, v in ipairs(intr.robberies.locations) do
            Targeting.Zones:AddBox(
                string.format("house-robbery-%s", k),
                "box",
                v.coords,
                v.length,
                v.width,
                v.options,
                {
                    {
                        icon = "magnifying-glass",
                        text = "Search",
                        event = string.format("HouseRobbery:Client:%s:Search", joiner),
                        data = {
                            id = k,
                            type = v.type,
                        },
                        isEnabled = function(data)
                            return _working and _state == 4 and _nodes ~= nil and data.id and not _nodes.searched[data.id]
                        end,
                    },
                },
                3.0,
                true
            )
        end


        Targeting.Zones:Refresh()

        if intr.zone then
            Polyzone.Create:Box("property-house-rob-zone", intr.zone.center, intr.zone.length, intr.zone.width, intr.zone.options, {})
        end

        Wait(2000)
        _isEntering = false
    end)
end)

AddEventHandler("HouseRobbery:Client:Enable", function()
    Callbacks:ServerCallback('HouseRobbery:Enable', {})
end)

AddEventHandler("HouseRobbery:Client:StartJob", function()
    Callbacks:ServerCallback('HouseRobbery:StartJob', _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
    end)
end)

RegisterNetEvent("HouseRobbery:Client:OffDuty", function(time)
    if LocalPlayer.state.inRobbedHouse then
        TriggerEvent(string.format("HouseRobbery:Client:%s:Exit", joiner))
    end

	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	eventHandlers = {}
	_joiner = nil
	_working = false
	_nodes = nil
    _p = nil
    _isEntering = false
end)

AddEventHandler("HouseRobbery:Client:HackSuccess", function(data)
	if not LocalPlayer.state.inRobbedHouse then
		return
	end

    _scPass = _scPass + 1
	if _scPass > 3 then
		_scPass = 1
        Callbacks:ServerCallback("HouseRobbery:HackAlarm", {
			propertyId = data.pId,
			state = true
		}, function()
            Notification:Success("Alarm Bypassed")
		end)
	else
		Wait(1500)
		DoHack(data.pId)
	end
end)

AddEventHandler("HouseRobbery:Client:HackFail", function(data)
	if not LocalPlayer.state.inRobbedHouse then
		return
	end

    _scFails = _scFails + 1

    if _scFails > 2 then
        _scFails = 1
        Callbacks:ServerCallback("HouseRobbery:HackAlarm", {
            propertyId = data.pId,
            state = false
        }, function()
        
        end)
    else
        _scPass = 1
		Wait(1500)
		DoHack(data)
    end
end)

local stageComplete = 0
function DoLockpick(diff, data, cb)
	Minigame.Play:RoundSkillbar((diff.timer + (0.2 * data.tier)), diff.base - stageComplete, {
		onSuccess = function()
			Wait(400)
			if stageComplete >= 3 then
				stageComplete = 0
				cb(true)
			else
				stageComplete = stageComplete + 1
				DoLockpick(diff, data, cb)
			end
		end,
		onFail = function()
			stageComplete = 0
			cb(false)
		end,
	}, {
		useWhileDead = false,
		vehicle = false,
		animation = {
			animDict = "veh@break_in@0h@p_m_one@",
			anim = "low_force_entry_ds",
			flags = 16,
		},
	})
end

function DoHack(pId)
	Minigame.Play:Sequencer(5, 300, 7500 - (1000 * _scPass), 3 + _scPass, true, {
		onSuccess = "HouseRobbery:Client:HackSuccess",
		onFail = "HouseRobbery:Client:HackFail",
	}, {
		playableWhileDead = false,
		animation = {
			animDict = "anim@heists@ornate_bank@hack",
			anim = "hack_loop",
			flags = 49,
		},
	}, {
        pId = pId,
    })
end
