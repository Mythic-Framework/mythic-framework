COMPONENTS.Game = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.Game = {
    Objects = {
        Spawn = function(self, coords, modelName, heading)
            local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
            local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
            SetEntityHeading(obj, heading)
            return obj
        end,
        Delete = function(self, obj)
            DeleteObject(obj)
        end
    }
}