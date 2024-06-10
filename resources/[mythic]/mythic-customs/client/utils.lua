function CheckClassRestriction(class, restrictedClasses)
    if not restrictedClasses then
        return true
    end

    if type(restrictedClasses) == 'number' then
        restrictedClasses = { restrictedClasses }
    end
    
    for k, v in ipairs(restrictedClasses) do
        if class == v then
            return true
        end
    end

    return false
end

function CheckJobRestriction(restriction)
    if type(restriction) ~= "table" then
        return true
    end

    local onDuty = LocalPlayer.state.onDuty

    local allowedJobs = 0

    -- Check for blocked jobs
    for k, v in pairs(restriction) do
        if onDuty and k == onDuty and not v then
            return false
        end

        if v then
            allowedJobs = allowedJobs + 1
        end
    end

    if allowedJobs > 0 then
        for k, v in pairs(restriction) do
            if onDuty and onDuty == k then
                return true
            end
        end
    else
        return true
    end

    return false
end