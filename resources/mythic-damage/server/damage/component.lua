_dead = {}

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

AddEventHandler("Damage:Shared:DependencyUpdate", DamageComponents)
function DamageComponents()
	Database = exports["mythic-base"]:FetchComponent("Database")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Damage", {
		"Database",
		"Callbacks",
		"Logger",
		"Chat",
		"Middleware",
		"Fetch",
		"Damage",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		DamageComponents()
		DamageCallbacks()
		DamageMiddleware()
	end)
end)

DAMAGE = {
	Heal = function(self, char, isFullHeal)
		local dfdg = table.copy(_defDmg)

		local pState = Player(char:GetData("Source")).state

		if pState.deadData?.isMinor or not isFullHeal then
			local dmg = char:GetData("Damage")
			for k, v in pairs(dfdg) do
				v.damageTypes = table.copy(dmg.Limbs[k]?.damageTypes or {})
			end
		end

		char:SetData("Damage", {
			Bleed = 0,
			Limbs = dfdg,
		})

		if not pState.deadData?.isMinor and isFullHeal then
			print(200)
			char:SetData("HP", 200)
		else
			print(125)
			char:SetData("HP", 125)
		end

		return true
	end,
	CanRespawn = function(self, char)
		local sb = Player(char:GetData("Source")).state

		local isDead = sb.isDead
		local isDeadTime = sb?.isDeadTime
		return isDead and (isDeadTime == nil or isDeadTime ~= nil and (os.time() - isDeadTime) >= Config.RespawnTimer)
	end,
	Died = function(self, char, data)
		--Player(char:GetData("Source")).state.isDead = true
	end,
	Effects = {
		Painkiller = function(self, source, tier)
			Callbacks:ClientCallback(source, "Damage:ApplyPainkiller", 225 * (tier or 1))
		end,
		Adrenaline = function(self, source, tier)
			Callbacks:ClientCallback(source, "Damage:ApplyAdrenaline", 75 * (tier or 1))
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Damage", DAMAGE)
end)
