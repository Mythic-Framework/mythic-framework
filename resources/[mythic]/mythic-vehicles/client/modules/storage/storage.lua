local blipsForVehType = {
    [0] = 357,
    [1] = 356,
    [2] = 359,
}

local _tempVehicles = {}
local tempVehAppearanceData = {}
local tempParkingSpace = nil
local tempCurrentStorageType = false
local tempCurrentStorageId = false
local vehActuallySpawningOne = false
local vehStorageMenuOpen = false

local loadingVehicleStorageVehicle = false

AddEventHandler('Vehicles:Client:StartUp', function()
    if _vehicleStorage then
        for k, v in pairs(_vehicleStorage) do
            local data = {
                veh_storage = true,
                veh_storage_id = k,
            }

            if v.zone and v.zone.type == 'poly' and v.zone.points then
                Polyzone.Create:Poly('veh_storage_'.. k, v.zone.points, {
                    minZ = v.zone.minZ,
                    maxZ = v.zone.maxZ,
                }, data)
            elseif v.zone and v.zone.type == 'box' and v.zone.center and v.zone.length and v.zone.width then
                Polyzone.Create:Box('veh_storage_'.. k, v.zone.center, v.zone.length, v.zone.width, {
                    heading = v.zone.heading,
                    minZ = v.zone.minZ,
                    maxZ = v.zone.maxZ,
                }, data)
            end
        end
    end

    Interaction:RegisterMenu("veh_storage", 'Garage List', "warehouse", function()
        OpenVehicleStorage()
        Interaction:Hide()
    end, function()
        local pedCoords = GetEntityCoords(GLOBAL_PED)
        local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(pedCoords)

        return inVehicleStorageZone or Properties:GetNearHouseGarage()
    end)
end)

AddEventHandler('Vehicles:Client:CharacterLogin', function()
    if _vehicleStorage then
        for k, v in pairs(_vehicleStorage) do
            if not v.restricted and not v.hideBlip then
                Blips:Add('veh_storage_'.. k, v.name, v.coords, blipsForVehType[v.vehType], 12, 0.6, false, 10)
            end
        end

        Wait(2500)
        
        -- Add Restricted Ones After so the Blips Appear With the Restricted Ones at the end of the list
        -- for k, v in pairs(_vehicleStorage) do
        --     if v.restricted then
        --         local charJobs = Jobs.Permissions:GetJobs()
                
        --         if #charJobs > 0 then
        --             if DoesCharacterPassStorageRestrictions(-1, charJobs, v.restricted) then
        --                 Blips:Add('veh_storage_'.. k, v.name .. ' [Restricted]', v.coords, blipsForVehType[v.vehType], 6, 0.45, false, 10)
        --             end
        --         end
        --     end
        -- end
    end
end)

function GetVehicleStorageAtCoords(coords)
    local insideZone = Polyzone:IsCoordsInZone(coords, false, 'veh_storage')
    if insideZone and insideZone.veh_storage and insideZone.veh_storage_id then
        return true, insideZone.veh_storage_id
    end
    return false
end

AddEventHandler('Vehicles:Client:StoreVehicle', function(entityData)
    if entityData and DoesEntityExist(entityData.entity) then
        local vehicleCoords = GetEntityCoords(entityData.entity)
        DetachVehicleFromTrailer(entityData.entity)
        local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(vehicleCoords)
        local vehState = Entity(entityData.entity).state

        if vehState.EmergencyBoat and Vehicles:HasAccess(entityData.entity, true) and GetPedInVehicleSeat(entityData.entity) == 0 and GetEntitySpeed(entityData.entity) <= 1  then
            TriggerServerEvent("Vehicles:Server:DeleteEmergencyBoat", VehToNet(entityData.entity))
            return
        end

        -- Also checks that nobody is in the drivers seat and that the vehicle is not moving
        if vehState and vehState.VIN and vehState.Owned and GetPedInVehicleSeat(entityData.entity) == 0 and GetEntitySpeed(entityData.entity) <= 1 then
            if inVehicleStorageZone and vehicleStorageZoneId then
                Callbacks:ServerCallback('Vehicles:PutVehicleInStorage', {
                    VIN = vehState.VIN,
                    storageId = vehicleStorageZoneId,
                }, function(success)
                    if success then
                        Notification:Success('Stored Vehicle')
                    else
                        Notification:Error('Error Storing Vehicle')
                    end
                end)
            else
                local propGarage = Properties:GetNearHouseGarage(vehicleCoords)
                if propGarage and propGarage.propertyId then
                    local prop = Properties:Get(propGarage.propertyId)
                    if prop and prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil then
                        Callbacks:ServerCallback('Vehicles:PutVehicleInPropertyStorage', {
                            VIN = vehState.VIN,
                            storageId = propGarage.propertyId,
                        }, function(success, tooFull)
                            if success then
                                Notification:Success('Stored Vehicle')
                            else
                                if tooFull then
                                    Notification:Error('Error Storing Vehicle - It\'s Full')
                                else
                                    Notification:Error('Error Storing Vehicle')
                                end
                            end
                        end)
                    else
                        Notification:Error('Don\'t Have Keys to Garage')
                    end
                else
                    Notification:Error('Error Storing Vehicle')
                end
            end
        else
            Notification:Error('Error Storing Vehicle')
        end
    end
end)

function OpenVehicleStorage()
    local pedCoords = GetEntityCoords(GLOBAL_PED)
    local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(pedCoords)
    if inVehicleStorageZone and vehicleStorageZoneId then
        local myDuty = LocalPlayer.state.onDuty
        local vehStorageData = _vehicleStorage[vehicleStorageZoneId]
        if not vehStorageData or (vehStorageData.restricted and not DoesCharacterPassStorageRestrictions(-1, Jobs.Permissions:GetJobs(), vehStorageData.restricted)) then
            return Notification:Error('Invalid Permission To Access This Vehicle Storage')
        end

        if vehStorageData and vehStorageData.spaces then
            local parkingSpace = false
            if vehStorageData.vehType == 0 then
                parkingSpace = GetClosestParkingSpace(pedCoords, vehStorageData.spaces)
            else
                parkingSpace = GetClosestAvailableParkingSpace(pedCoords, vehStorageData.spaces)
            end
            
            if parkingSpace then
                Callbacks:ServerCallback('Vehicles:GetVehiclesInStorage', vehicleStorageZoneId, function(storedVehicles)
                    if not storedVehicles then
                        Notification:Error('Error Fetching Vehicle Storage')
                        return
                    end

                    if #storedVehicles > 0 then
                        OpenVehicleStorageMenu(1, vehicleStorageZoneId, storedVehicles, parkingSpace, myDuty)
                    else
                        Notification:Error('Vehicle Storage Is Empty')
                    end
                end)
            else
                Notification:Error('Could Not Find Parking Space')
            end
        end
    else
        local propertyGarage = Properties:GetNearHouseGarage()
        if propertyGarage and propertyGarage.propertyId then

            local coords = vector4(propertyGarage.coords.x, propertyGarage.coords.y, propertyGarage.coords.z, propertyGarage.coords.h)

            if IsParkingSpaceFree(coords) then
                Callbacks:ServerCallback('Vehicles:GetVehiclesInPropertyStorage', propertyGarage.propertyId, function(storedVehicles, data, characterId, characters)
                    if not storedVehicles then
                        Notification:Error('Error Fetching Vehicle Storage')
                        return
                    end

                    if #storedVehicles > 0 then
                        OpenVehicleStorageMenu(
                            2,
                            propertyGarage.propertyId,
                            storedVehicles,
                            coords,
                            LocalPlayer.state.onDuty,
                            data.max,
                            data.current,
                            characterId,
                            characters
                        )
                    else
                        Notification:Error('Vehicle Storage Is Empty')
                    end
                end)
            else
                Notification:Error('Could Not Find Parking Space')
            end
        end
    end
end

function CleanupTempVehicle()
    for k, v in pairs(_tempVehicles) do
        if DoesEntityExist(v) then
            Game.Vehicles:Delete(v)
            _tempVehicles[k] = nil
        end
    end
end

function EstimateDegenState(degen)
    local partCount = 0
    local total = 0
    if degen and type(degen) == "table" then
        for k,v in pairs(degen) do
            if type(v) == "number" then
                partCount += 1
                total += v
            end
        end

        if partCount > 0 then
            local averageHealth = total / partCount

            if averageHealth >= 90 then
                return "Perfect"
            elseif averageHealth >= 70 then
                return "Good"
            elseif averageHealth >= 50 then
                return "Medium"
            elseif averageHealth >= 30 then
                return "Bad"
            elseif averageHealth >= 15 then
                return "Really Bad"
            else
                return "Falling Apart"
            end
        end
    end

    return "Unknown"
end

function EstimateEngineHealth(engineHealth)
    if type(engineHealth) == "number" then
        if engineHealth >= 950 then
            return "Perfect"
        elseif engineHealth >= 800 then
            return "Good"
        elseif engineHealth >= 600 then
            return "Medium"
        elseif engineHealth >= 400 then
            return "Poor"
        elseif engineHealth >= 1 then
            return "Smoking"
        else
            return "Destroyed"
        end

    end
    return "Unknown"
end

function OpenVehicleStorageMenu(storageType, storageId, storedVehicleData, parkingSpace, characterDuty, maxCount, currentCount, characterId, characters)
    tempCurrentStorageType = storageType
    tempCurrentStorageId = storageId
    tempParkingSpace = parkingSpace
    vehActuallySpawningOne = false

    local personalVehicles = {}
    local fleetVehicles = {}

    for k, v in ipairs(storedVehicleData) do
        if v and v.VIN then
            tempVehAppearanceData[v.VIN] = {
                Vehicle = v.Vehicle,
                RegisteredPlate = v.RegisteredPlate,
                Properties = v.Properties,
            }

            if v.Owner.Type == 0 then
                table.insert(personalVehicles, v)
            elseif v.Owner.Type == 1 then
                table.insert(fleetVehicles, v)
            end
        end
    end

    local storageName = 'Vehicle Storage'

    if storageType == 1 then
        storageName = _vehicleStorage[storageId].name
    elseif storageType == 2 then
        local prop = Properties:Get(storageId)
        if prop and prop.label then
            storageName = prop.label
        end
    end

    local storageMenu = {
        main = {
            label = storageName,
            items = {},
        }
    }

    if storageType == 2 then
        table.insert(storageMenu.main.items, {
            label = 'Property Garage',
            description = string.format('%s/%s Vehicles Stored', currentCount, maxCount),
            submenu = false,
        })
    end

    local function createVehicleSubmenu(vehicle)
        local vehItems = {}

        table.insert(vehItems, {
            label = 'Vehicle\'s Identification',
            description = string.format('VIN: %s, Plate: %s', vehicle.VIN, vehicle.RegisteredPlate or 'N/A'),
            event = false,
        })

        if vehicle.Owner.Type == 1 and vehicle.Type ~= 2 then
            table.insert(vehItems, {
                label = 'Vehicle\'s Current State',
                description = string.format('Fuel: %s%%<br>Engine State: %s<br>Average Vehicle Parts State: %s', vehicle.Fuel, EstimateEngineHealth(vehicle.Damage?.Engine), EstimateDegenState(vehicle.DamagedParts)),
                event = false,
            })
        else
            table.insert(vehItems, {
                label = 'Vehicle\'s Current State',
                description = string.format('Fuel: %s%%<br>Engine State: %s', vehicle.Fuel, EstimateEngineHealth(vehicle.Damage?.Engine)),
                event = false,
            })
        end


        if vehicle.Owner.Type == 1 then
            table.insert(vehItems, {
                label = 'Vehicle\'s Fleet Information',
                description = string.format('Req. Level: %s, Ownership Type: %s', vehicle.Owner.Level, vehicle.Owner.Workplace and string.upper(vehicle.Owner.Workplace) or 'All'),
                event = false,
            })

            if vehicle.LastDriver and #vehicle.LastDriver > 0 then
                local fhId = vehicle.VIN .. '-fleet-history'
                local shitCunt = {}

                local timeNow = GlobalState['OS:Time'] or 0
                for i = #vehicle.LastDriver, 1, -1 do
                    local driver = vehicle.LastDriver[i]
                    local timeString = GetFormattedTimeFromSeconds(timeNow - driver.time)

                    table.insert(shitCunt, {
                        label = string.format('Driver SID: %s', driver.char),
                        description = string.format('Returned Vehicle %s Ago', timeString),
                        event = false,
                    })
                end

                storageMenu[fhId] = {
                    label = (vehicle.RegisteredPlate or 'Vehicle') .. ' Fleet History',
                    items = shitCunt
                }

                table.insert(vehItems, {
                    label = 'Fleet History',
                    description = 'Latest Driver: ' .. (vehicle.LastDriver[#vehicle.LastDriver]?.char or '?'),
                    submenu = fhId,
                })
            end
        end

        local desc = 'Take the Vehicle Out of Storage'
        local disabled = false

        if vehicle.Owner and vehicle.Owner.Qualification then
            desc = 'This Vehicle Requires Qualifications'
            disabled = true

            local char = LocalPlayer.state.Character
            if char and char:GetData('Qualifications') and #char:GetData('Qualifications') > 0 then
                if hasValue(char:GetData('Qualifications'), vehicle.Owner.Qualification) then
                    disabled = false
                end
            end
        end

        table.insert(vehItems, {
            label = 'Retrieve',
            description = desc,
            event = 'Vehicles:Client:Storage:Retrieve',
            disabled = disabled,
            data = { VIN = vehicle.VIN },
        })

        storageMenu[vehicle.VIN] = {
            label = vehicle.Make .. ' ' .. vehicle.Model,
            items = vehItems
        }
    end

    if storageType == 2 then
        for k, v in ipairs(personalVehicles) do
            if v.Owner and v.Owner.Id == characterId then
                createVehicleSubmenu(v)
                local description = ''
                if v.RegisteredPlate then
                    description = 'Plate: '.. v.RegisteredPlate
                else
                    description = 'Type: '.. (v.Type == 1 and 'Boat' or 'Aircraft')
                end

                table.insert(storageMenu.main.items, {
                    label = v.Make .. ' ' .. v.Model,
                    description = description,
                    submenu = v.VIN,
                })
            end
        end

        for k, v in ipairs(personalVehicles) do
            if v.Owner and v.Owner.Id ~= characterId then
                createVehicleSubmenu(v)
                local description = ''
                if v.RegisteredPlate then
                    description = 'Plate: '.. v.RegisteredPlate
                else
                    description = 'Type: '.. (v.Type == 1 and 'Boat' or 'Aircraft')
                end

                if not storageMenu[string.format("%s-vehicles", v.Owner.Id)] then
                    local char = characters[v.Owner.Id]

                    if char then
                        storageMenu[string.format("%s-vehicles", v.Owner.Id)] = {
                            label = string.format("%s %s", char.First, char.Last),
                            items = {}
                        }

                        table.insert(storageMenu.main.items, {
                            label = string.format("%s %s", char.First, char.Last),
                            description = string.format("View Vehicles Belonging to State ID %s", v.Owner.Id),
                            submenu = string.format("%s-vehicles", v.Owner.Id),
                        })
                    end
                end

                table.insert(storageMenu[string.format("%s-vehicles", v.Owner.Id)].items, {
                    label = v.Make .. ' ' .. v.Model,
                    description = description,
                    submenu = v.VIN,
                })
            end
        end
    else
        for k, v in ipairs(personalVehicles) do
            createVehicleSubmenu(v)
            local description = ''
            if v.RegisteredPlate then
                description = 'Plate: '.. v.RegisteredPlate
            else
                description = 'Type: '.. (v.Type == 1 and 'Boat' or 'Aircraft')
            end

            table.insert(storageMenu.main.items, {
                label = v.Make .. ' ' .. v.Model,
                description = description,
                submenu = v.VIN,
            })
        end
    end

    if #fleetVehicles > 0 then
        table.insert(storageMenu.main.items, {
            label = 'Fleet Vehicles',
            description = characterDuty and 'View Fleet Vehicles That You Have Access To' or 'This Requires You to Be On Duty',
            submenu = 'fleet',
            disabled = not characterDuty,
        })

        storageMenu['fleet'] = {
            label = 'Fleet Vehicles',
            items = {}
        }

        for k, v in ipairs(fleetVehicles) do
            createVehicleSubmenu(v)

            local description = ''
            if v.RegisteredPlate then
                description = 'Plate: '.. v.RegisteredPlate
            else
                description = 'Type: '.. (v.Type == 1 and 'Boat' or 'Aircraft')
            end

            table.insert(storageMenu.fleet.items, {
                label = v.Make .. ' ' .. v.Model,
                description = description,
                submenu = v.VIN,
            })
        end
    end

    vehStorageMenuOpen = true
    ListMenu:Show(storageMenu)
end

AddEventHandler('ListMenu:EnterSubMenu', function(vin)
    if vehStorageMenuOpen then
        CleanupTempVehicle()
        local vehicle = tempVehAppearanceData[vin]
        if tempParkingSpace and vehicle then
            loadingVehicleStorageVehicle = true

            Game.Vehicles:SpawnLocal(tempParkingSpace.xyz, vehicle.Vehicle, tempParkingSpace.w, function(veh)
                table.insert(_tempVehicles, veh)

                FreezeEntityPosition(veh, true)
                SetEntityAlpha(veh, 155)
                SetVehicleDoorsLocked(veh, 2)
                if vehicle.Properties then
                    SetVehicleProperties(veh, vehicle.Properties)
                end
                SetEntityCollision(veh, false, true)
                if vehicle.RegisteredPlate then
                    SetVehicleNumberPlateText(veh, vehicle.RegisteredPlate)
                end

                loadingVehicleStorageVehicle = false
            end)
        end
    end
end)

AddEventHandler('ListMenu:GoBack', function()
    if vehStorageMenuOpen then
        CleanupTempVehicle()
    end
end)

AddEventHandler('Vehicles:Client:Storage:Retrieve', function(data)
    if loadingVehicleStorageVehicle then
        Notification:Error('Awaiting Vehicle Load')
        SetTimeout(2500, function()
            CleanupTempVehicle()
        end)
        return
    end

    if data.VIN and tempVehAppearanceData[data.VIN] and tempParkingSpace and tempCurrentStorageId then
        vehActuallySpawningOne = true
        Callbacks:ServerCallback('Vehicles:RetrieveVehicleFromStorage', {
            coords = tempParkingSpace.xyz,
            heading = tempParkingSpace.w,
            VIN = data.VIN,
            storageType = tempCurrentStorageType,
            storageId = tempCurrentStorageId,
        }, function(success)
            CleanupTempVehicle()
            if success then
                Notification:Info('Spawned Vehicle & Received Keys')
            else
                Notification:Error('Error') -- Very descriptive error message
            end
        end)
    end
end)

AddEventHandler('ListMenu:Close', function()
    if vehStorageMenuOpen then
        vehStorageMenuOpen = false
        tempVehAppearanceData = {}
        if not vehActuallySpawningOne then
            CleanupTempVehicle()
        else
            SetTimeout(2500, function()
                CleanupTempVehicle()
            end)
        end
    end

    loadingVehicleStorageVehicle = false
end)