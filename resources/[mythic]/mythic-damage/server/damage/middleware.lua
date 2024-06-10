function DamageMiddleware()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("Damage") == nil then
			char:SetData("Damage", {
				Bleed = 0,
				Limbs = _defDmg,
			})
		end
	end, 2)

	Middleware:Add("Characters:Logout", function(source)
		Player(source).state.isDead = false
		Player(source).state.healTicks = nil
	end, 9000)
end
