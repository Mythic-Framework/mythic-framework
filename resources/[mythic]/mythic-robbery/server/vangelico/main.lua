local _loot = {
	{ 10, { name = "rolex", min = 6, max = 12 } },
	{ 20, { name = "watch", min = 8, max = 16 } },
	{ 15, { name = "chain", min = 8, max = 16 } },
	{ 30, { name = "ring", min = 10, max = 20 } },
	{ 25, { name = "earrings", min = 14, max = 28 } },
}

local _requiredPd = 3
local _alerted = nil

local _notAllowedTill = 1000 * 60 * math.random(30, 40)
local _caseResetTime = nil

function PutShittyThingsOnCD()
	local time = _caseResetTime or os.time() + (60 * math.random(100, 140))
	GlobalState["Vangelico:State"] = 2
	GlobalState["Vangelico:InProgress"] = false
	for k, v in ipairs(VANG_CASES) do
		local pId = string.format("Vangelico:Case:%s", k)
		GlobalState[pId] = time
	end

	CreateThread(function()
		while time > os.time() do
			Wait(5000)
		end
		for k, v in ipairs(VANG_CASES) do
			local pId = string.format("Vangelico:Case:%s", k)
			GlobalState[pId] = nil
		end
		GlobalState["Vangelico:State"] = nil
	end)
end

function StartJewelryTimer()
	CreateThread(function()
		while os.time() < _caseResetTime do
			Wait(5000)
		end

		if GlobalState["Vangelico:State"] == 2 then
			_caseResetTime = nil
			return
		end

		PutShittyThingsOnCD()

		GlobalState["Vangelico:State"] = 2
		_caseResetTime = nil
	end)
end

AddEventHandler("Robbery:Server:Setup", function()
	GlobalState["VangelicoRequiredPd"] = _requiredPd
	GlobalState["VangelicoCases"] = VANG_CASES

	CreateThread(function()
		GlobalState["Vangelico:State"] = 2
		while GetGameTimer() < _notAllowedTill do
			Wait(1000)
		end
		GlobalState["Vangelico:State"] = nil
	end)

	Callbacks:RegisterServerCallback("Robbery:Vangelico:BreakCase", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local pId = string.format("Vangelico:Case:%s", data)
		if
			(
				not GlobalState["AntiShitlord"]
				or os.time() >= GlobalState["AntiShitlord"]
				or GlobalState["Vangelico:InProgress"]
			)
			and (
				not GlobalState["RestartLockdown"]
				or (GlobalState["RestartLockdown"] and GlobalState["Vangelico:InProgress"])
			)
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
			if not GlobalState[pId] or GlobalState[pId] < os.time() and GlobalState["Vangelico:State"] ~= 2 then
				Logger:Info(
					"Robbery",
					string.format(
						"%s %s (%s) Broke Vangelico Case #%s",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID"),
						data
					)
				)
				if not _caseResetTime then
					_caseResetTime = os.time() + (60 * math.random(100, 140))
					StartJewelryTimer()
				end

				if not GlobalState["AntiShitlord"] or os.time() >= GlobalState["AntiShitlord"] then
					GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
				end
				GlobalState["Vangelico:InProgress"] = true

				GlobalState["Vangelico:State"] = 1
				GlobalState[pId] = _caseResetTime

				if _alerted == nil or _alerted < os.time() then
					Robbery:TriggerPDAlert(source, vector3(-630.732, -237.111, 38.078), "10-90", "Armed Robbery", {
						icon = 617,
						size = 0.9,
						color = 31,
						duration = (60 * 5),
					}, {
						icon = "gem",
						details = "Vangelico Jewelry",
					}, "vangelico")
					_alerted = os.time() + (60 * 15)
				end

				local luck = math.random(100)
				if luck >= 98 then
					if luck == 100 then
						--Inventory:AddItem(char:GetData("SID"), "valuegoods", 1, {}, 1)
					end
					Loot.Sets:Gem(char:GetData("SID"), 1)
				end

				Loot:CustomWeightedSetWithCount(_loot, char:GetData("SID"), 1)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Vangelico:SecureStore", function(source, data, cb)
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
		if _alerted ~= nil and _alerted >= os.time() then
			PutShittyThingsOnCD()
			GlobalState["Vangelico:State"] = 2
			Execute:Client(source, "Notification", "Success", "Store Has Been Secure", 6000)
		else
			Execute:Client(source, "Notification", "Error", "Unable To Secure Store, No Recent Crime Reported", 6000)
			Logger:Info(
				"Robbery",
				string.format(
					"%s %s (%s) Secured Vangelico",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID")
				)
			)
			Logger:Warn(
				"Characters",
				string.format(
					"Shitlord Cop Tried Securing Vangelico Without A Recent PD Alert %s %s (%s)",
					player:GetData("Name"),
					player:GetData("AccountID"),
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID")
				),
				{
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
					},
				}
			)
		end
	end)
end)
