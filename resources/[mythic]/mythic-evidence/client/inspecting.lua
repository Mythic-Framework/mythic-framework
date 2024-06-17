-- Inspecting Evidence

local inspecting, ignoreFreeAim = false, false
local fetchedEvidenceCache, nearbyEvidence = {}, {}

local function filterNearbyEvidence(evidence)
    local nearby = {}

    local coords = GetEntityCoords(LocalPlayer.state.ped)
    local myRoute = LocalPlayer.state.currentRoute

    for k, v in ipairs(evidence) do
        if v and myRoute == v.route and #(coords - v.coords) <= 50.0 then
            table.insert(nearby, v)
        end
    end

    return nearby
end

local evidenceMarkers = {
    casing = { label = 'Casing', marker = 2, r = 10, g = 61, b = 9, a = 155, scale = 0.15, textZOffset = 0.3 },
    projectile = { label = 'Projectile', marker = 28, r = 73, g = 11, b = 115, a = 155, scale = 0.1, textZOffset = 0.1 },
    blood = { label = 'Blood', marker = 23, r = 88, g = 9, b = 9, a = 155, scale = 0.2, textZOffset = 0.05 },
    paint_fragment = { label = 'Paint Fragment', marker = 36, scale = 0.2, textZOffset = 0.2 },
}

AddEventHandler('Weapons:Client:SwitchedWeapon', function(weapon)
    if weapon == 'WEAPON_FLASHLIGHT' then
        ignoreFreeAim = false
        StartInspecting()
    else
        StopInspecting()
    end
end)

AddEventHandler('Animations:Client:UsingCamera', function(using)
    if using then
        ignoreFreeAim = true
        StartInspecting()
    else
        StopInspecting()
    end
end)

function CanSeeEvidence()
    return (IsPlayerFreeAiming(LocalPlayer.state.clientID) or ignoreFreeAim)
end

function StartInspecting()
    if not inspecting then
        inspecting = true
        fetchedEvidenceCache = FetchEvidence()
        nearbyEvidence = filterNearbyEvidence(fetchedEvidenceCache)

        CreateThread(function()
            while inspecting do
                if CanSeeEvidence() then
                    for k, v in ipairs(nearbyEvidence) do
                        if #(GetEntityCoords(LocalPlayer.state.ped) - v.coords) <= 8.0 then
                            if v.type == 'paint_fragment' then
                                DrawMarker(evidenceMarkers[v.type].marker, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, evidenceMarkers[v.type].scale, evidenceMarkers[v.type].scale, evidenceMarkers[v.type].scale, v.data.color.r, v.data.color.g, v.data.color.b, 150, 0, 1, 0, 0)
                            else
                                DrawMarker(evidenceMarkers[v.type].marker, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, evidenceMarkers[v.type].scale, evidenceMarkers[v.type].scale, evidenceMarkers[v.type].scale, evidenceMarkers[v.type].r, evidenceMarkers[v.type].g, evidenceMarkers[v.type].b, evidenceMarkers[v.type].a, 0, 1, 0, 0)
                            end

                            local text = string.format('%s | E-%s', evidenceMarkers[v.type].label, v.id)
                            if v.data.weapon and v.data.weapon.ammoTypeName then
                                text = (v.data.weapon.ammoTypeName or 'Unknown') .. ' ' .. text
                            end

                            if v.type == 'projectile' and v.data.tooDegraded then
                                text = 'Degraded ' .. text
                            end

                            if v.type == 'blood' and v.data then
                                if v.data.IsBloodPool then
                                    text = 'Pool of ' .. text
                                else
                                    text = 'Drops of ' .. text
                                end
                            end

                            draw3DText(v.coords.x, v.coords.y, v.coords.z + evidenceMarkers[v.type].textZOffset, text)
                        end
                    end

                    if IsControlJustPressed(0, 38) then
                        PickupClosestEvidence(nearbyEvidence)
                        Wait(350)
                    end
                else
                    Wait(200)
                end
                Wait(2)
            end
        end)

        CreateThread(function()
            while inspecting do
                if CanSeeEvidence() then
                    nearbyEvidence = filterNearbyEvidence(fetchedEvidenceCache) -- Filter down to the relatively close evidence
                    Wait(1000)
                else
                    Wait(1500)
                end
            end
        end)

        CreateThread(function()
            while inspecting do
                Wait(30000)
                fetchedEvidenceCache = FetchEvidence()
            end
        end)
    end
end

function StopInspecting()
    if inspecting then
        inspecting = false
    end
end

function FetchEvidence()
    local p = promise.new()
    Callbacks:ServerCallback('Evidence:Fetch', {}, function(evidence)
        p:resolve(evidence)
    end)

    return Citizen.Await(p)
end

function PickupClosestEvidence(localEvidence)
    if #localEvidence > 0 then
        local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)
        if hitting and endCoords then
            local closest, lastDist
    
            for k, v in ipairs(localEvidence) do
                local dist = #(v.coords - endCoords)
                if (closest == nil) or (dist < lastDist) then
                    closest = v.id
                    lastDist = dist
                end
            end
    
            if closest and lastDist <= 1.75 then
                if LocalPlayer.state.onDuty == 'police' then
                    Animations.Emotes:Play('pickup', false, false, true, true)
                    TriggerServerEvent('Evidence:Server:PickupEvidence', closest)
                -- else
                --     print('Destroy Evidence')
                end
            else
                Notification:Error('Not Close Enough to Any Evidence')
            end
        end
    end
end

RegisterNetEvent('Evidence:Client:ForceUpdateEvidence', function()
    if inspecting then
        fetchedEvidenceCache = FetchEvidence()
        nearbyEvidence = filterNearbyEvidence(fetchedEvidenceCache)
    end
end)