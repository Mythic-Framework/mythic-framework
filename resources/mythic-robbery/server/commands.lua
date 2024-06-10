function RegisterCommands()
	Chat:RegisterAdminCommand("resetheist", function(source, args, rawCommand)
		if args[1] == "mazebank" then
			ResetMazeBank()
			Execute:Client(source, "Notification", "Success", "Maze Bank Heist Reset")
		elseif args[1] == "lombank" then
			ResetLombank()
			Execute:Client(source, "Notification", "Success", "Lombank Heist Reset")
		elseif args[1] == "paleto" then
			ResetPaleto()
			Execute:Client(source, "Notification", "Success", "Paleto Bank Heist Reset")
		elseif args[1] == "bobcat" then
			ResetBobcat()
		elseif args[1]:find("fleeca") and FLEECA_LOCATIONS[args[1]] ~= nil then
			ResetFleeca(args[1])
			Execute:Client(
				source,
				"Notification",
				"Success",
				string.format("Fleeca %s Reset", FLEECA_LOCATIONS[args[1]].label)
			)
		else
			Execute:Client(source, "Notification", "Error", "Invalid Bank ID")
		end
	end, {
		help = "Force Reset Heist",
		params = {
			{
				name = "Heist ID",
				help = "ID of what heist to reset (paleto, lombank, mazebank, bobcat, fleeca_*)",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("disablepower", function(source, args, rawCommand)
		if args[1] == "mazebank" then
			MazeBankDisablePower(source)
		elseif args[1] == "lombank" then
			LombankDisablePower(source)
		elseif args[1] == "paleto" then
			DisablePaletoPower(source)
		else
			Execute:Client(source, "Notification", "Error", "Invalid Bank ID")
		end
	end, {
		help = "Force Disable Power For Heist",
		params = {
			{
				name = "Heist ID",
				help = "ID of heist to disable power for (mazebank, lombank, paleto)",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("checkheist", function(source, args, rawCommand)
		if args[1] ~= nil then
			if args[1] == "mazebank" then
				if not _mbGlobalReset then
					Chat.Send.System:Single(source, "<b>Maze Bank</b>: Not Yet Hit")
				else
					if os.time() > _mbGlobalReset then
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Maze Bank</b>: Expired (%s)",
								GetFormattedTimeFromSeconds(_mbGlobalReset - os.time())
							)
						)
					else
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Maze Bank</b>: On Cooldown (%s)",
								GetFormattedTimeFromSeconds(_mbGlobalReset - os.time())
							)
						)
					end
				end
			elseif args[1] == "lombank" then
				if not _lbGlobalReset then
					Chat.Send.System:Single(source, "<b>Lombank</b>: Not Yet Hit")
				else
					if os.time() > _lbGlobalReset then
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Lombank</b>: Expired (%s)",
								GetFormattedTimeFromSeconds(_lbGlobalReset - os.time())
							)
						)
					else
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Lombank</b>: On Cooldown (%s)",
								GetFormattedTimeFromSeconds(_lbGlobalReset - os.time())
							)
						)
					end
				end
			elseif args[1] == "paleto" then
				if not _pbGlobalReset then
					Chat.Send.System:Single(source, "<b>Paleto</b>: Not Yet Hit")
				else
					if os.time() > _pbGlobalReset then
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Paleto</b>: Expired (%s)",
								GetFormattedTimeFromSeconds(_pbGlobalReset - os.time())
							)
						)
					else
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Paleto</b>: On Cooldown (%s)",
								GetFormattedTimeFromSeconds(_pbGlobalReset - os.time())
							)
						)
					end
				end
			elseif args[1] == "bobcat" then
				if not _bcGlobalReset then
					Chat.Send.System:Single(source, "<b>Bobcat</b>: Not Yet Hit")
				else
					if os.time() > _bcGlobalReset then
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Bobcat</b>: Expired (%s)",
								GetFormattedTimeFromSeconds(_bcGlobalReset - os.time())
							)
						)
					else
						Chat.Send.System:Single(
							source,
							string.format(
								"<b>Bobcat</b>: On Cooldown (%s)",
								GetFormattedTimeFromSeconds(_bcGlobalReset - os.time())
							)
						)
					end
				end
			elseif args[1] == "fleeca" then
				local str = "<b>Fleeca Cooldowns</b>:<ul>"
				for k, v in pairs(FLEECA_LOCATIONS) do
					if not _fcGlobalReset[k] then
						str = str .. string.format("<li><b>%s</b>: Not Yet Hit</li>", v.label)
					else
						if os.time() > _fcGlobalReset[k] then
							str = str
								.. string.format(
									"<li><b>%s</b>: Expired (%s)</li>",
									v.label,
									GetFormattedTimeFromSeconds(_fcGlobalReset[k] - os.time())
								)
						else
							str = str
								.. string.format(
									"<li><b>%s</b>: On Cooldown (%s)</li>",
									v.label,
									GetFormattedTimeFromSeconds(_fcGlobalReset[k] - os.time())
								)
						end
					end
				end
				local str = str .. "</ul>"
				Chat.Send.System:Single(source, str)
			elseif args[1]:find("fleeca") and FLEECA_LOCATIONS[args[1]] ~= nil then
				local fleecaData = FLEECA_LOCATIONS[args[1]]
				if not _fcGlobalReset[args[1]] then
					Chat.Send.System:Single(source, string.format("Fleeca - %s: Not Yet Hit", fleecaData.label))
				else
					if os.time() > _fcGlobalReset[args[1]] then
						Chat.Send.System:Single(
							source,
							string.format(
								"Fleeca - %s: Expired (%s)",
								fleecaData.label,
								GetFormattedTimeFromSeconds(_fcGlobalReset[args[1]] - os.time())
							)
						)
					else
						Chat.Send.System:Single(
							source,
							string.format(
								"Fleeca - %s: On Cooldown (%s)",
								fleecaData.label,
								GetFormattedTimeFromSeconds(_fcGlobalReset[args[1]] - os.time())
							)
						)
					end
				end
			else
				Execute:Client(source, "Notification", "Error", "Invalid Heist ID")
			end
		else
			local str = "<ul>"

			for k, v in pairs(FLEECA_LOCATIONS) do
				if not _fcGlobalReset[k] then
					str = str .. string.format("<li><b>Fleeca %s</b>: Not Yet Hit</li>", v.label)
				else
					if os.time() > _fcGlobalReset[k] then
						str = str
							.. string.format(
								"<li><b>Fleeca %s</b>: Expired (%s)</li>",
								v.label,
								GetFormattedTimeFromSeconds(_fcGlobalReset[k] - os.time())
							)
					else
						str = str
							.. string.format(
								"<li><b>Fleeca %s</b>: On Cooldown (%s)</li>",
								v.label,
								GetFormattedTimeFromSeconds(_fcGlobalReset[k] - os.time())
							)
					end
				end
			end

			if not _bcGlobalReset then
				str = str .. "<li><b>Bobcat</b>: Not Yet Hit</li>"
			else
				if os.time() > _bcGlobalReset then
					str = str
						.. string.format(
							"<li><b>Bobcat</b>: Expired (%s)</li>",
							GetFormattedTimeFromSeconds(_bcGlobalReset - os.time())
						)
				else
					str = str
						.. string.format(
							"<li><b>Bobcat</b>: On Cooldown (%s)</li>",
							GetFormattedTimeFromSeconds(_bcGlobalReset - os.time())
						)
				end
			end

			if not _mbGlobalReset then
				str = str .. "<li><b>Maze Bank</b>: Not Yet Hit</li>"
			else
				if os.time() > _mbGlobalReset then
					str = str
						.. string.format(
							"<li><b>Maze Bank</b>: Expired (%s)</li>",
							GetFormattedTimeFromSeconds(_mbGlobalReset - os.time())
						)
				else
					str = str
						.. string.format(
							"<li><b>Maze Bank</b>: On Cooldown (%s)</li>",
							GetFormattedTimeFromSeconds(_mbGlobalReset - os.time())
						)
				end
			end

			if not _lbGlobalReset then
				str = str .. "<li><b>Lombank</b>: Not Yet Hit</li>"
			else
				if os.time() > _lbGlobalReset then
					str = str
						.. string.format(
							"<li><b>Lombank</b>: Expired (%s)</li>",
							GetFormattedTimeFromSeconds(_lbGlobalReset - os.time())
						)
				else
					str = str
						.. string.format(
							"<li><b>Lombank</b>: On Cooldown (%s)</li>",
							GetFormattedTimeFromSeconds(_lbGlobalReset - os.time())
						)
				end
			end

			if not _pbGlobalReset then
				str = str .. "<li><b>Paleto</b>: Not Yet Hit</li>"
			else
				if os.time() > _pbGlobalReset then
					str = str
						.. string.format(
							"<li><b>Paleto</b>: Expired (%s)</li>",
							GetFormattedTimeFromSeconds(_pbGlobalReset - os.time())
						)
				else
					str = str
						.. string.format(
							"<li><b>Paleto</b>: On Cooldown (%s)</li>",
							GetFormattedTimeFromSeconds(_pbGlobalReset - os.time())
						)
				end
			end

			local str = str .. "</ul>"
			Chat.Send.System:Single(source, str)
		end
	end, {
		help = "Check Heist Cooldown",
		params = {
			{
				name = "(Optional) Heist ID",
				help = "ID of heist to check cooldown timer (paleto, lombank, mazebank, bobcat, fleeca_*)",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("checkshitlord", function(source, args, rawCommand)
		if GlobalState["AntiShitlord"] ~= nil then
			if os.time() > GlobalState["AntiShitlord"] then
				Chat.Send.System:Single(
					source,
					string.format(
						"AntiShitlord: Expired (%s)",
						GetFormattedTimeFromSeconds(GlobalState["AntiShitlord"] - os.time())
					)
				)
			else
				Chat.Send.System:Single(
					source,
					string.format(
						"AntiShitlord: On Cooldown (%s)",
						GetFormattedTimeFromSeconds(GlobalState["AntiShitlord"] - os.time())
					)
				)
			end
		else
			Chat.Send.System:Single(source, "AntiShitlord: Not Yet Triggered")
		end
	end, {
		help = "Display AnitShitlord Cooldown Timer",
	})

	Chat:RegisterAdminCommand("resetshitlord", function(source, args, rawCommand)
		GlobalState["AntiShitlord"] = false
	end, {
		help = "Reset AnitShitlord Cooldown Timer",
	})

	Chat:RegisterAdminCommand("togglerobbery", function(source, args, rawCommand)
		GlobalState["RobberiesDisabled"] = not GlobalState["RobberiesDisabled"]
	end, {
		help = "Enabled/Disables Robbries",
	})

	Chat:RegisterAdminCommand("disablelockdown", function(source, args, rawCommand)
		GlobalState["RestartLockdown"] = false
	end, {
		help = "Disable Restart Lockdown",
	})
end
