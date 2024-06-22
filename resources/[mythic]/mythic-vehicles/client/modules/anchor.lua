local _anchored = false
local _anchorCD = false

function CanBeAnchored(vehicle)
    if not DoesEntityExist(vehicle) then
        return false
    end

    if GetEntitySpeed(vehicle) > 3.0 then
        Notification:Error('Boat Too Fast')
        return false
    end

    return true
end

function GetAnchorForce(veh, driftCoords, driftDist)
    local vehSpeed = GetEntitySpeed(veh)
    local direction = driftCoords / driftDist
    local distanceFactor = direction * (driftDist + 3.0) ^ 3
    local force = distanceFactor * math.max(math.min(vehSpeed, 2.0) * 0.1, 0.25)
    return force, #(force)
end

function CheckEntityOwnership(veh)
    local ownerPlayer = NetworkGetEntityOwner(veh)
    local ownerSource = GetPlayerServerId(ownerPlayer)
    if ownerSource == -1 then
        return false
    end

    if ownerSource ~= LocalPlayer.state.ID then
        TriggerServerEvent("Vehicles:Client:StartAnchor", ownerSource, VehToNet(veh))
        return false
    else
        return true
    end
end

AddEventHandler('Vehicles:Client:AnchorBoat', function(entity, data)
    if _anchorCD then
        return
    end

    if CanBeAnchored(entity.entity) then
        Progress:Progress({
            name = "boat_anchor",
            duration = 5000,
            label = "Toggling Boat Anchor",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(cancelled)
            if not cancelled and CanBeAnchored(entity.entity) then
                if _anchored == entity.entity then
                    _anchored = false
                else
                    _anchored = false
                    Wait(5)
                    StartAnchor(entity.entity)
                end

                if not NetworkHasControlOfEntity(entity.entity) then
                    TriggerServerEvent('Vehicles:Server:ToggleAnchor', VehToNet(entity.entity))
                end
            end
        end)

        _anchorCD = true
        SetTimeout(15000, function()
            _anchorCD = false
        end)
    end
end)

RegisterNetEvent('Vehicles:Client:ToggleAnchor', function(vNet, toggle)
    local veh = NetToVeh(vNet)
    if DoesEntityExist(veh) then
        if toggle then
            StartAnchor(veh)
        else
            if _anchored == veh then
                _anchored = false
            end
        end
    end
end)

function StartAnchor(veh)
    _anchored = veh
    local pos = GetEntityCoords(veh)
    local lastMag = 0.0

    CreateThread(function()
        while _anchored do
            if not CheckEntityOwnership(veh) then
                _anchored = false
                return
            end

            local driftVector = pos - GetEntityCoords(veh)
            local driftDist = #(driftVector)

            if driftDist > 0.25 then
                local force, magnitude = GetAnchorForce(veh, driftVector, driftDist)

                ApplyForceToEntityCenterOfMass(veh, 1, force.x, force.y, 0.0, false, false, false)
                local exceedsBreakingForce = lastMag > 500.0 and magnitude < lastMag
                if driftDist > 20.0 or exceedsBreakingForce then
                    _anchored = false
                end
            end

            Wait(5)
        end
    end)
end