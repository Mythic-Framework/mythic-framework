local interactionComboZone = nil

TARGETING.Zones = {
    AddBox = function(self, zoneId, icon, center, length, width, options, menuArray, proximity, enabled)
        if InteractionZones[zoneId] and interactionComboZone then
            interactionComboZone:RemoveZone(zoneId)
            Wait(100)
        end

        if enabled == nil then enabled = true end -- Make enabled if not specified
        if type(menuArray) ~= 'table' then menuArray = {} end

        InteractionZones[zoneId] = {
            type = 'zone',
            enabled = enabled,
            name = zoneId,
            icon = icon,
            menu = menuArray,
            zone = {
                type = 'box',
                center = center,
                length = length,
                width = width,
                options = options or {},
            },
            proximity = (type(proximity) == 'number' and proximity or 10.0),
        }
    end,
    AddCircle = function(self, zoneId, icon, center, radius, options, menuArray, proximity, enabled)
        if InteractionZones[zoneId] and interactionComboZone then
            interactionComboZone:RemoveZone(zoneId)
            Wait(100)
        end

        if enabled == nil then enabled = true end -- Make enabled if not specified
        if type(menuArray) ~= 'table' then menuArray = {} end

        InteractionZones[zoneId] = {
            type = 'zone',
            enabled = enabled,
            name = zoneId,
            icon = icon,
            menu = menuArray,
            zone = {
                type = 'circle',
                center = center,
                radius = radius,
                options = options or {},
            },
            proximity = (type(proximity) == 'number' and proximity or 10.0),
        }
    end,
    AddPoly = function(self, zoneId, icon, points, options, menuArray, proximity, enabled)
        if InteractionZones[zoneId] and interactionComboZone then
            interactionComboZone:RemoveZone(zoneId)
            Wait(100)
        end

        if enabled == nil then enabled = true end -- Make enabled if not specified
        if type(menuArray) ~= 'table' then menuArray = {} end

        InteractionZones[zoneId] = {
            type = 'zone',
            enabled = enabled,
            name = zoneId,
            icon = icon,
            menu = menuArray,
            zone = {
                type = 'poly',
                points = points,
                options = options or {},
            },
            proximity = (type(proximity) == 'number' and proximity or 10.0),
        }
    end,
    IsEnabled = function(self, zoneId)
        if InteractionZones[zoneId] then
            return InteractionZones[zoneId].toggle
        end
        return false
    end,
    Toggle = function(self, zoneId, toggle)
        if InteractionZones[zoneId] then
            InteractionZones[zoneId].toggle = toggle
        end
    end,
    IsCoordInZone = function(self, zoneId, coords)
        if interactionComboZone and InteractionZones[zoneId] then
            local isInside, insideZone = interactionComboZone:isPointInside(coords)
            if isInside and insideZone then
                return insideZone.name
            end
        end
        return false
    end,
    RemoveZone = function(self, zoneId)
        if interactionComboZone and InteractionZones[zoneId] then
            InteractionZones[zoneId] = nil
            interactionComboZone:RemoveZone(zoneId)
        else
            InteractionZones[zoneId] = nil
        end
    end,
    Refresh = function(self)
        DeInitPolyzoneTargets()
        InitPolyzoneTargets()
    end,
}

function InitPolyzoneTargets()
    if not interactionComboZone then
        local createdZones = {}

        for k, v in pairs(InteractionZones) do
            v.zone.options.name = k
            if v.zone.type == 'box' then
                table.insert(createdZones, BoxZone:Create(v.zone.center, v.zone.length, v.zone.width, v.zone.options))
            elseif v.zone.type == 'poly' then
                table.insert(createdZones, PolyZone:Create(v.zone.points, v.zone.options))
            elseif v.zone.type == 'circle' then
                table.insert(createdZones, CircleZone:Create(v.zone.center, v.zone.radius, v.zone.options))
            end
        end

        interactionComboZone = ComboZone:Create(createdZones, {
            name = 'targeting_zones',
        })
    end
end

function DeInitPolyzoneTargets()
    if interactionComboZone then
        interactionComboZone:destroy()
        interactionComboZone = nil
    end
end

function GetPZoneAtCoords(endCoords)
    if not interactionComboZone then
        return false
    end

    local isInside, insideZone = interactionComboZone:isPointInside(endCoords)
    if isInside and insideZone then
        local zoneData = InteractionZones[insideZone.name]
        if zoneData and zoneData.enabled and (#(GetEntityCoords(LocalPlayer.state.ped) - endCoords) <= zoneData.proximity) then
            return zoneData
        end
    end
    return false
end

local polyDebug = false

AddEventHandler('Targeting:Client:PolyzoneDebug', function(state)
    if state == polyDebug then
        return
    end

    polyDebug = state
    if polyDebug then
        CreateThread(function()
            while polyDebug do
                if interactionComboZone then
                    interactionComboZone:draw()
                else
                    Wait(500)
                end
                Wait(0)
            end
        end)
    end
end)
