function DoesCharacterPassChannelRestrictions(channelRestrictions)
    if type(channelRestrictions) ~= 'table' then
        return false
    end

    if LocalPlayer.state.Character then
        local stateId = LocalPlayer.state.Character:GetData('SID')

        for k, v in ipairs(channelRestrictions) do
            if v.type == 'character' and stateId == v.SID then
                return true
            elseif v.type == 'job' then
                if v.job then
                    if Jobs.Permissions:HasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.jobPermission) then
                        return true
                    end
                elseif v.jobPermission then
                    if Jobs.Permissions:HasPermission(v.jobPermission) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function CanRadioAccessChannel(radioType, channel)
    local radioData = _radioData[radioType]
    if radioData then
        if channel >= radioData.min and channel <= radioData.max then
            return true
        end
    end
    return false
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function LoadModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(10)
	end
end