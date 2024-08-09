local _exhaustNames = {
    "exhaust",
    "exhaust_2",
    "exhaust_3",
    "exhaust_4",
    "exhaust_5",
    "exhaust_6",
    "exhaust_7",
    "exhaust_8",
    "exhaust_9",
    "exhaust_10",
    "exhaust_11",
    "exhaust_12",
    "exhaust_13",
    "exhaust_14",
    "exhaust_15",
    "exhaust_16"
}

local exhaustFx = {}
local purgeFx = {}

local _usingNOS = false
local _usingPurge = false

local _veh = nil
local _vehNet = nil
local _NOSCooldown = 0
local _NOSMaxPurge = 0

local _hasNOS = false
local _flowRate = 5

local _NOSStart = 0
local _NOSUsage = 0

AddEventHandler("Characters:Client:Spawn", function()
    Wait(500)
    Hud:RegisterStatus("nos", 0, 100, "gauge-high", "#892020", true, false, {
        hideZero = true,
    })
end)

AddEventHandler("Vehicles:Client:StartUp", function()
    Keybinds:Add("vehicle_nos", "", "keyboard", "NOS", function()
        if VEHICLE_INSIDE and _hasNOS then
            StartVehicleNOS()
        end
    end, function()
        if VEHICLE_INSIDE and _hasNOS then
            EndVehicleNOS()
        end
    end)

    Keybinds:Add("vehicle_nos_purge", "", "keyboard", "NOS - Purge", function()
        if VEHICLE_INSIDE and _hasNOS then
            StartVehiclePurge()
        end
    end, function()
        if VEHICLE_INSIDE and _hasNOS then
            EndVehiclePurge()
        end
    end)

    Keybinds:Add("vehicle_nos_flow_up", "", "keyboard", "NOS - Increase Flow Rate", function()
        if VEHICLE_INSIDE and _hasNOS then
            if _flowRate < 10 then
                _flowRate = _flowRate + 1
                Notification:Standard("Changed Flow Rate to ".. _flowRate)
            end
        end
    end)

    Keybinds:Add("vehicle_nos_flow_down", "", "keyboard", "NOS - Decrease Flow Rate", function()
        if VEHICLE_INSIDE and _hasNOS then
            if _flowRate > 1 then
                _flowRate = _flowRate - 1
                Notification:Standard("Changed Flow Rate to ".. _flowRate)
            end
        end
    end)

    Callbacks:RegisterClientCallback('Vehicles:InstallNitrous', function(data, cb)
        if VEHICLE_INSIDE and DoesEntityExist(VEHICLE_INSIDE) and IsEntityAVehicle(VEHICLE_INSIDE) and GetPedInVehicleSeat(VEHICLE_INSIDE, -1) == LocalPlayer.state.ped then

            if not IsToggleModOn(VEHICLE_INSIDE, 18) then
                Notification:Error("Need a Turbo For This Mate")
                cb(false)
                return
            end

            if Police:IsPdCar(VEHICLE_INSIDE) then
                Notification:Error("How About No")
                cb(false)
                return
            end

            local vehModel = GetEntityModel(VEHICLE_INSIDE)

            if IsThisModelABike(vehModel) or IsThisModelABicycle(vehModel) or IsThisModelAPlane(vehModel) or IsThisModelAHeli(vehModel) or IsThisModelABoat(vehModel) then
                cb(false)
                return
            end

            Progress:Progress({
                name = "vehicle_installing_nitrous",
                duration = 15000,
                label = "Installing Nitrous Oxide",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = false,
                },
                animation = {
                    anim = "mechanic2",
                },
            }, function(cancelled)

                if not cancelled and VEHICLE_INSIDE then
                    cb(VehToNet(VEHICLE_INSIDE))

                    Wait(500)

                    DoInitNOSCheck(VEHICLE_INSIDE)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)

    AddTaskBeforeVehicleThread('nos', function(veh, class)
        DoInitNOSCheck(veh)
    end)

    AddTaskToVehicleThread('nos', 100, true, function(veh, class, running, inside, onExit)
        if _hasNOS then
            if onExit then
                _hasNOS = false
                EndVehicleNOS()
                EndVehiclePurge()

                TriggerEvent("Status:Client:Update", "nos", 0)
            end
        end
    end, true)
end)

function DoInitNOSCheck(veh)
    if GetPedInVehicleSeat(veh, -1) == LocalPlayer.state.ped then
        local vehEnt = Entity(veh)

        if vehEnt and vehEnt.state and vehEnt.state.VIN and vehEnt.state.Nitrous then
            _hasNOS = vehEnt.state.Nitrous

            print("Nitrous: ", _hasNOS)

            TriggerEvent("Status:Client:Update", "nos", math.ceil(_hasNOS))
        end
    end
end

function StartVehicleNOS()
    if VEHICLE_INSIDE and _hasNOS and not _usingNOS and not _usingPurge and GetGameTimer() >= _NOSCooldown and not IsVehicleStopped(VEHICLE_INSIDE) then

        if _hasNOS <= 0.0 then
            UISounds.Play:FrontEnd(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
            Notification:Standard("No More Nitrous Left!")
            return
        end

        if not IsVehicleEngineOn(VEHICLE_INSIDE) then
            Notification:Standard("Turning the Engine On Would Help...")
            return
        end

        if not IsToggleModOn(VEHICLE_INSIDE, 18) then
            return
        end

        _usingNOS = true
        _veh = VEHICLE_INSIDE
        _vehNet = VehToNet(VEHICLE_INSIDE)

        TriggerServerEvent("Vehicles:Server:SyncNitroEffect", _vehNet, true)

        SetVehicleBoostActive(_veh, true)

        _NOSStart = GetGameTimer()

        CreateThread(function()
            while _usingNOS do
                if not IsVehicleStopped(_veh) and IsVehicleEngineOn(_veh) and (_hasNOS - _NOSUsage) > 0 then
                    local vehicleModel = GetEntityModel(_veh)
                    local currentSpeed = GetEntitySpeed(_veh)
                    local maximumSpeed = GetVehicleModelMaxSpeed(vehicleModel)

                    local baseRate = 1.0 + (_flowRate * 0.1)
                    local multiplier = baseRate * (maximumSpeed / currentSpeed)

                    if multiplier >= 3.0 then
                        multiplier = 3.0
                    end

                    --print(multiplier, GetGameTimer() - _NOSStart)

                    _NOSUsage += _flowRate * 0.005

                    SetVehicleEngineTorqueMultiplier(_veh, multiplier)

                    --print(_NOSUsage)

                    if (GetGameTimer() - _NOSStart) >= 4000 then
                        UISounds.Play:FrontEnd(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET")
                        SetVehicleEngineHealth(_veh, 0.0)
                        SetVehicleCanLeakPetrol(_veh, false)

                        Vehicles.Engine:Force(_veh, false)

                        EndVehicleNOS()
                        break
                    end
                else
                    EndVehicleNOS()
                    break
                end

                Wait(5)
            end
        end)
    end
end

function EndVehicleNOS()
    if _usingNOS then
        local cooldown = (GetGameTimer() - _NOSStart) * 3

        _NOSCooldown = GetGameTimer() + cooldown
        _NOSMaxPurge = GetGameTimer() + cooldown * 0.7

        TriggerServerEvent("Vehicles:Server:NitrousUsage", _vehNet, _NOSUsage)
        _hasNOS -= _NOSUsage
        _NOSUsage = 0.0

        TriggerEvent("Status:Client:Update", "nos", math.ceil(_hasNOS))

        TriggerServerEvent("Vehicles:Server:SyncNitroEffect", _vehNet, false)

        SetVehicleEngineTorqueMultiplier(_veh, 1.0)
        SetVehicleBoostActive(_veh, false)

        _usingNOS = false
        _vehNet = nil
    end
end

function StartVehiclePurge()
    if VEHICLE_INSIDE and not _usingNOS and not _usingPurge then
        _usingPurge = true

        TriggerServerEvent("Vehicles:Server:SyncPurgeEffect", VehToNet(VEHICLE_INSIDE), true)

        CreateThread(function()
            while _usingPurge do
                if _NOSCooldown then
                    if _NOSCooldown > _NOSMaxPurge then
                        _NOSCooldown = _NOSCooldown - 400
                    end
                end
                Wait(100)
            end
        end)
    end
end

function EndVehiclePurge()
    if _usingPurge then
        _usingPurge = false

        TriggerServerEvent("Vehicles:Server:SyncPurgeEffect", VehToNet(VEHICLE_INSIDE), false)
    end
end

function CreateVehicleExhaustEffects(vehNet, vehicle)
    if exhaustFx[vehNet] then
        ClearVehicleExhaustEffects(vehNet)
    end

    exhaustFx[vehNet] = {}

    local dict = "veh_xs_vehicle_mods"
    LoadPtfxAsset(dict)

    for k, v in ipairs(_exhaustNames) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, v)
        if boneIndex ~= -1 then
            local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
            UseParticleFxAssetNextCall(dict)
            local particleEffect = StartParticleFxLoopedOnEntity("veh_nitrous", vehicle, off.x, off.y-0.1, off.z, 0.0, 0.0, 0.0, 1.5, false, false, false)
            SetParticleFxLoopedColour(particleEffect, 0, 0, 255, 0)

            if not exhaustFx[vehNet] then
                exhaustFx[vehNet] = {} 
            end

            table.insert(exhaustFx[vehNet], particleEffect)
        end
    end
end

function ClearVehicleExhaustEffects(vehNet)
    if exhaustFx[vehNet] then
        for k, v in ipairs(exhaustFx[vehNet]) do
            StopParticleFxLooped(v, true)
        end

        exhaustFx[vehNet] = nil
    end
end

RegisterNetEvent("Vehicles:Client:SyncNitroEffect", function(vNet, state)
    if state then
        if NetworkDoesEntityExistWithNetworkId(vNet) then
            local veh = NetToVeh(vNet)
            if veh and DoesEntityExist(veh) then
                CreateVehicleExhaustEffects(vNet, veh)
            end
        end
    else
        ClearVehicleExhaustEffects(vNet)
    end
end)

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
    UseParticleFxAssetNextCall("core")
    return StartParticleFxLoopedOnEntity("ent_sht_steam", vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end

function CreateVehiclePurgeEffects(vehNet, vehicle)
    if purgeFx[vehNet] then
        ClearVehiclePurgeEffects(vehNet)
    end

    purgeFx[vehNet] = {}

    local bone = GetEntityBoneIndexByName(vehicle, "wheel_rf")
    local pos = GetWorldPositionOfEntityBone(vehicle, bone)
    local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)

    for i = 0, 3 do
        local leftPurge = CreateVehiclePurgeSpray(vehicle, -2*off.x + 0.8, off.y + 0.33, off.z+0.15, 35.0, -40.0, 0.0, 0.6)
        local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x, off.y + 0.33, off.z+0.15, 50.0, 35.0, 0.0, 0.6)
        table.insert(purgeFx[vehNet], leftPurge)
        table.insert(purgeFx[vehNet], rightPurge)
    end
end

function ClearVehiclePurgeEffects(vehNet)
    if purgeFx[vehNet] then
        for k, v in ipairs(purgeFx[vehNet]) do
            StopParticleFxLooped(v, true)
        end

        purgeFx[vehNet] = nil
    end
end

RegisterNetEvent("Vehicles:Client:SyncPurgeEffect", function(vNet, state)
    if state then
        if NetworkDoesEntityExistWithNetworkId(vNet) then
            local veh = NetToVeh(vNet)
            if veh and DoesEntityExist(veh) then
                CreateVehiclePurgeEffects(vNet, veh)
            end
        end
    else
        ClearVehiclePurgeEffects(vNet)
    end
end)

function LoadPtfxAsset(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(10)
    end
end

AddEventHandler('Vehicles:Client:RemoveNitrous', function(entityData)
    if VEHICLE_INSIDE and DoesEntityExist(VEHICLE_INSIDE) then
        Progress:Progress({
            name = "vehicle_removing_nitrous",
            duration = 5000,
            label = "Removing Nitrous Oxide",
            useWhileDead = false,
            canCancel = true,
			ignoreModifier = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                anim = "mechanic2",
            },
        }, function(cancelled)
            if not cancelled and Vehicles:HasAccess(VEHICLE_INSIDE, true) then
                Callbacks:ServerCallback('Vehicles:RemoveNitrous', VehToNet(VEHICLE_INSIDE), function(success)
                    if success then
                        --Notification:Success('Removed Nitrous Successfully')

                        _hasNOS = false
                        EndVehicleNOS()
                        EndVehiclePurge()

                        TriggerEvent("Status:Client:Update", "nos", 0)
                    else
                        Notification:Error('Could not Remove Nitrous')
                    end
                end)
            else
                Notification:Error('Could not Remove Nitrous')
            end
        end)
    end
end)