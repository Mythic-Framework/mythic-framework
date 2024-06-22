function LoadDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function LoadRequestModel(object)
    local model = GetHashKey(object)
    while not HasModelLoaded(model) do
        Wait(50)
        RequestModel(model)
    end
end

function LoadAndCreateObject(object, coords)
    local model = GetHashKey(object)
    LoadRequestModel(object)

    local obj = CreateObject(model, coords, 1, 1, 0)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(obj, true, true)

    return obj
end