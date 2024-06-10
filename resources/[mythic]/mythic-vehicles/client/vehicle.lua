SLIM_JIM_ATTEMPTS = {}

local _actionShowing = false

_vehicleClasses = {
	X = {
		value = 2000000,
		lockpick = false,
		advLockpick = false,
		hack = false,
		advHack = {
			exterior = { rows = 10, length = 5, duration = 15000, charSize = 2 },
			interior = { rows = 10, length = 5, duration = 15000, charSize = 2 },
		},
	},
	S = {
		value = 1000000,
		lockpick = false,
		advLockpick = false,
		hack = false,
		advHack = {
			exterior = { rows = 9, length = 4, duration = 20000, charSize = 2 },
			interior = { rows = 9, length = 4, duration = 20000, charSize = 2 },
		},
	},
	A = {
		value = 500000,
		lockpick = {
			exterior = { stages = { 2, 3, 4, 5 }, base = 5 },
			interior = { stages = { 2, 3, 4, 5 }, base = 5 },
		},
		advLockpick = {
			exterior = { stages = { 0.8, 1.0, 1.2 }, base = 5 },
			interior = { stages = { 0.8, 1.0, 1.2 }, base = 5 },
		},
		hack = {
			exterior = { rows = 14, length = 8, duration = 18000, charSize = 2 },
			interior = { rows = 14, length = 8, duration = 18000, charSize = 2 },
		},
		advHack = {
			exterior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
			interior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
		},
	},
	B = {
		value = 350000,
		lockpick = {
			exterior = { stages = { 0.8, 1.0, 1.2, 1.4, 1.6 }, base = 6 },
			interior = { stages = { 0.8, 1.0, 1.2, 1.4, 1.6 }, base = 6 },
		},
		advLockpick = {
			exterior = { stages = { 0.4, 0.5 }, base = 4 },
			interior = { stages = { 0.4, 0.5 }, base = 4 },
		},
		hack = {
			exterior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
			interior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
		},
		advHack = {
			exterior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
			interior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
		},
	},
	C = {
		value = 250000,
		lockpick = {
			exterior = { stages = { 0.8, 1.0, 1.2, 1.4 }, base = 6 },
			interior = { stages = { 0.8, 1.0, 1.2, 1.4 }, base = 6 },
		},
		advLockpick = {
			exterior = { stages = { 0.4, 0.5 }, base = 5 },
			interior = { stages = { 0.4, 0.5 }, base = 5 },
		},
		hack = {
			exterior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
			interior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
		},
		advHack = {
			exterior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
			interior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
		},
	},
	D = {
		value = 150000,
		lockpick = {
			exterior = { stages = { 0.8, 1.0, 1.2 }, base = 6 },
			interior = { stages = { 0.8, 1.0, 1.2 }, base = 6 },
		},
		advLockpick = {
			exterior = { stages = { 0.4, 0.5 }, base = 5 },
			interior = { stages = { 0.4, 0.5 }, base = 5 },
		},
		hack = {
			exterior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
			interior = { rows = 8, length = 4, duration = 30000, charSize = 2, charSet = "alphanumer" },
		},
		advHack = {
			exterior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
			interior = { rows = 6, length = 3, duration = 20000, charSize = 1, charSet = "alphanumer" },
		},
	},
}

VEHICLE = {
    _required = {},
    Engine = {
        Force = function(self, veh, state)
            local vehState = Entity(veh).state

            if state and vehState.Fuel and vehState.Fuel <= 0.0 then
                state = false
                Notification:Error('Vehicle Out of Fuel', 2500, 'gas-pump')
            end

            if state and GetVehicleEngineHealth(veh) <= -2000.0 then
                state = false
                Notification:Error('Vehicle Engine Damaged', 2500, 'engine-warning')
            end
            
            if state then
                vehState:set('VEH_IGNITION', true, true)
                SetVehicleEngineOn(veh, true, false, true)
                SetVehicleUndriveable(veh, false)

                if _actionShowing then
                    Action:Hide()
                    _actionShowing = false
                end
            else
                vehState:set('VEH_IGNITION', false, true)
                SetVehicleEngineOn(veh, false, true, true)
                SetVehicleUndriveable(veh, true)
            end

            TriggerEvent('Vehicles:Client:Ignition', state)
        end,
        Off = function(self, customMessage)
            local vehEnt = Entity(VEHICLE_INSIDE)
            Vehicles.Engine:Force(VEHICLE_INSIDE, false)
            Notification:Info(customMessage and customMessage or 'Engine Turned Off', 1500, 'engine')

            if Vehicles.Keys:Has(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
                Action:Show('{keybind}toggle_engine{/keybind} Turn Engine On')
                _actionShowing = true
            end
        end,
        On = function(self)
            local vehEnt = Entity(VEHICLE_INSIDE)

            if Vehicles.Keys:Has(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
                Vehicles.Engine:Force(VEHICLE_INSIDE, true)
				Notification:Info('Engine Turned On', 1500, 'engine')
            else
                Notification:Error('You Don\'t Have Keys For This Vehicle', 3000, 'key')
            end
        end,
        Toggle = function(self)
            local vehEnt = Entity(VEHICLE_INSIDE)

            if vehEnt.state.VEH_IGNITION then
                Vehicles.Engine:Off()
            else
                Vehicles.Engine:On()
            end
        end,
    },
	SlimJim = function(self, vehicle)
		local vehEnt = Entity(vehicle)
		local val = GetVehicleHandlingInt(vehicle, "CHandlingData", "nMonetaryValue")

		if not vehEnt.state.towObjective then
			if vehEnt and vehEnt.state and vehEnt.state.VIN and not Vehicles:HasAccess(vehicle) then
				local vVIN = vehEnt.state.VIN
	
				if SLIM_JIM_ATTEMPTS[vVIN] and SLIM_JIM_ATTEMPTS[vVIN] > 3 then
					Notification:Error("You Have Tried This Vehicle Enough Already")
					return
				end
	
				local setToFail = false
				if vehEnt.state.Owned or val > 100000 then
					setToFail = true
				end
	
				local getFucked = math.random(0, 60)
				if getFucked <= 20 and getFucked >= 5 then
					setToFail = true
				end
	
				local startCoords = GetEntityCoords(GLOBAL_PED)
				TaskTurnPedToFaceEntity(GLOBAL_PED, vehicle, 500)
	
				local dumbAnim = true
	
				RequestAnimDict("veh@break_in@0h@p_m_one@")
				while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
					Citizen.Wait(5)
				end
	
				Citizen.CreateThread(function()
					while dumbAnim do
						TaskPlayAnim(
							GLOBAL_PED,
							"veh@break_in@0h@p_m_one@",
							"low_force_entry_ds",
							1.0,
							1.0,
							1.0,
							16,
							0.0,
							0,
							0,
							0
						)
						Citizen.Wait(1000)
	
						if math.random(100) <= 50 then
							SetVehicleAlarm(VEHICLE_INSIDE, true)
							SetVehicleAlarmTimeLeft(VEHICLE_INSIDE, 1000)
							StartVehicleAlarm(VEHICLE_INSIDE)
						end
					end
				end)
	
				Minigame.Play:RoundSkillbar(12, 3, {
					onSuccess = function()
						dumbAnim = false
						ClearPedTasks(GLOBAL_PED)
						if not SLIM_JIM_ATTEMPTS[vVIN] then
							SLIM_JIM_ATTEMPTS[vVIN] = 1
						else
							SLIM_JIM_ATTEMPTS[vVIN] = SLIM_JIM_ATTEMPTS[vVIN] + 1
						end
	
						if setToFail then
							Notification:Error("It Was too Difficult and It Didn't Work")
						else
							if #(startCoords - GetEntityCoords(GLOBAL_PED)) <= 2.0 then
								SetVehicleHasBeenOwnedByPlayer(vehicle, true)
								SetEntityAsMissionEntity(vehicle, true, true)
								Callbacks:ServerCallback("Vehicles:BreakOpenLock", {
									netId = VehToNet(vehicle),
								}, function(success)
									Notification:Success("You Managed to Unlock the Vehicle", 3000, "key")
								end)
							else
								Notification:Error("Too Far")
							end
						end
					end,
					onFail = function()
						dumbAnim = false
						ClearPedTasks(GLOBAL_PED)
						if not SLIM_JIM_ATTEMPTS[vVIN] then
							SLIM_JIM_ATTEMPTS[vVIN] = 1
						else
							SLIM_JIM_ATTEMPTS[vVIN] = SLIM_JIM_ATTEMPTS[vVIN] + 1
						end
						Notification:Error("It Was too Difficult and It Didn't Work")
					end,
				}, {
					useWhileDead = false,
					vehicle = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				})
			end
		else
			Notification:Error("You Cannot Slimjim This Vehicle", 3000, 'key')
		end
	end,
	LockpickExterior = function(self, config, canUnlockOwned, vehicle, cb)
		local vehEnt = Entity(vehicle)
		local val = GetVehicleHandlingInt(vehicle, "CHandlingData", "nMonetaryValue")

		if not vehEnt.state.towObjective and not Police:IsPdCar(vehicle) and not vehEnt.state.noLockpick then
			if vehEnt and vehEnt.state and vehEnt.state.VIN then
				local vVIN = vehEnt.state.VIN

				if Vehicles.Keys:Has(vVIN, vehEnt.state.GroupKeys) then
					return cb(false)
				end
	
				if not vehEnt.state.Locked then
					return cb(false)
				end
	
				local alerted = false
				local startCoords = GetEntityCoords(GLOBAL_PED)
				TaskTurnPedToFaceEntity(GLOBAL_PED, vehicle, 500)
	
				local dumbAnim = true
				RequestAnimDict("veh@break_in@0h@p_m_one@")
				while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
					Citizen.Wait(5)
				end
	
				Citizen.CreateThread(function()
					while dumbAnim do
						TaskPlayAnim(
							GLOBAL_PED,
							"veh@break_in@0h@p_m_one@",
							"low_force_entry_ds",
							1.0,
							1.0,
							1.0,
							16,
							0.0,
							0,
							0,
							0
						)
						Citizen.Wait(1000)
					end
				end)
	
				local wasFailed = false
				for k, v in ipairs(config.stages) do
					local alarmRoll = math.random(100)
					if alarmRoll <= 20 then
						SetVehicleAlarm(vehicle, true)
						SetVehicleAlarmTimeLeft(vehicle, math.random(25, 40) * 100)
						StartVehicleAlarm(vehicle)
						if not alerted then
							EmergencyAlerts:CreateIfReported(200.0, "lockpickext", true)
							alerted = true
						end
					end
	
					local stageComplete = false
					if wasFailed then
						break
					end
	
					Minigame.Play:RoundSkillbar(v, config.base - k, {
						onSuccess = function()
							Citizen.Wait(400)
							stageComplete = true
						end,
						onFail = function()
							wasFailed = true
							stageComplete = true
						end,
					}, {
						useWhileDead = false,
						vehicle = false,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "veh@break_in@0h@p_m_one@",
							anim = "low_force_entry_ds",
							flags = 16,
						},
					})
	
					while not stageComplete do
						Citizen.Wait(1)
					end
				end
	
				dumbAnim = false
				ClearPedTasks(GLOBAL_PED)
	
				if not wasFailed then
					if #(startCoords - GetEntityCoords(GLOBAL_PED)) <= 2.0 then
						SetVehicleHasBeenOwnedByPlayer(vehicle, true)
						SetEntityAsMissionEntity(vehicle, true, true)
						if vehEnt.state.Owned and not canUnlockOwned then
							Notification:Error("It Was Too Hard", 3000, 'key')
							return cb(true, false)
						end
	 
						Callbacks:ServerCallback("Vehicles:BreakOpenLock", {
							netId = VehToNet(vehicle),
						}, function(success)
							if success then
								Notification:Success("Vehicle Unlocked", 3000, "key")
							end
						end)
	
						cb(true, true)
					else
						Notification:Error("Too Far")
	
						cb(false, false)
					end
				else
					cb(true, false)
				end
			end
		else
			Notification:Error("You Cannot Lockpick This Vehicle", 3000, 'key')
		end
	end,
	Lockpick = function(self, config, canUnlockOwned, cb)
		local vehEnt = Entity(VEHICLE_INSIDE)

		if not vehEnt.state.towObjective and not vehEnt.state.noLockpick then
			if vehEnt and vehEnt.state and vehEnt.state.VIN then
				local vVIN = vehEnt.state.VIN

				if Vehicles.Keys:Has(vVIN, vehEnt.state.GroupKeys) then
					return cb(false, false)
				end
	
				local alerted = false
				local wasFailed = false

				for k, v in ipairs(config.stages) do
					local alarmRoll = math.random(100)
					if alarmRoll <= 20 then
						SetVehicleAlarm(VEHICLE_INSIDE, true)
						SetVehicleAlarmTimeLeft(VEHICLE_INSIDE, math.random(15, 30) * 100)
						StartVehicleAlarm(VEHICLE_INSIDE)
						if not alerted then
							if EmergencyAlerts:CreateIfReported(200.0, "lockpickint", true) then
								TriggerServerEvent('Radar:Server:StolenVehicle', GetVehicleNumberPlateText(VEHICLE_INSIDE))
							end
							alerted = true
						end
					end
	
					local stageComplete = false
					if wasFailed then
						break
					end
	
					Minigame.Play:RoundSkillbar(v, config.base - k, {
						onSuccess = function()
							Citizen.Wait(400)
							stageComplete = true
						end,
						onFail = function()
							wasFailed = true
							stageComplete = true
						end,
					}, {
						useWhileDead = false,
						vehicle = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "veh@break_in@0h@p_m_one@",
							anim = "low_force_entry_ds",
							flags = 16,
						},
					})
	
					while not stageComplete do
						Citizen.Wait(1)
					end
				end
	
				if not wasFailed then
					if VEHICLE_INSIDE and VEHICLE_SEAT == -1 then
						SetVehicleHasBeenOwnedByPlayer(vehicle, true)
						SetEntityAsMissionEntity(vehicle, true, true)
						if vehEnt.state.Owned and not canUnlockOwned then
							Notification:Error("It Was Too Hard", 3000, 'key')
							return cb(true, false)
						end
	
						Callbacks:ServerCallback("Vehicles:GetKeys", vehEnt.state.VIN, function(success)
							Notification:Success("Lockpicked Vehicle Ignition", 3000, 'key')
							Action:Show('{keybind}toggle_engine{/keybind} Turn Engine On')
							_actionShowing = true
						end)
	
						cb(true, true)
					else
						cb(true, false)
					end
				else
					cb(true, false)
				end
			end
		else
			Notification:Error("You Cannot Lockpick This Vehicle", 3000, 'key')
		end
	end,
	HackExterior = function(self, hackData, canUnlockOwned, vehicle, cb)
		local vehEnt = Entity(vehicle)
		local val = GetVehicleHandlingInt(vehicle, "CHandlingData", "nMonetaryValue")

		if not vehEnt.state.towObjective and not vehEnt.state.noLockpick then
			if vehEnt and vehEnt.state and vehEnt.state.VIN then
				local startCoords = GetEntityCoords(GLOBAL_PED)
				TaskTurnPedToFaceEntity(GLOBAL_PED, vehicle, 500)
	
				Minigame.Play:Pattern(
					3,
					hackData.duration,
					hackData.rows,
					hackData.length,
					hackData.charSize,
					hackData.charSet or false, {
					onSuccess = function()
						if #(startCoords - GetEntityCoords(GLOBAL_PED)) <= 2.0 then
							SetVehicleHasBeenOwnedByPlayer(vehicle, true)
							SetEntityAsMissionEntity(vehicle, true, true)

							Callbacks:ServerCallback("Vehicles:BreakOpenLock", {
								netId = VehToNet(vehicle),
							}, function(success)
								if success then
									Notification:Success("Vehicle Unlocked", 3000, "key")
								end
							end)
		
							cb(true, true)
						else
							Notification:Error("Too Far")
		
							cb(false, false)
						end
					end,
					onFail = function()
						cb(true, false)
					end,
				}, {
					useWhileDead = false,
					vehicle = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "amb@medic@standing@kneel@base",
						anim = "base",
						flags = 16,
					},
				})
			end
		else
			Notification:Error("You Cannot Lockpick This Vehicle", 3000, 'key')
		end
	end,
	Hack = function(self, hackData, canUnlockOwned, cb)
		local vehEnt = Entity(VEHICLE_INSIDE)
		local val = GetVehicleHandlingInt(VEHICLE_INSIDE, "CHandlingData", "nMonetaryValue")

		if not vehEnt.state.towObjective and not vehEnt.state.noLockpick then
			if vehEnt and vehEnt.state and vehEnt.state.VIN then
				local startCoords = GetEntityCoords(GLOBAL_PED)
				TaskTurnPedToFaceEntity(GLOBAL_PED, VEHICLE_INSIDE, 500)
	
				Minigame.Play:Pattern(
					3,
					hackData.duration,
					hackData.rows,
					hackData.length,
					hackData.charSize,
					hackData.charSet or false, {
					onSuccess = function()
						if VEHICLE_INSIDE and VEHICLE_SEAT == -1 then
							SetVehicleHasBeenOwnedByPlayer(VEHICLE_INSIDE, true)
							SetEntityAsMissionEntity(VEHICLE_INSIDE, true, true)
							if vehEnt.state.Owned and not canUnlockOwned then
								Notification:Error("It Was Too Hard", 3000, 'key')
								return cb(true, false)
							end
		
							Callbacks:ServerCallback("Vehicles:GetKeys", vehEnt.state.VIN, function(success)
								Notification:Success("Vehicle Ignition Bypassed", 3000, 'key')
								Action:Show('{keybind}toggle_engine{/keybind} Turn Engine On')
								_actionShowing = true
							end)
		
							cb(true, true)
						else
							cb(true, false)
						end
					end,
					onFail = function()
						cb(true, false)
					end,
				}, {
					useWhileDead = false,
					vehicle = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "veh@break_in@0h@p_m_one@",
						anim = "low_force_entry_ds",
						flags = 16,
					},
				})
			end
		else
			Notification:Error("You Cannot Lockpick This Vehicle", 3000, 'key')
		end
	end,
	CanBeStored = function(self, vehicle)
		local vehicleCoords = GetEntityCoords(vehicle)
		local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(vehicleCoords)
		return inVehicleStorageZone or Properties:GetNearHouseGarage(vehicleCoords)
	end,
	Properties = {
		Get = function(self, vehicle)
			return GetVehicleProperties(vehicle)
		end,
		Set = function(self, vehicle, data)
			return SetVehicleProperties(vehicle, data)
		end,
	},
	Utils = {
		IsCloseToRearOfVehicle = function(self, vehicle, coords)
			if not coords then
				coords = LocalPlayer.state.myPos
			end

			return IsCloseToFrontOfVehicle(vehicle, coords)
		end,
		IsCloseToFrontOfVehicle = function(self, vehicle, coords)
			if not coords then
				coords = LocalPlayer.state.myPos
			end

			return IsCloseToRearOfVehicle(vehicle, coords)
		end,
		IsCloseToVehicle = function(self, vehicle, coords)
			if not coords then
				coords = LocalPlayer.state.myPos
			end

			return IsCloseToVehicle(vehicle, coords)
		end,
	},
	Class = {
		Get = function(self, entity)
			local value = GetVehicleHandlingInt(entity, "CHandlingData", "nMonetaryValue")
			for k, v in pairs(_vehicleClasses) do
				if value == v.value then
					return k
				end
			end

			return "D"
		end,
		IsClass = function(self, entity, class)
			local entClass = Vehicle.Class:Get(entity)
			return entClass == class 
		end,
		IsClassOrHigher = function(self, entity, class)
			return _vehicleClasses[Vehicle.Class:Get(entity)].value >= _vehicleClasses[class]?.value or 10000
		end,
	}
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Vehicles", VEHICLE)
end)

AddEventHandler("Vehicles:Client:EnterVehicle", function(veh)
	local vehEnt = Entity(VEHICLE_INSIDE)

	TriggerEvent("Vehicles:Client:Seatbelt", false)

	Citizen.Wait(1000)

	TriggerEvent("Vehicles:Client:Ignition", vehEnt.state.VEH_IGNITION)
end)

AddEventHandler('Vehicles:Client:BecameDriver', function(veh, seat)
	local vehClass = Vehicles.Class:Get(VEHICLE_INSIDE)
    local vehEnt = Entity(VEHICLE_INSIDE)

    if vehEnt.state.VEH_IGNITION == nil then
        Vehicles.Engine:Force(VEHICLE_INSIDE, GetIsVehicleEngineRunning(VEHICLE_INSIDE))
	else
		Vehicles.Engine:Force(VEHICLE_INSIDE, vehEnt.state.VEH_IGNITION)
    end

    if GetVehicleClass(VEHICLE_INSIDE) == 13 then
        Vehicles.Engine:Force(VEHICLE_INSIDE, true)
    end

    while IsVehicleNeedsToBeHotwired(VEHICLE_INSIDE) do
        Citizen.Wait(0)
        SetVehicleNeedsToBeHotwired(VEHICLE_INSIDE, false)
    end

	SetVehRadioStation(VEHICLE_INSIDE, "OFF")

    if vehEnt.state.VEH_IGNITION then
        if not vehEnt.state.PlayerDriven then -- It was stolen directly with a ped in it, get keys
            Vehicles.Engine:Force(VEHICLE_INSIDE, true)
            Callbacks:ServerCallback('Vehicles:GetKeys', vehEnt.state.VIN, function()
                Notification:Success('You found the keys in the vehicle', 3000, 'key')
            end)
        end
    else
        if Vehicles.Keys:Has(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
            Action:Show('{keybind}toggle_engine{/keybind} Turn Engine On')
            _actionShowing = true
        end
    end

    vehEnt.state:set('PlayerDriven', true, true)
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function(veh)
	if _actionShowing then
		Action:Hide()
		_actionShowing = false
	end

    if veh and DoesEntityExist(veh) then
        local sb = Entity(veh).state
        if sb and sb.VEH_IGNITION then
            SetVehicleEngineOn(veh, true, true, true)
        else
            SetVehicleEngineOn(veh, false, true, true)
        end
    end
end)

AddEventHandler("Vehicles:Client:InspectVIN", function(entityData)
	if Vehicles:HasAccess(entityData.entity) then
		TriggerServerEvent("Vehicle:Server:InspectVIN", VehToNet(entityData.entity))
	end
end)

RegisterNetEvent("Vehicles:Client:ViewVIN", function(VIN)
	ListMenu:Show({
		main = {
			label = 'VIN Inspection',
			items = {
				{
					label = 'Vehicle Identification Number',
					description = VIN,
				},
			},
		},
	})
end)

RegisterNetEvent("Vehicles:Client:AttemptSlimJim", function()
	if not VEHICLE_INSIDE and _characterLoaded then
		local target = Targeting:GetEntityPlayerIsLookingAt()
		if
			target
			and target.entity
			and DoesEntityExist(target.entity)
			and IsEntityAVehicle(target.entity)
			and IsThisModelACar(GetEntityModel(target.entity))
			and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
		then
			Vehicles:SlimJim(target.entity)
		end
	end
end)

AddEventHandler("Vehicles:Client:StartUp", function()
	Callbacks:RegisterClientCallback("Vehicles:Slimjim", function(data, cb)
		print("Vehicles:Slimjim")
		if _characterLoaded and LocalPlayer.state.onDuty == "police" then
			if not VEHICLE_INSIDE then
				local target = Targeting:GetEntityPlayerIsLookingAt()
				if
					target
					and target.entity
					and DoesEntityExist(target.entity)
					and IsEntityAVehicle(target.entity)
					and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
				then
					local vehClass = _vehicleClasses.C
					if vehClass?.advLockpick then
						Vehicles:LockpickExterior(vehClass.advLockpick.exterior, data, target.entity, cb)
					else
						Notification:Error("Cannot Slimjim This Vehicle")
					end
				else
					print('nope2')
					cb(false, false)
				end
			end
		else
			print('nope')
			cb(false, false)
		end
	end)

	Callbacks:RegisterClientCallback("Vehicles:Lockpick", function(data, cb)
		if _characterLoaded then
			if VEHICLE_INSIDE then
				if VEHICLE_SEAT == -1 then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(VEHICLE_INSIDE)]
					if vehClass?.lockpick then
						Vehicles:Lockpick(vehClass.lockpick.interior, data, cb)
					else
						Notification:Error("Cannot Lockpick This Vehicle")
					end
				else
					cb(false, false)
				end
			else
				local target = Targeting:GetEntityPlayerIsLookingAt()
				if
					target
					and target.entity
					and DoesEntityExist(target.entity)
					and IsEntityAVehicle(target.entity)
					and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
				then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(target.entity)]
					if vehClass?.lockpick then
						Vehicles:LockpickExterior(vehClass.lockpick.exterior, data, target.entity, cb)
					else
						Notification:Error("Cannot Lockpick This Vehicle")
					end
				else
					cb(false, false)
				end
			end
		else
			cb(false, false)
		end
	end)

	Callbacks:RegisterClientCallback("Vehicles:AdvLockpick", function(data, cb)
		if _characterLoaded then
			if VEHICLE_INSIDE then
				if VEHICLE_SEAT == -1 then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(VEHICLE_INSIDE)]
					if vehClass?.advLockpick then
						Vehicles:Lockpick(vehClass.advLockpick.interior, data, cb)
					else
						Notification:Error("Cannot Lockpick This Vehicle")
					end
				else
					cb(false, false)
				end
			else
				local target = Targeting:GetEntityPlayerIsLookingAt()
				if
					target
					and target.entity
					and DoesEntityExist(target.entity)
					and IsEntityAVehicle(target.entity)
					and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
				then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(target.entity)]
					if vehClass?.advLockpick then
						Vehicles:LockpickExterior(vehClass.advLockpick.exterior, data, target.entity, cb)
					else
						Notification:Error("Cannot Lockpick This Vehicle")
					end
				else
					cb(false, false)
				end
			end
		else
			cb(false, false)
		end
	end)

	Callbacks:RegisterClientCallback("Vehicles:Hack", function(data, cb)
		if _characterLoaded then
			if VEHICLE_INSIDE then
				if VEHICLE_SEAT == -1 then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(VEHICLE_INSIDE)]
					if vehClass?.hack then
						Vehicles:Hack(vehClass?.hack.interior, data, cb)
					else
						Notification:Error("Cannot Hack This Vehicle")
					end
				else
					cb(false, false)
				end
			else
				local target = Targeting:GetEntityPlayerIsLookingAt()
				if
					target
					and target.entity
					and DoesEntityExist(target.entity)
					and IsEntityAVehicle(target.entity)
					and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
				then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(target.entity)]
					if vehClass?.hack then
						Vehicles:HackExterior(vehClass.hack.exterior, data, target.entity, cb)
					else
						Notification:Error("Cannot Hack This Vehicle")
					end
				else
					cb(false, false)
				end
			end
		else
			cb(false, false)
		end
	end)

	Callbacks:RegisterClientCallback("Vehicles:AdvHack", function(data, cb)
		if _characterLoaded then
			if VEHICLE_INSIDE then
				if VEHICLE_SEAT == -1 then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(VEHICLE_INSIDE)]
					if vehClass?.advHack then
						Vehicles:Hack(vehClass?.advHack.interior, data, cb)
					else
						Notification:Error("Cannot Hack This Vehicle")
					end
				else
					cb(false, false)
				end
			else
				local target = Targeting:GetEntityPlayerIsLookingAt()
				if
					target
					and target.entity
					and DoesEntityExist(target.entity)
					and IsEntityAVehicle(target.entity)
					and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0
				then
					local vehClass = _vehicleClasses[Vehicles.Class:Get(target.entity)]
					if vehClass?.advHack then
						Vehicles:HackExterior(vehClass.advHack.exterior, data, target.entity, cb)
					else
						Notification:Error("Cannot Hack This Vehicle")
					end
				else
					cb(false, false)
				end
			end
		else
			cb(false, false)
		end
	end)
end)
