function RunLaborLogoutShit(source)
    for k, v in pairs(_Jobs) do
        for k2, v2 in ipairs(v.OnDuty) do
            if v2.Joiner == source then
                if v2.Group then
                    for k3, v3 in pairs(_Groups) do
                        for k4, v4 in ipairs(v3.Members) do
                            if v3.Creator.ID == source then
                                return Labor.Workgroups:Disband(source, true)
                            end
                        end
                    end
                else
                    Labor.Duty:Off(k, source)
                end
            end
        end
    end

    for k, v in pairs(_Groups) do
        if v.Creator.ID == source then
            return Labor.Workgroups:Disband(source, true)
        else
            for k2, v2 in ipairs(v.Members) do
                if v2.ID == source then
                    return Labor.Workgroups:Leave(v, source)
                end
            end
        end
    end

    _pendingInvites[source] = nil

    for k, v in pairs(_pendingInvites) do
        if v == source then
            Phone.Notification:Add(
                v.Creator.ID,
                "Labor Activity",
                "Requested Group Is No Longer Available",
                os.time() * 1000,
                6000,
                "labor",
                {}
            )
            _pendingInvites[k] = nil
        end
    end
end


function RegisterMiddleware()
	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			RunLaborLogoutShit(source)

            char:SetData("TempJob", nil)
		end
	end, 2)

	Middleware:Add("playerDropped", function(source)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                RunLaborLogoutShit(source)

                char:SetData("TempJob", nil)
            end
        end
	end, 2)
end
