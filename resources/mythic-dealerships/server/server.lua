_hashToVeh = {}

AddEventHandler('Dealerships:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['mythic-base']:FetchComponent('Database')
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
    Vehicles = exports['mythic-base']:FetchComponent('Vehicles')
    Inventory = exports['mythic-base']:FetchComponent('Inventory')
    Dealerships = exports['mythic-base']:FetchComponent('Dealerships')
    Execute = exports['mythic-base']:FetchComponent('Execute')
    Billing = exports['mythic-base']:FetchComponent('Billing')
    Loans = exports['mythic-base']:FetchComponent('Loans')
    Banking = exports['mythic-base']:FetchComponent('Banking')
    Phone = exports['mythic-base']:FetchComponent('Phone')
    Wallet = exports['mythic-base']:FetchComponent('Wallet')
    Default = exports['mythic-base']:FetchComponent('Default')
    Chat = exports['mythic-base']:FetchComponent('Chat')
    MDT = exports['mythic-base']:FetchComponent('MDT')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Dealerships', {
        'Database',
        'Callbacks',
        'Logger',
        'Utils',
        'Doors',
        'Chat',
        'Inventory',
        'Jobs',
        'Fetch',
        'Vehicles',
        'Dealerships',
        'Execute',
        'Billing',
        'Loans',
        'Phone',
        'Banking',
        'Wallet',
        'Default',
        'MDT',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterVehicleRentalCallbacks()
        RegisterVehicleSaleCallbacks()
        LoadDealershipShit()

        Chat:RegisterAdminCommand("setstock", function(source, args, rawCommand)
            local dealership, vehicle, amount, price, class, make, model, category = table.unpack(args)
            amount = tonumber(amount)
            price = tonumber(price)

            if amount and (price and price > 0) then
                local res = Dealerships.Stock:Add(dealership, vehicle, amount, {
                    class = class,
                    price = price,
                    make = make,
                    model = model,
                    category = category
                })

                if res and res.success then
                    if res.existed then
                        Chat.Send.System:Single(source, "Success - Already Exists")
                    else
                        Chat.Send.System:Single(source, "Success")
                    end
                else
                    Chat.Send.System:Single(source, "Failed")
                end
            else
                Chat.Send.System:Single(source, "Invalid Arguments")
            end
        end, {
            help = "[Admin] Set Stock in a Vehicle Dealership. Use \" for multiple words",
            params = {
                {
                    name = "Dealership ID",
                    help = "ID of the Dealership e.g pdm or tuna",
                },
                {
                    name = "Vehicle ID",
                    help = "ID of the Vehicle e.g faggio",
                },
                {
                    name = "Amount",
                    help = "Quantity of Vehicle To Add",
                },
                {
                    name = "Data - Price",
                    help = "Price of Vehicle (Before commission)",
                },
                {
                    name = "Data - Class",
                    help = "Class e.g B",
                },
                {
                    name = "Data - Make",
                    help = "Class e.g Pegassi",
                },
                {
                    name = "Data - Model",
                    help = "Class e.g Faggio",
                },
                {
                    name = "Data - Category",
                    help = "Category e.g. import, compact, suv, sedans, muscle, sport, sportclassic, super, motorcycles, offroad, rally, van, utility, misc",
                },
            },
        }, 8)

        Chat:RegisterAdminCommand("incstock", function(source, args, rawCommand)
            local dealership, vehicle, amount = table.unpack(args)
            amount = tonumber(amount)

            if amount and amount > 0 then
                local res = Dealerships.Stock:Increase(dealership, vehicle, amount)

                if res and res.success then
                    Chat.Send.System:Single(source, "Successfully Increased Stock")
                else
                    Chat.Send.System:Single(source, "Not In Stock")
                end
            else
                Chat.Send.System:Single(source, "Invalid Arguments")
            end
        end, {
            help = "[Admin] Set Stock in a Vehicle Dealership. Use \" for multiple words",
            params = {
                {
                    name = "Dealership ID",
                    help = "ID of the Dealership e.g pdm or tuna",
                },
                {
                    name = "Vehicle ID",
                    help = "ID of the Vehicle e.g faggio",
                },
                {
                    name = "Amount",
                    help = "Quantity of Vehicle To Add",
                },
            },
        }, 3)

        local allStock = Dealerships.Stock:FetchAll()
        if allStock and #allStock > 0 then
            for k, v in ipairs(allStock) do
                if not _hashToVeh[v.dealership] then
                    _hashToVeh[v.dealership] = {}
                end

                _hashToVeh[v.dealership][GetHashKey(v.vehicle)] = v.vehicle
            end
        end
    end)
end)

DEALERSHIPS = {}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Dealerships', DEALERSHIPS)
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Dealerships:GetDealerStock', function(source, dealerId, cb)
        if dealerId and _dealerships[dealerId] then
            cb(Dealerships.Stock:FetchDealer(dealerId))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:ShowroomManagement:FetchData', function(source, dealerId, cb)
        if _dealerships[dealerId] and Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_showroom') then
            cb(true, Dealerships.Stock:FetchDealer(dealerId))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:StockViewing:FetchData', function(source, dealerId, cb)
        if _dealerships[dealerId] and Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_stock') or Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_sell') then
            cb(true, Dealerships.Stock:FetchDealer(dealerId), os.time(), Dealerships.Management:GetData(dealerId, 'profitPercentage'))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:Sales:FetchData', function(source, dealerId, cb)
        if _dealerships[dealerId] and Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_stock') or Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_sell') then
            cb(true, Dealerships.Stock:FetchDealer(dealerId), Loans:GetDefaultInterestRate(), Dealerships.Management:GetAllData(dealerId))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:ShowroomManagement:SetPosition', function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if data and data.dealerId and type(data.position) == 'number' and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_showroom') then
            cb(Dealerships.Showroom:UpdatePos(data.dealerId, data.position, data.vehData))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('BikeStand:Purchase', function(source, data, cb)
        if type(data.vehicleHash) == 'number' and type(data.price) == 'number' and data.price > 100 then
            local char = Fetch:Source(source):GetData('Character')
            if char and char:GetData('SID') then
                -- TODO: Charge Money
                if Wallet:Modify(source, -data.price) then
                    Vehicles.Owned:AddToCharacter(char:GetData('SID'), data.vehicleHash, 0, { make = 'Bicycle', model = data.name, class = 'Bicycle', value = data.price }, function(success, vehicleData)
                        if success and vehicleData then
                            Vehicles.Owned:Spawn(source, vehicleData.VIN, data.spawnCoords, data.spawnHeading, function(success)
                                Vehicles.Keys:Add(source, vehicleData.VIN)
                                cb(true)
                            end)
                        else
                            cb(false)
                        end
                    end)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:CheckPersonsCredit', function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")

        local stateId = math.tointeger(data.SID)

        if data and data.dealerId and stateId and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_sell') then
            local target = Fetch:SID(stateId)
            if target then
                target = target:GetData('Character')
            end

            if target then
                local loanData = Loans:GetAllowedLoanAmount(stateId)
                if loanData and loanData.maxBorrowable and loanData.maxBorrowable > 0 then
                    local charVehicleLoans = Loans:GetPlayerLoans(stateId, 'vehicle')
                    if not charVehicleLoans or #charVehicleLoans <= 1 then
                        cb({
                            SID = stateId,
                            price = loanData.maxBorrowable,
                            score = loanData.creditScore,
                            name = string.format('%s %s', target:GetData('First'), target:GetData('Last'))
                        })
                    else
                        cb({
                            SID = stateId,
                            price = false,
                            score = loanData.creditScore,
                            name = string.format('%s %s', target:GetData('First'), target:GetData('Last'))
                        })
                    end
                else
                    cb({
                        SID = stateId,
                        price = false,
                        score = loanData.creditScore,
                        name = string.format('%s %s', target:GetData('First'), target:GetData('Last'))
                    })
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:GetDealershipData', function(source, data, cb)
        if data and data.dealerId and _dealerships[data.dealerId] and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_manage') then
            cb(Dealerships.Management:GetAllData(data.dealerId))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:UpdateDealershipData', function(source, data, cb)
        if data and data.dealerId and _dealerships[data.dealerId] and data.updating and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_manage') then
            data.updating._id = nil
            data.updating.dealership = nil

            cb(Dealerships.Management:SetMultipleData(data.dealerId, data.updating))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:FetchHistory', function(source, dealerId, cb)
        if dealerId and _dealerships[dealerId] and Jobs.Permissions:HasPermissionInJob(source, dealerId, 'dealership_manage') then
            cb(Dealerships.Records:Get(dealerId))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:FetchCurrentOwner', function(source, data, cb)
        if data and data.dealerId and _dealerships[data.dealerId] and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_manage') then
            Vehicles.Owned:GetVIN(data.VIN, function(vehicle)
                if vehicle then
                    if vehicle.Owner then
                        if vehicle.Owner.Type == 0 then
                            local owner = MDT.People:View(vehicle.Owner.Id)
                            vehicle.OwnerName = string.format("%s %s (%s)", owner.First, owner.Last, owner.SID)
                        elseif vehicle.Owner.Type == 1 or vehicle.Owner.Type == 2 then
                            local jobData = Jobs:DoesExist(vehicle.Owner.Id, vehicle.Owner.Workplace)
                            if jobData then
                                if jobData.Workplace then
                                    vehicle.OwnerName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
                                else
                                    vehicle.OwnerName = jobData.Name
                                end
                            end
                        end

                        if vehicle.Owner.Type == 2 then
                            vehicle.OwnerName = vehicle.OwnerName .. " (Dealership Buyback)"
                        end
                    end

                    cb(vehicle)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:BuyBackStart', function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if data and data.dealerId and data.netId and _dealerships[data.dealerId] and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_buyback') then
            local veh = NetworkGetEntityFromNetworkId(data.netId)

            if veh and DoesEntityExist(veh) then
                local vehEnt = Entity(veh)
                if vehEnt.state.VIN and vehEnt.state.Owned and vehEnt.state.Make then
                    local vehModel = GetVehicleModelFromHash(data.dealerId, GetEntityModel(veh))
                    if vehModel then
                        local stockInfo = Dealerships.Stock:FetchDealerVehicle(data.dealerId, vehModel)
                        local vehStrikes = MDT.Vehicles:GetStrikes(vehEnt.state.VIN) or 0
                        local remainingLoan = Loans:HasRemainingPayments("vehicle", vehEnt.state.VIN)

                        if not remainingLoan then
                            if stockInfo and stockInfo.data and vehStrikes then
                                local strikeLoss = (vehStrikes * 0.02)
                                local pricePercent = 0.75 - strikeLoss
                                local buybackPrice = math.floor(stockInfo.data.price * pricePercent)

                                cb(true, stockInfo.data, vehStrikes, buybackPrice, math.floor(stockInfo.data.price * strikeLoss))
                            else
                                cb(false)
                            end
                        else
                            cb(false, "Vehicle Still Has Remaining Loan Payments")
                        end
                    else
                        cb(false, "We Don't Sell That Vehicle")
                    end
                else
                    cb(false, "Vehicle Isn't Owned!")
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Dealerships:BuyBack', function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if data and data.dealerId and data.netId and _dealerships[data.dealerId] and Jobs.Permissions:HasPermissionInJob(source, data.dealerId, 'dealership_buyback') then
            local veh = NetworkGetEntityFromNetworkId(data.netId)

            if veh and DoesEntityExist(veh) then
                local vehEnt = Entity(veh)
                if vehEnt.state.VIN and vehEnt.state.Owned and vehEnt.state.Make then
                    local vehModel = GetVehicleModelFromHash(data.dealerId, GetEntityModel(veh))
                    if vehModel then
                        local stockInfo = Dealerships.Stock:FetchDealerVehicle(data.dealerId, vehModel)
                        local vehStrikes = MDT.Vehicles:GetStrikes(vehEnt.state.VIN) or 0
                        local remainingLoan = Loans:HasRemainingPayments("vehicle", vehEnt.state.VIN)

                        if stockInfo and stockInfo.data and vehStrikes and not remainingLoan then
                            local vehicle = Vehicles.Owned:GetActive(vehEnt.state.VIN)

                            local pricePercent = 0.75 - (vehStrikes * 0.02)
                            local buybackPrice = math.floor(stockInfo.data.price * pricePercent)

                            if vehicle and vehicle:GetData('Owner')?.Type == 0 then
                                local owner = Fetch:SID(vehicle:GetData('Owner').Id)
                                if owner then
                                    owner = owner:GetData('Character')
                                    if owner then
                                        local ownerPed = GetPlayerPed(owner:GetData('Source'))
                                        local myPed = GetPlayerPed(source)

                                        if #(GetEntityCoords(ownerPed) - GetEntityCoords(myPed)) <= 5.0 then
                                            local d = Banking.Accounts:GetOrganization(data.dealerId)
                                            local p = Banking.Accounts:GetPersonal(owner:GetData('SID'))

                                            if d and d.Account and p and p.Account then
                                                local success = Banking.Balance:Charge(d.Account, buybackPrice, {
                                                    type = 'bill',
                                                    transactionAccount = p.Account,
                                                    title = 'Vehicle Buyback',
                                                    description = string.format('Vehicle Buyback of a %s %s (%s) From %s %s (%s)', vehEnt.state.Make, vehEnt.state.Model, vehEnt.state.VIN, owner:GetData("First"), owner:GetData("Last"), owner:GetData("SID")),
                                                    data = {
                                                        buyer = {
                                                            ID = char:GetData('ID'),
                                                            SID = char:GetData('SID'),
                                                            First = char:GetData('First'),
                                                            Last = char:GetData('Last'),
                                                        }
                                                    }
                                                })

                                                if success then
                                                    local ownerHistory = vehicle:GetData('OwnerHistory') or {}
                                                    local oldOwner = vehicle:GetData('Owner')
                                                    table.insert(ownerHistory, {
                                                        Type = oldOwner.Type,
                                                        Id = oldOwner.Id,
                                                        First = owner:GetData('First'),
                                                        Last = owner:GetData('Last'),
                                                        Time = os.time(),
                                                    })

                                                    vehicle:SetData('Owner', {
                                                        Type = 2,
                                                        Id = data.dealerId,
                                                    })

                                                    vehicle:SetData('OwnerHistory', ownerHistory)
                                                    vehicle:SetData('Storage', _dealerships[data.dealerId].storage)

                                                    Vehicles.Owned:ForceSave(vehEnt.state.VIN)
                                                    Vehicles.Keys:Remove(owner:GetData('Source'), VIN)

                                                    Dealerships.Records:CreateBuyBack(data.dealerId, {
                                                        time = os.time(),
                                                        vehicle = {
                                                            VIN = vehEnt.state.VIN,
                                                            plate = vehEnt.state.RegisteredPlate,
                                                            data = stockInfo.data,
                                                        },
                                                        previousOwner = {
                                                            ID = owner:GetData('ID'),
                                                            SID = owner:GetData('SID'),
                                                            First = owner:GetData('First'),
                                                            Last = owner:GetData('Last'),
                                                        },
                                                        buyer = {
                                                            ID = char:GetData('ID'),
                                                            SID = char:GetData('SID'),
                                                            First = char:GetData('First'),
                                                            Last = char:GetData('Last'),
                                                        },
                                                    })

                                                    Banking.Balance:Deposit(p.Account, buybackPrice, {
                                                        type = 'transfer',
                                                        transactionAccount = d.Account,
                                                        title = 'Vehicle Buyback',
                                                        description = string.format('%s Vehicle Buyback of a %s %s (%s)', _dealerships[data.dealerId].abbreviation, vehEnt.state.Make, vehEnt.state.Model, vehEnt.state.VIN),
                                                        data = {
                                                            buyer = {
                                                                ID = char:GetData('ID'),
                                                                SID = char:GetData('SID'),
                                                                First = char:GetData('First'),
                                                                Last = char:GetData('Last'),
                                                            }
                                                        },
                                                    })

                                                    Vehicles:Delete(veh, function() end)

                                                    Dealerships.Stock:Increase(data.dealerId, vehModel, 1)

                                                    cb(true)
                                                else
                                                    cb(false, "Dealership Cannot Afford This Vehicle")
                                                end
                                            else
                                                cb(false)
                                            end
                                        else
                                            cb(false, "Too Far Away")
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
                        else
                            cb(false)
                        end
                    else
                        cb(false, "We Don't Sell That Vehicle")
                    end
                else
                    cb(false, "Vehicle Isn't Owned!")
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end

function GetVehicleModelFromHash(dealer, hash)
    if _hashToVeh[dealer] then
        return _hashToVeh[dealer][hash]
    end
end