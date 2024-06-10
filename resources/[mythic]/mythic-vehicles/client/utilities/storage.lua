function GetClosestParkingSpace(pedCoords, parkingSpaces) 
    table.sort(parkingSpaces, function(a, b) 
        local distA = #(a.xyz - pedCoords)
        local distB = #(b.xyz - pedCoords)
        return distA < distB
    end)

    local nearestCoords = parkingSpaces[1]

    if IsParkingSpaceCloseEnough(pedCoords, nearestCoords) and IsParkingSpaceFree(nearestCoords) then
        return nearestCoords
    else
        return false
    end
end

function GetClosestAvailableParkingSpace(pedCoords, parkingSpaces)
    table.sort(parkingSpaces, function(a, b) 
        local distA = #(a.xyz - pedCoords)
        local distB = #(b.xyz - pedCoords)
        return distA > distB
    end)

    local nearestCoords = false

    for k, v in ipairs(parkingSpaces) do
        if IsParkingSpaceFree(v) then
            nearestCoords = v
        end
    end

    return nearestCoords
end

function IsParkingSpaceCloseEnough(pedCoords, parkingSpaceCoords)
    local distance = #(pedCoords - parkingSpaceCoords.xyz)
    local heightDifference = math.abs(parkingSpaceCoords.z - parkingSpaceCoords.z)
    if distance <= 5.0 and heightDifference <= 1.0 then
        return true
    else
        return false
    end
end

function IsParkingSpaceFree(spaceCoords)
    return GetClosestVehicleWithinRadius(spaceCoords.xyz, 2.0) == false
end