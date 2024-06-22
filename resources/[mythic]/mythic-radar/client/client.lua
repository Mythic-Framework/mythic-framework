GLOBAL_VEH = nil

RADAR_ENABLED_VEHICLE = false
RADAR_ENABLED = false
RADAR_LOCKED = false
RADAR_FRONT_FAST = false
RADAR_REAR_FAST = false


RADAR_LAST_REAR_PLATE = false
RADAR_LAST_FRONT_PLATE = false
RECENT_FLAGS = {}

AddEventHandler('Targeting:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Keybinds = exports['mythic-base']:FetchComponent('Keybinds')
    Targeting = exports['mythic-base']:FetchComponent('Targeting')
    Player = exports['mythic-base']:FetchComponent('Player')
    UISounds = exports['mythic-base']:FetchComponent('UISounds')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    EmergencyAlerts = exports['mythic-base']:FetchComponent('EmergencyAlerts')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Radar', {
        'Logger',
        'Utils',
        'Keybinds',
        'Targeting',
        'UISounds',
        'Player',
        'Jobs',
        'EmergencyAlerts',
        'Fetch',
    }, function(error)
        if #error > 0 then
            return
        end
        RetrieveComponents()

        Keybinds:Add('radar_lock', 'MULTIPLY', 'keyboard', 'Radar - Toggle Fast Lock', function()
            if RADAR_LOCKED then
                UnlockRadar()
            else
                LockRadar()
            end
        end)

        Keybinds:Add('radar_remote', 'DIVIDE', 'keyboard', 'Radar - Open Menu/Remote', function()
            OpenRadarRemote()
        end)

        Keybinds:Add('radar_toggle', 'SUBTRACT', 'keyboard', 'Radar - Show/Hide', function()
            ToggleRadarIsDisabled()
        end)

        Keybinds:Add('heli_toggle', 'E', 'keyboard', 'Heli Camera - Toggle', function()
            StartHeliCamera()
        end)

        Keybinds:Add('heli_lock', 'SPACE', 'keyboard', 'Heli Camera - Lock On/Off', function()
            LockOnHeliCamera()
        end)

        Keybinds:Add('heli_camera', 'MOUSE_RIGHT', 'MOUSE_BUTTON', 'Heli Camera - Change Mode', function()
            ChangeVision()
        end)
    end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    GetSavedSettings()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    SendNUIMessage({ type = 'RESET_RADAR' })

    RADAR_ENABLED_VEHICLE = false
    RADAR_ENABLED = false
    RADAR_LOCKED = false
    RADAR_FRONT_FAST = false
    RADAR_REAR_FAST = false

    RADAR_LAST_REAR_PLATE = false
    RADAR_LAST_FRONT_PLATE = false
    RECENT_FLAGS = {}
end)

RegisterNetEvent('Radar:Client:ToggleRadarDisabled', function()
    ToggleRadarIsDisabled()
end)

RegisterNetEvent('Vehicles:Client:EnterVehicle', function(veh, seat, class)
    GLOBAL_VEH = veh
    if RADAR_SETTINGS == nil or class ~= 18 then
        return
    end

    local myDuty = LocalPlayer.state.onDuty
    if myDuty and myDuty == 'police' then
        RADAR_ENABLED_VEHICLE = true
        EnableRadar()
    end
end)

RegisterNetEvent('Vehicles:Client:ExitVehicle', function()
    GLOBAL_VEH = nil

    DisableRadar()
    CloseRadarRemote()
end)

function EnableRadar()
    if RADAR_ENABLED_VEHICLE and not RADAR_FORCE_DISABLED and not RADAR_ENABLED then
        RADAR_ENABLED = true
        SendNUIMessage({ type = 'RADAR_SHOW' })

        CreateThread(function()
            while RADAR_ENABLED do
                Wait(200)
                local data = {}
                if RADAR_SETTINGS.frontRadar.transmit or RADAR_SETTINGS.rearRadar.transmit then
                    local vehCoords = GetEntityCoords(GLOBAL_VEH)
                    local vehHeading = Utils:Round(GetEntityHeading(GLOBAL_VEH), 0)
                    if RADAR_SETTINGS.frontRadar.transmit then
                        local angleOffsets = GetAngleOffsets('Front', RADAR_SETTINGS.frontRadar.lane)
                        local offsetCoords = GetOffsetFromEntityInWorldCoords(GLOBAL_VEH, angleOffsets.x, angleOffsets.y, angleOffsets.z)
                        local fromCoord = vector3(vehCoords.x, vehCoords.y, vehCoords.z + 0.8)
                        local hittingVehicle = CastRadarRay(fromCoord, offsetCoords, GLOBAL_VEH)

                        --DrawLine(fromCoord, offsetCoords, 255, 0, 0, 255)
                        --DrawMarker(28, GetEntityCoords(hittingVehicle), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, false, 2, false, false, false, false)

                        if hittingVehicle then
                            local targetHeading = Utils:Round(GetEntityHeading(hittingVehicle), 0)
                            local targetSpeed = GetEntityMPH(hittingVehicle)
                            local targetPlate = GetVehicleNumberPlateText(hittingVehicle)
                            local relativeDirection = GetEntityRelativeDirection(vehHeading, targetHeading, 110)

                            data.frontRadar = {
                                speed = targetSpeed,
                                direction = relativeDirection,
                                plate = relativeDirection and targetPlate or nil,
                            }

                            if not RADAR_LOCKED and RADAR_SETTINGS.fastSpeed > 20 and targetSpeed >= RADAR_SETTINGS.fastSpeed then
                                if not RADAR_FRONT_FAST or RADAR_FRONT_FAST.plate ~= targetPlate then
                                    PlayFastAlert()
                                end

                                if not RADAR_FRONT_FAST or (RADAR_FRONT_FAST.plate ~= targetPlate) or (targetSpeed > RADAR_FRONT_FAST.speed) then
                                    RADAR_FRONT_FAST = {
                                        speed = targetSpeed,
                                        plate = targetPlate,
                                        fast = true,
                                        locked = false,
                                        flag = false,
                                    }
                                    data.frontFast = RADAR_FRONT_FAST
                                end
                            end

                            if relativeDirection and targetPlate ~= RADAR_LAST_FRONT_PLATE then
                                CheckPlateFlagged('Front', hittingVehicle, targetPlate)
                                RADAR_LAST_FRONT_PLATE = targetPlate
                            end
                        else
                            data.frontRadar = {}
                        end
                    end

                    if RADAR_SETTINGS.rearRadar.transmit then
                        local angleOffsets = GetAngleOffsets('Rear', RADAR_SETTINGS.rearRadar.lane)
                        local offsetCoords = GetOffsetFromEntityInWorldCoords(GLOBAL_VEH, angleOffsets.x, angleOffsets.y, angleOffsets.z)
                        local fromCoord = vector3(vehCoords.x, vehCoords.y, vehCoords.z + 0.8)
                        local hittingVehicle = CastRadarRay(fromCoord, offsetCoords, GLOBAL_VEH)

                        --DrawLine(fromCoord, offsetCoords, 255, 0, 0, 255)
                        --DrawMarker(28, GetEntityCoords(hittingVehicle), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, false, 2, false, false, false, false)

                        if hittingVehicle then
                            local targetHeading = Utils:Round(GetEntityHeading(hittingVehicle), 0)
                            local targetSpeed = GetEntityMPH(hittingVehicle)
                            local targetPlate = GetVehicleNumberPlateText(hittingVehicle)
                            local relativeDirection = GetEntityRelativeDirection(vehHeading, targetHeading, 110)
                            data.rearRadar = {
                                speed = targetSpeed,
                                direction = relativeDirection,
                                plate = relativeDirection and targetPlate or nil,
                            }

                            if not RADAR_LOCKED and RADAR_SETTINGS.fastSpeed > 20 and targetSpeed >= RADAR_SETTINGS.fastSpeed then
                                if not RADAR_REAR_FAST or RADAR_REAR_FAST.plate ~= targetPlate then
                                    PlayFastAlert()
                                end

                                if not RADAR_REAR_FAST or (RADAR_REAR_FAST.plate ~= targetPlate) or (targetSpeed > RADAR_REAR_FAST.speed) then
                                    RADAR_REAR_FAST = {
                                        speed = targetSpeed,
                                        plate = targetPlate,
                                        fast = true,
                                        locked = false,
                                        flag = false,
                                    }
                                    data.rearFast = RADAR_REAR_FAST
                                end
                            end

                            if relativeDirection and targetPlate ~= RADAR_LAST_REAR_PLATE then
                                CheckPlateFlagged('Rear', hittingVehicle, targetPlate)
                                RADAR_LAST_REAR_PLATE = targetPlate
                            end
                        else
                            data.rearRadar = {}
                        end
                    end
                end

                data.patrolSpeed = GetEntityMPH(GLOBAL_VEH)
                SendNUIMessage({
                    type = 'UPDATE_DATA',
                    data = data,
                })
            end
        end)
    end
end

function DisableRadar()
    if RADAR_ENABLED then
        RADAR_ENABLED = false
        SendNUIMessage({ type = 'RADAR_HIDE' })
    end
end

function LockRadar(forced)
    if RADAR_ENABLED and (RADAR_FRONT_FAST or RADAR_REAR_FAST) then

        RADAR_LOCKED = true

        local frontFast = RADAR_FRONT_FAST and RADAR_FRONT_FAST or {}
        frontFast.locked = true

        local rearFast = RADAR_REAR_FAST and RADAR_REAR_FAST or {}
        rearFast.locked = true

        if not forced then
            PlayLockAlert()
        end

        SendNUIMessage({ 
            type = 'UPDATE_DATA',
            data = {
                rearFast = rearFast,
                frontFast = frontFast,
            }
        })
    end
end

function UnlockRadar(forced)
    if RADAR_ENABLED and RADAR_LOCKED then
        SendNUIMessage({ 
            type = 'UPDATE_DATA',
            data = {
                rearFast = {},
                frontFast = {},
            }
        })

        if not forced then
            PlayUnlockAlert()
        end
        RADAR_FRONT_FAST = false
        RADAR_REAR_FAST = false
        RADAR_LOCKED = false
    end
end

function CheckPlateFlagged(direction, vehicle, plate)
    local plateFlagged = GlobalState.RadarFlaggedPlates[plate]
    if plateFlagged and not RECENT_FLAGS[plate] then
        RECENT_FLAGS[plate] = true
        PlayFlaggedAlert()
        EmergencyAlerts:Create('Radar', 'Flagged Plate Detected', 0, GetLocationData(GetEntityCoords(vehicle)), {
            icon = 'radar',
            details = string.format('Your %s Radar Detected a Flagged Plate: %s, Flag Reason: %s', direction, plate, plateFlagged),
        })

        SetTimeout(30000, function() -- So the plate doesn't constantly get flagged
            RECENT_FLAGS[plate] = nil
        end)
    else
        return false
    end
end

-- RADAR = {}

-- AddEventHandler('Proxy:Shared:RegisterReady', function()
--     exports['mythic-base']:RegisterComponent('Radar', RADAR)
-- end)