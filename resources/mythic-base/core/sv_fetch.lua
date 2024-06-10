COMPONENTS.Fetch = {
	_required = { "Source", "PlayerData", "All" },
	_name = "base",
	Source = function(self, source)
		return COMPONENTS.Players[source]
	end,
	PlayerData = function(self, key, value)
		for k, v in pairs(COMPONENTS.Players) do
			if v:GetData(key) == value then
				return v
			end
		end

		return nil
	end,
	Website = function(self, type, id)
		if type == "account" then
			local data = COMPONENTS.WebAPI.GetMember:AccountID(id)
			if data ~= nil then
				return COMPONENTS.DataStore:CreateStore('Fetch', data.id, {
					ID = data.id,
					AccountID = data.id,
					Identifier = data.identifier,
					Name = data.name,
					Roles = data.roles,
				})
			end
		elseif type == "identifier" then
			local data = COMPONENTS.WebAPI.GetMember:Identifier(id)
			if data ~= nil then
				return COMPONENTS.DataStore:CreateStore('Fetch', data.id, {
					ID = data.id,
					AccountID = data.id,
					Identifier = data.identifier,
					Name = data.name,
					Roles = data.roles,
				})
			end
		end
		return nil
	end,
	All = function(self)
		return COMPONENTS.Players
	end,
	Count = function(self)
		local c = 0
		for k, v in pairs(COMPONENTS.Players) do
			if v ~= nil then
				c = c + 1
			end
		end
		return c
	end,
}
