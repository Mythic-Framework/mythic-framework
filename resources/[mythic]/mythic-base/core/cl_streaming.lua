COMPONENTS.Stream = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Stream = {
    RequestModel = function(modelName)
        local modelHash = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
            local timeout = 0
            while not HasModelLoaded(modelHash) do
                if timeout > 20000 then
                    COMPONENTS.Logger:Error("Stream", string.format('failed to load model, please report this: %s', modelName))
                end
                Wait(1)
                timeout += 1
            end
        end
    end,
    RequestAnimDict = function(dictName)
        RequestAnimDict(dictName)
        while not HasAnimDictLoaded(dictName) do
            Wait(100)
        end
    end,
    RequestAnimSet = function(setName)
        RequestAnimSet(setName)
        while not HasAnimSetLoaded(setName) do
            Wait(100)
        end
    end
}