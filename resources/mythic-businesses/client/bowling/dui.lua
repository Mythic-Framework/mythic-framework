function LoadScaleform(scaleform)
    local scaleformHandle = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleformHandle) do
        Citizen.Wait(100)
    end

    return scaleformHandle
end

local url = 'nui://mythic-businesses/dui/bowling/index.html'
local scale = 0.08

local insideAlley = false
local createdDUIs = {}

local tvCoords = {
    [1] = vector3(746.65, -782.806, 29.0),
    [2] = vector3(746.65, -776.706, 29.0),
    [3] = vector3(746.65, -772.406, 29.0),
}

function SetupBowlingTVs()
    for k, v in pairs(tvCoords) do
        createdDUIs[k] = createBowlingTVScaleform(k)

        PushScaleformMovieFunction(createdDUIs[k].sf, 'SET_TEXTURE')

        PushScaleformMovieMethodParameterString('texture_bowling_' .. k)
        PushScaleformMovieMethodParameterString('texture_bowling_other_' .. k)

        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(1280)
        PushScaleformMovieFunctionParameterInt(720)

        PopScaleformMovieFunctionVoid()
    end

    Citizen.CreateThread(function()
        while insideAlley do
            for k, v in pairs(tvCoords) do
                DrawScaleformMovie_3dSolid(
                    createdDUIs[k].sf,
                    v,
                    0, 270.0, 0,
                    2.0, 2.0, 2.0,
                    scale * 1, scale * (9 / 16), 1,
                    2
                )
            end
            Citizen.Wait(0)
        end
    end)
end

function DestroyBowlingTVs()
    for k, v in pairs(createdDUIs) do
        DestroyDui(v.dui)
        SetScaleformMovieAsNoLongerNeeded(v.sf)
    end
end

function createBowlingTVScaleform(id)
    local sfHandle = LoadScaleform('bowling_texture_renderer_'.. id)
    local txd = CreateRuntimeTxd('texture_bowling_' .. id)
    local duiObj = CreateDui(url, 1280, 720)
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'texture_bowling_other_'.. id, dui)

    return {
        sf = sfHandle,
        dui = duiObj,
    }
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        if insideAlley then
            insideAlley = false
            DestroyBowlingTVs()
        end
    end
end)

AddEventHandler('Polyzone:Enter', function(id, testedPoint, insideZones, data)
    if id == 'bowling_alley' then
        insideAlley = true
        SetupBowlingTVs()
        Citizen.Wait(2000)
        UpdateBowlingTVs(true)
    end
end)

AddEventHandler('Polyzone:Exit', function(id, testedPoint, insideZones, data)
    if id == 'bowling_alley' then
        if insideAlley then
            insideAlley = false
            DestroyBowlingTVs()
        end
    end
end)

function SendDUIMessage(dui, data)
    SendDuiMessage(dui, json.encode(data))
end

RegisterNetEvent('Bowling:Client:TVs:RequestUpdate', function(ignoreFlag)
    if insideAlley then
        Citizen.Wait(100)
        UpdateBowlingTVs(ignoreFlag)
    end
end)

RegisterNetEvent('Bowling:Client:TVs:Celebrate', function(alley, score)
    if insideAlley then
        if createdDUIs[alley] then
            SendDUIMessage(createdDUIs[alley].dui, {
                event = 'showScore',
                data = score,
            })
        end
    end
end)

function UpdateBowlingTVs(ignoreFlag)
    for k, v in pairs(_bowlingAlleys) do
        if createdDUIs[k] then
            local alleyData = GlobalState[string.format('Bowling:Alley:%s', k)]
            if alleyData and alleyData.active then
                createdDUIs[k].active = true

                SendDUIMessage(createdDUIs[k].dui, {
                    event = 'updateTable',
                    data = alleyData,
                })
            elseif createdDUIs[k].active or ignoreFlag then
                createdDUIs[k].active = false
                SendDUIMessage(createdDUIs[k].dui, {
                    event = 'showSplash',
                    data = GlobalState.BowlingTVsLink,
                })
            end
        end
    end
end

local linkPromise
function GetBowlingTVLink()
    linkPromise = promise.new()
    Input:Show('Bowling', 'URL', {
		{
			id = 'name',
			type = 'text',
			options = {
				inputProps = {},
			},
		},
	}, 'Bowling:Client:RecieveTVLinkInput', {})

    return Citizen.Await(linkPromise)
end

AddEventHandler('Bowling:Client:RecieveTVLinkInput', function(values)
    if linkPromise then
        linkPromise:resolve(values?.name)
        linkPromise = nil
    end
end)

AddEventHandler('Bowling:Client:SetTV', function()
    local tvLink = GetBowlingTVLink()
    Callbacks:ServerCallback('Bowling:UpdateTVLink', tvLink, function(success)
        if success then
            SendBowlingNotification('Updated Link!')
        else
            Notification:Error('Error', 5000, 'bowling-ball-pin')
        end
    end)
end)