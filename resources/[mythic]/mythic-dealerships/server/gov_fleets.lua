RegisterNetEvent('FleetDealers:Server:Purchase', function(shop, vehicle, livery)
    local src = source
    local shopData = _fleetConfig[shop]
    local char = Fetch:Source(src):GetData('Character')
    if char and shopData and Jobs.Permissions:HasPermissionInJob(src, shopData.job, shopData.requiredPermission) then
        local chosenVehicle = shopData.vehicles[vehicle]
        if chosenVehicle and chosenVehicle.liveries[livery] ~= nil then
            local purchaseBankAccount = Banking.Accounts:GetOrganization(shopData.bankAccount)
            if purchaseBankAccount and purchaseBankAccount.Account then
                if Banking.Balance:Charge(purchaseBankAccount.Account, chosenVehicle.price, {
                    type = 'bill',
                    title = 'Fleet Vehicle Purchase',
                    description = string.format(
                        'Fleet Vehicle Purchase - %s %s By %s %s (%s)',
                        chosenVehicle.make,
                        chosenVehicle.model,
                        char:GetData('First'),
                        char:GetData('Last'),
                        char:GetData('SID')
                    )
                }) then
                    local properties = table.copy(chosenVehicle.defaultProperties)
                    properties.livery = livery
                    Wait(200)
                    Vehicles.Owned:AddToFleet(
                        shopData.job,
                        shopData.workplace or false,
                        chosenVehicle.level or 0,
                        chosenVehicle.vehicle,
                        chosenVehicle.type or 0,
                        {
                            make = chosenVehicle.make,
                            model = chosenVehicle.model,
                            class = chosenVehicle.class,
                            value = chosenVehicle.price,
                        },
                        function(success, vehicle)
                            if success and vehicle then
                                Execute:Client(src, 'Notification', 'Success', string.format('Fleet Vehicle Purchase of a %s %s was Successful.<br><br>VIN: %s<br>Plate: %s', chosenVehicle.make, chosenVehicle.model, vehicle.VIN, vehicle.RegisteredPlate), 5000, 'car')
                            else
                                Logger:Error('Dealerships', string.format('Purchase of Fleet Vehicle Failed After Taking %s Cash from Bank Account: %s', chosenVehicle.price, purchaseBankAccount.Account))
                                Execute:Client(src, 'Notification', 'Error', 'Fleet Vehicle Purchase Failed', 5000, 'car')
                            end
                        end,
                        properties,
                        chosenVehicle.qaul or false
                    )
                else
                    Execute:Client(src, 'Notification', 'Error', 'Fleet Vehicle Purchase Failed - Not Enough Money in the Bank', 5000, 'car')
                end
            else
                Execute:Client(src, 'Notification', 'Error', 'Fleet Vehicle Purchase Failed', 5000, 'car')
            end
        else
            Execute:Client(src, 'Notification', 'Error', 'Fleet Vehicle Purchase Failed - Invalid Vehicle', 5000, 'car')
        end
    else
        Execute:Client(src, 'Notification', 'Error', 'Fleet Vehicle Purchase Failed', 5000, 'car')
    end
end)
