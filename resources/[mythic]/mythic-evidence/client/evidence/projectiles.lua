local hasWeapon = false
local currentWeapon, currentWeaponData, currentWeaponAmmo

local function generateRandomness()
    return math.random(-145, 145) / 100
end

AddEventHandler('Weapons:Client:SwitchedWeapon', function(weapon, weaponData, weaponItemData)
    if weapon and weaponItemData and weaponItemData.gun then
        StartHoldingWeapon(weapon, weaponData, weaponItemData)
    else
        StopHoldingWeapon()
    end
end)

function StartHoldingWeapon(weapon, weaponData, weaponItemData)
    currentWeapon = weapon
    currentWeaponData = weaponData
    currentWeaponAmmo = weaponItemData.ammoType or 'UNKNOWN'

    if not hasWeapon then
        hasWeapon = true
        CreateThread(function()
            while hasWeapon do
                if IsPedShooting(LocalPlayer.state.ped) then
                    -- Generate Randomness (Simulate Dropping and make sure they don't all stack ontop of eachother)
                    local casingPosition = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, generateRandomness(), generateRandomness(), VEHICLE_INSIDE and 0.0 or -0.9)

                    table.insert(LOCAL_CACHED_EVIDENCE, {
                        type = 'casing',
                        route = LocalPlayer.state.currentRoute,
                        coords = casingPosition,
                        data = {
                            weapon = {
                                name = currentWeapon,
                                serial = currentWeaponData.MetaData.SerialNumber or currentWeaponData.MetaData.ScratchedSerialNumber,
                                ammoType = currentWeaponAmmo,
                                ammoTypeName = _ammoNames[currentWeaponAmmo],
                            },
                        },
                        active = true,
                    })

                    local trajectory = GetBulletTrajectory(200.0)
                    -- print(trajectory.hitting, trajectory.endCoords)
                    if trajectory and trajectory.hitting then
                        if trajectory.entity > 0 and IsEntityAVehicle(trajectory.entity) then
                            local r, g, b = GetVehicleColor(trajectory.entity)
                            table.insert(LOCAL_CACHED_EVIDENCE, {
                                type = 'paint_fragment',
                                route = LocalPlayer.state.currentRoute,
                                coords = trajectory.endCoords,
                                data = {
                                    color = { r = r, g = g, b = b },
                                },
                                active = true,
                            })
                        else
                            local rand = math.random(20, 75)
                            table.insert(LOCAL_CACHED_EVIDENCE, {
                                type = 'projectile',
                                route = LocalPlayer.state.currentRoute,
                                coords = trajectory.endCoords,
                                data = {
                                    weapon = {
                                        name = currentWeapon,
                                        serial = currentWeaponData.MetaData.SerialNumber or currentWeaponData.MetaData.ScratchedSerialNumber,
                                        ammoType = currentWeaponAmmo,
                                        ammoTypeName = _ammoNames[currentWeaponAmmo],
                                    },
                                    tooDegraded = (rand >= 30 and rand <= 40),
                                },
                                active = true,
                            })
                        end
                    end

                    UpdateCachedEvidence()
                    Wait(250)
                end
                Wait(1)
            end
        end)
    end
end

function StopHoldingWeapon()
    if hasWeapon then
        hasWeapon = false
    end
end

function GetBulletTrajectory(maxDist)
    local camRotation = GetGameplayCamRot(2)
    local originCoords = GetGameplayCamCoord()

    local direction = rotationToDirection(camRotation)
    local targetCoords = originCoords + (direction * maxDist)

    local castedRay = StartExpensiveSynchronousShapeTestLosProbe(originCoords, targetCoords, -1, LocalPlayer.state.ped, 4)
    local _, hitting, endCoords, surfaceNormal, entity = GetShapeTestResult(castedRay)

    return {
        hitting = hitting,
        endCoords = endCoords,
        surfaceNormal = surfaceNormal,
        entity = entity,
    }
end