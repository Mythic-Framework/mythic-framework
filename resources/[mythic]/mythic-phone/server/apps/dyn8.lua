local _selling = {}
local _pendingLoanAccept = {}

local govCut = 5
local commissionCut = 5
local companyCut = 10

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Dyn8:Search", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			local qry = {
				label = {
					["$regex"] = data,
					["$options"] = "i",
				},
				sold = false,
			}

			if Player(source).state.onDuty == 'realestate' then
				qry = {
					label = {
						["$regex"] = data,
						["$options"] = "i",
					},
				}
			end

			Database.Game:aggregate({
				collection = "properties",
				aggregate = {
					{
						["$match"] = {
							label = {
								["$regex"] = data,
								["$options"] = "i",
							},
						},
					},
					{
						['$limit'] = 80
					},
				},
			}, function(success, results)
				if not success then
					cb(false)
					return
				end
				cb(results)
			end)
		else
			cb(false)
		end
	end)
end)



