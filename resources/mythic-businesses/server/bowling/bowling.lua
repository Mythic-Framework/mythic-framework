local _setupLanes = false
local _alleys = {}
local _defaultAlleyData = {
    active = false,
    currentPlayer = false,
    players = {},
    started = false,
    finished = false,
}

function SetupBowlingLanes()
    if _setupLanes then return; end
    _setupLanes = true

    for k, v in pairs(_bowlingAlleys) do
        local defaultAlley = deepcopy(_defaultAlleyData)
        defaultAlley.id = k
        GlobalState[string.format('Bowling:Alley:%s', k)] = defaultAlley
        table.insert(_alleys, k)
    end
end

AddEventHandler('Businesses:Server:Startup', function()
    SetupBowlingLanes()

    Callbacks:RegisterServerCallback('Bowling:StartGame', function(source, data, cb)
        if data?.alleyId and data?.nickName then
            local alley = GlobalState[string.format('Bowling:Alley:%s', data.alleyId)]

            if alley and not alley.active then
                alley.active = true
                local firstPlayer = CreateBowlingPlayer(source, data.nickName)
                alley.currentPlayer = firstPlayer.SID
                table.insert(alley.players, firstPlayer)
                GlobalState[string.format('Bowling:Alley:%s', data.alleyId)] = alley
                cb(true)

                TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Bowling:JoinGame', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        if char and data?.alleyId and data.nickName then
            local alley = GlobalState[string.format('Bowling:Alley:%s', data.alleyId)]

            if alley and alley.active and not alley.started and not IsPlayerInBowlingAlley(alley.players, char:GetData('SID')) and #alley.players < 5 then
                table.insert(alley.players, CreateBowlingPlayer(source, data.nickName))
                GlobalState[string.format('Bowling:Alley:%s', data.alleyId)] = alley
                cb(true)

                TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Bowling:EndGame', function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
        if char and data?.alleyId then
            local alley = GlobalState[string.format('Bowling:Alley:%s', data.alleyId)]

            if alley and (alley.finished and IsPlayerInBowlingAlley(alley.players, char:GetData('SID'))) or Player(source).state.onDuty == 'bowling' then
                alley.active = false
                alley.players = {}
                alley.currentPlayer = false
                alley.started = false
                alley.finished = false
                GlobalState[string.format('Bowling:Alley:%s', data.alleyId)] = alley

                cb(true)

                TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Bowling:UpdateTVLink', function(source, data, cb)
        if Player(source).state.onDuty == 'bowling' then
            GlobalState.BowlingTVsLink = data
            TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1, true)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Bowling:ResetAll', function(source, data, cb)
        if Player(source).state.onDuty == 'bowling' then
            for k, v in ipairs(_alleys) do
                local thisAlley = GlobalState[string.format('Bowling:Alley:%s', v)]
                if thisAlley then
                    thisAlley.active = false
                    thisAlley.players = {}
                    thisAlley.currentPlayer = false
                    thisAlley.started = false
                    thisAlley.finished = false

                    GlobalState[string.format('Bowling:Alley:%s', v)] = thisAlley
                end
            end

            for k, v in ipairs(GetAllObjects()) do
                local model = GetEntityModel(v)
                if model == -1501785249 or model == -563331074 and #(GetEntityCoords(v) - vector3(738.970, -775.074, 26.446)) <= 100.0 then
                    DeleteEntity(v)
                end
            end

            TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1, true)
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Bowling:ClearPins', function(source, data, cb)
        if Player(source).state.onDuty == 'bowling' then
            for k, v in ipairs(GetAllObjects()) do
                local model = GetEntityModel(v)
                if model == -1501785249 or model == -563331074 and #(GetEntityCoords(v) - vector3(738.970, -775.074, 26.446)) <= 100.0 then
                    DeleteEntity(v)
                end
            end

            cb(true)
        else
            cb(false)
        end
    end)
end)

function CreateBowlingPlayer(source, nickName)
    local char = Fetch:Source(source):GetData('Character')
    if char then
        return {
            SID = char:GetData('SID'),
            name = nickName,
            scores = {},
            total = 0,
        }
    end
end

RegisterServerEvent('Bowling:Server:StartBowling', function(alleyId)
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    if char and alleyId then
        local alley = GlobalState[string.format('Bowling:Alley:%s', alleyId)]
        local mySID = char:GetData('SID')

        if alley and alley.active and mySID == alley.currentPlayer then
            Callbacks:ClientCallback(source, 'Bowling:DoBowl', alleyId, function(res)
                if res?.first and res?.total then
                    if res.total == 10 then
                        if res.first == 10 then
                            TriggerClientEvent('Bowling:Client:TVs:Celebrate', -1, alleyId, 'strike')
                        else
                            TriggerClientEvent('Bowling:Client:TVs:Celebrate', -1, alleyId, 'spare')
                        end
                    else
                        TriggerClientEvent('Bowling:Client:TVs:Celebrate', -1, alleyId, res.total)
                    end

                    local currentIndex
                    for k, v in ipairs(alley.players) do
                        if v.SID == mySID then
                            v.total += res.total
                            res.total = v.total
                            currentIndex = k

                            table.insert(v.scores, res)
                        end
                    end

                    if currentIndex then
                        local nextIndex = currentIndex += 1
                        if nextIndex > #alley.players then
                            nextIndex = 1
                        end

                        local nextPlayer = alley.players[nextIndex]
                        if nextPlayer then
                            if #nextPlayer.scores >= 5 then
                                alley.finished = true
                                alley.currentPlayer = false
                            else
                                alley.currentPlayer = nextPlayer.SID
                            end
                        end
                    end

                    GlobalState[string.format('Bowling:Alley:%s', alleyId)] = alley
                    TriggerClientEvent('Bowling:Client:TVs:RequestUpdate', -1)
                end
            end)
        end
    end
end)