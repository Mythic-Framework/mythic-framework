AddEventHandler("Reputation:Shared:DependencyUpdate", RepComponents)
function RepComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Reputation", {
		"Callbacks",
		"Logger",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RepComponents()
	end)
end)

local _reps = {}
_REP = {
	GetLevel = function(self, id)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			local reps = LocalPlayer.state.Character:GetData("Reputations") or {}
			if reps[id] ~= nil then
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
				return 0
			end
		else
			return 0
		end
	end,
	HasLevel = function(self, id, level)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			local reps = LocalPlayer.state.Character:GetData("Reputations") or {}
			if reps[id] ~= nil then
				local l = 0
				if reps[id] ~= nil then
					for k, v in ipairs(GlobalState[string.format("Rep:%s", id)].levels) do
						if v.value <= reps[id] then
							l = k
						end
					end
					return l >= level
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end,
	GetLevelData = function(self, id)
		if GlobalState[string.format("Rep:%s", id)] ~= nil then
			local reps = LocalPlayer.state.Character:GetData("Reputations") or {}
			if reps[id] ~= nil then
				local level = 0
				if reps[id] ~= nil then
					for k, v in ipairs(GlobalState[string.format("Rep:%s", id)].levels) do
						if v.value <= reps[id] then
							level = {
								level = k,
								label = v.label,
								value = v.value,
							}
						end
					end
					return level
				else
					return 0
				end
			else
				return 0
			end
		else
			return 0
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Reputation", _REP)
end)
