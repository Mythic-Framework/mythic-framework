function GetEntityMPH(entity)
    return math.ceil(GetEntitySpeed(entity) * 2.237)
end

function GetAngleOffsets(direction, lane)
    if lane then
        return Config.RadarAngleOffsets[direction].Same
    else
        return Config.RadarAngleOffsets[direction].Opposite
    end
end

function CastRadarRay(fromCoord, toCoord, fromVehicle)
    local ray = StartShapeTestCapsule(fromCoord, toCoord, Config.RadarRayRadius, 10, fromVehicle, 7)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    if hit and DoesEntityExist(entity) and IsEntityAVehicle(entity) then
        return entity
    else
        return false
    end
end

function GetOppositeAngle(angle)
    return (angle + 180) % 360
end

function GetEntityRelativeDirection(myAng, tarAng, range)
    local rangeStartFront = myAng - (range / 2)
    local rangeEndFront = myAng + (range / 2)

    local opp = GetOppositeAngle(myAng)

    local rangeStartBack = opp - (range / 2)
    local rangeEndBack = opp + (range / 2)

    if ((tarAng > rangeStartFront) and (tarAng < rangeEndFront)) then 
        return 'up' -- Away from
    elseif ((tarAng > rangeStartBack) and (tarAng < rangeEndBack)) then 
        return 'down' -- Towards
    end
    return false
end

function GetLocationData(data)
    local main, cross = GetStreetNameAtCoord(
        data.x,
        data.y,
        data.z,
        Citizen.ResultAsInteger(),
        Citizen.ResultAsInteger()
    )

    main = GetStreetNameFromHashKey(main)
    cross = GetStreetNameFromHashKey(cross)
    return {
        street1 = main,
        street2 = intersect,
        area = GetLabelText(GetNameOfZone(data.x, data.y, data.z)),
        x = data.x,
        y = data.y,
        z = data.z,
    }
end