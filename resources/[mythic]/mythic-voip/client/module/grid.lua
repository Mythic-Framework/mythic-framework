local zoneRadius = GetConvarInt('voice_zoneRadius', 256)
local _routeBucket = 0
local _customChannelOverride = false

function GetGridMaxSize(radius)
    return math.floor(math.max(4500.0 + 8192.0, 0.0) / radius + math.max(8022.0 + 8192.0, 0.0) / radius)
end

function GetPlayerGridZone()
	local plyPos = GetEntityCoords(GLOBAL_PED, false)
	local sectorX = math.max(plyPos.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(plyPos.y + 8192.0, 0.0) / zoneRadius
	return math.ceil(sectorX + sectorY)
end

function StartVOIPGridThreads()
    CreateThread(function()
        while _characterLoaded do
            if not _customChannelOverride then
                local newGrid = GetPlayerGridZone()
                -- TODO: Add Property Support
                if newGrid ~= CURRENT_GRID then
                    --Logger:Trace('VOIP', ('Changing Grid Zone To %s From %s'):format(newGrid, CURRENT_GRID))
                    CURRENT_GRID = newGrid
                    
                    MumbleClearVoiceTargetChannels(1)
                    MumbleAddVoiceTargetChannel(CURRENT_GRID)
                    -- add nearby grids to voice targets
                    for nearbyGrids = CURRENT_GRID - 3, CURRENT_GRID + 3 do
                        MumbleAddVoiceTargetChannel(1, nearbyGrids)
                    end
                end
            else
                if CURRENT_GRID ~= _customChannelOverride then
                    Logger:Trace('VOIP', 'Channel Override Set to ' .. _customChannelOverride)
                    CURRENT_GRID = _customChannelOverride
                    MumbleClearVoiceTargetChannels(1)
                    MumbleAddVoiceTargetChannel(CURRENT_GRID)
                end
            end
            Wait(100)
        end
    end)
end

function GetCurrentVOIPGrid()
    return CURRENT_GRID
end

RegisterNetEvent('Routing:Client:NewRoute', function(route)
    _routeBucket = route

    if _routeBucket > 1 then
        _customChannelOverride = (1024 + _routeBucket)
    else
        _customChannelOverride = false
    end
end)