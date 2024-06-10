function DamageCallbacks()
	Callbacks:RegisterServerCallback("Damage:CheckDead", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(Player(source).state.isDead)
	end)

	Callbacks:RegisterServerCallback("Damage:Revive", function(source, isFullHeal, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			Damage:Heal(char, isFullHeal)
			cb(Player(source).state.isDead)
		end

	end)

	Callbacks:RegisterServerCallback("Damage:ApplyBleed", function(source, level, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local damage = char:GetData("Damage")
			if damage.Bleed ~= 4 then
				if damage.Bleed + level > 4 then
					damage.Bleed = 4
				else
					damage.Bleed = damage.Bleed + level
				end

				char:SetData("Damage", damage)
				cb(damage.Bleed)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Damage:ApplyDamage", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local damage = char:GetData("Damage")
			
			local bone = Config.Bones[data.bone]
			local wepClass = Config.DamageTypes[data.wepClass]

			if bone ~= nil and wepClass ~= nil then
				damage.Limbs[bone].damageTypes = damage.Limbs[bone].damageTypes or {}
				damage.Limbs[bone].damageTypes[wepClass] = damage.Limbs[bone].damageTypes[wepClass] or 0
				damage.Limbs[bone].damageTypes[wepClass] = damage.Limbs[bone].damageTypes[wepClass] + 1
			end
			
			if not damage.Limbs[bone].isDamaged then
				damage.Limbs[bone].isDamaged = true
				damage.Limbs[bone].severity = 1
			else
				if damage.Limbs[bone].severity < 4 then
					damage.Limbs[bone].severity = damage.Limbs[bone].severity + 1
				end
			end
			char:SetData("Damage", damage)
			cb(damage.Limbs[bone])
		end
	end)

	Callbacks:RegisterServerCallback("Damage:ApplySkeleDamage", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local damage = char:GetData("Damage")
			local bone = Config.Bones[data.bone]
			local wepClass = Config.DamageTypes[data.wepClass]

			if bone == nil or wepClass == nil then
				return
			end

			if bone ~= nil and wepClass ~= nil then
				damage.Limbs[bone].damageTypes = damage.Limbs[bone].damageTypes or {}
				damage.Limbs[bone].damageTypes[wepClass] = damage.Limbs[bone].damageTypes[wepClass] or 0
				damage.Limbs[bone].damageTypes[wepClass] = damage.Limbs[bone].damageTypes[wepClass] + 1
			end
			char:SetData("Damage", damage)
		end
	end)

	Callbacks:RegisterServerCallback("Damage:GetLimbDamage", function(source, data, cb)
		local char = Fetch:Source(data):GetData("Character")
		if char ~= nil then
			local damage = char:GetData("Damage")
			
			local menuData = {}

			for k, v in pairs(damage.Limbs) do
				local descStr = ""

				local data = {}
				for k2, v2 in pairs(v?.damageTypes or {}) do
					table.insert(data, string.format("%s %s", v2, Config.DamageTypeLabels[k2]))
				end

				if #data > 0 then
					table.insert(menuData, {
						label = v.label,
						description = table.concat( data, ", " )
					})
				end
			end

			if #menuData == 0 then
				table.insert(menuData, {
					label = "No Observed Injuries",
				})
			end

			cb(menuData)
		end
	end)
end
