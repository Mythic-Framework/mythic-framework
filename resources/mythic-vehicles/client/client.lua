_characterLoaded, GLOBAL_PED = false, nil

VEHICLE_INSIDE = nil
VEHICLE_SEAT = nil
VEHICLE_CLASS = nil

VEHICLE_SEATBELT = false
VEHICLE_HARNESS = false

AddEventHandler("Vehicles:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Menu = exports["mythic-base"]:FetchComponent("Menu")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Minigame = exports["mythic-base"]:FetchComponent("Minigame")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Confirm = exports["mythic-base"]:FetchComponent("Confirm")
	Police = exports["mythic-base"]:FetchComponent("Police")
	Input = exports["mythic-base"]:FetchComponent("Input")
	NetSync = exports["mythic-base"]:FetchComponent("NetSync")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
end

local vehicleDoorNames = {
	[0] = "Driver",
	[1] = "Passenger",
	[2] = "Rear Driver",
	[3] = "Rear Passenger",
	[4] = "Hood",
	[5] = "Trunk",
}

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Vehicles", {
		"Callbacks",
		"Notification",
		"Animations",
		"Game",
		"Action",
		"Progress",
		"Vehicles",
		"Blips",
		"Menu",
		"Utils",
		"Logger",
		"Minigame",
		"Keybinds",
		"Targeting",
		"Interaction",
		"Polyzone",
		"ListMenu",
		"Jobs",
		"Sounds",
		"PedInteraction",
		"EmergencyAlerts",
		"Properties",
		"Confirm",
		"Police",
		"Input",
		"NetSync",
		"Hud",
		"UISounds",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCallbacks()

		TriggerEvent("Vehicles:Client:StartUp")

		Keybinds:Add("toggle_engine", "F9", "keyboard", "Vehicle - Toggle Engine", function()
			if VEHICLE_INSIDE and VEHICLE_SEAT == -1 then
				Vehicles.Engine:Toggle(VEHICLE_INSIDE)
			end
		end)

		Interaction:RegisterMenu("veh_quick_actions", false, "car", function()
			if VEHICLE_INSIDE then
				local subMenu = {}
				local seatAmount = GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE))
				Interaction:ShowMenu({
					{
						icon = "person-seat",
						label = "Seats",
						shouldShow = function()
							if VEHICLE_INSIDE then
								if GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE)) > 1 then
									return true
								end
							end
							return false
						end,
						action = function()
							local fuckingSeats = {}
							local seatAmount = GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE))
							for i = 1, seatAmount do
								local actualFuckingSeatNumber = i - 2
								if GetPedInVehicleSeat(VEHICLE_INSIDE, actualFuckingSeatNumber) == 0 then
									table.insert(fuckingSeats, {
										icon = "person-seat",
										label = actualFuckingSeatNumber == -1 and "Driver's Seat" or "Seat #" .. i,
										action = function()
											TriggerEvent("Vehicles:Client:Actions:SwitchSeat", actualFuckingSeatNumber)
											Interaction:Hide()
										end,
									})
								end
							end

							if #fuckingSeats > 0 then
								Interaction:ShowMenu(fuckingSeats)
							else
								Notification:Error("No Seats Free")
							end
						end,
					},
					{
						icon = "car-side",
						label = "Doors",
						shouldShow = function()
							if VEHICLE_INSIDE then
								if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
									return true
								end
							end
							return false
						end,
						action = function()
							local fuckingDoors = {}
							for doorId, doorName in pairs(vehicleDoorNames) do
								if GetIsDoorValid(VEHICLE_INSIDE, doorId) then
									table.insert(fuckingDoors, {
										icon = "car-side",
										label = doorName,
										action = function()
											TriggerEvent("Vehicles:Client:Actions:ToggleDoor", doorId)
										end,
									})
								end
							end

							Interaction:ShowMenu(fuckingDoors)
						end,
					},
					{
						icon = "car-side",
						label = "Close All Doors",
						shouldShow = function()
							if VEHICLE_INSIDE then
								if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
									return true
								end
							end
							return false
						end,
						action = function()
							if VEHICLE_INSIDE then
								TriggerEvent("Vehicles:Client:Actions:ToggleDoor", "shut")
							end
						end,
					},
					{
						icon = "car-side",
						label = "Open All Doors",
						shouldShow = function()
							if VEHICLE_INSIDE then
								if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
									return true
								end
							end
							return false
						end,
						action = function()
							if VEHICLE_INSIDE then
								TriggerEvent("Vehicles:Client:Actions:ToggleDoor", "open")
							end
						end,
					},
					{
						icon = "window-frame",
						label = "Windows",
						shouldShow = function()
							if VEHICLE_INSIDE then
								if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
									return true
								end
							end
							return false
						end,
						action = function()
							local fuckingDoors = {}
							table.insert(fuckingDoors, {
								icon = "window-frame",
								label = "Driver Window",
								action = function()
									TriggerEvent("Vehicles:Client:Actions:ToggleWindow", 0)
								end,
							})

							table.insert(fuckingDoors, {
								icon = "window-frame",
								label = "Passenger Window",
								action = function()
									TriggerEvent("Vehicles:Client:Actions:ToggleWindow", 1)
								end,
							})

							table.insert(fuckingDoors, {
								icon = "window-frame",
								label = "Close All",
								action = function()
									TriggerEvent("Vehicles:Client:Actions:ToggleWindow", "shut")
								end,
							})

							table.insert(fuckingDoors, {
								icon = "window-frame",
								label = "Open All",
								action = function()
									TriggerEvent("Vehicles:Client:Actions:ToggleWindow", "open")
								end,
							})

							Interaction:ShowMenu(fuckingDoors)
						end,
					},
					{
						icon = "gauge-min",
						label = "Check Mileage",
						action = function()
							if VEHICLE_INSIDE then
								local vehEnt = Entity(VEHICLE_INSIDE)
								if vehEnt and vehEnt.state and vehEnt.state.Mileage then
									Notification:Info(
										"This Vehicle Has " .. vehEnt.state.Mileage .. " Miles on the Odometer",
										10000
									)
								end

								Interaction:Hide()
							end
						end,
					},
					{
						icon = "gauge-circle-plus",
						label = "Check Nitrous Levels",
						shouldShow = function()
							if VEHICLE_INSIDE then
								local vehEnt = Entity(VEHICLE_INSIDE)
								if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
									return true
								end
							end
							return false
						end,
						action = function()
							if VEHICLE_INSIDE then
								local vehEnt = Entity(VEHICLE_INSIDE)
								if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
									Notification:Standard("Nitrous Remaining: " .. Utils:Round(vehEnt.state.Nitrous, 2) .. "%", 10000)
								end

								Interaction:Hide()
							end
						end,
					},
					{
						icon = "gauge-circle-minus",
						label = "Remove Nitrous",
						shouldShow = function()
							if VEHICLE_INSIDE then
								local vehEnt = Entity(VEHICLE_INSIDE)
								if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
									return true
								end
							end
							return false
						end,
						action = function()
							if VEHICLE_INSIDE then
								local vehEnt = Entity(VEHICLE_INSIDE)
								if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
									TriggerEvent("Vehicles:Client:RemoveNitrous")
								end
							end
						end,
					},
					-- {
					-- 	icon = "print-magnifying-glass",
					-- 	label = "Inspect VIN",
					-- 	shouldShow = function()
					-- 		return (LocalPlayer.state.onDuty ~= "police" and Vehicles:HasAccess(VEHICLE_INSIDE))
					-- 			or (LocalPlayer.state.onDuty == "police" and LocalPlayer.state.inPdStation)
					-- 	end,
					-- 	action = function()
					-- 		if
					-- 			VEHICLE_INSIDE
					-- 			and (
					-- 				(LocalPlayer.state.onDuty ~= "police" and Vehicles:HasAccess(VEHICLE_INSIDE))
					-- 				or (LocalPlayer.state.onDuty == "police" and LocalPlayer.state.inPdStation)
					-- 			)
					-- 		then
                    --             ListMenu:Close()
					-- 			TriggerServerEvent("Vehicle:Server:InspectVIN", VehToNet(VEHICLE_INSIDE))
					-- 		end
					-- 	end,
					-- },
					{
						icon = "lightbulb-on",
						label = "Neons",
						shouldShow = function()
							if VEHICLE_INSIDE and Vehicles.Sync.Neons:Has() then
								return true
							end
						end,
						action = function()
							if VEHICLE_INSIDE then
								Vehicles.Sync.Neons:Toggle()
							end
						end,
					},
				})
			end
		end, function()
			if VEHICLE_INSIDE then
				return true
			end
			return false
		end)
	end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	_characterLoaded = true
	TriggerEvent("Vehicles:Client:CharacterLogin")
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	_characterLoaded = false

	TriggerEvent("Vehicles:Client:CharacterLogout")
end)

RegisterNetEvent("Vehicles:Client:Actions:SwitchSeat")
AddEventHandler("Vehicles:Client:Actions:SwitchSeat", function(seatNum)
	if not VEHICLE_INSIDE then
		return
	end
	if GetPedInVehicleSeat(VEHICLE_INSIDE, seatNum) == 0 then
		SetPedIntoVehicle(GLOBAL_PED, VEHICLE_INSIDE, seatNum)
	else
		Notification:Error("Seat Occupied")
	end
end)

RegisterNetEvent("Vehicles:Client:Actions:ToggleDoor")
AddEventHandler("Vehicles:Client:Actions:ToggleDoor", function(doorNum)
	local vehicle = VEHICLE_INSIDE

	if not vehicle then
		local targetVehicle = Targeting:GetEntityPlayerIsLookingAt()
		if
			targetVehicle
			and targetVehicle.entity
			and DoesEntityExist(targetVehicle.entity)
			and GetEntitySpeed(targetVehicle.entity) <= 2.0
			and GetPedInVehicleSeat(targetVehicle.entity, -1) == 0
		then
			vehicle = targetVehicle.entity
		else
			return
		end
	end

	if doorNum == "shut" or doorNum == "close" then
		Vehicles.Sync.Doors:Shut(vehicle, "all", false)
	elseif doorNum == "open" then
		Vehicles.Sync.Doors:Open(vehicle, "all", false, false)
	else
		if GetVehicleDoorAngleRatio(vehicle, doorNum) > 0.0 then
			Vehicles.Sync.Doors:Shut(vehicle, doorNum, false)
		else
			Vehicles.Sync.Doors:Open(vehicle, doorNum, false, false)
		end
	end
end)

RegisterNetEvent("Vehicles:Client:Actions:ToggleWindow")
AddEventHandler("Vehicles:Client:Actions:ToggleWindow", function(winNum)
	local vehicle = VEHICLE_INSIDE

	if not vehicle then
		local targetVehicle = Targeting:GetEntityPlayerIsLookingAt()
		if
			targetVehicle
			and targetVehicle.entity
			and DoesEntityExist(targetVehicle.entity)
			and GetEntitySpeed(targetVehicle.entity) <= 2.0
			and GetPedInVehicleSeat(targetVehicle.entity, -1) == 0
		then
			vehicle = targetVehicle.entity
		else
			return
		end
	end

	if winNum == "shut" or winNum == "close" then
		for i = 0, 4 do
			RollUpWindow(vehicle, i)
		end
	elseif winNum == "open" then
		for i = 0, 4 do
			RollDownWindows(vehicle, i)
		end
	else
		if IsVehicleWindowIntact(vehicle, winNum) then
			RollDownWindows(vehicle, winNum)
		else
			RollUpWindow(vehicle, winNum)
		end
	end
end)
