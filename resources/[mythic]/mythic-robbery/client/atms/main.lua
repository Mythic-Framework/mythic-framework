local atmObjects = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`,
}

local _atmZone
local _blip

local _phoneApp = {
    color = '#247919',
    label = 'Root',
    icon = 'terminal',
}

AddEventHandler("Robbery:Client:Setup", function()
    local atmRobbery = GlobalState["ATMRobberyTerminal"]
    Targeting.Zones:AddBox("atm-robbery-terminal", "bug", atmRobbery.coords, atmRobbery.length, atmRobbery.width, atmRobbery.options, {
        {
            icon = "eye-evil",
            text = "Do Illegal Things",
            event = "Robbery:Client:ATM:UseTerminal",
            item = "vpn",
            data = {},
            isEnabled = function(data, entity)
                return not LocalPlayer.state.ATMRobbery or LocalPlayer.state.ATMRobbery <= 0
            end,
        },
    }, 2.0)

    for k, v in ipairs(atmObjects) do
        Targeting:AddObject(v, "credit-card", {
            {
                text = "Run Exploit",
                icon = 'eye-evil',
                event = "Robbery:Client:ATM:StartHack",
                data = {},
                minDist = 2.0,
                isEnabled = function(data, entity)
                    if LocalPlayer.state.ATMRobbery and LocalPlayer.state.ATMRobbery > 0 then
                        if _atmZone and #(_atmZone.coords - LocalPlayer.state.position) <= _atmZone.radius then
                            return true
                        end
                    end
                end,
            },
        }, 3.0)
    end
end)

AddEventHandler("Robbery:Client:ATM:UseTerminal", function()
    if GlobalState['Sync:IsNight'] then
        if (not GlobalState["ATMRobberyStartCD"]) or (GlobalState["OS:Time"] > GlobalState["ATMRobberyStartCD"]) then
            Minigame.Play:Memory(5, 1200, 9000, 5, 5, 5, 2, {
                onSuccess = function(data)
                    Callbacks:ServerCallback("Robbery:ATM:StartJob", true, function(success, locationId)
                        if success then
                            Phone.Notification:AddWithId("ATMRobbery", "Started - Good Luck", "Access an ATM in the highlighted area", GetCloudTimeAsInt() * 1000, -1, {
                                color = '#247919',
                                label = 'Root',
                                icon = 'terminal',
                            }, {
                                accept = "dicks",
                            }, nil)

                            StartATMRobbery(locationId, true)
                        else
                            if locationId then
                                Phone.Notification:Add("No More!", "You already have done too much today...", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
                            end
                        end
                    end)
                end,
                onFail = function(data)
                    Callbacks:ServerCallback("Robbery:ATM:StartJob", false, function() end)

                    Phone.Notification:Add("Not Today Failure", "Your skills are useless to us...", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
                end,
            }, {
                playableWhileDead = false,
                animation = {
                    animDict = "anim@heists@prison_heiststation@cop_reactions",
                    anim = "cop_b_idle",
                    flags = 17,
                },
            }, {})
        else
            Phone.Notification:Add("Busy at the Moment", "Sorry, please try again in a minute.", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
        end
    else
        Phone.Notification:Add("Come Back Later", "Sorry, please try again when it's dark.", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
    end
end)

function StartATMRobbery(locationId, firstLocation)
    _atmZone = GlobalState["ATMRobberyAreas"][locationId]

    if not _atmZone then return; end

    if _blip then
        RemoveBlip(_blip) 
    end

    _blip = AddBlipForRadius(_atmZone.coords.x, _atmZone.coords.y, _atmZone.coords.maxZ, _atmZone.radius + 0.0)
    SetBlipColour(_blip, 1)
    SetBlipAlpha(_blip, 90)

    Blips:Add("ATMRobbery", "Target Area", _atmZone.coords, 521, 6, 1.5)

    ClearGpsPlayerWaypoint()
	SetNewWaypoint(_atmZone.coords.x, _atmZone.coords.y)

    if not firstLocation then
        Phone.Notification:AddWithId("ATMRobbery", "Well Done - Next!", "Access an ATM in the new highlighted area", GetCloudTimeAsInt() * 1000, -1, _phoneApp, {
            accept = "dicks",
        }, nil)
    end
end

function EndATMRobbery()
    RemoveBlip(_blip)
    Blips:Remove("ATMRobbery")

    _blip = nil

    Phone.Notification:Remove("ATMRobbery")
end

function DoATMProgress(label, duration, canCancel, cb)
    Progress:Progress({
		name = "installing_atm_hack",
		duration = (math.random(10) + 10) * 1000,
		label = label,
		useWhileDead = false,
		canCancel = canCancel,
        ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "type",
		},
	}, function(status)
        if cb then
            cb(status)
        end
    end)
end

AddEventHandler('Robbery:Client:ATM:StartHack', function(entity)
    local coords = GetEntityCoords(LocalPlayer.state.ped)
    local alarm = false

    if math.random(100) >= 75 then
        alarm = true

        SetTimeout(8000, function()
            Sounds.Play:Location(coords, 20.0, "house_alarm.ogg", 0.05)
            TriggerServerEvent("Robbery:Server:ATM:AlertPolice", coords)
        end)
    end

    DoATMProgress("Connecting & Installing", (math.random(10) + 20) * 1000, true, function(status)
        if status then return; end

        local size = math.random(5, 7)
        local toGet = math.random(4, 6)

        Minigame.Play:Memory(5, 1000, 8000, size, size, toGet, 1, {
            onSuccess = function(data)

                while LocalPlayer.state.doingAction do -- Apparently this is dumb
                    Wait(100)
                end

                DoATMProgress("Executing", (math.random(10) + 10) * 1000, false, function(status)
                    Callbacks:ServerCallback("Robbery:ATM:HackATM", size, function(success, locationId)
                        if success then
                            DoATMProgress("Uninstalling", (math.random(5) + 10) * 1000, false)
                            if locationId then
                                StartATMRobbery(locationId, false)
                            else
                                Phone.Notification:Add("Done", "We hope to work with you more in the future.", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
                            end
                        end

                        if not success or not locationId then
                            EndATMRobbery()
                        end
                    end)
                end)
            end,
            onFail = function(data)
                Sounds.Play:Location(coords, 20.0, "house_alarm.ogg", 0.05)

                while LocalPlayer.state.doingAction do -- Apparently this is dumb
                    Wait(100)
                end

                Callbacks:ServerCallback("Robbery:ATM:FailHackATM", {
                    coords = coords,
                    alarm = alarm,
                }, function()
                    DoATMProgress("Uninstalling", (math.random(5) + 10) * 1000, false)

                    EndATMRobbery()

                    Phone.Notification:Add("Failed", "I can't believe you just did this.", GetCloudTimeAsInt() * 1000, 7500, _phoneApp, {}, nil)
                end)
            end,
        }, {
            playableWhileDead = false,
            animation = {
                anim = "type",
            },
        }, {})
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    EndATMRobbery()
end)