_mbInUse = {
	mazebank_gate = false,
	mazebank_tills = false,
	mazebank_vault_gate = false,
	mazebank_offices = false,
	mazebank_office_1 = false,
	mazebank_office_2 = false,
	mazebank_office_3 = false,
	powerBoxes = {},
	drillPoints = {},
	officePcs = {},
}

_mbGlobalReset = nil
_mbAlerted = false
_mbPowerAlerted = false

local _heistCoin = false
local _officesLooted = 1

local _purpDongie = false

local _mbLoot = {
	{ 60, { name = "moneyroll", min = 360, max = 440 } },
	{ 33, { name = "moneyband", min = 36, max = 44 } },
	{ 5, { name = "valuegoods", min = 20, max = 28 } },
	{ 2, { name = "moneybag", min = 4, max = 6 } },
}

function MazeBankClearSourceInUse(source)
	for k, v in pairs(_mbInUse) do
		if v == source then
			_mbInUse[k] = nil
		elseif type(v) == "table" then
			for k2, v2 in pairs(v) do
				if v2 == source then
					_mbInUse[k][k2] = nil
				end
			end
		end
	end
end

function IsMBPowerDisabled()
	for k, v in ipairs(_mbElectric) do
		if
			not GlobalState[string.format("MazeBank:Power:%s", v.data.boxId)]
			or os.time() > GlobalState[string.format("MazeBank:Power:%s", v.data.boxId)]
		then
			return false
		end
	end
	return true
end

function MazeBankDisablePower(source)
	if not _mbGlobalReset or os.time() > _mbGlobalReset then
		_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
	end
	for k, v in ipairs(_mbElectric) do
		GlobalState[string.format("MazeBank:Power:%s", v.data.boxId)] = _mbGlobalReset
	end

	Robbery:TriggerPDAlert(source, vector3(-1332.651, -846.451, 17.080), "10-33", "Minor Power Grid Disruption", {
		icon = 354,
		size = 0.9,
		color = 31,
		duration = (60 * 5),
	}, {
		icon = "bolt-slash",
		details = "Del Perro",
	}, false, 50.0)
	GlobalState["Fleeca:Disable:mazebank_baycity"] = true
end

function ResetMazeBank()
	_mbGlobalReset = nil

	for k, v in pairs(_mbElectric) do
		GlobalState[string.format("MazeBank:Power:%s", v.data.boxId)] = nil
	end

	for k, v in ipairs(_mbDrillPoints) do
		GlobalState[string.format("MazeBank:Vault:Wall:%s", v.data.wallId)] = nil
	end

	for k, v in ipairs(_mbDesks) do
		GlobalState[string.format("MazeBank:Offices:PC:%s", v.data.deskId)] = nil
	end

	Doors:SetLock("mazebank_offices", true)
	CCTV.State.Group:Online("mazebank")
	for k, v in pairs(_mbDoors) do
		Doors:SetLock(v.door, true)
	end

	for k, v in ipairs(_mbOfficeDoors) do
		Doors:SetLock(v.door, true)
	end

	for k, v in ipairs(_mbHacks) do
		GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] = nil
		TriggerClientEvent("Robbery:Client:MazeBank:CloseVaultDoor", -1, v)
	end
	
	_heistCoin = false
	_officesLooted = 1

	_mbAlerted = false
	_mbPowerAlerted = false

	GlobalState["Fleeca:Disable:mazebank_baycity"] = false
	_purpDongie = false
	GlobalState["MazeBankInProgress"] = false
	GlobalState["MazeBank:Secured"] = false
end

function SecureMazeBank()
	_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME

	for k, v in pairs(_mbElectric) do
		GlobalState[string.format("MazeBank:Power:%s", v.data.boxId)] = nil
	end

	for k, v in ipairs(_mbDrillPoints) do
		GlobalState[string.format("MazeBank:Vault:Wall:%s", v.data.wallId)] = nil
	end

	for k, v in ipairs(_mbDesks) do
		GlobalState[string.format("MazeBank:Offices:PC:%s", v.data.deskId)] = nil
	end

	Doors:SetLock("mazebank_offices", true)
	CCTV.State.Group:Online("mazebank")
	for k, v in ipairs(_mbDoors) do
		Doors:SetLock(v.door, true)
	end

	for k, v in ipairs(_mbOfficeDoors) do
		Doors:SetLock(v.door, true)
	end

	for k, v in ipairs(_mbHacks) do
		GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] = {
			state = 4,
			expires = _mbGlobalReset,
		}
		TriggerClientEvent("Robbery:Client:MazeBank:CloseVaultDoor", -1, v)
	end

	_heistCoin = false
	_officesLooted = 1

	GlobalState["Fleeca:Disable:mazebank_baycity"] = false
	GlobalState["MazeBankInProgress"] = false
	GlobalState["MazeBank:Secured"] = _mbGlobalReset
end

AddEventHandler("Robbery:Server:Setup", function()
	StartMazeBankThreads()
	RegisterMBItemUses()

	Middleware:Add("playerDropped", MazeBankClearSourceInUse)
	Middleware:Add("Characters:Logout", MazeBankClearSourceInUse)

	Chat:RegisterAdminCommand("resetmb", function(source, args, rawCommand)
		ResetMazeBank()
	end, {
		help = "Force Reset Maze Bank Heist",
	}, 0)

	Callbacks:RegisterServerCallback("Robbery:MazeBank:SecureBank", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Player(source).state.onDuty == "police" then
					SecureMazeBank()
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MazeBank:ElectricBox:Hack", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["MazeBankInProgress"]
					) and not GlobalState["MazeBank:Secured"]
				then
					if
						GetGameTimer() < MAZEBANK_SERVER_START_WAIT
						or (GlobalState["RestartLockdown"] and not GlobalState["MazeBankInProgress"])
					then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Network Offline For A Storm, Check Back Later",
							6000
						)
						return
					elseif
						(GlobalState["Duty:police"] or 0) < MAZEBANK_REQUIRED_POLICE
						and not GlobalState["MazeBankInProgress"]
					then
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
					elseif
						GlobalState[string.format("MazeBank:Power:%s", data.boxId)] ~= nil
						and GlobalState[string.format("MazeBank:Power:%s", data.boxId)] > os.time()
					then
						Execute:Client(source, "Notification", "Error", "Electric Box Already Disabled", 6000)
						return
					end
					if not _mbInUse.powerBoxes[data.boxId] then
						_mbInUse.powerBoxes[data.boxId] = source
						GlobalState["MazeBankInProgress"] = true

						if Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1) then
							local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
							local itemData = Inventory.Items:GetData("adv_electronics_kit")

							if itemData ~= nil then
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Started Hacking Maze Bank Power Box %s",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID"),
										data.boxId
									)
								)
								Callbacks:ClientCallback(source, "Robbery:Games:Hack", {
									config = {
										countdown = 3,
										timer = 5,
										limit = 18000,
										delay = 2000,
										difficulty = 8,
										chances = 6,
										anim = false,
									},
									data = {},
								}, function(success)
									local newValue = slot.CreateDate - (60 * 60 * 24)
									if success then
										newValue = slot.CreateDate - (60 * 60 * 12)
									end
									if os.time() - itemData.durability >= newValue then
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
									else
										Inventory:SetItemCreateDate(slot.id, newValue)
									end

									if success then
										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Successfully Hacked Maze Bank Power Box %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												data.boxId
											)
										)
										if
											not GlobalState["AntiShitlord"]
											or os.time() >= GlobalState["AntiShitlord"]
										then
											GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
										end

										_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME

										GlobalState[string.format("MazeBank:Power:%s", data.boxId)] = _mbGlobalReset
										TriggerEvent("Particles:Server:DoFx", data.ptFxPoint, "spark")
										if IsMBPowerDisabled() then
											Doors:SetLock("mazebank_offices", false)
											CCTV.State.Group:Offline("mazebank")
											Sounds.Play:Location(
												source,
												data.ptFxPoint,
												15.0,
												"power_small_complete_off.ogg",
												0.1
											)
											Robbery:TriggerPDAlert(
												source,
												vector3(-1332.651, -846.451, 17.080),
												"10-33",
												"Minor Power Grid Disruption",
												{
													icon = 354,
													size = 0.9,
													color = 31,
													duration = (60 * 5),
												},
												{
													icon = "bolt-slash",
													details = "Del Perro",
												},
												false,
												50.0
											)
											GlobalState["Fleeca:Disable:mazebank_baycity"] = true
										else
											Doors:SetLock("mazebank_offices", true)
											Sounds.Play:Location(
												source,
												data.ptFxPoint,
												15.0,
												"power_small_off.ogg",
												0.25
											)
											if not _mbPowerAlerted or os.time() > _mbPowerAlerted then
												Robbery:TriggerPDAlert(
													source,
													GetEntityCoords(GetPlayerPed(source)),
													"10-33",
													"Attack on Power Grid",
													{
														icon = 354,
														size = 0.9,
														color = 31,
														duration = (60 * 5),
													},
													{
														icon = "bolt-slash",
														details = "Del Perro",
													},
													false,
													false
												)
												_mbPowerAlerted = os.time() + (60 * 10)
											end
										end
									end

									_mbInUse.powerBoxes[data.boxId] = false
								end, string.format("mazebank_power_%s", data.boxId))
							else
								_mbInUse.powerBoxes[data.boxId] = false
							end
						else
							_mbInUse.powerBoxes[data.boxId] = false
						end
					else
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Someone Is Already Interacting With This",
							6000
						)
					end

					return
				else
					_mbInUse.powerBoxes[data.boxId] = false
					Execute:Client(
						source,
						"Notification",
						"Error",
						"Temporary Emergency Systems Enabled, Check Beck In A Bit",
						6000
					)
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MazeBank:ElectricBox:Thermite", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["MazeBankInProgress"]
					) and not GlobalState["MazeBank:Secured"]
				then
					if
						GetGameTimer() < MAZEBANK_SERVER_START_WAIT
						or (GlobalState["RestartLockdown"] and not GlobalState["MazeBankInProgress"])
					then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif
						(GlobalState["Duty:police"] or 0) < MAZEBANK_REQUIRED_POLICE
						and not GlobalState["MazeBankInProgress"]
					then
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
					elseif
						GlobalState[string.format("MazeBank:Power:%s", data.boxId)] ~= nil
						and GlobalState[string.format("MazeBank:Power:%s", data.boxId)] > os.time()
					then
						Execute:Client(source, "Notification", "Error", "Electric Box Already Disabled", 6000)
						return
					end

					local myPos = GetEntityCoords(GetPlayerPed(source))

					if
						#(
							vector3(
								data.thermitePoint.coords.x,
								data.thermitePoint.coords.y,
								data.thermitePoint.coords.z
							) - myPos
						) <= 3.5
					then
						if not _mbInUse.powerBoxes[data.boxId] then
							_mbInUse.powerBoxes[data.boxId] = source
							GlobalState["MazeBankInProgress"] = true

							if Inventory.Items:Has(char:GetData("SID"), 1, "thermite", 1) then
								if Inventory.Items:Remove(char:GetData("SID"), 1, "thermite", 1) then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started Thermiting Maze Bank Power Box %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											data.boxId
										)
									)
									Callbacks:ClientCallback(source, "Robbery:Games:Thermite", {
										passes = 1,
										location = data.thermitePoint,
										duration = 25000,
										config = {
											countdown = 3,
											preview = 1500,
											timer = 7500,
											passReduce = 500,
											base = 16,
											cols = 5,
											rows = 5,
											anim = false,
										},
										data = {},
									}, function(success)
										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Thermited Maze Bank Power Box %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													data.boxId
												)
											)
											if
												not GlobalState["AntiShitlord"]
												or os.time() >= GlobalState["AntiShitlord"]
											then
												GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
											end

											_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME

											GlobalState[string.format("MazeBank:Power:%s", data.boxId)] = _mbGlobalReset
											TriggerEvent("Particles:Server:DoFx", data.ptFxPoint, "spark")
											if IsMBPowerDisabled() then
												Doors:SetLock("mazebank_offices", false)
												CCTV.State.Group:Offline("mazebank")
												Sounds.Play:Location(
													source,
													data.ptFxPoint,
													15.0,
													"power_small_complete_off.ogg",
													0.1
												)

												Robbery:TriggerPDAlert(
													source,
													vector3(-1332.651, -846.451, 17.080),
													"10-33",
													"Minor Power Grid Disruption",
													{
														icon = 354,
														size = 0.9,
														color = 31,
														duration = (60 * 5),
													},
													{
														icon = "bolt-slash",
														details = "Del Perro",
													},
													false,
													50.0
												)
												GlobalState["Fleeca:Disable:mazebank_baycity"] = true
											else
												Doors:SetLock("mazebank_offices", true)
												Sounds.Play:Location(
													source,
													data.ptFxPoint,
													15.0,
													"power_small_off.ogg",
													0.25
												)
												if not _mbPowerAlerted or os.time() > _mbPowerAlerted then
													Robbery:TriggerPDAlert(
														source,
														GetEntityCoords(GetPlayerPed(source)),
														"10-33",
														"Attack on Power Grid",
														{
															icon = 354,
															size = 0.9,
															color = 31,
															duration = (60 * 5),
														},
														{
															icon = "bolt-slash",
															details = "Del Perro",
														},
														false,
														false
													)
													_mbPowerAlerted = os.time() + (60 * 10)
												end
											end
										end

										_mbInUse.powerBoxes[data.boxId] = false
									end, string.format("mazebank_power_%s", data.boxId))
								else
									_mbInUse.powerBoxes[data.boxId] = false
								end
							else
								_mbInUse.powerBoxes[data.boxId] = false
								Execute:Client(source, "Notification", "Error", "You Need Thermite", 6000)
							end
						else
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Someone Is Already Interacting With This",
								6000
							)
						end

						return
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
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MazeBank:Drill", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["MazeBankInProgress"]
					) and not GlobalState["MazeBank:Secured"]
				then
					if
						GetGameTimer() < MAZEBANK_SERVER_START_WAIT
						or (GlobalState["RestartLockdown"] and not GlobalState["MazeBankInProgress"])
					then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Door Is Barricaded For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif
						(GlobalState["Duty:police"] or 0) < MAZEBANK_REQUIRED_POLICE
						and not GlobalState["MazeBankInProgress"]
					then
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
					elseif
						GlobalState[string.format("MazeBank:Vault:Wall:%s", data)] ~= nil
						and GlobalState[string.format("MazeBank:Vault:Wall:%s", data)] > os.time()
					then
						Execute:Client(source, "Notification", "Error", "Electric Box Already Disabled", 6000)
						return
					end
					if not _mbInUse.drillPoints[data] then
						_mbInUse.drillPoints[data] = source
						GlobalState["MazeBankInProgress"] = true

						if Inventory.Items:Has(char:GetData("SID"), 1, "drill", 1) then
							local slot = Inventory.Items:GetFirst(char:GetData("SID"), "drill", 1)
							local itemData = Inventory.Items:GetData("drill")

							if slot ~= nil then
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Started Drilling Vault Box: %s",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID"),
										data
									)
								)
								Callbacks:ClientCallback(source, "Robbery:Games:Drill", {
									passes = 1,
									duration = 25000,
									config = {},
									data = {},
								}, function(success)
									local newValue = slot.CreateDate - itemData.durability
									if success then
										newValue = slot.CreateDate - (itemData.durability / 2)
									end
									if os.time() - itemData.durability >= newValue then
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
									else
										Inventory:SetItemCreateDate(slot.id, newValue)
									end

									if success then
										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Successfully Drilled Vault Box: %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												data
											)
										)
										if
											not GlobalState["AntiShitlord"]
											or os.time() >= GlobalState["AntiShitlord"]
										then
											GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
										end

										_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME

										Loot:CustomWeightedSetWithCount(_mbLoot, char:GetData("SID"), 1)

										if not _purpDongie then
											if math.random(100) <= 10 then
												_purpDongie = source
												Inventory:AddItem(char:GetData("SID"), "purple_dongle", 1, {}, 1)
											end
										end

										GlobalState[string.format("MazeBank:Vault:Wall:%s", data)] = _mbGlobalReset
										GlobalState["Fleeca:Disable:mazebank_baycity"] = true
									end

									_mbInUse.drillPoints[data] = false
								end, string.format("mazebank_drill_%s", data))
							else
								_mbInUse.drillPoints[data] = false
							end
						else
							_mbInUse.drillPoints[data] = false
							Execute:Client(source, "Notification", "Error", "You Need A Drill", 6000)
						end
					else
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Someone Is Already Interacting With This",
							6000
						)
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
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MazeBank:PC:Hack", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["MazeBankInProgress"]
					) and not GlobalState["MazeBank:Secured"]
				then
					if
						GetGameTimer() < MAZEBANK_SERVER_START_WAIT
						or (GlobalState["RestartLockdown"] and not GlobalState["MazeBankInProgress"])
					then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Network Offline For A Storm, Check Back Later",
							6000
						)
						return
					elseif
						(GlobalState["Duty:police"] or 0) < MAZEBANK_REQUIRED_POLICE
						and not GlobalState["MazeBankInProgress"]
					then
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

					if not _mbInUse.officePcs[data.id] then
						_mbInUse.officePcs[data.id] = source
						GlobalState["MazeBankInProgress"] = true

						if Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1) then
							local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
							local itemData = Inventory.Items:GetData("adv_electronics_kit")

							if itemData ~= nil then
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Started Hacking Maze Bank PC %s",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID"),
										data.id
									)
								)
								Callbacks:ClientCallback(source, "Robbery:Games:Progress", {
									config = {
										label = "Doing Hackermans Stuff",
										anim = {
											anim = "type",
										},
									},
									data = {},
								}, function(success)
									if success then
										newValue = slot.CreateDate - (60 * 60 * 12)
										if os.time() - itemData.durability >= newValue then
											Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
										else
											Inventory:SetItemCreateDate(slot.id, newValue)
										end

										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Successfully Hacked Maze Bank PC %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												data.id
											)
										)
										if
											not GlobalState["AntiShitlord"]
											or os.time() >= GlobalState["AntiShitlord"]
										then
											GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
										end

										_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME

										GlobalState["Fleeca:Disable:mazebank_baycity"] = true
										GlobalState[string.format("MazeBank:Offices:PC:%s", data.id)] = _mbGlobalReset
										Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
											CryptoCoin = "PLEB",
											Quantity = math.random(120, 200),
										}, 1)

										if math.random(100) <= (33 * _officesLooted) and not _heistCoin then
											_heistCoin = true
											Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
												CryptoCoin = "HEIST",
												Quantity = 6,
											}, 1)
										else 
											_officesLooted += 1
										end
									end

									_mbInUse.officePcs[data.id] = false
								end, string.format("mazebank_pc_%s", data.id))
							else
								_mbInUse.officePcs[data.id] = false
							end
						else
							_mbInUse.officePcs[data.id] = false
						end
					else
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Someone Is Already Interacting With This",
							6000
						)
					end

					return
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
		end
	end)
end)
