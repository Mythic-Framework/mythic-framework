function RegisterJobMiddleware()
    Middleware:Add('Characters:Logout', function(source)
        Jobs.Duty:Off(source)
	end, 1)

    Middleware:Add('playerDropped', function(source)
		Jobs.Duty:Off(source)
	end, 1)

    Middleware:Add("Characters:GetSpawnPoints", function(source, charId, cData)
		local spawns = {}

        if cData.Jobs and type(cData.Jobs) == 'table' then
            for k, v in ipairs(cData.Jobs) do
                local spawnsForJob = _jobSpawns[v.Id]
                if spawnsForJob and spawnsForJob.locations then
                    for j, b in ipairs(spawnsForJob.locations) do
                        if (not b.workplace) or (b.workplace == v.Workplace?.Id) then
                            table.insert(spawns, {
                                id = string.format('JobSpawn:%s:%s', v.Id, j),
                                label = b.label,
                                location = b.location,
                                icon = spawnsForJob.icon,
                                event = "Characters:GlobalSpawn",
                            })
                        end
                    end
                end
            end
        end

		return spawns
	end, 4)
end