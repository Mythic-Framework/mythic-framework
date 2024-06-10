local _robberyTerminal = {
	coords = vector3(301.03, -1268.38, 29.52),
	length = 1.0,
	width = 1.0,
	options = {
		heading = 0,
		--debugPoly=true,
		minZ = 28.52,
		maxZ = 30.52,
	},
}

local _robberyAreas = {
	{
		coords = vector3(-1421.514, -164.651, 47.587),
		radius = 400.0,
	},
	{
		coords = vector3(-236.920, -862.055, 30.423),
		radius = 400.0,
	},
	{
		coords = vector3(-49.921, -1751.744, 29.421),
		radius = 400.0,
	},
	{
		coords = vector3(1099.503, 2687.090, 38.721),
		radius = 400.0,
	},
	{
		coords = vector3(1856.481, 3732.085, 33.137),
		radius = 400.0,
	},
	{
		coords = vector3(1856.481, 3732.085, 33.137),
		radius = 400.0,
	},
	{
		coords = vector3(1721.703, 6405.138, 37.410),
		radius = 400.0,
	},
	{
		coords = vector3(1721.703, 6405.138, 37.410),
		radius = 400.0,
	},
	{
		coords = vector3(-303.475, 6231.736, 38.460),
		radius = 400.0,
	},
	{
		coords = vector3(-974.370, -1835.689, 21.205),
		radius = 400.0,
	},
	{
		coords = vector3(-1116.592, 2673.240, 18.349),
		radius = 400.0,
	},
	{
		coords = vector3(202.766, 6616.819, 31.656),
		radius = 400.0,
	},
	{
		coords = vector3(1671.253, 4843.808, 42.052),
		radius = 400.0,
	},
	{
		coords = vector3(3.202, -920.910, 29.530),
		radius = 200.0,
	},
}

local _maxRobberies = 15
local _atmLoot = {
	{ 85, { name = "moneyroll", min = 15, max = 30 } },
	{ 15, { name = "moneyband", min = 1, max = 3 } },
}

AddEventHandler("Robbery:Server:Setup", function()
	GlobalState["ATMRobberyTerminal"] = _robberyTerminal
	GlobalState["ATMRobberyAreas"] = _robberyAreas

	Reputation:Create("ATMRobbery", "ATM Robberies", {
		{ label = "Newbie", value = 1000 },
		{ label = "Okay", value = 2000 },
		{ label = "Good", value = 4000 },
		{ label = "Pro", value = 8000 },
		{ label = "Expert", value = 12000 },
	}, true) -- Not sure what to do with this yet so hide it

	Callbacks:RegisterServerCallback("Robbery:ATM:StartJob", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local inATM = Player(source).state.ATMRobbery

		if
			char and (not inATM or inATM <= 0) and not GlobalState["ATMRobberyStartCD"]
			or (os.time() > GlobalState["ATMRobberyStartCD"]) and GlobalState["Sync:IsNight"]
		then
			if GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			end
			if data then
				local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
				if personalMax < _maxRobberies then
					Player(source).state.ATMRobbery = math.random(4, 6)
					GlobalState["ATMRobberyStartCD"] = os.time() + (60 * math.random(2, 5)) -- Cooldown

					local randlocation = math.random(#_robberyAreas)
					Player(source).state.ATMRobberyZone = randlocation

					cb(true, randlocation)
				else
					cb(false, true)
				end
			else
				GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = 10
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:ATM:HackATM", function(source, difficulty, cb)
		local char = Fetch:Source(source):GetData("Character")
		local inATM = Player(source).state.ATMRobbery

		if
			char and inATM and inATM > 0 and not GlobalState["ATMRobberyHackCD"]
			or (os.time() > GlobalState["ATMRobberyHackCD"])
		then
			if GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			end
			local newATMRobbery = inATM - 1
			Player(source).state.ATMRobbery = newATMRobbery
			GlobalState["ATMRobberyHackCD"] = os.time() + 60

			local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
			GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = personalMax + 1

			Reputation.Modify:Add(source, "ATMRobbery", 100)

			Loot:CustomWeightedSetWithCount(_atmLoot, char:GetData("SID"), 1)

			if math.random(100) < 15 then
				Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
					CryptoCoin = "HEIST",
					Quantity = 2,
				}, 1)
			end

			local reward = math.floor((difficulty or 5) * 100 / 4)
			Wallet:Modify(source, (math.random(150) + reward))

			if newATMRobbery > 0 then
				local randlocation = GetNewATMLocation(Player(source).state.ATMRobberyZone)
				cb(true, randlocation)
			else
				cb(true, false)
			end

			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:ATM:FailHackATM", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local inATM = Player(source).state.ATMRobbery

		if char and inATM and inATM > 0 then
			Player(source).state.ATMRobbery = false

			if not data.alarm then
				Robbery:TriggerPDAlert(source, data.coords, "10-90", "ATM Robbery", {
					icon = 521,
					size = 0.9,
					color = 31,
					duration = (60 * 5),
				})
			end

			local personalMax = GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] or 0
			GlobalState[string.format("ATMRobbery:%s", char:GetData("SID"))] = personalMax + 2

			Reputation.Modify:Remove(source, "ATMRobbery", 80)

			cb(true)
		else
			cb(false)
		end
	end)

	Middleware:Add("Characters:Spawning", function(source)
		Player(source).state.ATMRobbery = false
	end, 10)
end)

function GetNewATMLocation(lastZone)
	local randlocation = math.random(#_robberyAreas)

	while randlocation == lastZone do
		randlocation = math.random(#_robberyAreas)
	end

	return randlocation
end

RegisterNetEvent("Robbery:Server:ATM:AlertPolice", function(coords)
	local src = source
	Robbery:TriggerPDAlert(src, coords, "10-90", "ATM Robbery", {
		icon = 521,
		size = 0.9,
		color = 31,
		duration = (60 * 5),
	})
end)
