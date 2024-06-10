local _taggedVehs = {}

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Vehicles:GetKeys', function(source, VIN, cb)
        Vehicles.Keys:Add(source, VIN)
        cb(true)
    end)

    Callbacks:RegisterServerCallback('Vehicles:ToggleLocks', function(source, data, cb)
        local veh = NetworkGetEntityFromNetworkId(data.netId)
        local vehState = Entity(veh).state
        if DoesEntityExist(veh) and vehState.VIN and not vehState.wasThermited then
            local groupKeys = vehState.GroupKeys
            if Vehicles.Keys:Has(source, vehState.VIN, vehState.GroupKeys) then
                local newState = data.state
                if newState == nil then 
                    newState = not vehState.Locked
                end

                vehState.Locked = newState
                SetVehicleDoorsLocked(veh, vehState.Locked and 2 or 1)
                cb(true, vehState.Locked)
            end
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:BreakOpenLock', function(source, data, cb)
        local veh = NetworkGetEntityFromNetworkId(data.netId)
        local vehState = Entity(veh).state
        if DoesEntityExist(veh) and vehState.VIN then
            vehState.Locked = false
            SetVehicleDoorsLocked(veh, vehState.Locked and 2 or 1)
            cb(true, vehState.Locked)
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:GetVehiclesInStorage', function(source, storageId, cb)
        local character = Fetch:Source(source):GetData('Character')
        local storageData = _vehicleStorage[storageId]
        if not character or not storageData then
            cb(false)
            return
        end

        local charJobs = character:GetData('Jobs') or {}
        local fleetFetch = false

        if type(storageData.restricted) ~= 'table' or DoesCharacterPassStorageRestrictions(source, charJobs, storageData.restricted) then
            local myDuty = Player(source).state.onDuty

            if type(storageData.fleet) == 'table' and myDuty then
                for k, v in ipairs(storageData.fleet) do
                    if v.JobId == myDuty then
                        local jobData = Jobs.Permissions:HasJob(source, v.JobId, v.WorkplaceId)
                        if jobData then
                            local jobPermissions = Jobs.Permissions:GetPermissionsFromJob(source, jobData.Id)
                            if jobPermissions then
                                fleetFetch = {
                                    Id = jobData.Id,
                                    Workplace = (jobData.Workplace and jobData.Workplace.Id or false),
                                    Level = GetAllowedFleetVehicleLevelFromJobPermissions(jobPermissions)
                                }
                            end
                        end
                    end
                end
            end

            local characterId = character:GetData('SID')
            Vehicles.Owned:GetAll(storageData.vehType, 0, characterId, function(vehicles)
                cb(vehicles)
            end, 1, storageId, true, fleetFetch)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:GetVehiclesInPropertyStorage', function(source, storageId, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character then
            cb(false)
            return
        end

        local property = Properties:Get(storageId)
        local maxParking = Properties:GetMaxParkingSpaces(storageId)

        if property and maxParking and maxParking > 0 then
            local characterId = character:GetData('SID')
            Vehicles.Owned:GetAll(0, false, false, function(vehicles)
                local c = {}
                local charsToFetch = {}

                for k, v in ipairs(vehicles) do
                    if v.Owner and v.Owner.Type == 0 and v.Owner.Id then
                        if not c[v.Owner.Id] then
                            c[v.Owner.Id] = true
                            table.insert(charsToFetch, v.Owner.Id)
                        end
                    end
                end

                Database.Game:find({
                    collection = 'characters',
                    query = {
                        SID = {
                            ['$in'] = charsToFetch
                        }
                    },
                    options = {
                        projection = {
                            SID = 1,
                            First = 1,
                            Last = 1,
                            Phone = 1,
                        }
                    }
                }, function(success, results)
                    if success and #results > 0 then
                        local dumbShit = {}
                        for k, v in ipairs(results) do
                            dumbShit[v.SID] = v
                        end

                        cb(vehicles, {
                            current = Vehicles.Owned.Properties:GetCount(storageId),
                            max = maxParking or 0
                        }, characterId, dumbShit)
                    else
                        cb(false)
                    end
                end)
            end, 2, storageId, true, false)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:RetrieveVehicleFromStorage', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or not data or not data.VIN or not data.coords or not data.heading then
            cb(false)
            return
        end

        local characterId = character:GetData('SID')

        if Vehicles.Owned:GetActive(data.VIN) then
            cb(false)
            return
        end

        Vehicles.Owned:GetVIN(data.VIN, function(vehicle)

            if vehicle and vehicle.VIN then
                local isAuthedForVehicle = false
                if vehicle.Owner.Type == 0 and (vehicle.Owner.Id == characterId or data.storageType == 2) then
                    isAuthedForVehicle = true
                elseif vehicle.Owner.Type == 1 then
                    local onDuty = Player(source).state.onDuty

                    if onDuty and onDuty == vehicle.Owner.Id then
                        local jobPermissions = Jobs.Permissions:GetPermissionsFromJob(source, vehicle.Owner.Id, vehicle.Owner.Workplace)
                        if jobPermissions then
                            local allowedLevel = GetAllowedFleetVehicleLevelFromJobPermissions(jobPermissions)
                            if (allowedLevel >= vehicle.Owner.Level) then
                                isAuthedForVehicle = true
                            end
                        end
                    end
                end

                if isAuthedForVehicle then
                    Vehicles.Owned:Spawn(source, vehicle.VIN, data.coords, data.heading, function(success, vehicleData, vehicleId)
                        if success then
                            Vehicles.Keys:Add(source, vehicle.VIN)
                        end
                        cb(success)
                    end)
                else
                    cb(false)
                end
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Vehicles:PutVehicleInStorage', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        local storageData = _vehicleStorage[data.storageId]
        if not character or not data or not data.VIN or not data.storageId or not storageData then
            cb(false)
            return
        end

        if storageData.retrievalOnly then
            Execute:Client(source, 'Notification', 'Error', 'Cannot Store Vehicles Here')
            cb(false)
            return
        end

        local characterId = character:GetData('SID')
        local vehicle = Vehicles.Owned:GetActive(data.VIN)

        if not vehicle then
            cb(false)
            return
        end

        local vehicleOwner = vehicle:GetData('Owner')

        local isAuthedForVehicle = false
        if vehicleOwner.Type == 0 and (not storageData.restricted) or (storageData.restricted and DoesCharacterPassStorageRestrictions(source, character:GetData('Jobs') or {}, storageData.restricted) and characterId == vehicleOwner.Id) then
            isAuthedForVehicle = true
        elseif vehicleOwner.Type == 1 then
            if storageData.fleet and DoesVehiclePassFleetRestrictions(vehicleOwner, storageData.fleet) then
                local onDuty = Player(source).state.onDuty

                if onDuty and onDuty == vehicleOwner.Id then
                    local jobPermissions = Jobs.Permissions:GetPermissionsFromJob(source, vehicleOwner.Id, vehicleOwner.Workplace)
                    if jobPermissions then
                        local allowedLevel = GetAllowedFleetVehicleLevelFromJobPermissions(jobPermissions)
                        if (allowedLevel >= vehicleOwner.Level) then
                            local t = vehicle:GetData('LastDriver') or {}
                            if #t >= 20 then
                                table.remove(t, 1)
                            end

                            table.insert(t, {
                                time = os.time(),
                                char = characterId,
                            })

                            vehicle:SetData('LastDriver', t)

                            isAuthedForVehicle = true
                        end
                    end
                end
            else
                Execute:Client(source, 'Notification', 'Error', 'Cannot Store This Vehicle Here')
            end
        end

        if isAuthedForVehicle and vehicle:GetData('Type') == storageData.vehType then
            Vehicles.Owned:Store(data.VIN, 1, data.storageId, function(success)
                cb(success)
            end)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Vehicles:Impound:TagVehicle", function(source, data, cb)
        local plyr = Fetch:Source(source)
        local pState = Player(source).state
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if pState.onDuty == "police" then
                    local entState = Entity(NetworkGetEntityFromNetworkId(data.vNet)).state
                    if entState ~= nil and entState.VIN ~= nil and _taggedVehs[entState.VIN] == nil then
                        _taggedVehs[entState.VIN] = data
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:PutVehicleInPropertyStorage', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or not data or not data.VIN or not data.storageId then
            cb(false)
            return
        end

        local characterId = character:GetData('SID')
        local vehicle = Vehicles.Owned:GetActive(data.VIN)

        if not vehicle then
            cb(false)
            return
        end

        local vehicleOwner = vehicle:GetData('Owner')
        if vehicleOwner.Type == 0 and vehicle:GetData('Type') == 0 then
            if Properties.Keys:HasBySID(data.storageId, vehicleOwner.Id) then
                local property = Properties:Get(data.storageId)
                local vehLimit = Properties:GetMaxParkingSpaces(data.storageId)
                if not vehLimit then
                    vehLimit = 0
                end

                if Vehicles.Owned.Properties:GetCount(data.storageId, vehicle:GetData('VIN')) < vehLimit then
                    Vehicles.Owned:Store(data.VIN, 2, data.storageId, function(success)
                        cb(success)
                    end)
                else
                    cb(false, true)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:Impound', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or not data.type or not data.vNet then
            cb(false)
            return
        end

        local veh = NetworkGetEntityFromNetworkId(data.vNet)
        local myDuty = Player(source).state.onDuty

        if DoesEntityExist(veh) and myDuty and Jobs.Permissions:HasPermission(source, _impoundConfig.RequiredPermission) or Jobs.Permissions:HasPermission(source, _impoundConfig.Police.RequiredPermission) then
            local vState = Entity(veh).state
            if vState and vState.VIN and not vState.towObjective then
                local ownedVehicle = Vehicles.Owned:GetActive(vState.VIN)
                if ownedVehicle then
                    local impounderData = {
                        SID = character:GetData('SID'),
                        First = character:GetData('First'),
                        Last = character:GetData('Last'),
                        ID = character:GetData('ID'),
                        Police = myDuty == 'police',
                    }

                    if _taggedVehs[vState.VIN] ~= nil then
                        local p = Fetch:CharacterData("SID", _taggedVehs[vState.VIN].requester)
                        if p ~= nil then
                            local c = p:GetData("Character")
                            local duty = Player(p:GetData("Source")).state.onDuty
                            impounderData = {
                                SID = c:GetData('SID'),
                                First = c:GetData('First'),
                                Last = c:GetData('Last'),
                                ID = c:GetData('ID'),
                                Police = duty == 'police',
                            }
                        end

                        data = _taggedVehs[vState.VIN]
                    end

                    local impoundData = ParseImpoundData(0, 0, impounderData)
                    if data.type == 'impound' then
                        impoundData = ParseImpoundData(_impoundConfig.RegularFine, 0, impounderData)
                    elseif data.type == 'police' and data.level then
                        local levelData = _impoundConfig.Police.Levels[data.level]
                        if levelData then
                            local policeFine = 0

                            if levelData.Fine.Percent and vState and vState.Value then
                                local fineMultiplier = levelData.Fine.Percent / 100
                                policeFine = math.ceil(vState.Value * fineMultiplier)
                            end
    
                            if policeFine <= levelData.Fine.Min then
                                policeFine = levelData.Fine.Min
                            end
    
                            impoundData = ParseImpoundData(policeFine, levelData.Holding, impounderData)
                        end
                    end

                    if ownedVehicle:GetData('Type') == 0 and ownedVehicle:GetData('Owner').Type == 0 then
                        ownedVehicle:SetData('Storage', impoundData)
                    end
                end

                if myDuty == 'tow' and _taggedVehs[vState.VIN] ~= nil then
                    Banking.Balance:Deposit(Banking.Accounts:GetPersonal(character:GetData("SID")).Account, 800, {
                        type = 'paycheck',
                        title = "PD Tow Fee",
                        description = 'Your Fee For A Vehicle Pickup',
                        data = 800
                    })
                end

                Vehicles:Delete(veh, function(success)
                    cb(success)
                end)
            elseif vState and vState.towObjective then
                if myDuty == 'tow' and _taggedVehs[vState.VIN] ~= nil then
                    Banking.Balance:Deposit(Banking.Accounts:GetPersonal(character:GetData("SID")).Account, 800, {
                        type = 'paycheck',
                        title = "PD Tow Fee",
                        description = 'Your Fee For A Vehicle Pickup',
                        data = 800
                    })
                end
                Vehicles:Delete(veh, function(success)
                    if success then
                        Tow:PayoutPickup(source)
                    end
                    cb(success)
                end)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:GetVehiclesInImpound', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character then
            cb(false)
            return
        end

        local characterId = character:GetData('SID')
        Vehicles.Owned:GetAll(0, 0, characterId, function(vehicles)
            cb(vehicles, os.time())
        end, 0, 0, false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:RetrieveVehicleFromImpound', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or not data.VIN or not data.coords or not data.heading then
            cb(false)
            return
        end

        local characterId = character:GetData('SID')
        local timeNow = os.time()

        Vehicles.Owned:GetVIN(data.VIN, function(vehicle)
            if vehicle and vehicle.VIN and vehicle.Storage.Type == 0 and not vehicle.Seized then

                if vehicle.Storage.Fine and vehicle.Storage.Fine > 0 then
                    if not Wallet:Modify(source, -vehicle.Storage.Fine) then
                        cb(false)
                        return
                    end

                    local f = Banking.Accounts:GetOrganization("government")
                    Banking.Balance:Deposit(f.Account, vehicle.Storage.Fin, false, true)
                end


                if vehicle.Storage.TimeHold and (vehicle.Storage.TimeHold.ExpiresAt - timeNow) > 0 then
                    -- Holding Time Has Not Expired
                    cb(false)
                    return
                end

                Vehicles.Owned:Spawn(source, vehicle.VIN, data.coords, data.heading, function(success, vehicleData, vehicleId)
                    if success then
                        local vData = Vehicles.Owned:GetActive(vehicle.VIN)
                        vData:SetData('Storage', GetVehicleTypeDefaultStorage(vehicleData.Type))
                        Vehicles.Keys:Add(source, vehicle.VIN)
                    end
                    cb(success)
                end)
            else
                cb(false)
            end
        end)
    end)

    Callbacks:RegisterServerCallback('Vehicles:CompleteCustoms', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or type(data.cost) ~= 'number' or type(data.changes) ~= 'table' or not data.vNet then
            cb(false)
            return
        end

        local veh = NetworkGetEntityFromNetworkId(data.vNet)
        local vehState = Entity(veh)
        if DoesEntityExist(veh) and vehState and vehState.state.VIN then
            if Wallet:Modify(source, -math.abs(data.cost)) then
                local vehicleData = Vehicles.Owned:GetActive(vehState.state.VIN)
                local newProperties = false
                if vehicleData and vehicleData:GetData('Properties') then
                    local currentProperties = vehicleData:GetData('Properties')
    
                    for k, v in pairs(data.changes) do
                        if k == 'mods' then
                            for mod, val in pairs(v) do
                                currentProperties.mods[mod] = val
                            end
                        elseif k == 'extras' then
                            currentProperties.extras = currentProperties.extras or {}
                            for extraId, val in pairs(v) do
                                currentProperties.extras[extraId] = val
                            end
                        else
                            currentProperties[k] = v
                        end
                    end
    
                    newProperties = currentProperties
                    vehicleData:SetData('Properties', currentProperties)
                    vehicleData:SetData('DirtLevel', 0.0)
                    Vehicles.Owned:ForceSave(vehicleData:GetData('VIN'))

                elseif vehState.state.PleaseDoNotFuckingDelete then
                    _savedVehiclePropertiesClusterfuck[vehState.state.VIN] = data.new
                end
    
                SetVehicleDirtLevel(veh, 0.0)

                local f = Banking.Accounts:GetOrganization("dgang")
                Banking.Balance:Deposit(f.Account, math.abs(data.cost), {
                    type = 'deposit',
                    title = 'Benny\'s',
                    description = string.format("Benny's Vehicle Modifications For %s %s", character:GetData("First"), character:GetData("Last")),
                    data = {},
                }, true)
    
                cb(true, newProperties)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:WheelFitment', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or not data?.vNet then
            cb(false)
            return
        end

        local veh = NetworkGetEntityFromNetworkId(data.vNet)
        local vehEnt = Entity(veh)
        if DoesEntityExist(veh) and vehEnt?.state?.VIN then
            local vehicleData = Vehicles.Owned:GetActive(vehEnt.state.VIN)
            if vehicleData then
                vehicleData:SetData('WheelFitment', data.fitment)
                Vehicles.Owned:ForceSave(vehicleData:GetData('VIN'))
            end

            vehEnt.state.WheelFitment = data.fitment
            TriggerClientEvent('Fitment:Client:Update', -1, data.vNet, data.fitment)

            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:CompleteRepair', function(source, data, cb)
        local character = Fetch:Source(source):GetData('Character')
        if not character or type(data.cost) ~= 'number' then
            cb(false)
            return
        end

        if Wallet:Modify(source, -math.abs(data.cost)) then
            local f = Banking.Accounts:GetOrganization("dgang")
            Banking.Balance:Deposit(f.Account, math.abs(data.cost), {
                type = 'deposit',
                title = 'Benny\'s Repair',
                description = string.format("Benny's Vehicle Repair For %s %s", character:GetData("First"), character:GetData("Last")),
                data = {},
            }, true)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Vehicles:CleanVehicle', function(source, data, cb)
        local veh = NetworkGetEntityFromNetworkId(data.vNet)
        local vehState = Entity(veh)
        if DoesEntityExist(veh) and vehState and vehState.state.VIN then
            if not data.bill or (data.bill and Wallet:Modify(source, -100)) then
                local vehicleData = Vehicles.Owned:GetActive(vehState.state.VIN)
                if vehicleData then
                    vehicleData:SetData('DirtLevel', 0.0)
                end

                SetVehicleDirtLevel(veh, 0.0)
                return cb(true)
            end
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:RemoveFakePlate', function(source, data, cb)
        local veh = NetworkGetEntityFromNetworkId(data)
        if veh and DoesEntityExist(veh) then
            local vehState = Entity(veh).state
            if vehState.VIN and vehState.FakePlate then
                local char = Fetch:Source(source):GetData('Character')
                local vehicle = Vehicles.Owned:GetActive(vehState.VIN)
                if char and vehicle and vehicle:GetData('FakePlate') then
                    local fakePlateData = vehicle:GetData('FakePlateData')
                    local originalPlate = vehicle:GetData('RegisteredPlate')

                    SetVehicleNumberPlateText(veh, originalPlate)
                    vehicle:SetData('FakePlate', false)
                    vehicle:SetData('FakePlateData', false)

                    vehState.FakePlate = false

                    Vehicles.Owned:ForceSave(vehState.VIN)

                    if fakePlateData and fakePlateData.Plate then
                        Inventory:AddItem(char:GetData('SID'), 'fakeplates', 1, fakePlateData, 1)
                    end

                    cb(true)
                    return
                end
            end
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:RemoveHarness', function(source, data, cb)
        local veh = NetworkGetEntityFromNetworkId(data)
        if veh and DoesEntityExist(veh) then
            local vehState = Entity(veh).state
            if vehState.VIN and vehState.Harness and vehState.Harness > 0 then
                vehState.Harness = 0

                cb(true)
                return
            end
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:Tranfers:CompleteTransfer', function(source, data, cb)
        local SID, VIN in data
        local player = Fetch:Source(source)

        if SID and VIN and player then
            local char = player:GetData('Character')
            local target = Fetch:SID(SID)
            local vehicle = Vehicles.Owned:GetActive(VIN)
            if char and target and vehicle and vehicle:GetData('Owner')?.Type == 0 and vehicle:GetData('Owner')?.Id == char:GetData('SID') then
                local targetChar = target:GetData('Character')
                if targetChar and source ~= targetChar:GetData('Source') then
                    local ped = GetPlayerPed(source)
                    local targetPed = GetPlayerPed(targetChar:GetData('Source'))
                    if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) <= 10.0 then
                        local ownerHistory = vehicle:GetData('OwnerHistory') or {}
                        local oldOwner = vehicle:GetData('Owner')
                        table.insert(ownerHistory, {
                            Type = oldOwner.Type,
                            Id = oldOwner.Id,
                            First = char:GetData('First'),
                            Last = char:GetData('Last'),
                            Time = os.time(),
                        })

                        vehicle:SetData('Owner', {
                            Type = 0,
                            Id = targetChar:GetData('SID'),
                        })

                        vehicle:SetData('OwnerHistory', ownerHistory)

                        vehicle:SetData('Storage', GetVehicleTypeDefaultStorage(vehicle:GetData('Type')))
                        Vehicles.Owned:ForceSave(VIN)

                        Phone.Notification:Add(
                            source,
                            "Vehicle Ownership",
                            "A vehicle was just transferred out of your ownership",
                            os.time() * 1000,
                            6000,
                            "garage",
                            {}
                        )
                        Phone.Notification:Add(
                            targetChar:GetData('Source'),
                            "Vehicle Ownership",
                            "A vehicle was just transferred into your ownership",
                            os.time() * 1000,
                            6000,
                            "garage",
                            {}
                        )

                        Vehicles.Keys:Remove(source, VIN)
                        Vehicles.Keys:Add(targetChar:GetData('Source'), VIN)
                        return
                    else
                        Execute:Client(source, 'Notification', 'Error', 'Cannot Transfer to Someone That Isn\'t Nearby')
                    end
                end
            end
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback('Vehicles:RemoveNitrous', function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        local veh = NetworkGetEntityFromNetworkId(data)
        if char and veh and DoesEntityExist(veh) then
            local vehState = Entity(veh).state
            if vehState.VIN and vehState.Nitrous then

                Inventory:AddItem(char:GetData('SID'), 'nitrous', 1, {
                    Nitrous = math.floor(vehState.Nitrous)
                }, 1)

                vehState.Nitrous = false

                cb(true)
                return
            end
        end
        cb(false)
    end)
end