_recipes = {}
_cooldowns = {}

_schematics = {}
_knownRecipes = {}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Crafting", CRAFTING)
end)

_types = {}
_inProg = {}

--[[
    Location for types
]]

-- Dear lua, die.
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

CRAFTING = {
	RegisterBench = function(self, id, label, targeting, location, restrictions, recipes, canUseSchematics)
		while not itemsLoaded do
			Citizen.Wait(10)
		end

		_cooldowns[id] = _cooldowns[id] or {}
		_types[id] = {
			id = id,
			label = label,
			targeting = targeting,
			location = location,
			restrictions = restrictions,
			recipes = {},
			canUseSchematics = canUseSchematics or false,
		}

		for k, v in pairs(recipes) do
			if itemsDatabase[v.result.name] ~= nil then
				v.id = k
				Crafting:AddRecipeToBench(id, k, v)
			end
		end

		if _knownRecipes[id] ~= nil then
			for k, v in pairs(_knownRecipes[id]) do
				if itemsDatabase[v.result.name] ~= nil then
					v.id = k
					Crafting:AddRecipeToBench(id, k, v)
				end
			end
		end
	end,
	AddRecipeToBench = function(self, bench, id, recipe)
		if _types[bench] == nil then
			print('invalid table')
			return
		end
		recipe.id = id
		_types[bench].recipes[id] = recipe
	end,
	Craft = {
		Start = function(self, crafter, bench, result, qty)
			if _inProg[crafter] ~= nil or _types[bench] == nil or _types[bench].recipes[result] == nil then
				return { error = true, message = "Already Crafting" }
			end

			local reagents = {}
			for k, v in ipairs(_types[bench].recipes[result].items) do
				if reagents[v.name] ~= nil then
					reagents[v.name] = reagents[v.name] + (v.count * qty)
				else
					reagents[v.name] = v.count * qty
				end
			end

			local makingItem = _types[bench].recipes[result].result
			local reqSlotPerItem = itemsDatabase[makingItem.name].isStackable or 1
			local totalRequiredSlots = math.ceil((makingItem.count * qty) / reqSlotPerItem)
			local freeSlots = Inventory:GetFreeSlotNumbers(crafter, 1)
			if #freeSlots < totalRequiredSlots then
				return { error = true, message = "Inventory Full" }
			end

			for k, v in pairs(reagents) do
				if not Inventory.Items:Has(crafter, 1, k, v) then
					return { error = true, message = "Missing Ingredients" }
				end
			end

			if _cooldowns[bench][result] ~= nil and _cooldowns[bench][result] > (os.time() * 1000) then
				return { error = true, message = "Recipe On Cooldown" }
			end

			_inProg[crafter] = {
				bench = bench,
				result = result,
				qty = tonumber(qty),
			}

			local t = deepcopy(_types[bench].recipes[result])
			t.time = t.time * qty

			return {
				error = false,
				data = t,
				string = _types[bench].targeting?.actionString or "Crafting",
			}
		end,
		End = function(self, crafter)
			if _inProg[crafter] == nil or _types[_inProg[crafter].bench] == nil then
				return false
			end

			local recipe = _types[_inProg[crafter].bench].recipes[_inProg[crafter].result]

			local reagents = {}
			for k, v in ipairs(recipe.items) do
				if reagents[v.name] ~= nil then
					reagents[v.name] = reagents[v.name] + (v.count * _inProg[crafter].qty)
				else
					reagents[v.name] = v.count * _inProg[crafter].qty
				end
			end

			local reqSlotPerItem = itemsDatabase[recipe.result.name].isStackable or 1
			local totalRequiredSlots = math.ceil((recipe.result.count * _inProg[crafter].qty) / reqSlotPerItem)
			local freeSlots = Inventory:GetFreeSlotNumbers(crafter, 1)
			if #freeSlots < totalRequiredSlots then
				return false
			end

			for k, v in pairs(reagents) do
				if not Inventory.Items:Remove(crafter, 1, k, v) then
					return false
				end
			end

			local p = promise.new()

			local meta = {}
			if itemsDatabase[recipe.result.name].type == 2 and not itemsDatabase[recipe.result.name].noSerial then
				meta.Scratched = true
			end

			if recipe.cooldown then
				_cooldowns[_inProg[crafter].bench][recipe.id] = (os.time() * 1000) + recipe.cooldown
			end

			if Inventory:AddItem(crafter, recipe.result.name, recipe.result.count * _inProg[crafter].qty, meta, 1) then
				p:resolve(_inProg[crafter].bench)
			else
				p:resolve(nil)
			end
			_inProg[crafter] = nil
			return Citizen.Await(p)
		end,
		Cancel = function(self, crafter)
			if _inProg[crafter] == nil then
				return false
			end
			_inProg[crafter] = nil
			return true
		end,
	},
	Schematics = {
		Has = function(self, bench, item)
			if _types[bench] ~= nil then
				for k, v in ipairs(_types[bench].recipes) do
					if v.schematic == item then
						return true
					end
				end
			end

			return false
		end,
		Add = function(self, bench, item)
			if _types[bench] ~= nil and _schematics[item] ~= nil then
				if not Crafting.Schematics:Has(bench, item) then
					Database.Game:insertOne({
						collection = "schematics",
						document = {
							bench = bench,
							item = item,
						},
					})

					local f = table.copy(_schematics[item])
					f.schematic = item
					Crafting:AddRecipeToBench(bench, item, f)
				end
			end

			return false
		end,
	},
}

function RegisterCraftingCallbacks()
	Callbacks:RegisterServerCallback("Crafting:GetBenchDetails", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		local bench = _types[data]
		if
			bench ~= nil
			and (
				not bench.restrictions
				or bench.restrictions.shared
				or (bench.restrictions.interior ~= nil and bench.restrictions.interior == GlobalState[string.format(
					"%s:House",
					source
				)])
				or (bench.restrictions.char ~= nil and bench.restrictions.char == char:GetData("SID"))
				or (bench.restrictions.job ~= nil and Jobs.Permissions:HasJob(
					source,
					bench.restrictions.job.id,
					bench.restrictions.job.workplace,
					bench.restrictions.job.grade,
					false,
					bench.restrictions.job.reqDuty,
					bench.restrictions.job.permissionKey or "JOB_CRAFTING"
				))
				or (
					bench.restrictions.rep ~= nil
					and Reputation:GetLevel(source, bench.restrictions.rep.id) >= bench.restrictions.rep.level
				)
			)
		then
			-- local slots = GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 1)] or {}
			-- local items = {}
			-- -- for k, v in ipairs(slots) do
			-- --     local key = ("inventory:%s:1:%s"):format(char:GetData("ID"), v)
			-- --     table.insert(save, GlobalState[key])
			-- --     GlobalState[key] = nil
			-- -- end
			cb({
				recipes = bench.recipes,
				cooldowns = _cooldowns[data],
				myCounts = Inventory.Items:GetCounts(char:GetData("ID"), 1),
				string = bench.targeting?.actionString or "Crafting",
				canUseSchematics = bench.canUseSchematics,
			})
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Crafting:Craft", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(Crafting.Craft:Start(char:GetData("ID"), data.bench, data.result, data.qty))
	end)

	Callbacks:RegisterServerCallback("Crafting:End", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(Crafting.Craft:End(char:GetData("ID")))
	end)

	Callbacks:RegisterServerCallback("Crafting:Cancel", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(Crafting.Craft:Cancel(char:GetData("ID")))
	end)

	Callbacks:RegisterServerCallback("Crafting:GetSchematics", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local schems = Inventory.Items:GetAllOfType(char:GetData("ID"), 1, 17)

				local list = {}
				for k, v in ipairs(schems) do
					local itemData = Inventory.Items:GetData(v)
					if itemData?.schematic ~= nil and not Crafting.Schematics:Has(data.id, v) then
						local result = Inventory.Items:GetData(itemData.schematic.result.name)

						table.insert(list, {
							label = itemData.label,
							description = string.format("Makes: x%s %s", itemData.schematic.result.count, result.label),
							event = "Crafting:Client:UseSchematic",
							data = v,
						})
					end
				end

				cb(list)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Crafting:UseSchematic", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Inventory.Items:Has(char:GetData("ID"), 1, data.schematic, 1) then
					local bench = _types[data.bench]
					if bench ~= nil then
						if
							bench.canUseSchematics
							and (
								not bench.restrictions
								or bench.restrictions.shared
								or (bench.restrictions.interior ~= nil and bench.restrictions.interior == GlobalState[string.format(
									"%s:House",
									source
								)])
								or (bench.restrictions.char ~= nil and bench.restrictions.char == char:GetData("SID"))
								or (bench.restrictions.job ~= nil and Jobs.Permissions:HasJob(
									source,
									bench.restrictions.job.id,
									bench.restrictions.job.workplace,
									bench.restrictions.job.grade,
									false,
									bench.restrictions.job.reqDuty,
									bench.restrictions.job.permissionKey or "JOB_CRAFTING"
								))
								or (
									bench.restrictions.rep ~= nil
									and Reputation:GetLevel(source, bench.restrictions.rep.id)
										>= bench.restrictions.rep.level
								)
							)
						then
							if Inventory.Items:Remove(char:GetData("ID"), 1, data.schematic, 1) then
								if Crafting.Schematics:Add(data.bench, data.schematic) then
									TriggerClientEvent("Crafting:Client:ForceBenchRefresh", source)
									cb(true)
								else
									cb(false)
								end
							else
								cb(false)
							end
						else
							cb(false)
						end
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end

function RegisterTestBench()
	for k, v in ipairs(CraftingTables) do
		Crafting:RegisterBench(
			string.format("crafting-%s", k),
			v.label,
			v.targetConfig,
			v.location,
			v.restriction,
			v.recipes
		)
	end
end

AddEventHandler("Jobs:Server:JobUpdate", function(source)
	TriggerClientEvent("Crafting:Client:ForceBenchRefresh", source)
end)
