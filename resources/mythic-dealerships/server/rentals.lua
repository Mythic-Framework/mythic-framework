ACTIVE_RENTAL_VEHICLES = {}

function RegisterVehicleRentalCallbacks()
    Callbacks:RegisterServerCallback('Rentals:Purchase', function(source, data, cb)
        local rentalSpot, rentalVehicle, spaceCoords, spaceHeading = data.rental, data.vehicle, data.spaceCoords, data.spaceHeading
        if type(rentalSpot) == "number" and type(rentalVehicle) == "number" and spaceCoords and spaceHeading and _vehicleRentals[rentalSpot] then
            local char = Fetch:Source(source):GetData('Character')
            local rentalSpotData = _vehicleRentals[rentalSpot]
            local rentalVehicleData = rentalSpotData.vehicleList and rentalSpotData.vehicleList[rentalVehicle] or false
            if char and rentalVehicleData then
                local rentalCost = rentalVehicleData.cost.deposit + rentalVehicleData.cost.payment

                if Wallet:Modify(source, -rentalCost) then
                    local renterId = char:GetData('ID')
                    local renterSID = char:GetData('SID')
                    local renterName = char:GetData('First') .. ' ' .. char:GetData('Last')
    
                    Vehicles:SpawnTemp(source, rentalVehicleData.vehicle, spaceCoords, spaceHeading, function(spawnedVehicle, VIN, plate)
                        if spawnedVehicle then
                            Vehicles.Keys:Add(source, VIN)
    
                            local vehState = Entity(spawnedVehicle).state
                            vehState.Rental = renterSID
                            vehState.RentalCompany = rentalSpot
                            vehState.RentalCompanyName = rentalSpotData.name
    
                            ACTIVE_RENTAL_VEHICLES[VIN] = {
                                VIN = VIN,
                                Entity = spawnedVehicle,
                                Vehicle = rentalVehicleData.make .. ' ' .. rentalVehicleData.model,
                                NetworkEntity = NetworkGetNetworkIdFromEntity(spawnedVehicle),
                                RentalOrigin = rentalSpot,
                                RentalRenter = renterSID,
                                RentalVehicle = rentalVehicleData,
                                RentalPlate = plate,
                                Deposit = rentalVehicleData.cost.deposit,
                            }
    
                            cb(true, plate)
    
                            Inventory:AddItem(renterSID, 'rental_papers', 1, {
                                Renter = renterName,
                                Vehicle = rentalVehicleData.make .. ' ' .. rentalVehicleData.model,
                                Plate = not rentalVehicleData.noPlate and plate or 'No Plate',
                                VIN = VIN,
                                Company = rentalSpotData.name,
                                Deposit = rentalVehicleData.cost.deposit,
                                Payment = rentalVehicleData.cost.payment
                            }, 1)
                        else
                            cb(false)
                        end
                    end, {
                        Make = rentalVehicleData.make,
                        Model = rentalVehicleData.model,
                    })
                else
                    Execute:Client(source, 'Notification', 'Error', 'Not Enough Money to Rent', 5000)
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Rentals:GetPending', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        if type(data.rental) == "number" and char then
            local pending = {}
            local stateId = char:GetData('SID')
            for k, v in pairs(ACTIVE_RENTAL_VEHICLES) do
                if v.RentalRenter == stateId and v.RentalOrigin == data.rental then
                    pending[k] = v
                end
            end
            cb(pending)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Rentals:Return', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        if data and data.VIN then
            local vehicle = ACTIVE_RENTAL_VEHICLES[data.VIN]
            if vehicle and DoesEntityExist(vehicle.Entity) then
                Vehicles:Delete(vehicle.Entity, function(success)
                    if success then
                        Wallet:Modify(source, vehicle.Deposit)
                        ACTIVE_RENTAL_VEHICLES[data.VIN] = nil
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
end