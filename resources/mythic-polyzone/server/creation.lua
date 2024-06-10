AddEventHandler('Polyzone:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Chat = exports['mythic-base']:FetchComponent('Chat')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Polyzone', {
        'Logger',
        'Utils',
        'Chat',
        'Fetch'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()

        Chat:RegisterAdminCommand('pzcreate', function(src, args, raw)
            TriggerClientEvent('polyzone:createcommand', src, args)
        end, {
            help = 'Starts creation of a zone for PolyZone',
            params = {
                { name = 'zoneType', help = 'Zone Type (circle, box, poly)' }
            }
        }, 1)

        Chat:RegisterAdminCommand('pzadd', function(src, args, raw)
            TriggerClientEvent('polyzone:pzadd', src)
        end, {
            help = 'Adds point to a zone'
        })

        Chat:RegisterAdminCommand('pzundo', function(src, args, raw)
            TriggerClientEvent('polyzone:pzundo', src)
        end, {
            help = 'Undoes the last point added.'
        })

        Chat:RegisterAdminCommand('pzfinish', function(src, args, raw)
            TriggerClientEvent('polyzone:pzfinish', src)
        end, {
            help = 'Finishes and prints zone.'
        })

        Chat:RegisterAdminCommand('pzlast', function(src, args, raw)
            TriggerClientEvent('polyzone:pzlast', src)
        end, {
            help = 'Starts creation of the last zone you finished (only works on BoxZone and CircleZone)'
        })

        Chat:RegisterAdminCommand('pzcancel', function(src, args, raw)
            TriggerClientEvent('polyzone:pzcancel', src)
        end, {
            help = 'Cancel zone creation.'
        })

        Chat:RegisterAdminCommand('pzcomboinfo', function(src, args, raw)
            TriggerClientEvent('polyzone:pzcomboinfo', src)
        end, {
            help = 'Prints some useful info for all created ComboZones.'
        })

        Chat:RegisterAdminCommand('pzdebug', function(src, args, raw)
            TriggerClientEvent('Polyzone:Client:ToggleDebug', src)
        end, {
            help = 'Toggle Polyzone Debug mode'
        })
    end)
end)

RegisterNetEvent("polyzone:printPoly")
AddEventHandler("polyzone:printPoly", function(zone)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end

    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parsePoly(zone)
    io.write(output)
    io.close(file)
end)

RegisterNetEvent("polyzone:printCircle")
AddEventHandler("polyzone:printCircle", function(zone)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end

    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parseCircle(zone)
    io.write(output)
    io.close(file)
end)

RegisterNetEvent("polyzone:printBox")
AddEventHandler("polyzone:printBox", function(zone)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end

    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parseBox(zone)
    io.write(output)
    io.close(file)
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function printoutHeader(name)
    return "--Name: " .. name .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n")
end

function parsePoly(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "PolyZone:Create({\n"
    for i=1, #zone.points do
        if i ~= #zone.points then
            printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) .."),\n"
        else
            printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) ..")\n"
        end
    end
    printout = printout .. "}, {\n  name=\"" .. zone.name .. "\",\n  --minZ = " .. zone.minZ .. ",\n  --maxZ = " .. zone.maxZ .. "\n})\n\n"
    return printout
end

function parseCircle(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "CircleZone:Create("
    printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
    printout = printout .. tostring(zone.radius) .. ", "
    printout = printout .. "{\n  name=\"" .. zone.name .. "\",\n  useZ=" .. tostring(zone.useZ) .. ",\n  --debugPoly=true\n})\n\n"
    return printout
end

function parseBox(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "BoxZone:Create("
    printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
    printout = printout .. tostring(zone.length) .. ", "
    printout = printout .. tostring(zone.width) .. ", "
    
    printout = printout .. "{\n  name = \"" .. zone.name .. "\",\n  heading = " .. zone.heading .. ",\n  --debugPoly=true"
    if zone.minZ then
        printout = printout .. ",\n  minZ = " .. tostring(round(zone.minZ, 2))
    end
    if zone.maxZ then
        printout = printout .. ",\n  maxZ = " .. tostring(round(zone.maxZ, 2))
    end
    printout = printout .. "\n})\n\n"
    return printout
end