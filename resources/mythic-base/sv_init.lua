AddEventHandler("Core:Shared:Ready", function()
	COMPONENTS.Default:AddAuth('roles', 1662066295, {
        {
			Abv = "Whitelisted",
			Name = "Whitelisted",
			Queue = {
				Priority = 0,
			},
			Permission = {
				Level = 0,
				Group = "",
			},
        },
        {
			Abv = "Staff",
			Name = "Staff",
			Queue = {
				Priority = 0,
			},
			Permission = {
				Level = 50,
				Group = "staff",
			},
        },
        {
			Abv = "Admin",
			Name = "Admin",
			Queue = {
				Priority = 0,
			},
			Permission = {
				Level = 75,
				Group = "admin",
			},
        },
        {
			Abv = "Owner",
			Name = "Owner",
			Queue = {
				Priority = 0,
			},
			Permission = {
				Level = 100,
				Group = "admin",
			},
        },
    })

	COMPONENTS.Database.Auth:find({
		collection = "roles",
		query = {},
	}, function(success, results)
		if not success or #results <= 0 then
			COMPONENTS.Logger:Critical("Core", "Failed to Load User Groups", {
				console = true,
				file = true,
			})

			return
		end

		COMPONENTS.Config.Groups = {}

		for k, v in ipairs(results) do
			COMPONENTS.Config.Groups[v.Abv] = v
		end

		COMPONENTS.Logger:Info("Core", string.format("Loaded %s User Groups", #results), {
			console = true,
		})
	end)
end)
