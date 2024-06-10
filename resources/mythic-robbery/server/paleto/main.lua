_pbInUse = {
	workstation = false,
	officeSafe = false,
	pcHacks = {},
	officeHacks = {},
	substations = {},
	powerHacks = {},
	vaultPower = false,
	powerBoxes = {},
	drillPoints = {},
	securityAccess = {},
	searchPoints = {},
}

_pbVaultPower = false
_pbGlobalReset = nil
_pbAlerted = false

local _mintDongie = false
local _pbLoot = {
	{ 60, { name = "moneyroll", min = 570, max = 720 } },
	{ 33, { name = "moneyband", min = 57, max = 72 } },
	{ 2, { name = "moneybag", min = 1, max = 1, metadata = { CustomAmt = { Min = 57000, Random = 14500 } } } },
}
local _pbSearchLoot = {
	{ 60, { name = "moneyroll", min = 570, max = 720 } },
	{ 33, { name = "moneyband", min = 57, max = 72 } },
	{ 2, { name = "moneybag", min = 1, max = 1, metadata = { CustomAmt = { Min = 57000, Random = 14500 } } } },
}

AddEventHandler("Robbery:Server:Setup", function()
	RegisterPBItems()
	StartPaletoThreads()

	for k, v in ipairs(_pbDoorIds) do
		Doors:SetLock(v, true)
	end

	Middleware:Add("playerDropped", PaletoClearSourceInUse)
	Middleware:Add("Characters:Logout", PaletoClearSourceInUse)

	Callbacks:RegisterServerCallback("Robbery:Paleto:SecureBank", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Player(source).state.onDuty == "police" then
					SecurePaleto()
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Paleto:DisableAlarm", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Player(source).state.onDuty == "police" then
					if _bankStates.paleto.fookinLasers then
						TriggerClientEvent(
							"Sounds:Client:Stop:Distance",
							-1,
							_bankStates.paleto.fookinLasers,
							"bank_alarm.ogg"
						)
						Robbery.State:Update("paleto", "fookinLasers", false)
						_pbAlerted = false
					end
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Paleto:TriggeredLaser", function(source, data, cb)
		if not _bankStates.paleto.fookinLasers then
			Robbery.State:Update("paleto", "fookinLasers", source)
			Sounds.Loop:Location(source, vector3(-104.552, 6469.050, 35.981), 50.0, "bank_alarm.ogg", 0.15)
			GlobalState["Fleeca:Disable:savings_paleto"] = true
			if not _pbAlerted or os.time() > _pbAlerted then
				Robbery:TriggerPDAlert(source, vector3(-111.130, 6462.485, 31.643), "10-33", "Bank Alarm Triggered", {
					icon = 137,
					size = 0.9,
					color = 31,
					duration = (60 * 5),
				}, {
					icon = "building-columns",
					details = "Blaine County Savings Bank",
				}, "paleto")
				_pbAlerted = os.time() + (60 * 10)
				Status.Modify:Add(source, "PLAYER_STRESS", 15)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Paleto:GetDoors", function(source, data, cb)
		local its = {}

		table.insert(its, {
			label = "Vault Terminal Override",
			data = {},
			disabled = _bankStates.paleto.vaultTerminal or 0 > os.time(),
			event = "Robbery:Client:Paleto:VaultTerminal",
		})

		for k, v in ipairs(_pbDoorsGarbage) do
			table.insert(its, {
				label = v.label,
				data = v.data,
				disabled = not Doors:IsLocked(v.doorId),
				event = Doors:IsLocked(v.doorId) and "Robbery:Client:Paleto:Door" or nil,
			})
		end
		cb(its)
	end)

	Callbacks:RegisterServerCallback("Robbery:Paleto:VaultTerminal", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if not IsPaletoExploitInstalled() then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Bank Firewalls Still Active, Cannot Do This Yet",
								6000
							)
							return
						end

						if not _bankStates.paleto.vaultTerminal or os.time() > _bankStates.paleto.vaultTerminal then
							if not _pbGlobalReset or os.time() > _pbGlobalReset then
								_pbGlobalReset = os.time() + PALETO_RESET_TIME
							end
							Robbery.State:Update("paleto", "vaultTerminal", _pbGlobalReset)
						end
					else
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:UnlockDoor", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if not IsPaletoExploitInstalled() then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Bank Firewalls Still Active, Cannot Do This Yet",
								6000
							)
							return
						end

						if data.data.id ~= nil then
							if
								not _pbDoorsGarbage[data.data.id].requireCode
								or (
									data.data.officeId
									and (
										_accessCodes.paleto[data.data.officeId] == nil
										or _accessCodes.paleto[data.data.officeId].code == tonumber(data.code)
									)
								)
							then
								Doors:SetLock(data.data.door, false)
								Execute:Client(source, "Notification", "Success", "Door Unlocked")

								if _pbDoorsGarbage[data.data.id].requireCode then
									Inventory.Items:RemoveAll(char:GetData("SID"), 1, "paleto_access_codes")
								end
							else
								Doors:SetLock(data.data.door, true)
								Execute:Client(source, "Notification", "Error", "Invalid Access Code")
								Status.Modify:Add(source, "PLAYER_STRESS", 6)
							end
						else
							cb(false)
						end
					else
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:ElectricBox:Hack", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if not IsPaletoExploitInstalled() then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Power Grid Firewalls Still Active, Cannot Do This Yet",
								6000
							)
							return
						end

						if not _pbInUse.powerBoxes[data.boxId] then
							_pbInUse.powerBoxes[data.boxId] = source
							GlobalState["PaletoInProgress"] = true

							if Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1) then
								local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
								local itemData = Inventory.Items:GetData("adv_electronics_kit")

								if itemData ~= nil then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started hacking Paleto Electrical Box %s",
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
											limit = 14000,
											delay = 2000,
											difficulty = 8,
											chances = 6,
											anim = false,
										},
										data = {},
									}, function(success)
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)

										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Hacked Paleto Electrical Box %s",
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

											if not _pbGlobalReset or os.time() > _pbGlobalReset then
												_pbGlobalReset = os.time() + PALETO_RESET_TIME
											end

											Robbery.State:Update(
												"paleto",
												data.boxId,
												_pbGlobalReset,
												"electricalBoxes"
											)
											TriggerEvent("Particles:Server:DoFx", data.ptFxPoint, "spark")
											if IsPaletoPowerDisabled() then
												Sounds.Play:Location(
													source,
													data.ptFxPoint,
													15.0,
													"power_small_complete_off.ogg",
													0.1
												)
												Robbery:TriggerPDAlert(
													source,
													vector3(-195.586, 6338.740, 31.515),
													"10-33",
													"Regional Power Grid Disruption",
													{
														icon = 354,
														size = 0.9,
														color = 31,
														duration = (60 * 5),
													},
													{
														icon = "bolt-slash",
														details = "Paleto",
													},
													false,
													250.0
												)
												GlobalState["Fleeca:Disable:savings_paleto"] = true
												Doors:SetLock("bank_savings_paleto_gate", false)
											else
												Sounds.Play:Location(
													source,
													data.ptFxPoint,
													15.0,
													"power_small_complete_off.ogg",
													0.1
												)
												Doors:SetLock("bank_savings_paleto_gate", true)
											end
											Status.Modify:Add(source, "PLAYER_STRESS", 3)
										else
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_pbInUse.powerBoxes[data.boxId] = false
									end, string.format("paleeto_power_%s", data.boxId))
								else
									_pbInUse.powerBoxes[data.boxId] = false
								end
							else
								_pbInUse.powerBoxes[data.boxId] = false
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:PC:Hack", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if
							_bankStates.paleto.exploits[data.pcId] ~= nil
							and _bankStates.paleto.exploits[data.pcId] > os.time()
						then
							Execute:Client(source, "Notification", "Error", "Electric Box Already Disabled", 6000)
							return
						end

						if not _pbInUse.pcHacks[data.pcId] then
							_pbInUse.pcHacks[data.pcId] = source
							GlobalState["PaletoInProgress"] = true

							if Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1) then
								local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
								local itemData = Inventory.Items:GetData("adv_electronics_kit")

								if itemData ~= nil then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started hacking Paleto PC %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											data.pcId
										)
									)
									Callbacks:ClientCallback(source, "Robbery:Games:Tracking", {
										config = {
											countdown = 3,
											delay = 2000,
											limit = 14000,
											difficulty = 4 + CountPaletoExploits(),
											anim = false,
										},
										data = {},
									}, function(success)
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)

										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Hacked Paleto PC %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													data.pcId
												)
											)
											if not _pbGlobalReset or os.time() > _pbGlobalReset then
												_pbGlobalReset = os.time() + PALETO_RESET_TIME
											end

											Robbery.State:Update("paleto", data.pcId, _pbGlobalReset, "exploits")
											if IsPaletoExploitInstalled() then
												Phone.Email:Send(
													source,
													"ghost@ls.undg",
													os.time() * 1000,
													"Exploit Fully Uploaded",
													string.format(
														[[
																Nicely done %s<br /><br />
																Those exploits got us in and my hackers have managed to disable security measures at various substations around the region.
																You need to attack those, doing so should bring down Paleto Banks more advanced security measures.
															]],
														char:GetData("First")
													)
												)
											else
												local count = CountPaletoExploits()
												Phone.Email:Send(
													source,
													"ghost@ls.undg",
													os.time() * 1000,
													string.format(
														"Paleto Power Grid Exploits: %s/%s",
														count,
														#_pbPCHackAreas
													),
													string.format(
														[[
																Good Work %s<br /><br />
																In order to expose the power grid in paleto enough that we can actually attack it you need to install a total of %s exploits.
																There's workstations setup around the region that are good for installing 1 exploit.
															]],
														char:GetData("First"),
														#_pbPCHackAreas
													)
												)
											end
											Status.Modify:Add(source, "PLAYER_STRESS", 3)
										else
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_pbInUse.pcHacks[data.pcId] = false
									end, string.format("paleeto_pc_%s", data.pcId))
								else
									_pbInUse.pcHacks[data.pcId] = false
								end
							else
								_pbInUse.pcHacks[data.pcId] = false
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:Workstation", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if not IsPaletoExploitInstalled() then
							Execute:Client(source, "Notification", "Error", "Network Firewalls Still Active", 6000)
							return
						elseif _bankStates.paleto.workstation and _bankStates.paleto.workstation > os.time() then
							Execute:Client(source, "Notification", "Error", "Workstation Has Already Been Hacked", 6000)
							return
						end

						if not _pbInUse.workstation then
							_pbInUse.workstation = source
							GlobalState["PaletoInProgress"] = true

							if
								hasValue(char:GetData("States") or {}, "PHONE_VPN")
								and Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1)
							then
								local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
								local itemData = Inventory.Items:GetData("adv_electronics_kit")

								if itemData ~= nil then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started hacking Paleto Lobby Workstation",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID")
										)
									)
									Callbacks:ClientCallback(source, "Robbery:Games:AimHack", {
										config = {
											countdown = 3,
											limit = 15750,
											timer = 500,
											startSize = 20,
											maxSize = 75,
											growthRate = 20,
											accuracy = 75,
											isMoving = true,
											anim = false,
										},
										data = {},
									}, function(success, data)
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)

										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Hacked Paleto Lobby Workstation",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID")
												)
											)
											if not _pbGlobalReset or os.time() > _pbGlobalReset then
												_pbGlobalReset = os.time() + PALETO_RESET_TIME
											end

											Robbery.State:Update("paleto", "workstation", _pbGlobalReset)
											Inventory:AddItem(char:GetData("SID"), "paleto_access_codes", 1, {
												AccessCodes = { _accessCodes.paleto[1] },
											}, 1)

											GlobalState["Fleeca:Disable:savings_paleto"] = true
											if not _pbAlerted or os.time() > _pbAlerted then
												Robbery:TriggerPDAlert(
													source,
													vector3(-111.130, 6462.485, 31.643),
													"10-90",
													"Armed Robbery",
													{
														icon = 586,
														size = 0.9,
														color = 31,
														duration = (60 * 5),
													},
													{
														icon = "building-columns",
														details = "Blaine County Savings Bank",
													},
													"paleto"
												)
												_pbAlerted = os.time() + (60 * 10)
												Status.Modify:Add(source, "PLAYER_STRESS", 3)
											end
										else
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_pbInUse.workstation = false
									end, "paleto_workstation")
								else
									_pbInUse.workstation = false
								end
							else
								_pbInUse.workstation = false
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:OfficeHack", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if
							_bankStates.paleto.officeHacks[data.officeId] ~= nil
							and _bankStates.paleto.officeHacks[data.officeId] > os.time()
						then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"This Workstation Has Already Been Comprimised",
								6000
							)
							return
						end

						if not _pbInUse.officeHacks[data.officeId] then
							_pbInUse.officeHacks[data.officeId] = source
							GlobalState["PaletoInProgress"] = true

							if Inventory.Items:Has(char:GetData("SID"), 1, "adv_electronics_kit", 1) then
								local slot = Inventory.Items:GetFirst(char:GetData("SID"), "adv_electronics_kit", 1)
								local itemData = Inventory.Items:GetData("adv_electronics_kit")

								if itemData ~= nil then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started hacking Paleto Office %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											data.officeId
										)
									)
									Callbacks:ClientCallback(source, "Robbery:Games:Tracking", {
										config = {
											countdown = 3,
											delay = 2000,
											limit = 14000,
											difficulty = 6,
											anim = false,
										},
										data = {},
									}, function(success)
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)

										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Hacked Paleto Office %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													data.officeId
												)
											)
											if not _pbGlobalReset or os.time() > _pbGlobalReset then
												_pbGlobalReset = os.time() + PALETO_RESET_TIME
											end

											Robbery.State:Update("paleto", data.officeId, _pbGlobalReset, "officeHacks")

											if _accessCodes.paleto[data.officeId + 1] ~= nil then
												Inventory:AddItem(char:GetData("SID"), "paleto_access_codes", 1, {
													AccessCodes = { _accessCodes.paleto[data.officeId + 1] },
												}, 1)
											end

											Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
												CryptoCoin = "PLEB",
												Quantity = math.random(200, 400),
											}, 1)

											GlobalState["Fleeca:Disable:savings_paleto"] = true
											if not _pbAlerted or os.time() > _pbAlerted then
												Robbery:TriggerPDAlert(
													source,
													vector3(-111.130, 6462.485, 31.643),
													"10-90",
													"Armed Robbery",
													{
														icon = 586,
														size = 0.9,
														color = 31,
														duration = (60 * 5),
													},
													{
														icon = "building-columns",
														details = "Blaine County Savings Bank",
													},
													"paleto"
												)
												_pbAlerted = os.time() + (60 * 10)
												Status.Modify:Add(source, "PLAYER_STRESS", 3)
											end
										else
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_pbInUse.officeHacks[data.officeId] = false
									end, string.format("paleto_office_%s", data.officeId))
								else
									_pbInUse.officeHacks[data.officeId] = false
								end
							else
								_pbInUse.officeHacks[data.officeId] = false
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:Drill", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, false) then
						if
							_bankStates.paleto.drillPoints[data] ~= nil
							and _bankStates.paleto.officeHacks[data] > os.time()
						then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"This Workstation Has Already Been Comprimised",
								6000
							)
							return
						elseif Doors:IsLocked("bank_savings_paleto_vault") then
							return
						end
						if not _pbInUse.drillPoints[data] then
							_pbInUse.drillPoints[data] = source
							GlobalState["PaletoInProgress"] = true

							if Inventory.Items:Has(char:GetData("SID"), 1, "drill", 1) then
								local slot = Inventory.Items:GetFirst(char:GetData("SID"), "drill", 1)
								local itemData = Inventory.Items:GetData("drill")

								if slot ~= nil then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started Drilling Paleto Vault Box: %s",
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
										Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)

										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Drilled Paleto Vault Box: %s",
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

											if not _pbGlobalReset or os.time() > _pbGlobalReset then
												_pbGlobalReset = os.time() + PALETO_RESET_TIME
											end

											Loot:CustomWeightedSetWithCount(_pbLoot, char:GetData("SID"), 1)

											Robber.State:Update("paleto", data, _pbGlobalReset, "drillPoints")
											GlobalState["Fleeca:Disable:savings_paleto"] = true
										end

										_pbInUse.drillPoints[data] = false
									end, string.format("paleto_drill_%s", data))
								else
									_pbInUse.drillPoints[data] = false
								end
							else
								_pbInUse.drillPoints[data] = false
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:Search", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, false) then
						if
							_bankStates.paleto.officeSearch[data.searchId] ~= nil
							and _bankStates.paleto.officeSearch[data.searchId] > os.time()
						then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"This Workstation Has Already Been Comprimised",
								6000
							)
							return
						elseif Doors:IsLocked(data.door) then
							return
						end
						if not _pbInUse.searchPoints[data.searchId] then
							_pbInUse.searchPoints[data.searchId] = source
							GlobalState["PaletoInProgress"] = true

							Logger:Info(
								"Robbery",
								string.format(
									"%s %s (%s) Started Drilling Paleto Vault Box: %s",
									char:GetData("First"),
									char:GetData("Last"),
									char:GetData("SID"),
									data.searchId
								)
							)
							Callbacks:ClientCallback(source, "Robbery:Games:Lockpick", {
								config = 0.75,
								data = {
									stages = 3,
								},
							}, function(success)
								if success then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Successfully Drilled Paleto Vault Box: %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											data.searchId
										)
									)
									if not GlobalState["AntiShitlord"] or os.time() >= GlobalState["AntiShitlord"] then
										GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
									end

									if not _pbGlobalReset or os.time() > _pbGlobalReset then
										_pbGlobalReset = os.time() + PALETO_RESET_TIME
									end

									Loot:CustomWeightedSetWithCount(_pbSearchLoot, char:GetData("SID"), 1)

									Robbery.State:Update("paleto", data.searchId, _pbGlobalReset, "officeSearch")
									GlobalState["Fleeca:Disable:savings_paleto"] = true
								end

								_pbInUse.searchPoints[data.searchId] = false
							end, string.format("paleto_search_%s", data.searchId))
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:StartSafe", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if _bankStates.paleto.officeSafe and _bankStates.paleto.officeSafe > os.time() then
							Execute:Client(source, "Notification", "Error", "Safe Has Already Been Looted", 6000)
							return
						end

						if not _pbInUse.officeSafe then
							_pbInUse.officeSafe = source
							Logger:Info(
								"Robbery",
								string.format(
									"%s %s (%s) Started Accessing Paleto Office Safe",
									char:GetData("First"),
									char:GetData("Last"),
									char:GetData("SID")
								)
							)
							GlobalState["PaletoInProgress"] = true
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

	Callbacks:RegisterServerCallback("Robbery:Paleto:Safe", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					(
						not GlobalState["AntiShitlord"]
						or os.time() > GlobalState["AntiShitlord"]
						or GlobalState["PaletoInProgress"]
					) and not GlobalState["Paleto:Secured"]
				then
					if PaletoIsGloballyReady(source, true) then
						if _bankStates.paleto.officeSafe and _bankStates.paleto.officeSafe > os.time() then
							Execute:Client(source, "Notification", "Error", "Safe Has Already Been Looted", 6000)
							return
						end

						if _pbInUse.officeSafe == source then
							if _accessCodes.paleto[4].code == tonumber(data.code) then
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Successfully Accessed Paleto Office Safe",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID")
									)
								)

								Inventory.Items:RemoveAll(char:GetData("SID"), 1, "paleto_access_codes")
								if not _pbGlobalReset or os.time() > _pbGlobalReset then
									_pbGlobalReset = os.time() + PALETO_RESET_TIME
								end

								Robbery.State:Update("paleto", "officeSafe", _pbGlobalReset)

								Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
									CryptoCoin = "PLEB",
									Quantity = math.random(200, 400),
								}, 1)

								Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
									CryptoCoin = "HEIST",
									Quantity = 12,
								}, 1)

								GlobalState["Fleeca:Disable:savings_paleto"] = true
								if not _pbAlerted or os.time() > _pbAlerted then
									Robbery:TriggerPDAlert(
										source,
										vector3(-111.130, 6462.485, 31.643),
										"10-90",
										"Armed Robbery",
										{
											icon = 586,
											size = 0.9,
											color = 31,
											duration = (60 * 5),
										},
										{
											icon = "building-columns",
											details = "Blaine County Savings Bank",
										},
										"paleto"
									)
									_pbAlerted = os.time() + (60 * 10)
									Status.Modify:Add(source, "PLAYER_STRESS", 3)
								end

								_pbInUse.officeSafe = false
								GlobalState["PaletoInProgress"] = true
							else
								_pbInUse.officeSafe = false
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Failed Accessing Paleto Office Safe",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID")
									)
								)
							end
						else
							_pbInUse.officeSafe = false
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Someone Is Already Interacting With This",
								6000
							)
						end
					else
						_pbInUse.officeSafe = false
					end
				else
					_pbInUse.officeSafe = false
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
