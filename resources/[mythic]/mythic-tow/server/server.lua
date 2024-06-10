local _activeTowVehicles = {}
local maxActive = 10

_activeTowers = {}

AddEventHandler('Tow:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Database = exports["mythic-base"]:FetchComponent('Database')
	Middleware = exports['mythic-base']:FetchComponent('Middleware')
	Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
	Logger = exports['mythic-base']:FetchComponent('Logger')
	Jobs = exports['mythic-base']:FetchComponent('Jobs')
	Fetch = exports['mythic-base']:FetchComponent('Fetch')
	Chat = exports['mythic-base']:FetchComponent('Chat')
	Execute = exports['mythic-base']:FetchComponent('Execute')
    Vehicles = exports['mythic-base']:FetchComponent('Vehicles')
    Phone = exports['mythic-base']:FetchComponent('Phone')
    Banking = exports['mythic-base']:FetchComponent('Banking')
    Tow = exports['mythic-base']:FetchComponent('Tow')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mythic-base']:RequestDependencies('Tow', {
		'Database',
		'Middleware',
		'Callbacks',
		'Logger',
		'Jobs',
		'Fetch',
		'Chat',
		'Execute',
        'Vehicles',
        'Phone',
        'Banking',
        'Tow',
	}, function(error)
		if #error > 0 then return; end
		RetrieveComponents()
        
        Middleware:Add("Characters:Logout", function(source)
            Tow:CleanupPickup(source)
            _activeTowers[source] = nil
        end)
    
        Middleware:Add("playerDropped", function(source)
            Tow:CleanupPickup(source)
            _activeTowers[source] = nil
        end)

		Callbacks:RegisterServerCallback('Tow:RequestJob', function(source, data, cb)
            local char = Fetch:Source(source):GetData('Character')
			if not Jobs.Permissions:HasJob(source, 'tow') and char then
                cb(Jobs:GiveJob(char:GetData('SID'), 'tow', false, 'employee'))
            else
                cb(false)
            end
		end)

        Callbacks:RegisterServerCallback('Tow:QuitJob', function(source, data, cb)
            local char = Fetch:Source(source):GetData('Character')
			if Jobs.Permissions:HasJob(source, 'tow') and char then
                _activeTowers[source] = nil
                cb(Jobs:RemoveJob(char:GetData('SID'), 'tow'))
            else
                cb(false)
            end
        end)

        Callbacks:RegisterServerCallback('Tow:OnDuty', function(source, data, cb)
            local char = Fetch:Source(source):GetData('Character')
            local dutyData = Jobs.Duty:GetDutyData('tow')
			if Jobs.Permissions:HasJob(source, 'tow') and char then
                if not dutyData or (dutyData and dutyData.Count < maxActive) then
                    if Jobs.Duty:On(source, 'tow', true) then
                        _activeTowers[source] = {
                            next = os.time() + (math.random(1, 3) * 60),
                        }
                        Execute:Client(
                            source, 
                            'Notification', 
                            'Info', 
                            [[
                                You are now on Duty as a Tow Truck Driver.<br><br>
                                Get a Tow Truck from Jerry in the Tow Lot.<br>
                                To Impound Vehicles, Bring them to the Tow Lot and
                                Fill out the Paperwork.
                            ]],
                            10000, 
                            'truck-tow'
                        )
                    else
                        Execute:Client(source, 'Notification', 'Error', 'Failed to Go On Duty', 5000, 'truck-tow')
                    end
                else
                    Execute:Client(source, 'Notification', 'Error', 'Too Many Tow Employees on Duty', 5000, 'truck-tow')
                end
            else
                Execute:Client(source, 'Notification', 'Error', 'Failed to Go On Duty', 5000, 'truck-tow')
            end
        end)

        Callbacks:RegisterServerCallback('Tow:OffDuty', function(source, data, cb)
            local char = Fetch:Source(source):GetData('Character')
			if char and Jobs.Duty:Get(source, 'tow') then
                local stateId = char:GetData('SID')
                if not _activeTowVehicles[stateId] then
                    Jobs.Duty:Off(source, 'tow')
                    Tow:CleanupPickup(source)
                    _activeTowers[source] = nil
                    Phone.Notification:RemoveById(source, "TOW_OBJ")
                else
                    Execute:Client(source, 'Notification', 'Error', 'Return the Tow Truck Before Going Off Duty', 5000, 'truck-tow')
                end
            else
                Execute:Client(source, 'Notification', 'Error', 'Failed to Go Off Duty', 5000, 'truck-tow')
            end
        end)

        Callbacks:RegisterServerCallback('Tow:RequestTruck', function(source, spaceCoords, cb)
            local char = Fetch:Source(source):GetData('Character')
			if char and Player(source).state.onDuty == 'tow' then
                local stateId = char:GetData('SID')
                if not _activeTowVehicles[stateId] then
                    Vehicles:SpawnTemp(source, `flatbed`, spaceCoords.xyz, spaceCoords.w, function(spawnedVehicle, VIN, plate)
                        if spawnedVehicle then
                            Vehicles.Keys:Add(source, VIN)

                            _activeTowVehicles[stateId] = {
                                SID = stateId,
                                veh = spawnedVehicle,
                                net = NetworkGetNetworkIdFromEntity(spawnedVehicle),
                                VIN = VIN,
                                plate = plate,
                            }

                            GlobalState[string.format('TowTrucks:%s', stateId)] = NetworkGetNetworkIdFromEntity(spawnedVehicle)

                            Execute:Client(source, 'Notification', 'Success', 'Your Tow Truck Was Provided', 5000, 'truck-tow')
                            cb(spawnedVehicle)
                        else
                            Execute:Client(source, 'Notification', 'Error', 'Truck Spawn Failed', 5000, 'truck-tow')
                            cb(nil)
                        end
                    end, {
                        Make = 'MTL',
                        Model = 'Flatbed',
                        Value = 50000,
                    })
                else
                    Execute:Client(source, 'Notification', 'Error', 'We Already Gave You a Truck', 5000, 'truck-tow')
                    cb(nil)
                end
            end
        end)

        Callbacks:RegisterServerCallback('Tow:ReturnTruck', function(source, data, cb)
            local char = Fetch:Source(source):GetData('Character')
			if char then
                local stateId = char:GetData('SID')
                local hasTruck = _activeTowVehicles[stateId]
                if hasTruck and hasTruck.veh and DoesEntityExist(hasTruck.veh) then
                    local truckCoords = GetEntityCoords(hasTruck.veh)
                    if #(truckCoords - _towSpaces[1].xyz) <= 20.0 then
                        Vehicles:Delete(hasTruck.veh, function(success)
                            if success then
                                _activeTowVehicles[stateId] = nil
                                GlobalState[string.format('TowTrucks:%s', stateId)] = false
                                Execute:Client(source, 'Notification', 'Success', 'Thanks for Returning Your Tow Truck', 5000, 'truck-tow')
                            else
                                Execute:Client(source, 'Notification', 'Error', 'Error Returning Truck', 5000, 'truck-tow')
                            end
                        end)
                    else
                        Execute:Client(source, 'Notification', 'Error', 'Your Tow Truck Isn\'t Nearby', 5000, 'truck-tow')
                    end
                else
                    Execute:Client(source, 'Notification', 'Error', 'You Don\'t Have a Truck to Return', 5000, 'truck-tow')
                end
            end
        end)
	end)
end)

TOW = {
    PayoutPickup = function(self, source)
        if _activeTowers[source] ~= nil then
            local char = Fetch:Source(source):GetData("Character")
            Banking.Balance:Deposit(Banking.Accounts:GetPersonal(char:GetData("SID")).Account, 300, {
				type = 'paycheck',
				title = "Tow Fee",
				description = 'Your Fee For A Vehicle Pickup',
				data = 300
			})
			Phone.Notification:RemoveById(source, "TOW_OBJ")
            Phone.Notification:Add(source, "Yard Manager", "Good work, I've sent your fee to your account. I'll let you know when I got another job for you", os.time() * 1000, 10000, {
                color = '#247919',
                label = 'Los Santos Tow',
                icon = 'truck-tow',
            }, {}, nil)

            Tow:CleanupPickup(source)
        end
    end,
    CleanupPickup = function(self, source)
        if _activeTowers[source] ~= nil then
            if _activeTowers[source].veh ~= nil and DoesEntityExist(_activeTowers[source].veh) then
                DeleteEntity(veh)
                _activeTowers[source].veh = nil
            end

            if _activeTowers[source].location ~= nil then
                _inuse[_activeTowers[source].location] = false
                _activeTowers[source].location = nil
            end
            
            _activeTowers[source].next = os.time() + (math.random(5, 10) * 60)
            _activeTowers[source].onTask = false
            TriggerClientEvent("Tow:Client:CleanupPickup", source)
        end

    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Tow', TOW)
end)