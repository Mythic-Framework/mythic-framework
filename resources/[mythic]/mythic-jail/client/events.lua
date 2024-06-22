RegisterNetEvent("Characters:Client:Logout", function()
	_inPickup = false
	_inLogout = false
	_doingMugshot = false
end)

RegisterNetEvent("Jail:Client:EnterJail", function()
	Sounds.Play:One("jailed.ogg", 0.075)
	if not IsScreenFadedOut() then
		DoScreenFadeOut(1000)
		while not IsScreenFadedOut() do
			Wait(10)
		end
	end

	local cellData = Config.Cells[math.random(#Config.Cells)]

	SetEntityCoords(LocalPlayer.state.ped, cellData.coords.x, cellData.coords.y, cellData.coords.z, 0, 0, 0, false)
	Wait(100)
	SetEntityHeading(LocalPlayer.state.ped, cellData.heading)
	_disabled = false

	Wait(1000)

	DoScreenFadeIn(1000)
	while not IsScreenFadedIn() do
		Wait(10)
	end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _inLogout then
		Callbacks:ServerCallback("Jail:Validate", {
			id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
			type = "logout",
		}, function(state)
			if state then
				Characters:Logout()
			end
		end)
	end
end)

AddEventHandler("Jail:Client:RetreiveItems", function()
	Callbacks:ServerCallback("Jail:RetreiveItems")
end)

AddEventHandler("Jail:Client:CheckSentence", function()
	local jailed = LocalPlayer.state.Character:GetData("Jailed")
	if not jailed or GlobalState["OS:Time"] >= (jailed.Release or 0) then
		Notification:Info("Time Served")
	else
		if jailed.Duration >= 9999 then
			Notification:Info("You've Been Setenced To The 9's")
		else
			local months = math.ceil((jailed.Release - GlobalState["OS:Time"]) / 60)
			Notification:Info(
				string.format("You Have %s Months of Your %s Month Sentence Remaining", months, jailed.Duration)
			)
		end
	end
end)

AddEventHandler("Jail:Client:Released", function()
	if Jail:IsJailed() and Jail:IsReleaseEligible() then
		Callbacks:ServerCallback("Jail:Release", {}, function(s)
			if s then
				DoScreenFadeOut(1000)
				while not IsScreenFadedOut() do
					Wait(10)
				end

				Sounds.Play:One("release.ogg", 0.15)
				SetEntityCoords(
					LocalPlayer.state.ped,
					Config.Release.coords.x,
					Config.Release.coords.y,
					Config.Release.coords.z,
					0,
					0,
					0,
					false
				)
				Wait(100)
				SetEntityHeading(LocalPlayer.state.ped, Config.Release.heading)

				Wait(1000)

				DoScreenFadeIn(1000)
				while not IsScreenFadedIn() do
					Wait(10)
				end
			end
		end)
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == "prison-pickup" then
		_inPickup = true
	elseif id == "prison-logout" then
		_inLogout = true
		Action:Show("{keybind}primary_action{/keybind} Switch Characters")
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "prison" and LocalPlayer.state.loggedIn then
		if Jail:IsJailed() and not _doingMugshot then
			TriggerEvent("Jail:Client:EnterJail")
		end
	elseif id == "prison-pickup" then
		_inPickup = false
	elseif id == "prison-logout" then
		_inLogout = false
		Action:Hide()
	end
end)

AddEventHandler("Jail:Client:StartWork", function()
	Callbacks:ServerCallback("Jail:StartWork")
end)

AddEventHandler("Jail:Client:QuitWork", function()
	Callbacks:ServerCallback("Jail:QuitWork")
end)

AddEventHandler("Jail:Client:MakeFood", function()
	Progress:Progress({
		name = "prison_action",
		duration = 12500,
		label = "Making Food",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "dj",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Jail:MakeItem", "food")
		end
	end)
end)

AddEventHandler("Jail:Client:MakeDrink", function()
	Progress:Progress({
		name = "prison_action",
		duration = 12500,
		label = "Making Drink",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "dj",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Jail:MakeItem", "drink")
		end
	end)
end)
