local containers = {
    [666561306] = true,
    [218085040] = true,
    [-58485588] = true,
    [682791951] = true,
    [-206690185] = true,
    [364445978] = true,
    [143369] = true,
    [1511880420] = true,
}
--[[

local containerList = {}
containerId = nil

DecorRegister('TrashContainer-Inventory', 3)

function ScanContainer()
    local player = PlayerPedId()
    local startPos = GetOffsetFromEntityInWorldCoords(player, 0, 0.1, 0)
    local endPos = GetOffsetFromEntityInWorldCoords(player, 0, 3.0, 0.4)

    local rayHandle = StartShapeTestRay(startPos, endPos, 16, 0, 0)
    local a, b, c, d, result = GetShapeTestResult(rayHandle)

    if hitData ~= 2 then
        if containers[GetEntityModel(result)] ~= nil then
            if DecorExistOn(result, 'TrashContainer-Inventory') then
                containerId = true
            else
                randomIdent = math.random(1000000,9999999)
                DecorSetInt(result, 'TrashContainer-Inventory', randomIdent)
                containerId = true
            end
            return containerId, result
        end
    end
end]]
