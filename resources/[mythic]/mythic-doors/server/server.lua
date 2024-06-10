DOORS_CACHE = {}
DOORS_IDS = {}
ELEVATOR_CACHE = {}

AddEventHandler('Doors:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Chat = exports['mythic-base']:FetchComponent('Chat')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Inventory = exports['mythic-base']:FetchComponent('Inventory')
    Execute = exports['mythic-base']:FetchComponent('Execute')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
    Doors = exports['mythic-base']:FetchComponent('Doors')
    Pwnzor = exports['mythic-base']:FetchComponent('Pwnzor')
    Properties = exports['mythic-base']:FetchComponent('Properties')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Doors', {
        'Callbacks',
        'Logger',
        'Utils',
        'Chat',
        'Inventory',
        'Jobs',
        'Execute',
        'Fetch',
        'Doors',
        'Pwnzor',
        'Properties',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
        RegisterCallbacks()
        RegisterChatCommands()
        --RegisterItems()

        RunStartup()
    end)
end)

local _startup = false
function RunStartup()
    if _startup then return; end
    _startup = true

    for k, v in ipairs(_doorConfig) do
        if v.model and v.coords then
            if v.id and not DOORS_IDS[v.id] then
                DOORS_IDS[v.id] = k
            end

            DOORS_CACHE[k] = {
                locked = v.locked,
            }
        else
            Logger:Warn('Doors', 'Door: '.. (v.id and v.id or k), ' Missing Required Data')
        end
    end

    for k, v in ipairs(_elevatorConfig) do
        ELEVATOR_CACHE[k] = {
            floors = {}
        }

        for k2,v2 in pairs(v.floors) do
            ELEVATOR_CACHE[k].floors[k2] = {
                locked = v2.defaultLocked or false
            }
        end
    end

    Logger:Trace('Doors', 'Loaded ^2'.. #_doorConfig .. '^7 Doors & ^2'.. #_elevatorConfig .. '^7 Elevators')
end

function RegisterChatCommands()
    Chat:RegisterAdminCommand('doorhelp', function(source, args, rawCommand)
        TriggerClientEvent('Doors:Client:DoorHelper', source)
    end, {
        help = '[Developer] Toggle Door Creation Helper'
    })
end

-- function RegisterItems()
--     Inventory.Items:RegisterUse('lockpick', 'Doors', function(source, item)
--         TriggerClientEvent('Doors:Client:AttemptLockpick', source, item)
--     end)
-- end

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Doors:Fetch', function(source, data, cb)
        cb(DOORS_CACHE, ELEVATOR_CACHE)
    end)

    Callbacks:RegisterServerCallback('Doors:ToggleLocks', function(source, doorId, cb)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local targetDoor = _doorConfig[doorId]
        if targetDoor and CheckPlayerAuth(source, targetDoor.restricted) then
            local newState = Doors:SetLock(doorId)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Doors:Lockpick', function(source, doorId, cb)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local targetDoor = _doorConfig[doorId]
        if targetDoor and targetDoor.canLockpick then
            local newState = Doors:SetLock(doorId, false)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Doors:Elevators:ToggleLocks', function(source, data, cb)
        local targetElevator = _elevatorConfig[data.elevator]
        if targetElevator and targetElevator.canLock and CheckPlayerAuth(source, targetElevator.canLock) then
            local newState = Doors:SetElevatorLock(data.elevator, data.floor)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Doors:Elevator:Validate", function(source, data, cb)
        Pwnzor.Players:TempPosIgnore(source)
        cb()
    end)
end

DOORS = {
    SetLock = function(self, doorId, newState, doneDouble)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local doorData = _doorConfig[doorId]

        if doorData then
            local isLocked = DOORS_CACHE[doorId].locked
            if newState == nil then
                newState = not isLocked
            end

            if newState ~= isLocked then
                DOORS_CACHE[doorId].locked = newState

                if DOORS_CACHE[doorId].forcedOpen then
                    DOORS_CACHE[doorId].forcedOpen = false
                end

                TriggerClientEvent('Doors:Client:UpdateState', -1, doorId, newState)
                if doorData.double and not doneDouble then
                    Doors:SetLock(doorData.double, newState, true)
                end
            end
            return newState
        end
        return nil
    end,
    IsLocked = function(self, doorId)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local doorData = _doorConfig[doorId]
        if doorData then
            return DOORS_CACHE[doorId].locked
        end
        return false
    end,
    SetForcedOpen = function(self, doorId)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        if DOORS_CACHE[doorId] then
            DOORS_CACHE[doorId].forcedOpen = true

            TriggerClientEvent('Doors:Client:SetForcedOpen', -1, doorId)
        end
    end,
    SetElevatorLock = function(self, elevatorId, floorId, newState)
        local data = _elevatorConfig[elevatorId]

        if data and ELEVATOR_CACHE[elevatorId] and ELEVATOR_CACHE[elevatorId].floors and ELEVATOR_CACHE[elevatorId].floors[floorId] then
            local isLocked = ELEVATOR_CACHE[elevatorId].floors[floorId].locked
            if newState == nil then
                newState = not isLocked
            end

            if data and newState ~= isLocked then
                ELEVATOR_CACHE[elevatorId].floors[floorId].locked = newState
                TriggerClientEvent('Doors:Client:UpdateElevatorState', -1, elevatorId, floorId, newState)
            end
            return newState
        end
        return nil
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Doors', DOORS)
end)

function CheckPlayerAuth(source, doorPermissionData)
    if type(doorPermissionData) ~= 'table' then
        return true
    end

    local player = Fetch:Source(source)
    if player then
        local char = player:GetData('Character')
        if char then
            local stateId = char:GetData('SID')

            if Jobs.Permissions:HasJob(source, 'dgang', false, false, 99, true) then
				return true
			end

            for k, v in ipairs(doorPermissionData) do
				if v.type == 'character' then
					if stateId == v.SID then
						return true
					end
				elseif v.type == 'job' then
					if v.job then
						if Jobs.Permissions:HasJob(source, v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.jobPermission) then
							return true
						end
					elseif v.jobPermission then
						if Jobs.Permissions:HasPermission(source, v.jobPermission) then
							return true
						end
					end
                elseif v.type == 'propertyData' then
					if Properties.Keys:HasAccessWithData(source, v.key, v.value) then
						return true
					end
				end
			end
        end
    end
    return false
end

RegisterNetEvent('Doors:Server:PrintDoor', function(data)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end

    file = io.open('created_doors_data.txt', "a")
    io.output(file)
    local output = GetDoorOutput(data)
    io.write(output)
    io.close(file)
end)

function GetDoorOutput(data)
    local printout = "{\n\tid = \"" .. data.name .. "\",\n\tmodel = " .. data.model .. ","

    printout = printout .. "\n\tcoords = vector3(" .. tostring(Utils:Round(data.coords.x, 2)) .. ", " .. tostring(Utils:Round(data.coords.y, 2))  .. ", " .. tostring(Utils:Round(data.coords.z, 2)) .."),"
    printout = printout .. "\n}\n\n"
    return printout
end