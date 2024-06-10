FETCH = {
	CharacterData = function(self, key, value)
		for _, v in ipairs(GetPlayers()) do
			local plyr = Fetch:Source(tonumber(v))
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local data = char:GetData(key)
					if data ~= nil and data == value then
						return plyr
					end
				end
			end
		end
		return nil
	end,
	ID = function(self, value)
		return self:CharacterData("ID", value)
	end,
	SID = function(self, value)
		return self:CharacterData("SID", value)
	end,
	Next = function(self, prev)
		local retNext = false
		for k, v in pairs(Fetch:All()) do
			if prev == 0 or retNext then
				return v
			elseif prev == v:GetData("Source") then
				retNext = true
			end
		end

		return nil
	end,
	CountCharacters = function(self)
		local c = 0
		for k, v in pairs(Fetch:All()) do
			if v:GetData("Character") ~= nil then
				c = c + 1
			end
		end
		return c
	end,
	GetOfflineData = function(self, stateId, key)
		local p = promise.new()
		Database.Game:findOne({
			collection = "characters",
			query = {
				SID = stateId,
			},
			options = {
				projection = {
					[key] = true,
				},
			},
		}, function(success, results)
			if not success then
				return p:resolve(nil)
			end
			return p:resolve(results[1][key])
		end)
		return Citizen.Await(p)
	end,
}

AddEventHandler("Proxy:Shared:ExtendReady", function(component)
	if component == "Fetch" then
		exports["mythic-base"]:ExtendComponent(component, FETCH)
	end
end)
