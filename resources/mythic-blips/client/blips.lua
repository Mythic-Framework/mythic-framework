blips = {}

AddEventHandler('Blips:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Blips = exports['mythic-base']:FetchComponent('Blips')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Blips', {
        'Logger',
        'Blips',
    }, function(error)
        if #error > 0 then
            return ;
        end
        RetrieveComponents()
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler("Characters:Client:Logout", function()
    Blips:RemoveAll()
end)

BLIPS = {
    Add = function(self, id, name, coords, sprite, colour, scale, display, category, flashes)
        if coords == nil then
            Logger:Error('Blips', "Coords needed for Blip")
            return
        end

        if type(coords) == 'table' and coords.x ~= nil then
            coords = vector3(coords.x, coords.y, coords.z)
        else
            coords = vector3(coords[1], coords[2], coords[3])
        end

        if blips[id] ~= nil then
            Blips:Remove(id)
        end

        local _blip = AddBlipForCoord(coords)
        SetBlipSprite(_blip, sprite or 1)
        SetBlipAsShortRange(_blip, true)
        SetBlipDisplay(_blip, display and display or 2)
        SetBlipScale(_blip, scale or 0.55)
        SetBlipColour(_blip, colour or 1)
        SetBlipFlashes(_blip, flashes)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(name or 'Name Missing')
        EndTextCommandSetBlipName(_blip)
        if category then 
            SetBlipCategory(_blip, category)
        end

        blips[id] = {
            blip = _blip,
            coords = coords
        }

        return _blip
    end,
    Remove = function(self, id)
        if blips[id] == nil then return end
        RemoveBlip(blips[id].blip)
        blips[id] = nil
    end,
    RemoveAll = function(self)
        for k, v in pairs(blips) do
            RemoveBlip(blips[k].blip)
            blips[k] = nil
        end
    end,
    SetMarker = function(self, id)
        local blip = blips[id]
        SetNewWaypoint(blip.coords.x, blip.coords.y)
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Blips', BLIPS)
end)

Citizen.CreateThread(function()
    AddTextEntry("BLIP_PROPCAT", "Garage")
    AddTextEntry("BLIP_APARTCAT", "Business")
    AddTextEntry("BLIP_OTHPLYR", "Units")
end)