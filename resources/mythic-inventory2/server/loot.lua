AddEventHandler("Loot:Shared:DependencyUpdate", LootComponents)
function LootComponents()
	Database = exports["mythic-base"]:FetchComponent("Database")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Loot", {
		"Database",
		"Callbacks",
		"Fetch",
		"Logger",
		"Utils",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		LootComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Loot", _LOOT)
end)

_LOOT = {
	ItemClass = function(self, owner, invType, class, count)
		return Inventory:AddItem(owner, itemClasses[class][math.random(#itemClasses[class])], count, {}, invType)
	end,
	CustomSet = function(self, set, owner, invType, count)
		return Inventory:AddItem(owner, set[math.random(#set)], count, {}, invType)
	end,
	CustomSetWithCount = function(self, set, owner, invType)
		local i = set[math.random(#set)]
		return Inventory:AddItem(owner, i.name, math.random(i.min or 0, i.max), {}, invType)
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, item_name },
	-- }
	CustomWeightedSet = function(self, set, owner, invType)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem then
			return Inventory:AddItem(owner, randomItem, 1, {}, invType)
		end
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, { name = item, max = max } },
	-- }
	CustomWeightedSetWithCount = function(self, set, owner, invType, dontAdd)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem?.name and randomItem?.max then
			if dontAdd then
				return {
					name = randomItem.name,
					count = math.random(randomItem.min or 1, randomItem.max)
				}
			else
				return Inventory:AddItem(owner, randomItem.name, math.random(randomItem.min or 1, randomItem.max), randomItem.metadata or {}, invType)
			end
		end
	end,
	-- Pass a set array with the following layout
	-- set = {
	-- 	{chance_num, { name = item, max = max } },
	-- }
	CustomWeightedSetWithCountAndModifier = function(self, set, owner, invType, modifier, dontAdd)
		local randomItem = Utils:WeightedRandom(set)
		if randomItem?.name and randomItem?.max then
			if dontAdd then
				return {
					name = randomItem.name,
					count = math.random(randomItem.min or 1, randomItem.max) * modifier
				}
			else
				return Inventory:AddItem(owner, randomItem.name, math.random(randomItem.min or 1, randomItem.max) * modifier, randomItem.metadata or {}, invType)
			end
		end
	end,
	Sets = {
		Gem = function(self, owner, invType)
			local randomGem = Utils:WeightedRandom({
				{8, "diamond"},
				{5, "emerald"},
				{10, "sapphire"},
				{12, "ruby"},
				{16, "amethyst"},
				{18, "citrine"},
				{31, "opal"},
			})
			return Inventory:AddItem(owner, randomGem, 1, {}, invType)
		end,
		Ore = function(self, owner, invType, count)
			local randomOre = Utils:WeightedRandom({
				{18, "goldore"},
				{27, "silverore"},
				{55, "ironore"},
			})
			return Inventory:AddItem(owner, randomOre, count, {}, invType)
		end,
	},
}
