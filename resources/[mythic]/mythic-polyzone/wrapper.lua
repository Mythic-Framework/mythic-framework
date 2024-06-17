local characterLoaded = false
local addedZones = {}
local wCombozone

local polyDebug = false

AddEventHandler("Polyzone:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Polyzone", {
		"Logger",
		"Callbacks",
		"Game",
		"Utils",
		"Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Callbacks:RegisterClientCallback("Polyzone:GetZoneAtCoords", function(data, cb)
			cb(Polyzone:GetZoneAtCoords(data))
		end)

		Callbacks:RegisterClientCallback("Polyzone:GetZonePlayerIn", function(data, cb)
			local c = GetEntityCoords(LocalPlayer.state.ped)
			cb(Polyzone:GetZoneAtCoords(vector3(c.x, c.y, c.z)))
		end)

        Callbacks:RegisterClientCallback("Polyzone:GetAllZonesAtCoords", function(data, cb)
			cb(Polyzone:GetAllZonesAtCoords(data))
		end)

		Callbacks:RegisterClientCallback("Polyzone:GetAllZonesPlayerIn", function(data, cb)
			local c = GetEntityCoords(LocalPlayer.state.ped)
			cb(Polyzone:GetAllZonesAtCoords(vector3(c.x, c.y, c.z)))
		end)

        Callbacks:RegisterClientCallback("Polyzone:IsCoordsInZone", function(data, cb)
			cb(Polyzone:IsCoordsInZone(data.coords, data.id, data.key, data.val))
		end)
	end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
    InitWrapperZones()
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
    for k, v in pairs(addedZones) do
        TriggerEvent('Polyzone:Exit', k, false, false, v.data or {})
    end
    polyDebug = false
    TriggerEvent('Targeting:Client:PolyzoneDebug', false)
    if wCombozone then
        wCombozone:destroy()
        wCombozone = nil
        Logger:Trace('Polyzone', 'Destroyed All Polyzones (Character Logout)')
    end

end)

function CreateZoneForCombo(id, data)
    local options = data.options
    options.name = id
    options.data = (type(data.data) == 'table' and data.data or {})
    options.data.id = id

    if data.type == 'circle' then
        return CircleZone:Create(data.center, data.radius, data.options)
    elseif data.type == 'poly' then
        return PolyZone:Create(data.points, data.options)
    elseif data.type == 'box' then
        return BoxZone:Create(data.center, data.length, data.width, data.options)
    end
end

function InitWrapperZones()
    if wCombozone then return end

    local createdZones = {}

    for k, v in pairs(addedZones) do
        local zone = CreateZoneForCombo(k, v)
        table.insert(createdZones, zone)
    end

    Logger:Trace('Polyzone', string.format('Initialized %s Simple Polyzones', #createdZones))

    wCombozone = ComboZone:Create(createdZones, {
        name = 'wrapper_combo',
    })

    wCombozone:onPlayerInOutExhaustive(function(isPointInside, testedPoint, insideZones, enteredZones, leftZones)
        if not characterLoaded then return end

        if enteredZones then
            for id, zone in ipairs(enteredZones) do
                if zone.data and zone.data.id then
                    TriggerEvent('Polyzone:Enter', zone.data.id, testedPoint, insideZones, zone.data)
                end
            end
        end

        if leftZones then
            for id, zone in ipairs(leftZones) do
                if zone.data and zone.data.id then
                    TriggerEvent('Polyzone:Exit', zone.data.id, testedPoint, insideZones, zone.data)
                end
            end
        end
    end)
end

function AddZoneAfterCreation(id, zoneData)
    if not wCombozone then return; end
    local zone = CreateZoneForCombo(id, zoneData)
    wCombozone:AddZone(zone)
end

_POLYZONE = {
    Create = {
        Box = function(self, id, center, length, width, options, data)
            local existingZone = addedZones[id]

            if existingZone and wCombozone then
                Polyzone:Remove(id)
                Wait(100)
            end

            addedZones[id] = {
                id = id,
                type = 'box',
                center = center,
                width = width,
                length = length,
                options = options,
                data = data,
            }

            AddZoneAfterCreation(id, addedZones[id])
        end,
        Poly = function(self, id, points, options, data)
            local existingZone = addedZones[id]

            if existingZone and wCombozone then
                Polyzone:Remove(id)
                Wait(100)
            end

            addedZones[id] = {
                id = id,
                type = 'poly',
                points = points,
                options = options,
                data = data,
            }

            AddZoneAfterCreation(id, addedZones[id])
        end,
        Circle = function(self, id, center, radius, options, data)
            local existingZone = addedZones[id]

            if existingZone and wCombozone then
                Polyzone:Remove(id)
                Wait(100)
            end

            addedZones[id] = {
                id = id,
                type = 'circle',
                center = center,
                radius = radius,
                options = options,
                data = data,
            }

            AddZoneAfterCreation(id, addedZones[id])
        end,
    },
    Remove = function(self, id)
        if addedZones[id] then
            if wCombozone then
                wCombozone:RemoveZone(id)
                TriggerEvent('Polyzone:Exit', id, false, false, addedZones[id].data or {})
            end
            addedZones[id] = nil
        end
        return false
    end,
    Get = function(self, id)
        return addedZones[id]
    end,
    -- !! WARNING WON'T WORK FOR OVERLAPPING ZONES SO BETTER OFF NOT USING IT !!
    GetZoneAtCoords = function(self, coords)
        if not wCombozone then return false end
        local isInside, insideZone = wCombozone:isPointInside(coords)
        if isInside and insideZone and insideZone.data then
            return insideZone.data
        end
        return false
    end,
    GetAllZonesAtCoords = function(self, coords)
        local withinZonesData = {}
        local isInside, insideZones = wCombozone:isPointInsideExhaustive(coords)
        if isInside and insideZones and #insideZones > 0 then
            for k, v in ipairs(insideZones) do
                table.insert(withinZonesData, v.data)
            end
        end
        return withinZonesData
    end,
    IsCoordsInZone = function(self, coords, id, key, val)
        local isInside, insideZones = wCombozone:isPointInsideExhaustive(coords)
        if isInside and insideZones and #insideZones > 0 then
            for k, v in ipairs(insideZones) do
                if (not id or v.data.id == id) and (not key or ((val == nil and v.data[key]) or (val ~= nil and v.data[key] == val))) then
                    return v.data
                end
            end
        end
        return false
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Polyzone', _POLYZONE)
end)


RegisterNetEvent('Polyzone:Client:ToggleDebug', function()
    polyDebug = not polyDebug

    TriggerEvent('Targeting:Client:PolyzoneDebug', polyDebug)
    if polyDebug and LocalPlayer.state.isAdmin then
        Logger:Warn('Polyzone', 'Polyzone Debug Enabled')
        CreateThread(function()
            while polyDebug do
                if wCombozone then
                    wCombozone:draw()
                else
                    Wait(500)
                end
                Wait(0)
            end
        end)
    end
end)