COMPONENTS.ShapeTest = {
    _protected = true,
    _name = 'base',
}

COMPONENTS.ShapeTest = {
    Ray = {
        EntityHit = function(startCoords, endCoords)
            local rayHandle = StartShapeTestRay(startCoords.x, startCoords.y, startCoords.z, endCoords.x, endCoords.y, endCoords.z, -1, PlayerPedId(), 0)
            local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
            if hit then
                return entityHit
            else
                return false
            end
        end
    }
}

