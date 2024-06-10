_pickups = {}
_warmers = {}

function Startup()
	for k, v in ipairs(Config.Restaurants) do
		Logger:Trace("Restaurant", string.format("Registering Restaurant ^3%s^7", v.Name))
		if v.Benches then
			for benchId, bench in pairs(v.Benches) do
				Logger:Trace("Restaurant", string.format("Registering Crafting Bench ^2%s^7 For ^3%s^7", bench.label, v.Name))
				Crafting:RegisterBench(string.format("%s-%s", k, benchId), bench.label, bench.targeting, {
					x = bench.targeting.poly.coords.x,
					y = bench.targeting.poly.coords.y,
					z = bench.targeting.poly.coords.z,
					h = bench.targeting.poly.options.heading,
				}, {
					job = {
						id = v.Job,
						onDuty = true,
					},
				}, bench.recipes)
			end
		end

		if v.Storage then
			for _, storage in pairs(v.Storage) do
				Logger:Trace("Restaurant", string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", storage.id, v.Name))
				Inventory.Poly:Create(storage)
			end
		end

		if v.Pickups then
			for num, pickup in pairs(v.Pickups) do
				table.insert(_pickups, pickup.id)
				pickup.num = num
				pickup.job = v.Job
				pickup.jobName = v.Name
				GlobalState[string.format("Restaurant:Pickup:%s", pickup.id)] = pickup
			end
		end

		if v.Warmers then
			for _, warmer in pairs(v.Warmers) do
				for _, jobId in ipairs(warmer.restrict.jobs) do
					if _warmers[jobId] == nil then
						_warmers[jobId] = {}
					end
	
					table.insert(_warmers[jobId], warmer.id)
				end
				GlobalState[string.format("Restaurant:Warmers:%s", warmer.id)] = warmer
			end
		end
	end
end
