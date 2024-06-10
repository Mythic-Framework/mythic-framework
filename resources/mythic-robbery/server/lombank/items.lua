function RegisterLBItemUses()
	Inventory.Items:RegisterUse("thermite", "LombankRobbery", function(source, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inLombank then
			if
				(
					not GlobalState["AntiShitlord"]
					or os.time() > GlobalState["AntiShitlord"]
					or GlobalState["LombankInProgress"]
				) and not GlobalState["Lombank:Secured"]
			then
				if
					GetGameTimer() < LOMBANK_SERVER_START_WAIT
					or (GlobalState["RestartLockdown"] and not GlobalState["LombankInProgress"])
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
					(GlobalState["Duty:police"] or 0) < LOMBANK_REQUIRED_POLICE
					and not GlobalState["LombankInProgress"]
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

				local myPos = GetEntityCoords(GetPlayerPed(source))

				for k, v in pairs(lbThermPoints) do
					if Doors:IsLocked(v.door) and #(v.coords - myPos) <= 1.5 then
						if AreRequirementsUnlocked(v.requiredDoors) then
							if not _lbInUse[k] then
								_lbInUse[k] = source
								GlobalState["LombankInProgress"] = true

								if
									Inventory.Items:RemoveSlot(
										itemData.Owner,
										itemData.Name,
										1,
										itemData.Slot,
										itemData.invType
									)
								then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started Thermiting Lombank Door: %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											v.door
										)
									)
									Callbacks:ClientCallback(source, "Robbery:Games:Thermite", {
										passes = 1,
										location = v,
										duration = 11000,
										config = {
											countdown = 3,
											preview = 1500,
											timer = 9000,
											passReduce = 500,
											base = 16,
											cols = 6,
											rows = 6,
											anim = false,
										},
										data = {},
									}, function(success)
										if success then
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Successfully Thermited Lombank Door: %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													v.door
												)
											)
											if
												not GlobalState["AntiShitlord"]
												or os.time() >= GlobalState["AntiShitlord"]
											then
												GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
											end

											Doors:SetLock(v.door, false)
											GlobalState["Fleeca:Disable:lombank_legion"] = true
											if not _lbAlerted or os.time() > _lbAlerted then
												Robbery:TriggerPDAlert(
													source,
													vector3(8.976, -932.315, 29.903),
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
														details = "Legion Square Lombank",
													},
													"lombank"
												)
												_lbAlerted = os.time() + (60 * 10)
											end
											Status.Modify:Add(source, "PLAYER_STRESS", 3)
										else
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_lbInUse[k] = false
									end, v.door)

									break
								else
									_lbInUse[k] = false
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
		elseif pState.inLombankPower and not Doors:IsLocked("lombank_hidden_entrance") and IsLBPowerDisabled() then
			local pos = {
				coords = vector3(50.79477, -818.1543, 31.59213),
				heading = 253.851,
			}

			if
				(
					not GlobalState["AntiShitlord"]
					or os.time() > GlobalState["AntiShitlord"]
					or GlobalState["LombankInProgress"]
				) and not GlobalState["Lombank:Secured"]
			then
				if
					GetGameTimer() < LOMBANK_SERVER_START_WAIT
					or (GlobalState["RestartLockdown"] and not GlobalState["LombankInProgress"])
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
					(GlobalState["Duty:police"] or 0) < LOMBANK_REQUIRED_POLICE
					and not GlobalState["LombankInProgress"]
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

				local myPos = GetEntityCoords(GetPlayerPed(source))

				if #(pos.coords - myPos) <= 3.5 then
					if not _lbInUse.vaultPower then
						_lbInUse.vaultPower = source
						GlobalState["LombankInProgress"] = true

						if
							Inventory.Items:RemoveSlot(
								itemData.Owner,
								itemData.Name,
								1,
								itemData.Slot,
								itemData.invType
							)
						then
							Logger:Info(
								"Robbery",
								string.format(
									"%s %s (%s) Started Thermiting Lombank Vault Power",
									char:GetData("First"),
									char:GetData("Last"),
									char:GetData("SID")
								)
							)
							Callbacks:ClientCallback(source, "Robbery:Games:Thermite", {
								passes = 1,
								location = pos,
								duration = 25000,
								config = {
									countdown = 3,
									preview = 1500,
									timer = 9000,
									passReduce = 500,
									base = 16,
									cols = 6,
									rows = 6,
									anim = false,
								},
								data = {},
							}, function(success)
								if success then
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Successfully Thermited Lombank Vault Power",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID")
										)
									)
									if not GlobalState["AntiShitlord"] or os.time() >= GlobalState["AntiShitlord"] then
										GlobalState["AntiShitlord"] = os.time() + (60 * math.random(20, 30))
									end

									TriggerEvent("Particles:Server:DoFx", pos.coords, "spark")
									Sounds.Play:Location(source, pos.coords, 15.0, "power_small_complete_off.ogg", 0.1)

									Doors:SetLock("lombank_lasers", false)
									Status.Modify:Add(source, "PLAYER_STRESS", 3)
									GlobalState["Fleeca:Disable:lombank_legion"] = true
									if not _lbAlerted or os.time() > _lbAlerted then
										Robbery:TriggerPDAlert(
											source,
											vector3(8.976, -932.315, 29.903),
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
												details = "Legion Square Lombank",
											},
											"lombank"
										)
										_lbAlerted = os.time() + (60 * 10)
									end
								else
									Status.Modify:Add(source, "PLAYER_STRESS", 6)
								end

								_lbInUse.vaultPower = false
							end, "lombank_vault_power")
						else
							_lbInUse.vaultPower = false
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
	end)

	Inventory.Items:RegisterUse("purple_laptop", "LombankRobbery", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inLombank then
			local ped = GetPlayerPed(source)
			local myCoords = GetEntityCoords(ped)

			if
				(
					not GlobalState["AntiShitlord"]
					or os.time() > GlobalState["AntiShitlord"]
					or GlobalState["LombankInProgress"]
				) and not GlobalState["Lombank:Secured"]
			then
				if
					GetGameTimer() < LOMBANK_SERVER_START_WAIT
					or (GlobalState["RestartLockdown"] and not GlobalState["LombankInProgress"])
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
					(GlobalState["Duty:police"] or 0) < LOMBANK_REQUIRED_POLICE
					and not GlobalState["LombankInProgress"]
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

				for k, v in pairs(_lbHackPoints) do
					if #(v.coords - myCoords) <= 1.5 then
						if AreRequirementsUnlocked(v.requiredDoors) then
							if not _lbInUse[k] then
								_lbInUse[k] = source
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Started Hacking Lombank Door: %s",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID"),
										v.door
									)
								)
								Callbacks:ClientCallback(source, "Robbery:Games:Laptop", {
									location = {
										coords = v.coords,
										heading = v.heading,
									},
									config = v.config,
									data = {},
								}, function(success, data)
									if success then
										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Successfully Hacked Lombank Door: %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												v.door
											)
										)

										local timer = math.random(2, 4)

										Execute:Client(
											source,
											"Notification",
											"Success",
											string.format("Time Lock Disengaging, Please Wait %s Minutes", timer),
											6000
										)
										table.insert(_unlockingDoors, {
											door = v.door,
											forceOpen = v.forceOpen,
											source = source,
											expires = os.time() + (60 * timer),
										})

										Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)
										Status.Modify:Add(source, "PLAYER_STRESS", 3)
										GlobalState["Fleeca:Disable:lombank_legion"] = true
										if not _lbAlerted or os.time() > _lbAlerted then
											Robbery:TriggerPDAlert(
												source,
												vector3(8.976, -932.315, 29.903),
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
													details = "Legion Square Lombank",
												},
												"lombank"
											)
											_lbAlerted = os.time() + (60 * 10)
										end
									else
										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Failed Hacking Lombank Door: %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												v.door
											)
										)
										Doors:SetLock(v.door, true)
										Status.Modify:Add(source, "PLAYER_STRESS", 6)

										local newValue = slot.CreateDate - math.ceil(itemData.durability / 4)
										if os.time() - itemData.durability >= newValue then
											Inventory.Items:RemoveId(char:GetData("SID"), 1, slot)
										else
											Inventory:SetItemCreateDate(slot.id, newValue)
										end
									end
									_lbInUse[k] = false
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
						else
						end
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
end
