function HospitalMiddleware()
	Middleware:Add("Characters:Logout", function(source)
		local player = Fetch:Source(source)
		if player ~= nil then
			local char = player:GetData("Character")
			if char ~= nil then
				if _inBedChar[char:GetData('ID')] ~= nil then
					_inBed[_inBedChar[char:GetData('ID')]] = nil
					_inBedChar[char:GetData('ID')] = nil
				end
			end
		end
	end, 1)
	Middleware:Add("playerDropped", function(source)
		local player = Fetch:Source(source)
		if player ~= nil then
			local char = player:GetData("Character")
			if char ~= nil then
				if _inBedChar[char:GetData('ID')] ~= nil then
					_inBed[_inBedChar[char:GetData('ID')]] = nil
					_inBedChar[char:GetData('ID')] = nil
				end
			end
		end
	end, 5)
end