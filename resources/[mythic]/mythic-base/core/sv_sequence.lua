local _cachedSeq = {}
local _loading = {}

COMPONENTS.Sequence = {
	Get = function(self, key)
		if _loading[key] then
			while _loading[key] do
				Wait(10)
			end
		end

		if _cachedSeq[key] ~= nil then
			_cachedSeq[key] = {
				value = _cachedSeq[key].value + 1,
				dirty = true
			}
			return _cachedSeq[key].value
		else
			local p = promise.new()

			_loading[key] = true
			COMPONENTS.Database.Game:findOne({
				collection = "sequence",
				query = {
					key = key,
				},
			}, function(success, results)
				if #results == 0 then
					COMPONENTS.Database.Game:insertOne({
						collection = "sequence",
						document = {
							key = key,
							current = 1,
						},
					})
					p:resolve({ value = 1, dirty = true })
				else
					p:resolve({ value = results[1].current + 1, dirty = true })
				end
			end)
	
			local v = Citizen.Await(p)
			_cachedSeq[key] = v
			_loading[key] = false
			return v.value
		end
	end,
	Save = function(self)
		for k, v in pairs(_cachedSeq) do
			if v.dirty then
				local p = promise.new()
				COMPONENTS.Database.Game:updateOne({
					collection = "sequence",
					query = {
						key = k,
					},
					update = {
						["$set"] = {
							current = v.value,
						},
					},
					options = {
						upsert = true
					}
				}, function(success, result)
					if success then
						COMPONENTS.Logger:Trace("Sequence", string.format("Saved Sequence: ^2%s^7", k))
					end

					v.dirty = false
					p:resolve(true)
				end)
				Citizen.Await(p)
			end
		end
	end,
}

AddEventHandler("Core:Shared:Ready", function()
	COMPONENTS.Tasks:Register("sequence_save", 1, function()
		COMPONENTS.Sequence:Save()
	end)
end)

AddEventHandler("Core:Server:ForceSave", function()
	COMPONENTS.Sequence:Save()
end)
