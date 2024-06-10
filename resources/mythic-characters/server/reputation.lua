AddEventHandler("Reputation:Shared:DependencyUpdate", RepComponents)
function RepComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Database = exports["mythic-base"]:FetchComponent("Database")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Reputation", {
		"Fetch",
		"Callbacks",
		"Database",
		"Middleware",
		"Logger",
		"Database",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RepComponents()
	end)
end)

_REP = {
	Create = function(self, id, label, levels, hidden)
		GlobalState[string.format("Rep:%s", id)] = {
			id = id,
			label = label,
			levels = levels,
			hidden = hidden,
		}
	end,
	GetLevel = function(self, source, id)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			local char = Fetch:Source(source):GetData("Character")
			if char ~= nil then
				local reps = char:GetData("Reputations") or {}
                local level = 0
				if reps[id] ~= nil then
                    for k, v in ipairs(GlobalState[string.format("Rep:%s", id)].levels) do
                        if v.value <= reps[id] then
                            level = k
                        end
                    end
                    return level
				else
					return 0
				end
			else
				return nil
			end
		else
			return nil
		end
	end,
	View = function(self, source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local reps = char:GetData("Reputations") or {}
			local viewingData = {}

			for id, val in pairs(reps) do
				local repData = GlobalState[string.format("Rep:%s", id)]
				if id and val and repData and not repData.hidden then
					local repCurrent = {
						level = 0,
						value = 0
					}

					for k, v in ipairs(repData.levels) do
                        if v.value <= val then
							repCurrent = {
								level = k,
								label = v.label,
								value = v.value,
							}
                        end
                    end

					local repNext = {
						level = repCurrent.level += 1
					}

					local nextRepLevel = repCurrent.level += 1
					local nextRepLevelLabel = nil
					if repData.levels[nextRepLevel] then
						repNext.value = repData.levels[nextRepLevel].value
						repNext.label = repData.levels[nextRepLevel].label
					else
						repNext = {
							level = repCurrent.level,
							value = repCurrent.value,
							label = 'Done!',
						}
					end

					table.insert(viewingData, {
						id = repData.id,
						label = repData.label,
						value = val,
						current = repCurrent,
						next = repNext,
					})
				end
			end

			return viewingData
		else
			return nil
		end
	end,
	ViewList = function(self, source, list)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local reps = char:GetData("Reputations") or {}
			local viewingData = {}

			for id, val in pairs(reps) do
				local repData = GlobalState[string.format("Rep:%s", id)]
				if id and val and repData and list[id] then
					local repCurrent = {
						level = 0,
						value = 0
					}

					for k, v in ipairs(repData.levels) do
                        if v.value <= val then
							repCurrent = {
								level = k,
								label = v.label,
								value = v.value,
							}
                        end
                    end

					local repNext = {
						level = repCurrent.level += 1
					}

					local nextRepLevel = repCurrent.level += 1
					local nextRepLevelLabel = nil
					if repData.levels[nextRepLevel] then
						repNext.value = repData.levels[nextRepLevel].value
						repNext.label = repData.levels[nextRepLevel].label
					else
						repNext = {
							level = repCurrent.level,
							value = repCurrent.value,
							label = 'Done!',
						}
					end

					table.insert(viewingData, {
						id = repData.id,
						label = repData.label,
						value = val,
						current = repCurrent,
						next = repNext,
					})
				end
			end

			return viewingData
		else
			return nil
		end
	end,
	Modify = {
		Add = function(self, source, id, amount)
			if GlobalState[string.format("Rep:%s", id)] ~= nil then
                local rep = GlobalState[string.format("Rep:%s", id)]
				local char = Fetch:Source(source):GetData("Character")
				if char ~= nil then
					local reps = char:GetData("Reputations") or {}
					if reps[id] ~= nil then
						if reps[id] + math.abs(amount) <= rep.levels[#rep.levels].value then
							reps[id] = reps[id] + math.abs(amount)
						else
							reps[id] = rep.levels[#rep.levels].value
						end
					else
						if math.abs(amount) <= rep.levels[#rep.levels].value then
							reps[id] = math.abs(amount)
						else
							reps[id] = rep.levels[#rep.levels].value
						end
					end
					char:SetData("Reputations", reps)
				end
			end
		end,
		Remove = function(self, source, id, amount)
			if GlobalState[string.format("Rep:%s", id)] ~= nil then
                local rep = GlobalState[string.format("Rep:%s", id)]

				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						local reps = char:GetData("Reputations") or {}
						if reps[id] ~= nil and (reps[id] - math.abs(amount) > 0) then
							reps[id] = reps[id] - math.abs(amount)
						else
							reps[id] = 0
						end
						char:SetData("Reputations", reps)
					end
				end
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Reputation", _REP)
end)
