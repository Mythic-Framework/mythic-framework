local wasBoosting = false
local trackerThread = false
local trackerTimer = nil

_boosting = nil

_pedModels = {
    `a_m_m_afriamer_01`,
    `a_m_m_fatlatin_01`,
    `a_m_m_business_01`,
    `a_m_m_golfer_01`,
    `a_m_m_indian_01`,
    `a_m_m_mexlabor_01`,
    `a_m_m_prolhost_01`,
    `a_m_m_soucent_01`,
    `a_m_m_stlat_02`,
    `a_m_m_tourist_01`,
    `a_m_o_salton_01`,
    `a_m_y_beachvesp_01`,
    `a_m_y_bevhills_02`,
    `a_m_y_busicas_01`,
    `a_m_y_business_01`,
    `a_m_y_business_02`,
    `a_m_y_business_03`,
    `s_m_m_autoshop_02`,
    `s_m_m_autoshop_01`,
    `s_m_m_cntrybar_01`,
    `s_m_m_ccrew_01`,
    `s_m_m_gentransport`,
    `s_m_m_movspace_01`,
    `s_f_m_sweatshop_01`,
    `s_f_m_shop_high`,
    `A_F_M_EastSA_01`,
    `A_F_M_EastSA_02`,
    `A_F_M_Downtown_01`,
    `A_F_M_Business_02`,
    `A_F_M_BevHills_02`,
    `A_F_M_FatWhite_01`,
    `A_F_M_Salton_01`,
    `A_F_O_GenStreet_01`,
    `A_F_Y_BevHills_01`,
    `A_F_Y_BevHills_03`,
    `a_f_y_epsilon_01`,
    `a_f_y_eastsa_03`,
    `a_f_y_eastsa_01`,
    `a_f_y_hiker_01`,
}

_availableWeaponsForClass = {
    D = {
        {5, `WEAPON_BAT`},
        {5, `WEAPON_GOLFCLUB`},
        {5, `WEAPON_MACHETE`},
        {70, `WEAPON_UNARMED`},
        {5, `WEAPON_KNIFE`},
        {5, `WEAPON_WRENCH`},
        {5, `WEAPON_HAMMER`},
        {5, `WEAPON_POOLCUE`},
        {5, `WEAPON_BOTTLE`},
    },
    C = {
        {5, `WEAPON_BAT`},
        {5, `WEAPON_GOLFCLUB`},
        {5, `WEAPON_MACHETE`},
        {50, `WEAPON_UNARMED`},
        {5, `WEAPON_KNIFE`},
        {5, `WEAPON_WRENCH`},
        {5, `WEAPON_HAMMER`},
        {1, `WEAPON_PISTOL`},
        {5, `WEAPON_POOLCUE`},
        {5, `WEAPON_BOTTLE`},
    },
    B = {
        {5, `WEAPON_BAT`},
        {2, `WEAPON_MACHETE`},
        {40, `WEAPON_UNARMED`},
        {5, `WEAPON_KNIFE`},
        {5, `WEAPON_WRENCH`},
        {5, `WEAPON_HAMMER`},
        {5, `WEAPON_BOTTLE`},
        {5, `WEAPON_PISTOL`},
        {2, `WEAPON_SNSPISTOL`},
        {5, `WEAPON_REVOLVER`},
        {2, `WEAPON_PISTOL50`},
        {1, `WEAPON_APPISTOL`},
    },
    A = {
        {5, `WEAPON_BAT`},
        {8, `WEAPON_MACHETE`},
        {20, `WEAPON_UNARMED`},
        {8, `WEAPON_KNIFE`},
        {8, `WEAPON_WRENCH`},
        {5, `WEAPON_PISTOL`},
        {5, `WEAPON_SNSPISTOL`},
        {5, `WEAPON_REVOLVER`},
        {5, `WEAPON_PISTOL50`},
        {1, `WEAPON_PUMPSHOTGUN`},
        {5, `WEAPON_APPISTOL`},
    },
    ["A+"] = {
        {5, `WEAPON_MACHETE`},
        {1, `WEAPON_UNARMED`},
        {5, `WEAPON_KNIFE`},
        {5, `WEAPON_SNSPISTOL`},
        {5, `WEAPON_REVOLVER`},
        {5, `WEAPON_PISTOL50`},
        {5, `WEAPON_PUMPSHOTGUN`},
        {5, `WEAPON_APPISTOL`},
        {2, `WEAPON_SAWNOFFSHOTGUN`},
        {1, `WEAPON_MICROSMG`},
        {1, `WEAPON_MINISMG`},
    },
    ["S+"] = {
        {1, `WEAPON_MACHETE`},
        {2, `WEAPON_REVOLVER`},
        {5, `WEAPON_PISTOL50`},
        {5, `WEAPON_PUMPSHOTGUN`},
        {5, `WEAPON_APPISTOL`},
        {5, `WEAPON_SAWNOFFSHOTGUN`},
        {5, `WEAPON_MICROSMG`},
        {5, `WEAPON_MINISMG`},
        {4, `WEAPON_ASSAULTRIFLE`},
        {4, `WEAPON_COMBATPDW`},
    },
}

_trackerHacks = {
    ["S+"] = {
        rows = 10, 
        lengthMin = 4,
        lengthMax = 6,
        duration = 20000, 
        charSize = 2,
        charSet = {
            {15, "alphanumer"},
            {10, "symbols"},
            {15, "greek"},
            {10, "currency"},
            {5, "braille"},
        } 
    },
    ["A+"] = {
        rows = 10, 
        lengthMin = 4,
        lengthMax = 6, 
        duration = 20000, 
        charSize = 2,
        charSet = {
            {20, "alphanumer"},
            {5, "symbols"},
            {10, "greek"},
            {2, "currency"},
        }
    },
    A = {
        rows = 8, 
        lengthMin = 3,
        lengthMax = 5, 
        duration = 25000, 
        charSize = 2,
        charSet = {
            {25, "alphanumer"},
            {15, "alphabet"},
            {2, "symbols"},
            {10, "greek"},
        }
    },
    B = {
        rows = 8, 
        lengthMin = 2,
        lengthMax = 4,
        duration = 25000, 
        charSize = 1,
        charSet = {
            {5, "numeric"},
            {20, "alphabet"},
            {15, "alphanumer"},
            {1, "greek"},
        }
    },
}

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
    LocalPlayer.state.isBoosting = false
    _boosting = nil
    wasBoosting = false
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
    Wait(1000)
    Hud:RegisterStatus("boosting-timer", 0, 100, "hourglass", "#892020", false, false, {
        hideZero = true,
    })
end)

RegisterNetEvent("Laptop:Client:LSUnderground:Boosting:Start", function(data)
    LocalPlayer.state.isBoosting = true
    _boosting = data
    wasBoosting = true
    trackerThread = false

    if _boosting then
        if _boosting.pickUp then
            local function getRandomPointWithinCircle(center, maxRadius)
                local angle = math.random() * 2 * math.pi
                local distance = math.sqrt(math.random()) * maxRadius
                local offsetX = math.cos(angle) * distance
                local offsetY = math.sin(angle) * distance
                return vector3(center.x + offsetX, center.y + offsetY, center.z)
            end

            local radius = 100.0
            local randomizedCenter = getRandomPointWithinCircle(_boosting.pickUp, radius)

            local blip = AddBlipForRadius(randomizedCenter.x, randomizedCenter.y, randomizedCenter.z, radius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, 17)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)

            _boosting.blip = blip
        end

        Polyzone.Create:Circle("boosting-dropoff", _boosting.dropOff, 30.0, {})
    end
end)

RegisterNetEvent("Laptop:Client:LSUnderground:Boosting:UpdateState", function(state, data)
    if not _boosting then return; end

    print("Update Boosting State: ", state)

    _boosting.state = state

    if state == 1 then
        if _boosting and _boosting.blip then
            RemoveBlip(_boosting.blip)
            _boosting.blip = nil
        end
    elseif state == 2 then

        if data then
            _boosting.trackerDelay = data.trackerDelay
            _boosting.trackerCount = data.trackerCount
        end

        if not trackerThread then
            trackerThread = true
            CreateThread(function()
                while _boosting and _boosting.state == 2 and LocalPlayer.state.loggedIn do
                    if NetworkDoesEntityExistWithNetworkId(_boosting.vehicleNet) then
                        local veh = NetToVeh(_boosting.vehicleNet)
                        if veh == GetVehiclePedIsIn(LocalPlayer.state.ped, false) then
                            UISounds.Play:FrontEnd(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET")
                        end
                    end

                    Wait(7000 + (_boosting.trackerDelay * 1000))
                end
            end)
        end
    elseif state == 3 and _boosting.dropOff then
        Notification.Persistent:Remove("boosting-trackers")
        Blips:Add(
            "boosting-contract",
            "[Contract]: Dropoff Location",
            _boosting.dropOff,
            523,
            6,
            1.1,
            2,
            false,
            false
        )

        --ClearGpsPlayerWaypoint()
        --SetNewWaypoint(_boosting.dropOff.x, _boosting.dropOff.y)
        TriggerEvent("Status:Client:Update", "boosting-timer", 0)
    end
end)

RegisterNetEvent("Laptop:Client:LSUnderground:Boosting:TrackerNotificationUpdate", function(notif)
    Notification.Persistent:Info("boosting-trackers", notif)
end)

AddEventHandler("Laptop:Client:LSUnderground:Boosting:AttemptExterior", function(veh)
    if _boosting and NetworkDoesEntityExistWithNetworkId(_boosting.vehicleNet) then
        if veh == NetToVeh(_boosting.vehicleNet) then
            Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Exterior", {}, function(numPeds, makeDifficult, noAlert)
                if numPeds then
                    --numPeds = 0
                    local availableWeapons = _availableWeaponsForClass[_boosting.vehicleData?.class or "D"]

                    CreateThread(function()
                        for i = 1, numPeds do
                            local model = _pedModels[math.random(#_pedModels)]
                            local spawn = _boosting.pedSpawns[#_boosting.pedSpawns]

                            -- Requesting model
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                Wait(5)
                            end
                            SetModelAsNoLongerNeeded(model)

                            local ped = CreatePed(5, model, spawn.x, spawn.y, spawn.z, spawn.w, true, true)
                            while not DoesEntityExist(ped) do
                                Wait(1)
                            end

                            Entity(ped).state:set('crimePed', true, true)

                            local w = Utils:WeightedRandom(availableWeapons)
                            GiveWeaponToPed(ped, w, 99999, false, true)
                            SetCurrentPedWeapon(ped, w, true)

                            SetEntityMaxHealth(ped, makeDifficult and 250 or 150)
                            SetEntityHealth(ped, makeDifficult and 250 or 150)
                            if makeDifficult then
                                SetPedArmour(ped, 150)
                            end

                            DecorSetBool(ped, 'ScriptedPed', true)
                            SetEntityAsMissionEntity(ped, 1, 1)

                            SetPedRelationshipGroupDefaultHash(ped, `BOBCAT_SECURITY`)
                            SetPedRelationshipGroupHash(ped, `BOBCAT_SECURITY`)
                            SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
                            SetCanAttackFriendly(ped, false, true)
                            SetPedAsCop(ped)

                            TaskTurnPedToFaceEntity(ped, LocalPlayer.state.ped, 1.0)

                            SetPedCombatMovement(ped, 2)
                            SetPedCombatRange(ped, 0)
                            SetPedCombatAttributes(ped, 46, 1)
                            SetPedCombatAttributes(ped, 292, 1)
                            SetPedCombatAttributes(ped, 5000, 1)
                            SetPedFleeAttributes(ped, 0, 0)
                            SetPedAsEnemy(ped, true)

                            SetPedSeeingRange(ped, 100.0)
                            SetPedHearingRange(ped, 100.0)
                            SetPedAlertness(ped, 3)

                            TaskCombatHatedTargetsAroundPed(ped, 100.0, 0)

                            local _, cur = GetCurrentPedWeapon(ped, true)
                            SetPedInfiniteAmmo(ped, true, cur)
                            SetPedDropsWeaponsWhenDead(ped, false)

                            if i <= (numPeds / 2) then
                                Wait(3000)
                            else
                                Wait(math.random(10, 35) * 1000)
                            end
                        end
                    end)
                end


                local plate = GetVehicleNumberPlateText(veh)
                local isTracked = _boosting.trackerTotal and _boosting.trackerTotal > 0
                local r, g, b = GetVehicleCustomPrimaryColour(veh)

                if not noAlert then
                    TriggerServerEvent('Radar:Server:StolenVehicle', plate)
                    TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", isTracked and "boostingTracked" or "boosting", {
                        icon = "car",
                        details = _boosting.vehicleData.label,
                        vehicleColor = {
                            r = r,
                            g = g,
                            b = b,
                        },
                        vehiclePlate = plate,
                        vehicleClass = _boosting.vehicleData.class,
                    })
                end
            end)
        end
    end
end)

AddEventHandler("Laptop:Client:LSUnderground:Boosting:SuccessIgnition", function(veh)
    if _boosting and NetworkDoesEntityExistWithNetworkId(_boosting.vehicleNet) then
        if veh == NetToVeh(_boosting.vehicleNet) then
            local coords = GetEntityCoords(LocalPlayer.state.ped)
            local main, cross = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Ignition", {
                location = string.format("%s - %s", GetStreetNameFromHashKey(main), GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)))
            }, function()

            end)
        end
    end
end)

function BoostingTrackerCooldown()
    trackerTimer = GetGameTimer() + 30000

    CreateThread(function()
        while _boosting and trackerTimer > GetGameTimer() do

            local time = math.floor((trackerTimer - GetGameTimer()) / 1000)
            local percent = math.floor((time / 30) * 100)

            TriggerEvent("Status:Client:Update", "boosting-timer", percent)
            Wait(500)
        end

        TriggerEvent("Status:Client:Update", "boosting-timer", 0)
    end)
end

function RegisterBoostingCallbacks()
    Callbacks:RegisterClientCallback("Laptop:LSUnderground:Boosting:TrackerHacker", function(data, cb)
        local hackData = _trackerHacks[_boosting?.vehicleData?.class or "B"]
        if not hackData then
            hackData = _trackerHacks.B
        end

        if _boosting and (not trackerTimer or GetGameTimer() >= trackerTimer) and hackData and NetworkDoesEntityExistWithNetworkId(_boosting.vehicleNet) then
            local veh = NetToVeh(_boosting.vehicleNet)

            if GetEntitySpeed(veh) >= 15.0 and GetPedInVehicleSeat(veh, 0) == LocalPlayer.state.ped then
                Minigame.Play:Pattern(
                    3,
                    hackData.duration,
                    hackData.rows,
                    math.random(hackData.lengthMin, hackData.lengthMax),
                    hackData.charSize,
                    Utils:WeightedRandom(hackData.charSet), {
                    onSuccess = function()
                        BoostingTrackerCooldown()
                        cb(true, true)
                    end,
                    onFail = function()
                        BoostingTrackerCooldown()
                        cb(true, false)
                    end,
                }, {
                    useWhileDead = false,
                    vehicle = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "veh@break_in@0h@p_m_one@",
                        anim = "low_force_entry_ds",
                        flags = 16,
                    },
                })
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end

local inZone = false
AddEventHandler("Polyzone:Enter", function(id)
    if id == "boosting-dropoff" then
        inZone = true
    end
end)

AddEventHandler("Polyzone:Exit", function(id)
    if id == "boosting-dropoff" and inZone then
        inZone = false
        if _boosting and _boosting.state == 4 then
            Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:LeftArea", {})
        end
    end
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function(veh)
    if not _boosting then return; end

    if
        _boosting.state == 3
        and inZone
        and NetworkDoesEntityExistWithNetworkId(_boosting.vehicleNet) 
        and veh == NetToVeh(_boosting.vehicleNet)
        and not CheckPDInZone(_boosting.dropOff, 60.0)
    then
        Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:DropOff", {})
    end
end)

function CleanUpBoosting()
    if _boosting then
        LocalPlayer.state.isBoosting = false
        _boosting = nil

        Polyzone:Remove("boosting-dropoff")
        Blips:Remove("boosting-contract")

        TriggerEvent("Status:Client:Update", "boosting-timer", 0)
        Notification.Persistent:Remove("boosting-trackers")
    end
end

RegisterNetEvent("Laptop:Client:LSUnderground:Boosting:End", function(cancelled)
    CleanUpBoosting()
end)

RegisterNetEvent("Laptop:Client:Teams:Set", function(teamData)
    if not teamData and wasBoosting then
        Laptop.Notification:Remove("BOOSTING_CONTRACT")

        CleanUpBoosting()
    end
end)
