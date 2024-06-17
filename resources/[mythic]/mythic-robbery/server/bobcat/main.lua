_bcInUse = {
	extrDoor = false,
	frontDoor = false,
	securedDoor = false,
	securityDoor = false,
	grabC4 = false,
	useC4 = false,
	loot = {},
	moneyTruckLoot = {},
	frontPc = false,
	securityPc = false,
}
_bcGlobalReset = nil

local _bobcatPeds = {}

local _pedsSpawned = false
local _alerted = false

local _eventLoot = false
local _eventLootItems = {
	'schematic_thermite',
	'schematic_mp5',
	'schematic_smg_ammo',
	'schematic_shotgun_ammo',
}

local _threading = nil
function StartCooldown()
	local timestamp = os.time()
	if _threading ~= nil then
		return
	end
	_threading = timestamp
	CreateThread(function()
		Wait(BC_RESET_TIME)

		if _threading == timestamp then
			ResetBobcat()
		end
	end)
end

function BobcatClearSourceInUse(source)
	for k, v in pairs(_bcInUse) do
		if v == source then
			_bcInUse[k] = nil
		elseif type(v) == "table" then
			for k2, v2 in pairs(v) do
				if v2 == source then
					_bcInUse[k][k2] = nil
				end
			end
		end
	end
end

AddEventHandler("Robbery:Server:Setup", function()
	StartBobcatThreads()
	GlobalState["Bobcat:LootLocations"] = _bobcatLootLocs

	Middleware:Add("playerDropped", BobcatClearSourceInUse)
	Middleware:Add("Characters:Logout", BobcatClearSourceInUse)

	Chat:RegisterAdminCommand("eventloot", function(source, args, rawCommand)
		_eventLoot = not _eventLoot
		if _eventLoot then
			Chat.Send.System:Single(source, "Bobcat Event Loot Enabled")
		else
			Chat.Send.System:Single(source, "Bobcat Event Loot Disabled")
		end
	end, {
		help = "Toggle Special Event Loot For Bobcat",
	}, 0)

	Inventory.Items:RegisterUse("thermite", "BobcatRobbery", function(source, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		local myPos = GetEntityCoords(GetPlayerPed(source))
		if
			(
				not GlobalState["AntiShitlord"]
				or os.time() > GlobalState["AntiShitlord"]
				or GlobalState["BobcatInProgress"]
			)
			and not GlobalState["Bobcat:Secured"]
			and not GlobalState["Bobcat:ExtrDoor"]
			and #(_bobcatLocations.extrDoor.coords - myPos) <= 3.5
		then
			if GetGameTimer() < BC_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not GlobalState["BobcatInProgress"]) then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
					6000
				)
				return
			elseif (GlobalState["Duty:police"] or 0) < BC_REQUIRED_POLICE and not GlobalState["BobcatInProgress"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
					6000
				)
				return
			elseif GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			end

			if not _bcInUse.extrDoor then
				_bcInUse.extrDoor = source
				if Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
					Logger:Info("Robbery", string.format("%s %s (%s) Started Thermiting Bobcat Exterior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
					Callbacks:ClientCallback(source, "Robbery:Games:Thermite", {
						passes = 1,
						location = _bobcatLocations.extrDoor,
						duration = 11000,
						config = {
							countdown = 3,
							preview = 1500,
							timer = 7500,
							passReduce = 500,
							base = 12,
							cols = 5,
							rows = 5,
							anim = false,
						},
						data = {},
					}, function(success)
						if success then
							Logger:Info("Robbery", string.format("%s %s (%s) Successfully Thermited Bobcat Exterior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
							if not GlobalState["AntiShitlord"] or os.time() >= GlobalState["AntiShitlord"] then
								GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
							end

							GlobalState["Bobcat:ExtrDoor"] = true
							GlobalState["BobcatInProgress"] = true

							if not _bcGlobalReset then
								_bcGlobalReset = os.time() + BC_RESET_TIME
							end

							Doors:SetLock("bobcat_extr", false)
							if not _alerted or os.time() > _alerted then
								Robbery:TriggerPDAlert(
									source,
									vector3(879.020, -2263.657, 30.468),
									"10-90",
									"Armed Robbery",
									{
										icon = 586,
										size = 0.9,
										color = 31,
										duration = (60 * 5),
									},
									{
										icon = "shield-quartered",
										details = 'Bobcat Security',
									},
									'bobcat'
								)
								_alerted = os.time() + (60 * 10)
							end
						else
							Logger:Info("Robbery", string.format("%s %s (%s) Failed Thermiting Bobcat Exterior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
						end
						_bcInUse.extrDoor = false
					end)
				end
			else
				Execute:Client(source, "Notification", "Error", "Someone Is Already Doing This", 6000)
			end
		else
			if pState.inBobcat then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["BobcatInProgress"]
					)
					and GlobalState["Bobcat:ExtrDoor"]
					and not GlobalState["Bobcat:FrontDoor"]
					and not GlobalState["Bobcat:Secured"]
					and #(_bobcatLocations.startDoor.coords - myPos) <= 3.5
				then
					if
						GetGameTimer() < BC_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not GlobalState["BobcatInProgress"])
					then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif (GlobalState["Duty:police"] or 0) < BC_REQUIRED_POLICE and not GlobalState["BobcatInProgress"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
							6000
						)
						return
					elseif GlobalState["RobberiesDisabled"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Temporarily Disabled, Please See City Announcements",
							6000
						)
						return
					end

					if not _bcInUse.frontDoor then
						_bcInUse.frontDoor = source
						if Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
							Logger:Info("Robbery", string.format("%s %s (%s) Started Thermiting Bobcat Interior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
							Callbacks:ClientCallback(source, "Robbery:Games:Thermite", {
								passes = 1,
								location = _bobcatLocations.startDoor,
								duration = 11000,
								config = {
									countdown = 3,
									preview = 1500,
									timer = 7500,
									passReduce = 500,
									base = 12,
									cols = 5,
									rows = 5,
									anim = false,
								},
								data = {},
							}, function(success)
								if success then
									Logger:Info("Robbery", string.format("%s %s (%s) Successfully Thermited Bobcat Interior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
									if not GlobalState["AntiShitlord"] or os.time() >= GlobalState["AntiShitlord"] then
										GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
									end

									GlobalState["Bobcat:FrontDoor"] = true
									GlobalState["BobcatInProgress"] = true

									if not _bcGlobalReset then
										_bcGlobalReset = os.time() + BC_RESET_TIME
									end

									Doors:SetLock("bobcat_front", false)
									if not _alerted or os.time() > _alerted then
										Robbery:TriggerPDAlert(
											source,
											vector3(879.020, -2263.657, 30.468),
											"10-90",
											"Armed Robbery",
											{
												icon = 586,
												size = 0.9,
												color = 31,
												duration = (60 * 5),
											},
											{
												icon = "shield-quartered",
												details = 'Bobcat Security',
											},
											'bobcat'
										)
										_alerted = os.time() + (60 * 10)
									end
								else
									Logger:Info("Robbery", string.format("%s %s (%s) Failed Thermiting Bobcat Interior Door", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
								end
								_bcInUse.frontDoor = false
							end)
						end
					else
						Execute:Client(source, "Notification", "Error", "Someone Is Already Doing This", 6000)
					end
				end
			else
				Callbacks:ClientCallback(source, "Robbery:Moneytruck:CheckForTruck", {}, function(type, vNet)
					if type ~= nil then
						local ent = NetworkGetEntityFromNetworkId(vNet)
						local entState = Entity(ent).state

						-- if
						-- 	GetGameTimer() < BCT_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not entState.robberyInProgress)
						-- then
						-- 	Execute:Client(
						-- 		source,
						-- 		"Notification",
						-- 		"Error",
						-- 		"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
						-- 		6000
						-- 	)
						-- 	return
						-- elseif (GlobalState["Duty:police"] or 0) < BCT_REQUIRED_POLICE and not entState.robberyInProgress then
						-- 	Execute:Client(
						-- 		source,
						-- 		"Notification",
						-- 		"Error",
						-- 		"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
						-- 		6000
						-- 	)
						-- 	return
						-- elseif GlobalState["RobberiesDisabled"] then
						-- 	Execute:Client(
						-- 		source,
						-- 		"Notification",
						-- 		"Error",
						-- 		"Temporarily Disabled, Please See City Announcements",
						-- 		6000
						-- 	)
						-- 	return
						-- end

						if not entState.robberyInProgress then
							entState.robberyInProgress = source
							if not entState.wasThermited then
								if
									Inventory.Items:RemoveSlot(
										itemData.Owner,
										itemData.Name,
										1,
										itemData.Slot,
										itemData.invType
									)
								then
									Logger:Info("Robbery", string.format("%s %s (%s) Started Thermiting Moneytruck", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
									Callbacks:ClientCallback(source, "Robbery:Moneytruck:Thermite:Door", {
										vNet = vNet,
										passes = 1,
										location = _bobcatLocations.startDoor,
										duration = 3000,
										config = {
											countdown = 3,
											preview = 2000,
											timer = 7500,
											passReduce = 500,
											base = 9,
											cols = 5,
											rows = 5,
											anim = false,
										},
										data = {},
									}, function(success)
										if success then
											Logger:Info("Robbery", string.format("%s %s (%s) Successfully Thermited Moneytruck", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
											local peds = {}

											SetVehicleDoorsLocked(ent, 3)
											FreezeEntityPosition(ent, 1)

											local amount = 4
											if type == 2 then
												amount = 8
											end

											-- for i = 1, amount do
											-- 	local model = `S_M_M_Security_01`
											-- 	if type == 2 then
											-- 		model = `s_m_m_armoured_03`
											-- 	end

											-- 	local coords = GetEntityCoords(ent)

											-- 	local p = CreatePed(5, GetHashKey("s_m_m_armoured_03"), coords.x + math.random(-5, 5), coords.y + math.random(-5, 5), coords.z, math.random(360) * 1.0, true, true)
											-- 	local w = _bobcatWeapons[math.random(#_bobcatWeapons)]
											-- 	Entity(p).state.crimePed = true
											-- 	GiveWeaponToPed(p, w, 99999, false, true)
											-- 	SetCurrentPedWeapon(p, w, true)
											-- 	SetPedArmour(p, 1000)

											-- 	while not DoesEntityExist(p) do
											-- 		Wait(1)
											-- 	end

											-- 	table.insert(peds, NetworkGetNetworkIdFromEntity(p))
											-- end

											Wait(300)

											Entity(ent).state.wasThermited = true

											Robbery:TriggerPDAlert(
												source,
												GetEntityCoords(ent),
												"10-90",
												"Armored Truck Robbery",
												{
													icon = 477,
													size = 0.9,
													color = 50,
													duration = (60 * 5),
												},
												{
													icon = "truck-field",
													details = type == 2 and 'Bobcat Security' or 'Gruppe 6',
												}
											)

											Callbacks:ClientCallback(
												source,
												"Robbery:MoneyTruck:CreatePeds",
												{
													netId = vNet,
													amount = amount
												},
												function() end
											)

											-- Callbacks:ClientCallback(
											-- 	source,
											-- 	"Robbery:Bobcat:SetupPeds",
											-- 	{
											-- 		peds = peds,
											-- 		isBobcat = false,
											-- 		skipLeaveVeh = true
											-- 	},
											-- 	function() end
											-- )
										else
											Logger:Info("Robbery", string.format("%s %s (%s) Failed Thermiting Moneytruck", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
										end
										entState.robberyInProgress = false
									end)
								end
							else
								Execute:Client(source, "Notification", "Error", "This Truck Has Already Been Hit", 6000)
							end
						else
							Execute:Client(source, "Notification", "Error", "Someone Is Already Doing This", 6000)
						end
					end
				end)
			end
		end
	end)

	Inventory.Items:RegisterUse("bobcat_charge", "BobcatRobbery", function(source, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inBobcat then
			if
				(
					not GlobalState["AntiShitlord"]
					or os.time() >= GlobalState["AntiShitlord"]
					or GlobalState["BobcatInProgress"]
				)
				and GlobalState["Bobcat:ExtrDoor"]
				and GlobalState["Bobcat:FrontDoor"]
				and GlobalState["Bobcat:SecuredDoor"]
				and GlobalState["BobcatC4"]
				and not GlobalState["Bobcat:Secured"]
			then
				local myPos = GetEntityCoords(GetPlayerPed(source))
				if #(_bobcatLocations.vaultDoor.coords - myPos) <= 3.5 then
					if GetGameTimer() < BC_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not GlobalState["BobcatInProgress"]) then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif (GlobalState["Duty:police"] or 0) < BC_REQUIRED_POLICE and not GlobalState["BobcatInProgress"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
							6000
						)
						return
					elseif GlobalState["RobberiesDisabled"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Temporarily Disabled, Please See City Announcements",
							6000
						)
						return
					end

					if not _bcInUse.useC4 then
						_bcInUse.useC4 = source
						if Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
							Logger:Info("Robbery", string.format("%s %s (%s) Started Breaching Bobcat Vault", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
							Callbacks:ClientCallback(source, "Robbery:Games:Aim", {
								location = {
									coords = vector3(890.41, -2285.601, 30.467),
									heading = 93.374,
								},
								duration = 11000,
								config = {
									countdown = 3,
									limit = 15750,
									timer = 500,
									startSize = 20,
									maxSize = 75,
									growthRate = 20,
									accuracy = 75,
									isMoving = false,
									anim = false,
								},
								data = {},
							}, function(success, data)
								GlobalState["BobcatInProgress"] = true
	
								if success then
									Logger:Info("Robbery", string.format("%s %s (%s) Successfully Breached Bobcat Vault", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
									GlobalState["Bobcat:VaultDoor"] = true
									TriggerClientEvent("Robbery:Client:Bobcat:UpdateIPL", -1, true)

									if not _bcGlobalReset then
										_bcGlobalReset = os.time() + BC_RESET_TIME
									end
								else
									Logger:Info("Robbery", string.format("%s %s (%s) Failed Breaching Bobcat Vault", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
									GlobalState["Bobcat:VaultDoor"] = false
									GlobalState["BobcatC4"] = false
								end
								_bcInUse.useC4 = false
							end)
						end
					else
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Someone Else Is Already Doing A Thing",
							6000
						)
					end
				end
			end
		end
	end)

	Inventory.Items:RegisterUse("blue_laptop", "BobcatRobbery", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inBobcat then
			local ped = GetPlayerPed(source)
			local myCoords = GetEntityCoords(ped)

			if
				(
					not GlobalState["AntiShitlord"]
					or os.time() >= GlobalState["AntiShitlord"]
					or GlobalState["BobcatInProgress"]
				)
				and GlobalState["Bobcat:ExtrDoor"]
				and GlobalState["Bobcat:FrontDoor"]
				and not GlobalState["Bobcat:Secured"]
			then
				if #(_bobcatLocations.securedDoor.coords - myCoords) <= 1.5 then
					if GetGameTimer() < BC_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not GlobalState["BobcatInProgress"]) then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif (GlobalState["Duty:police"] or 0) < BC_REQUIRED_POLICE and not GlobalState["BobcatInProgress"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
							6000
						)
						return
					elseif GlobalState["RobberiesDisabled"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Temporarily Disabled, Please See City Announcements",
							6000
						)
						return
					end

					if not _bcInUse.securedDoor then
						_bcInUse.securedDoor = source
						Logger:Info("Robbery", string.format("%s %s (%s) Started Hacking Bobcat Doors", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
						Callbacks:ClientCallback(source, "Robbery:Games:Laptop", {
							location = {
								coords = vector3(883.116, -2267.680, 30.468),
								heading = 178.302
							},
							config = {
								countdown = 3,
								timer = { 1700, 2400 },
								limit = 20000,
								difficulty = 4,
								chances = 6,
								isShuffled = false,
								anim = false,
							},
							data = {},
						}, function(success, data)
							if success then
								Logger:Info("Robbery", string.format("%s %s (%s) Successfully Hacked Bobcat Doors", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
								GlobalState["Bobcat:SecuredDoor"] = true
								GlobalState["BobcatInProgress"] = true
	
								_bobcatPeds = SpawnPeds(source)
								Callbacks:ClientCallback(source, "Robbery:Bobcat:SetupPeds", {
									peds = _bobcatPeds,
									isBobcat = true,
									skipLeaveVeh = true,
								}, function() end)
								Doors:SetLock("bobcat_inner", false)
								Execute:Client(source, "Notification", "Success", "Doorlock Disengaged", 6000)
								Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)

								if not _bcGlobalReset then
									_bcGlobalReset = os.time() + BC_RESET_TIME
								end
							else
								Logger:Info("Robbery", string.format("%s %s (%s) Failed Hacking Bobcat Doors", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
								Doors:SetLock("bobcat_inner", true)
								Status.Modify:Add(source, "PLAYER_STRESS", 6)
						
								local newValue = slot.CreateDate - math.ceil(itemData.durability / 4)
								if (os.time() - itemData.durability >= newValue) then
									Inventory.Items:RemoveId(char:GetData("SID"), 1, slot)
								else
									Inventory:SetItemCreateDate(
										slot.id,
										newValue
									)
								end
							end
							_bcInUse.securedDoor = false
						end)
					else
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Someone Else Is Already Doing A Thing",
							6000
						)
					end
				end
			else
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporary Emergency Systems Enabled, Check Beck In A Bit",
					6000
				)
			end
		end
	end)

	Inventory.Items:RegisterUse("gps_tracker", "BobcatRobbery", function(source, slot, itemData)
		if _truckSpawnEnabled then
			if #_moneyTruckSpawns == 0 then
				_moneyTruckSpawns = table.copy(_spawnHoldingShit)
			end

			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local pState = Player(source).state

					Execute:Client(
						source,
						"Notification",
						"Info",
						"Locating Truck...",
						6000
					)

					local m = `stockade`
					if math.random(100) <= 25 then
						m = `stockade2`
					end
					local netId = SpawnBobcatTruck(m)
			
					if not netId then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Unable To Locate A Truck",
							6000
						)
					else
						Logger:Info("Robbery", string.format("%s %s (%s) Used Money Truck GPS Tracker", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
						Callbacks:ClientCallback(source, "Robbery:MoneyTruck:MarkTruck", netId, function(r) 
							if r then
								Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)
								Execute:Client(
									source,
									"Notification",
									"Success",
									"A Truck Has Been Marked On Your GPS",
									6000
								)
							end
						end)
					end
				end
			end
		else
			Execute:Client(
				source,
				"Notification",
				"Error",
				"No Trucks Currently Available, Try Again Later",
				6000
			)
		end
	end)

	Inventory.Items:RegisterUse("fleeca_tracker", "BobcatRobbery", function(source, slot, itemData)
		if _truckSpawnEnabled then
			if #_moneyTruckSpawns == 0 then
				_moneyTruckSpawns = table.copy(_spawnHoldingShit)
			end

			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local pState = Player(source).state

					Execute:Client(
						source,
						"Notification",
						"Info",
						"Locating Truck...",
						6000
					)

					local netId = SpawnBobcatTruck(`stockade`)
			
					if not netId then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Unable To Locate A Truck",
							6000
						)
					else
						Logger:Info("Robbery", string.format("%s %s (%s) Used Fleeca Money Truck GPS Tracker", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
						Callbacks:ClientCallback(source, "Robbery:MoneyTruck:MarkTruck", netId, function(r) 
							if r then
								Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)
								Execute:Client(
									source,
									"Notification",
									"Success",
									"A Truck Has Been Marked On Your GPS",
									6000
								)
							end
						end)
					end
				end
			end
		else
			Execute:Client(
				source,
				"Notification",
				"Error",
				"No Trucks Currently Available, Try Again Later",
				6000
			)
		end
	end)

	Inventory.Items:RegisterUse("bobcat_tracker", "BobcatRobbery", function(source, slot, itemData)
		if _truckSpawnEnabled then
			if #_moneyTruckSpawns == 0 then
				_moneyTruckSpawns = table.copy(_spawnHoldingShit)
			end

			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local pState = Player(source).state

					Execute:Client(
						source,
						"Notification",
						"Info",
						"Locating Truck...",
						6000
					)

					local netId = SpawnBobcatTruck(`stockade2`)
			
					if not netId then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Unable To Locate A Truck",
							6000
						)
					else
						Logger:Info("Robbery", string.format("%s %s (%s) Used Bobcat Money Truck GPS Tracker", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
						Callbacks:ClientCallback(source, "Robbery:MoneyTruck:MarkTruck", netId, function(r) 
							if r then
								Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)
								Execute:Client(
									source,
									"Notification",
									"Success",
									"A Truck Has Been Marked On Your GPS",
									6000
								)
							end
						end)
					end
				end
			end
		else
			Execute:Client(
				source,
				"Notification",
				"Error",
				"No Trucks Currently Available, Try Again Later",
				6000
			)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:PickupC4", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local pState = Player(source).state

				if pState.inBobcat then
					if
						(
							not GlobalState["AntiShitlord"]
							or os.time() > GlobalState["AntiShitlord"]
							or GlobalState["BobcatInProgress"]
						)
						and not GlobalState["BobcatC4"]
						and GlobalState["Bobcat:ExtrDoor"]
						and GlobalState["Bobcat:FrontDoor"]
						and GlobalState["Bobcat:SecuredDoor"]
						and not GlobalState["Bobcat:Secured"]
					then
						if GetGameTimer() < BC_SERVER_START_WAIT or (GlobalState["RestartLockdown"] and not GlobalState["BobcatInProgress"]) then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
								6000
							)
							return
						elseif (GlobalState["Duty:police"] or 0) < BC_REQUIRED_POLICE and not GlobalState["BobcatInProgress"] then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
								6000
							)
							return
						elseif GlobalState["RobberiesDisabled"] then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Temporarily Disabled, Please See City Announcements",
								6000
							)
							return
						end

						if not _bcInUse.grabC4 then
							_bcInUse.grabC4 = source
							if Inventory:AddItem(char:GetData("SID"), "bobcat_charge", 1, {}, 1) then
								GlobalState["BobcatC4"] = true
								GlobalState["BobcatInProgress"] = true

								if not _bcGlobalReset then
									_bcGlobalReset = os.time() + BC_RESET_TIME
								end
							end
							_bcInUse.grabC4 = false
						else
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Someone Else Is Already Doing A Thing",
								6000
							)
						end
					end
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:DoThermiteFx", function(source, data, cb)
		TriggerClientEvent("Robbery:Client:ThermiteFx", -1, data.delay or 13000, data.netId)
	end)

	Callbacks:RegisterServerCallback("Robbery:DoBombFx", function(source, data, cb)
		TriggerClientEvent("Robbery:Client:BombFx", -1, data)
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:CheckLoot", function(source, data, cb)
		local pState = Player(source).state

		if
			pState.inBobcat
			and (not GlobalState["AntiShitlord"] or os.time() > GlobalState["AntiShitlord"] or GlobalState["BobcatInProgress"])
			and GlobalState["Bobcat:ExtrDoor"]
			and GlobalState["Bobcat:FrontDoor"]
			and GlobalState["Bobcat:SecuredDoor"]
			and GlobalState["Bobcat:VaultDoor"]
			and not GlobalState["Bobcat:Secured"]
			and not GlobalState[string.format("Bobcat:Loot:%s", data.id)]
			and _bobcatLootLocs[data.id] ~= nil
		then
			if not _bcInUse.loot[data.id] then
				GlobalState[string.format("Bobcat:Loot:%s", data.id)] = true
				_bcInUse.loot[data.id] = source
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:CancelLoot", function(source, data, cb)
		local pState = Player(source).state

		if
			pState.inBobcat
			and (not GlobalState["AntiShitlord"] or os.time() > GlobalState["AntiShitlord"] or GlobalState["BobcatInProgress"])
			and GlobalState["Bobcat:ExtrDoor"]
			and GlobalState["Bobcat:FrontDoor"]
			and GlobalState["Bobcat:SecuredDoor"]
			and GlobalState["Bobcat:VaultDoor"]
			and _bobcatLootLocs[data.id] ~= nil
		then
			if _bcInUse.loot[data.id] == source then
				GlobalState[string.format("Bobcat:Loot:%s", data.id)] = false
				_bcInUse.loot[data.id] = false
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:Loot", function(source, data, cb)
		local pState = Player(source).state

		if
			pState.inBobcat
			and (not GlobalState["AntiShitlord"] or os.time() > GlobalState["AntiShitlord"] or GlobalState["BobcatInProgress"])
			and GlobalState["Bobcat:ExtrDoor"]
			and GlobalState["Bobcat:FrontDoor"]
			and GlobalState["Bobcat:SecuredDoor"]
			and GlobalState["Bobcat:VaultDoor"]
			and not GlobalState["Bobcat:Secured"]
			and _bobcatLootLocs[data.id] ~= nil
		then
			if _bcInUse.loot[data.id] == source then
				local actualData = _bobcatLootLocs[data.id]
				if actualData.data.type == data.type then
					local plyr = Fetch:Source(source)
					if plyr ~= nil then
						local char = plyr:GetData("Character")
						if char ~= nil then
							Logger:Info("Robbery", string.format("%s %s (%s) Looted Bobcat Loot Crate #%s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), data.id))

							for i = 1, actualData.data.amount do
								Loot:CustomWeightedSetWithCount(_bobcatLootTable[data.type], char:GetData("SID"), 1)
							end
							if math.random(100) <= actualData.data.bonus then
								Loot:CustomWeightedSetWithCount(_bobcatLootTable[data.type], char:GetData("SID"), 1)
							end

							if _eventLoot and data.id == 1 then
								for k, v in ipairs(_eventLootItems) do
									Inventory:AddItem(char:GetData("SID"), v, 1, {}, 1)
								end
								_eventLoot = false
							end

							if not _bcGlobalReset then
								_bcGlobalReset = os.time() + BC_RESET_TIME
							end

							TriggerClientEvent("Weapons:Client:Attach", source)

							_bcInUse.loot[data.id] = false
						else
							_bcInUse.loot[data.id] = false
							cb(false)
						end
					else
						GlobalState[string.format("Bobcat:Loot:%s", data.id)] = true
						_bcInUse.loot[data.id] = false
						cb(false)
					end
				else
					GlobalState[string.format("Bobcat:Loot:%s", data.id)] = true
					_bcInUse.loot[data.id] = false
					-- Dumb cunt trying to cheat :)
					cb(false)
				end
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:Secure", function(source, data, cb)
		local pState = Player(source).state
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if pState.onDuty == "police" then
					Logger:Info("Robbery", string.format("%s %s (%s) Secured Bobcat Security", char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
					SecureBobcat()
					Execute:Client(source, "Notification", "Success", "Building Secure", 6000)
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:CheckFrontPC", function(source, data, cb)
		if not _bcInUse.frontPc and not GlobalState["Bobcat:PCHacked"] then
			_bcInUse.frontPc = source
			cb({
				passes = 3,
				config = {
					preview = 3,
					timer = 1500,
					limit = 15000,
					difficulty = 4,
					difficulty2 = 2,
					anim = {
						anim = "type",
					},
				},
				data = {},
			})
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Bobcat:FrontPCResults", function(source, data, cb)
		if _bcInUse.frontPc == source and not GlobalState["Bobcat:PCHacked"] then
			if data?.state then
				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						if Inventory:AddItem(char:GetData("SID"), "bobcat_tracker", 1, {}, 1) then
							_bcInUse.frontPc = false
							GlobalState["Bobcat:PCHacked"] = true
							cb(true)
						else
							cb(false)
						end
					else
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	-- Callbacks:RegisterServerCallback("Robbery:Bobcat:CheckSecurityPC", function(source, data, cb)
	-- 	if not _bcInUse.securityPc and not GlobalState["Bobcat:SecurityPCHacked"] then
	-- 		_bcInUse.securityPc = source
	-- 		cb({
	-- 			passes = 3,
	-- 			config = {
	-- 				preview = 3,
	-- 				timer = 1500,
	-- 				limit = 15000,
	-- 				difficulty = 4,
	-- 				difficulty2 = 2,
	-- 				anim = {
	-- 					anim = "type",
	-- 				},
	-- 			},
	-- 			data = {},
	-- 		})
	-- 	else
	-- 		cb(false)
	-- 	end
	-- end)

	-- Callbacks:RegisterServerCallback("Robbery:Bobcat:SecurityPCResults", function(source, data, cb)
	-- 	if _bcInUse.frontPc == source and not GlobalState["Bobcat:SecurityPCHacked"] then
	-- 		if data then
	-- 			local plyr = Fetch:Source(source)
	-- 			if plyr ~= nil then
	-- 				local char = plyr:GetData("Character")
	-- 				if char ~= nil then
	-- 					if Inventory:AddItem(char:GetData("SID"), "moneytruck_map", 1, {}, 1) then
	-- 						_bcInUse.securityPc = false
	-- 						GlobalState["Bobcat:SecurityPCHacked"] = true
	-- 					end
	-- 				else
	-- 					cb(false)
	-- 				end
	-- 			else
	-- 				cb(false)
	-- 			end
	-- 		else
	-- 			cb(false)
	-- 		end
	-- 	else
	-- 		cb(false)
	-- 	end
	-- end)

	Middleware:Add("Characters:Logout", RemoveC4, 1)
	Middleware:Add("playerDropped", RemoveC4, 1)
	Callbacks:RegisterServerCallback("Robbery:Bobcat:LeftBuilding", function(source, data, cb)
		cb(RemoveC4(source))
	end)
end)

function SecureBobcat()
	Doors:SetLock("bobcat_inner", true)
	GlobalState["Bobcat:SecuredDoor"] = false
	GlobalState["BobcatInProgress"] = false
	GlobalState["Bobcat:Secured"] = true

	if not _bcGlobalReset then
		_bcGlobalReset = os.time() + BC_RESET_TIME
	end

	for k, v in ipairs(_bobcatPeds) do
		local ent = NetworkGetEntityFromNetworkId(v)
		if ent ~= 0 then
			DeleteEntity(ent)
		end
	end
	_bobcatPeds = {}
	_pedsSpawned = false
	_eventLoot = false

	for k, v in pairs(_bcInUse) do
		if k ~= 'loot' then
			_bcInUse[v] = false
		else
			for k2, v2 in pairs(v) do
				_bcInUse[k][k2] = false
			end
		end
	end
end

function ResetBobcat()
	Doors:SetLock("bobcat_extr", true)
	Doors:SetLock("bobcat_front", true)
	Doors:SetLock("bobcat_inner", true)

	GlobalState["Bobcat:ExtrDoor"] = false
	GlobalState["Bobcat:FrontDoor"] = false
	GlobalState["Bobcat:SecuredDoor"] = false
	GlobalState["Bobcat:VaultDoor"] = false

	for k, v in ipairs(_bobcatLootLocs) do
		GlobalState[string.format("Bobcat:Loot:%s", v.data.id)] = false
	end

	GlobalState["Bobcat:Secured"] = false
	GlobalState["BobcatInProgress"] = false

	for k, v in ipairs(_bobcatPeds) do
		local ent = NetworkGetEntityFromNetworkId(v)
		if ent ~= 0 then
			DeleteEntity(ent)
		end
	end
	_bobcatPeds = {}
	_pedsSpawned = false
	_eventLoot = false
	_bcGlobalReset = nil

	TriggerClientEvent("Robbery:Client:Bobcat:UpdateIPL", -1, false)
end

function RemoveC4(source)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		local char = plyr:GetData("Character")
		if char ~= nil then
			Inventory.Items:RemoveAll(char:GetData("SID"), 1, "bobcat_charge")
			GlobalState["BobcatC4"] = false
			return true
		end
	end

	return false
end

function SpawnPeds(source)
	if _pedsSpawned then
		return
	end
	_pedsSpawned = true

	local peds = {}

	for k, v in ipairs(_bobcatPedLocs) do
		local p = CreatePed(5, GetHashKey("s_m_m_armoured_03"), v[1], v[2], v[3], v[4], true, true)
		local w = _bobcatWeapons[math.random(#_bobcatWeapons)]
		Entity(p).state.crimePed = true
		GiveWeaponToPed(p, w, 99999, false, true, true)
		SetCurrentPedWeapon(p, w, true)
		SetPedArmour(p, 600)
		--TaskCombatPed(p, GetPlayerPed(source), 0, 16)

		table.insert(peds, NetworkGetNetworkIdFromEntity(p))
		Wait(3)
	end

	Wait(1000)

	return peds
end
