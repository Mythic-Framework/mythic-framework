--[[
	Rep Ideas?

	Farming: Sell food mats in bulk?
	Salvage: Gain access to chop-lists (Will be a seperate thing from boosting, chopping will be NPC-driven stuff that will give raw materials and rarely car parts opposed to boosting)
	Garbage: Gain access to pawn shop stuff allowing people to sell off chains/watches/etc
	Mining: Gain access to selling gems? And/Or crafting bench to smelt?
	Hunting: Gain access to selling hides?
	Fishing: ????
]]

local _ran = false
AddEventHandler("Labor:Server:Startup", function()
	if _ran then
		return
	end
	_ran = true
	Labor.Jobs:Register(
		"HouseRobbery",
		"House Robbery",
		4,
		0,
		100,
		{
			state = "SCRIPT_HOUSE_ROBBERY",
		},
		{
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 3000 },
			{ label = "Rank 3", value = 6000 },
			{ label = "Rank 4", value = 16000 },
			{ label = "Rank 5", value = 30000 },
		},
		false,
		{
			Duration = 60 * 10,
			Message = "If you wont do the job, I'll give it to someone else",
		}
	)
	Labor.Jobs:Register(
		"OxyRun",
		"Oxy",
		4,
		0,
		100,
		{
			state = "SCRIPT_OXY_RUN",
		},
		{
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 2000 },
			{ label = "Rank 3", value = 4000 },
			{ label = "Rank 4", value = 8000 },
			{ label = "Rank 5", value = 12000 },
		},
		false,
		{
			Duration = 60 * 20,
			Message = "You took too damn long, maybe next time",
		}
	)
	Labor.Jobs:Register(
		"WeedRun",
		"Weed Distribution",
		0,
		0,
		100,
		{
			state = "SCRIPT_WEED_RUN",
		},
		{
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 2500 },
			{ label = "Rank 3", value = 5000 },
			{ label = "Rank 4", value = 10000 },
			{ label = "Rank 5", value = 25000 },
			{ label = "Rank 6", value = 50000 },
			{ label = "Rank 7", value = 100000 },
			{ label = "Rank 8", value = 250000 },
			{ label = "Rank 9", value = 500000 },
			{ label = "Rank 10", value = 1000000 },
		},
		false,
		{
			KeepRep = true,
			Duration = 60 * 20,
			Message = "Let Me Know If You Want To Do More Runs",
		}
	)
	Labor.Jobs:Register(
		"CornerDealing",
		"Corner Dealing",
		4,
		0,
		100,
		{
			state = "SCRIPT_CORNER_DEALING",
		},
		{
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 2500 },
			{ label = "Rank 3", value = 5000 },
			{ label = "Rank 4", value = 10000 },
			{ label = "Rank 5", value = 25000 },
			{ label = "Rank 6", value = 50000 },
			{ label = "Rank 7", value = 100000 },
			{ label = "Rank 8", value = 250000 },
			{ label = "Rank 9", value = 500000 },
			{ label = "Rank 10", value = 1000000 },
		},
		false,
		{
			KeepRep = true,
			Duration = 60 * 20,
			Message = "Let me know if you have anymore product you want to sell",
		}
	)

	Labor.Jobs:Register("Prison", "U SHOULDNT SEE THIS LOL", 0, 0, 0, {
		state = "SCRIPT_PRISON_JOB",
	}, {}, true)

	Labor.Jobs:Register("Hunting", "Hunting", 0, 1200, 100)
	Labor.Jobs:Register("Mining", "Mining", 0, 1300, 100, false, {
		{ label = "Rank 1", value = 1500 },
		{ label = "Rank 2", value = 3000 },
		{ label = "Rank 3", value = 7000 },
		{ label = "Rank 4", value = 10000 },
		{ label = "Rank 5", value = 12000 },
	})
	Labor.Jobs:Register("Farming", "Farming", 0, 1200, 100)
	Labor.Jobs:Register("Salvaging", "Salvaging", 0, 1200, 100)
	Labor.Jobs:Register("Garbage", "Garbage", 0, 1500, 100, false, {
		{ label = "Rank 1", value = 1500 },
		{ label = "Rank 2", value = 3000 },
		{ label = "Rank 3", value = 7000 },
		{ label = "Rank 4", value = 10000 },
		{ label = "Rank 5", value = 12000 },
	})
	Labor.Jobs:Register("Fishing", "Fishing", 0, 1000, 100)

	Labor.Jobs:Register("Coke", "THIS SHOULD NOT BE SEEN", 1, 0, 100, {
		state = "SCRIPT_COKE_RUN",
	}, {
		{ label = "Rank 1", value = 1500 },
		{ label = "Rank 2", value = 3000 },
		{ label = "Rank 3", value = 7000 },
		{ label = "Rank 4", value = 10000 },
		{ label = "Rank 5", value = 12000 },
	}, true)

	--Labor.Jobs:Register("Trucking", "Trucking", 0, 1005, 100)
end)
