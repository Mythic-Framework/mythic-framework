local inBank = true

AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Action = exports["mythic-base"]:FetchComponent("Action")
end

function TableLength(tbl)
	local c = 0
	for k, v in pairs(tbl) do
		c += 1
	end
	return c
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Finance", {
		"Utils",
		"Callbacks",
		"Logger",
		"Interaction",
		"Progress",
		"Targeting",
		"PedInteraction",
		"Notification",
		"Blips",
		"Polyzone",
		"Action",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		RunBankingStartup()

		PedInteraction:Add("paycheck", `ig_bankman`, vector3(253.193, 216.434, 105.282), 339.578, 25.0, {
			{
				icon = "hand-holding-dollar",
				text = "Get Paycheck",
				event = "Finance:Client:Paycheck",
				isEnabled = function()
					return TableLength(LocalPlayer.state.Character:GetData("Salary") or {}) > 0
				end,
			},
		}, "money-check-dollar")

		Targeting.Zones:AddBox("paycheck-fuckingcunt", "money-check-dollar", vector3(254.53, 216.58, 106.28), 0.8, 3.6, {
			name = "paycheck",
			heading = 340,
			--debugPoly=true,
			minZ = 105.28,
			maxZ = 108.28
		}, {
			{
				icon = "hand-holding-dollar",
				text = "Get Paycheck",
				event = "Finance:Client:Paycheck",
				isEnabled = function()
					return TableLength(LocalPlayer.state.Character:GetData("Salary") or {}) > 0
				end,
			},
		}, 3.0, true)

		PedInteraction:Add("paycheck-2", `ig_bankman`, vector3(17.568, -927.223, 28.903), 111.958, 25.0, {
			{
				icon = "hand-holding-dollar",
				text = "Get Paycheck",
				event = "Finance:Client:Paycheck",
				isEnabled = function()
					return TableLength(LocalPlayer.state.Character:GetData("Salary") or {}) > 0
				end,
			},
		}, "money-check-dollar")

		Targeting.Zones:AddBox("paycheck-fuckingcunt-2", "money-check-dollar", vector3(16.72, -927.74, 29.9), 2.0, 1.0, {
			name = "paycheck",
			heading = 15,
			--debugPoly=true,
			minZ = 29.7,
			maxZ = 31.3
		}, {
			{
				icon = "hand-holding-dollar",
				text = "Get Paycheck",
				event = "Finance:Client:Paycheck",
				isEnabled = function()
					return TableLength(LocalPlayer.state.Character:GetData("Salary") or {}) > 0
				end,
			},
		}, 3.0, true)

		Interaction:RegisterMenu("cash", "Show Cash", "dollar-sign", function()
			TriggerServerEvent("Wallet:ShowCash")
			Interaction:Hide()
		end)
	end)
end)

RegisterNetEvent("UI:Client:Reset", function()
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "APP_HIDE",
		data = {},
	})
end)

AddEventHandler("Finance:Client:Paycheck", function(entity, data)
	Callbacks:ServerCallback("Finance:Paycheck", {}, function(s)
		if s.total > 0 then
			Notification:Success(string.format("You Received $%s For %s Total Minutes Worked", s.total, s.minutes))
		else
			Notification:Error("You Need To Work To Earn A Paycheck")
		end
	end)
end)

RegisterNUICallback("Close", function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "APP_HIDE",
	})

	if not inBank then
		Progress:Progress({
			name = "atm_removing",
			duration = 1500,
			label = "Removing Card",
			useWhileDead = false,
			canCancel = false,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
			disarm = true,
		}, function(cancelled) end)
	end

	inBank = false
end)

RegisterNetEvent("Finance:Client:OpenUI", function()
	inBank = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "SET_APP",
		data = {
			brand = "fleeca",
			app = "BANK",
		},
	})
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "Cash" then
		SendNUIMessage({
			type = "SET_DATA",
			data = {
				type = "character",
				data = {
					ID = LocalPlayer.state.Character:GetData("ID"),
					SID = LocalPlayer.state.Character:GetData("SID"),
					First = LocalPlayer.state.Character:GetData("First"),
					Last = LocalPlayer.state.Character:GetData("Last"),
					Cash = LocalPlayer.state.Character:GetData("Cash"),
				},
			},
		})
	end
end)

AddEventHandler("Characters:Client:Spawn", function()
	SendNUIMessage({
		type = "SET_DATA",
		data = {
			type = "character",
			data = {
				ID = LocalPlayer.state.Character:GetData("ID"),
				SID = LocalPlayer.state.Character:GetData("SID"),
				First = LocalPlayer.state.Character:GetData("First"),
				Last = LocalPlayer.state.Character:GetData("Last"),
				Cash = LocalPlayer.state.Character:GetData("Cash"),
			},
		},
	})
end)

RegisterNetEvent('Finance:Client:HandOffCash', function()
	loadAnimDict("mp_safehouselost@")
	TaskPlayAnim(LocalPlayer.state.ped, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
end)