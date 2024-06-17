_activePlants, _nearbyPlants, _spawnedPlants = {}, {}, {}

RegisterNetEvent('Weed:Client:Objects:Init', function(plants)
    if plants and type(plants) == 'table' then
        for k,v in pairs(plants) do
            _activePlants[k] = v
        end

        _spawnedPlants = {}
        _nearbyPlants = {}

        while not LocalPlayer.state.loggedIn do
            Wait(100)
        end

        CreateThread(function()
            while LocalPlayer.state.loggedIn do
                Wait(3000)

                if _activePlants then
                    local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
                    for k,v in pairs(_activePlants) do
                        if #(pedCoords - vector3(v.plant.location.x, v.plant.location.y, v.plant.location.z)) <= 500.0 then
                            if not _nearbyPlants[k] then
                                _nearbyPlants[k] = true
                            end
                        elseif _nearbyPlants[k] then
                            _nearbyPlants[k] = nil

                            if _spawnedPlants[k] and DoesEntityExist(_spawnedPlants[k]) then
                                DeleteEntity(_spawnedPlants[k])
                                _spawnedPlants[k] = nil
                                Wait(5)
                            end
                        end
                    end
                end
            end
        end)

        CreateThread(function()
            while LocalPlayer.state.loggedIn do
                Wait(350)
                if _activePlants and _nearbyPlants then
                    local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
                    for k,v in pairs(_nearbyPlants) do
                        local weed = _activePlants[k]
                        if #(pedCoords - vector3(weed.plant.location.x, weed.plant.location.y, weed.plant.location.z)) <= 50.0 then
                            if not _spawnedPlants[k] then
                                _spawnedPlants[k] = CreateWeedPlant(k, weed)
                                Wait(5)
                            end
                        elseif _spawnedPlants[k] and DoesEntityExist(_spawnedPlants[k]) then
                            DeleteEntity(_spawnedPlants[k])
                            _spawnedPlants[k] = nil
                            Wait(5)
                        end
                    end
                else
                    Wait(1500)
                end
            end
        end)
    else
        Logger:Error('Weed', 'Failed to Load Weed Objects')
    end
end)

RegisterNetEvent('Weed:Client:Objects:Update', function(plantId, data, isUpdate)
    _activePlants[plantId] = data

    if isUpdate and _spawnedPlants[plantId] then
        DeleteEntity(_spawnedPlants[plantId])
        _spawnedPlants[plantId] = nil
    end
end)

RegisterNetEvent('Weed:Client:Objects:Delete', function(plantId)
    _activePlants[plantId] = nil

    if _spawnedPlants[plantId] then
        DeleteEntity(_spawnedPlants[plantId])
        _spawnedPlants[plantId] = nil
    end

    if _nearbyPlants[plantId] then
        _nearbyPlants[plantId] = nil
    end
end)

function CreateWeedPlant(id, data)
    local stage = getStageByPct(data.plant.growth)

    local obj = CreateObject(Plants[stage].model, data.plant.location.x + 0.0, data.plant.location.y + 0.0, data.plant.location.z + Plants[stage].offset, false, true)
    FreezeEntityPosition(obj, true)
    SetEntityCoords(obj, data.plant.location.x + 0.0, data.plant.location.y + 0.0, data.plant.location.z + Plants[stage].offset)

    return obj
end

function GetWeedPlant(entity)
    for k, v in pairs(_spawnedPlants) do
        if v == entity then
            return k
        end
    end
end

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    if _spawnedPlants then
        for k, v in pairs(_spawnedPlants) do
            DeleteEntity(v)
        end
    end

    _activePlants = nil
    _spawnedPlants = nil
    _nearbyPlants = nil

    collectgarbage()

    _activePlants = {}
    _spawnedPlants = {}
    _nearbyPlants = {}
end)