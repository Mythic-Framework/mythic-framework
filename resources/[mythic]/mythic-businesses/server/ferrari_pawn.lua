local _jobName = "ferrari_pawn"
local _pawnItems = {
	["jewelry"] = {
		{
			item = "rolex",
			rep = 15,
		},
		{
			item = "ring",
			rep = 10,
		},
		{
			item = "chain",
			rep = 10,
		},
		{
			item = "watch",
			rep = 10,
		},
		{
			item = "earrings",
			rep = 10,
		},
		{
			item = "goldcoins",
			rep = 5,
		},
	},
	["valuegoods"] = {
		{
			item = "valuegoods",
			rep = 30,
		},
	},
	["electronics"] = {
		{
			item = "tv",
			rep = 30,
		},
		{
			item = "big_tv",
			rep = 80,
		},
		{
			item = "boombox",
			rep = 20,
		},
		{
			item = "pc",
			rep = 50,
		},
	},
	["appliance"] = {
		{
			item = "microwave",
			rep = 25,
		},
	},
	["golf"] = {
		{
			item = "golfclubs",
			rep = 40,
		},
	},
	["art"] = {
		{
			item = "house_art",
			rep = 50,
		},
	},
	["raremetals"] = {
		{
			item = "goldbar",
			rep = 25,
		},
		{
			item = "silverbar",
			rep = 15,
		},
	},
}

AddEventHandler("Businesses:Server:Startup", function()
	Callbacks:RegisterServerCallback("FerrariPawn:Sell", function(source, data, cb)
		if Jobs.Permissions:HasJob(source, _jobName) then
			local char = Fetch:Source(source):GetData("Character")
			if char then
				local money = 0
				local soldCount = 0
				local data = {}
				for category, pawning in pairs(_pawnItems) do
					for k, v in ipairs(pawning) do
						local count = Inventory.Items:GetCount(char:GetData("SID"), 1, v.item) or 0
						if count > 0 then
							local itemData = Inventory.Items:GetData(v.item)

							if itemData and Inventory.Items:Remove(char:GetData("SID"), 1, v.item, count) then
								money += itemData.price * count
								soldCount += count
								table.insert(
									data,
									string.format("%s %s ($%s/each)", count, itemData.name, itemData.price)
								)
							end
						end
					end
				end

				if money > 0 then
					local f = Banking.Accounts:GetOrganization(_jobName)
					if f ~= nil then
						Banking.Balance:Deposit(f.Account, math.ceil(math.abs(money) * 0.8), {
							type = "deposit",
							title = "Sold Goods",
							description = string.format("Sold %s Pawned Goods", soldCount),
							data = data,
						})
					else
						Wallet:Modify(source, money)
					end

					
					f = Banking.Accounts:GetOrganization("government")
					Banking.Balance:Deposit(f.Account, math.ceil(math.abs(money) * 0.1), {
						type = "deposit",
						title = "Sold Goods Tax",
						description = string.format("10%% Tax On %s Sold Goods", soldCount),
						data = data,
					}, true)

					-- KEKW
					f = Banking.Accounts:GetOrganization("dgang")
					Banking.Balance:Deposit(f.Account, math.ceil(math.abs(money) * 0.1), {
						type = "deposit",
						title = "Sold Goods Tax",
						description = string.format("10%% Tax On %s Sold Goods", soldCount),
						data = data,
					}, true)
				else
					Execute:Client(source, "Notification", "Error", "You Have Nothing To Sell")
				end
			end
		end
	end)
end)
