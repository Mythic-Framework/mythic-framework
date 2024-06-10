function RegisterMBItemUses()
	Inventory.Items:RegisterUse("thermite", "MazeBankRobbery", function(source, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inMazeBank then
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
				end

				local myPos = GetEntityCoords(GetPlayerPed(source))

				for k, v in pairs(_mbDoors) do
					if Doors:IsLocked(v.door) and #(v.coords - myPos) <= 1.5 then
						if AreRequirementsUnlocked(v.requiredDoors) then
							if not _mbInUse[k] then
								_mbInUse[k] = source
								GlobalState["MazeBankInProgress"] = true

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
											"%s %s (%s) Started Thermiting Maze Bank Door: %s",
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
													"%s %s (%s) Successfully Thermited Maze Bank Door: %s",
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

											_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
											Doors:SetLock(v.door, false)
											if not _mbAlerted or os.time() > _mbAlerted then
												Robbery:TriggerPDAlert(
													source,
													vector3(-1332.651, -846.451, 17.080),
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
														details = "Bay City Maze Bank",
													},
													"mazebank"
												)
												GlobalState["Fleeca:Disable:mazebank_baycity"] = true
												_mbAlerted = os.time() + (60 * 10)
												Status.Modify:Add(source, "PLAYER_STRESS", 3)
											end
										else
											_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end

										_mbInUse[k] = false
									end, v.door)
									break
								else
									_mbInUse[k] = false
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
		end
	end)

	Inventory.Items:RegisterUse("red_laptop", "MazeBankRobbery", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inMazeBank then
			local ped = GetPlayerPed(source)
			local myCoords = GetEntityCoords(ped)

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
				end

				for k, v in pairs(_mbHacks) do
					if #(v.coords - myCoords) <= 1.5 then
						if
							GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] == nil
							or GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)].state == 4
								and os.time() > GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)].expires
						then
							if AreRequirementsUnlocked(v.requiredDoors) then
								if not _mbInUse[k] then
									_mbInUse[k] = source
									Logger:Info(
										"Robbery",
										string.format(
											"%s %s (%s) Started Hacking Maze Bank Door: %s",
											char:GetData("First"),
											char:GetData("Last"),
											char:GetData("SID"),
											v.doorId
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
													"%s %s (%s) Successfully Hacked Maze Bank Door: %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													v.doorId
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

											Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1)
											_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
											GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] = {
												state = 2,
												expires = os.time() + (60 * timer),
											}

											GlobalState["Fleeca:Disable:mazebank_baycity"] = true
											Status.Modify:Add(source, "PLAYER_STRESS", 3)
										else
											Logger:Info(
												"Robbery",
												string.format(
													"%s %s (%s) Failed Hacking Maze Bank Door: %s",
													char:GetData("First"),
													char:GetData("Last"),
													char:GetData("SID"),
													v.doorId
												)
											)

											local newValue = slot.CreateDate - (60 * 60 * 24)
											if os.time() - itemData.durability >= newValue then
												Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
											else
												Inventory:SetItemCreateDate(slot.id, newValue)
											end

											_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
											Status.Modify:Add(source, "PLAYER_STRESS", 6)
										end
										_mbInUse[k] = false
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

	Inventory.Items:RegisterUse("adv_lockpick", "MazeBankRobbery", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.inMazeBank then
			local ped = GetPlayerPed(source)
			local myCoords = GetEntityCoords(ped)

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
				end

				for k, v in ipairs(_mbOfficeDoors) do
					if #(v.coords - myCoords) <= 1.5 then
						if AreRequirementsUnlocked(v.requiredDoors) then
							if not _mbInUse[v.door] then
								_mbInUse[v.door] = source
								Logger:Info(
									"Robbery",
									string.format(
										"%s %s (%s) Started Lock Picking Maze Bank Door: %s",
										char:GetData("First"),
										char:GetData("Last"),
										char:GetData("SID"),
										v.door
									)
								)
								Callbacks:ClientCallback(source, "Robbery:Games:Lockpick", {
									config = 0.75,
									data = {
										stages = 4,
									},
								}, function(success, data)
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
												"%s %s (%s) Successfully Lock Picked Maze Bank Door: %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												v.door
											)
										)

										GlobalState["Fleeca:Disable:mazebank_baycity"] = true
										_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
										Doors:SetLock(v.door, false)
										Status.Modify:Add(source, "PLAYER_STRESS", 3)
									else
										Logger:Info(
											"Robbery",
											string.format(
												"%s %s (%s) Failed Lock Picking Maze Bank Door: %s",
												char:GetData("First"),
												char:GetData("Last"),
												char:GetData("SID"),
												v.door
											)
										)

										_mbGlobalReset = os.time() + MAZEBANK_RESET_TIME
										Doors:SetLock(v.door, true)
										Status.Modify:Add(source, "PLAYER_STRESS", 6)

										local newValue = slot.CreateDate - math.ceil(itemData.durability / 4)
										if os.time() - itemData.durability >= newValue then
											Inventory.Items:RemoveId(char:GetData("SID"), 1, slot)
										else
											Inventory:SetItemCreateDate(slot.id, newValue)
										end
									end
									_mbInUse[v.door] = false
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
