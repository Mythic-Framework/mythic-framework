_state = false
_rate = GetResourceKvpInt("TAXI_RATE") or 10

AddEventHandler("Taxi:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Taxi = exports["mythic-base"]:FetchComponent("Taxi")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Jail", {
		"Logger",
		"Blips",
		"Keybinds",
		"Notification",
		"PedInteraction",
		"Taxi",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Keybinds:Add("taxi_increase_rate", "", "keyboard", "Taxi - Increase Rate", function()
			Taxi.Rate:Increase()
		end)

		Keybinds:Add("taxi_decrease_rate", "", "keyboard", "Taxi - Decrease Rate", function()
			Taxi.Rate:Decrease()
		end)

		Keybinds:Add("taxi_reset_trip", "", "keyboard", "Taxi - Reset Trip", function()
			Taxi.Trip:Reset()
		end)

		Keybinds:Add("taxi_toggle_hud", "", "keyboard", "Taxi - Toggle HUD", function()
			Taxi.Hud:Toggle()
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Taxi", _TAXI)
end)

local _threading = false
function DoTaxiThread(veh)
	if _threading then
		return
	end
	_threading = true

	local prevLocation = GetEntityCoords(veh)
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn and _inVeh == veh and _state do
			local currLocation = GetEntityCoords(veh)
			local dist = #(currLocation - prevLocation)
			SendNUIMessage({
				type = "UPDATE_TRIP",
				data = {
					trip = dist,
				},
			})
			prevLocation = currLocation
			Citizen.Wait(1000)
		end
		_threading = false
	end)
end

_TAXI = {
	Hud = {
		Show = function(self)
			local veh = GetVehiclePedIsIn(LocalPlayer.state.ped)
			if _models[GetEntityModel(veh)] and GetPedInVehicleSeat(veh, -1) == LocalPlayer.state.ped then
				_inVeh = veh

				_state = true
				DoTaxiThread(veh)
				SendNUIMessage({
					type = "APP_SHOW",
					data = {
						rate = _rate,
					},
				})
			end
		end,
		Hide = function(self)
			_state = false
			SendNUIMessage({
				type = "APP_HIDE",
			})
		end,
		Reset = function(self)
			_state = false
			SendNUIMessage({
				type = "APP_RESET",
			})
		end,
		Toggle = function(self)
			if _state then
				Taxi.Hud:Hide()
			else
				Taxi.Hud:Show()
			end
		end,
	},
	Rate = {
		Increase = function(self)
			if _rate < 1000 then
				_rate = _rate + 1
				SetResourceKvpInt("TAXI_RATE", _rate)
				SendNUIMessage({
					type = "SET_RATE",
					data = {
						rate = _rate,
					},
				})
			else
				Notification:Error("Rate Cannot Go Higher")
			end
		end,
		Decrease = function(self)
			if _rate > 0 then
				_rate = _rate - 1
				SetResourceKvpInt("TAXI_RATE", _rate)
				SendNUIMessage({
					type = "SET_RATE",
					data = {
						rate = _rate,
					},
				})
			else
				Notification:Error("Rate Cannot Go Lower")
			end
		end,
	},
	Trip = {
		Reset = function(self)
			SendNUIMessage({
				type = "RESET_TRIP",
			})
		end,
	},
}
