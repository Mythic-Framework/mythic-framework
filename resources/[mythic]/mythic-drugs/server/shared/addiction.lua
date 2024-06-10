function RunDegenThread()
	for k, v in pairs(Fetch:All()) do
		local char = v:GetData("Character")
		if char ~= nil then
			local addictions = char:GetData("Addiction")
			if addictions ~= nil then
				for k2, v2 in pairs(addictions) do
					if v2.Factor > 0 and v2.LastUse < os.time() - (60 * 60 * 2) then
						v2.Factor = v2.Factor - 1.0

						if v2.Factor < 0 then
							v2.Factor = 0
						end

						DoAlert(v:GetData("Source"), k2, v2.Factor + 1.0, v2.Factor)
					end
				end
				char:SetData("Addiction", addictions)
			end
		end
	end
end

function DoAlert(source, drug, previous, factor)
	if factor > 10.0 and previous <= 10.0 then
		Execute:Client(source, "Notification", "Info", string.format("You're Incredibly Addicted To %s", drug))
	elseif factor > 5.0 and (previous <= 5.0 or previous > 10.0) then
		Execute:Client(source, "Notification", "Info", string.format("You're Very Addicted To %s", drug))
	elseif factor > 0.0 and (previous <= 0.0) then
		Execute:Client(source, "Notification", "Info", string.format("You're Somewhat Addicted To %s", drug))
	elseif factor <= 0.0 and (previous > 0.0) then
		Execute:Client(source, "Notification", "Info", string.format("You're No Longer Addicted To %s", drug))
	end
end

_DRUGS.Addiction = {
	Add = function(self, source, drug, factor)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local addictions = char:GetData("Addiction")
				addictions[drug] = {
					LastUse = os.time(),
					Factor = addictions[drug].Factor + (factor or 1.0),
				}
				DoAlert(plyr:GetData("Source"), drug, addictions[drug].Factor - (factor or 1.0), addictions[drug].Factor)
				char:SetData("Addiction", addictions)
			end
		end
	end,
	Remove = function(self, source, drug, factor)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local addictions = char:GetData("Addiction")
				addictions[drug] = {
					LastUse = os.time(),
					Factor = addictions[drug].Factor - (factor or 1.0),
				}

				if addictions[drug].Factor < 0 then
					addictions[drug].Factor = 0
				end

				DoAlert(v:GetData("Source"), drug, addictions[drug].Factor - (factor or 1.0), addictions[drug].Factor)
				char:SetData("Addiction", addictions)
			end
		end
	end,
	Reset = function(self, source, drug)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local addictions = char:GetData("Addiction")
				addictions[drug] = {
					LastUse = false,
					Factor = 0,
				}
				DoAlert(source, drug, addictions[drug].Factor)
				char:SetData("Addiction", addictions)
			end
		end
	end,
}
