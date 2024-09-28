local _sbChangeHandlers = {}

function PaletoNeedsReset()
	if _bankStates.paleto.workstation or _bankStates.paleto.vaultTerminal then
		return true
	end

	for k, v in ipairs(_pbDoorIds) do
		if not Doors:IsLocked(v) then
			return true
		end
	end

	for k, v in pairs(_bankStates.paleto.securityPower) do
		if v ~= nil then
			return true
		end
	end

	for k, v in pairs(_bankStates.paleto.officeHacks) do
		if v ~= nil then
			return true
		end
	end

	for k, v in pairs(_bankStates.paleto.drillPoints) do
		if v ~= nil then
			return true
		end
	end

	if IsPaletoPowerDisabled() then
		return true
	end

	return false
end

AddEventHandler("Robbery:Client:Setup", function()
	Polyzone.Create:Poly("bank_paleto", {
		-- vector2(-102.71809387207, 6450.455078125),
		-- vector2(-103.4940032959, 6447.8139648438),
		-- vector2(-104.5740814209, 6447.9951171875),
		-- vector2(-103.34963226318, 6451.4379882812),
		-- vector2(-111.12901306152, 6459.4956054688),
		-- vector2(-109.9501953125, 6460.8173828125),
		-- vector2(-112.78342437744, 6463.6616210938),
		-- vector2(-113.99594116211, 6462.578125),
		-- vector2(-123.86438751221, 6472.3857421875),
		-- vector2(-115.0514755249, 6481.14453125),
		-- vector2(-113.489112854, 6479.6889648438),
		-- vector2(-107.47613525391, 6485.4438476562),
		-- vector2(-88.173873901367, 6465.876953125),
		-- vector2(-93.701072692871, 6460.7612304688),
		-- vector2(-93.123313903809, 6460.1650390625),
		vector2(-129.5386505127, 6470.3793945312),
		vector2(-103.76642608643, 6444.1923828125),
		vector2(-82.150863647461, 6466.1552734375),
		vector2(-107.7488861084, 6491.7861328125),
	}, {
		--debugPoly = true,
	})

	Polyzone.Create:Box("paleto_hack_access", vector3(-107.04, 6474.16, 31.63), 1.8, 1.2, {
		heading = 315,
		--debugPoly=true,
		minZ = 30.63,
		maxZ = 32.63,
	}, {})

	for k, v in ipairs(_pbKillZones) do
		Polyzone.Create:Box(string.format("pb_killzone_%s", k), v.coords, v.length, v.width, v.options, v.data)
	end

	for k, v in ipairs(_pbPCHackAreas) do
		Polyzone.Create:Box(
			string.format("paleto_hack_pc_%s", v.data.pcId),
			v.coords,
			v.length,
			v.width,
			v.options,
			v.data
		)
	end

	for k, v in ipairs(_pbSubStationZones) do
		Polyzone.Create:Box(
			string.format("pb_substation_%s", v.data.subStationId),
			v.coords,
			v.length,
			v.width,
			v.options,
			v.data
		)
	end

	Targeting.Zones:AddBox("paleto_secure", "shield-keyhole", vector3(-109.57, 6461.51, 31.64), 0.6, 0.4, {
		heading = 315,
		--debugPoly=true,
		minZ = 31.24,
		maxZ = 32.84,
	}, {
		{
			icon = "phone",
			text = "Secure Bank",
			event = "Robbery:Client:Paleto:StartSecuring",
			jobPerms = {
				{
					job = "police",
					reqDuty = true,
				},
			},
			data = {},
			isEnabled = PaletoNeedsReset,
		},
		{
			icon = "bell",
			text = "Disable Alarm",
			event = "Robbery:Client:Paleto:DisableAlarm",
			jobPerms = {
				{
					job = "police",
					reqDuty = true,
				},
			},
			data = {},
			isEnabled = function()
				return _bankStates.paleto.fookinLasers
			end,
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("paleto_security", "shield-keyhole", vector3(-91.76, 6464.78, 31.63), 1.4, 0.8, {
		heading = 315,
		--debugPoly=true,
		minZ = 30.63,
		maxZ = 32.43,
	}, {
		{
			icon = "bell",
			text = "Access Door Controls",
			event = "Robbery:Client:Paleto:Doors",
			data = {},
			isEnabled = function(data, entity)
				return IsPaletoExploitInstalled() and not Doors:IsLocked("bank_savings_paleto_security")
			end,
		},
	}, 3.0, true)

	Targeting.Zones:AddBox("paleto_hack_workstation", "terminal", vector3(-106.12, 6473.87, 31.63), 1.2, 0.6, {
		heading = 315,
		--debugPoly=true,
		minZ = 31.03,
		maxZ = 32.43,
	}, {
		{
			icon = "binary-lock",
			text = "Breach Network",
			items = {
				{
					item = "adv_electronics_kit",
					count = 1,
				},
				{
					item = "vpn",
					count = 1,
				},
			},
			event = "Robbery:Client:Paleto:Workstation",
			data = {},
			isEnabled = function(data, entity)
				return IsPaletoExploitInstalled()
					and LocalPlayer.state.inPaletoWSPoint
					and (not _bankStates.paleto.workstation or GetCloudTimeAsInt() > _bankStates.paleto.workstation)
			end,
		},
	}, 3.0, true)

	for k, v in ipairs(_pbOfficeHacks) do
		Targeting.Zones:AddBox(
			string.format("paleto_officehack_%s", k),
			"terminal",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "binary-lock",
					text = "Upload Exploit",
					event = "Robbery:Client:Paleto:OfficeHack",
					items = {
						{
							item = "adv_electronics_kit",
							count = 1,
						},
						{
							item = "vpn",
							count = 1,
						},
					},
					data = v.data,
					isEnabled = function(data, entity)
						return IsPaletoExploitInstalled()
							and (
								not _bankStates.paleto.officeHacks[v.data.officeId]
								or GetCloudTimeAsInt() > _bankStates.paleto.officeHacks[v.data.officeId]
							)
					end,
				},
			},
			3.0,
			true
		)
	end

	for k, v in ipairs(_pbPowerHacks) do
		Targeting.Zones:AddBox(
			string.format("paleto_electricbox_%s", k),
			"box-taped",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "terminal",
					text = "Hack Power Interface",
					item = "adv_electronics_kit",
					event = "Robbery:Client:Paleto:ElectricBox:Hack",
					data = v.data,
					isEnabled = function(data, entity)
						return not _bankStates.paleto.electricalBoxes[data.boxId]
							or GetCloudTimeAsInt() > _bankStates.paleto.electricalBoxes[data.boxId]
					end,
				},
			},
			3.0,
			true
		)
	end

	for k, v in ipairs(_pbLasers) do
		Lasers:Create(
			string.format("paleto_lasers_%s", k),
			v.origins,
			v.targets,
			v.options,
			false,
			function(playerBeingHit, hitPos)
				if playerBeingHit then
					Callbacks:ServerCallback("Robbery:Paleto:TriggeredLaser")
				end
			end
		)
	end

	for k, v in ipairs(_pbDrillPoints) do
		Targeting.Zones:AddBox(
			string.format("paleto_drillpoint_%s", v.data.drillId),
			"bore-hole",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "bore-hole",
					text = "Use Drill",
					item = "drill",
					event = "Robbery:Client:Paleto:Drill",
					data = v.data,
					isEnabled = function(data, entity)
						return IsPaletoExploitInstalled()
							and not Doors:IsLocked("bank_savings_paleto_vault")
							and (
								not _bankStates.paleto.drillPoints[data.drillId]
								or GetCloudTimeAsInt() > _bankStates.paleto.drillPoints[data.drillId]
							)
					end,
				},
			},
			3.0,
			true
		)
	end

	Targeting.Zones:AddBox("paleto_office_safe", "vault", vector3(-105.27, 6480.67, 31.63), 0.8, 0.6, {
		heading = 45,
		--debugPoly=true,
		minZ = 31.43,
		maxZ = 32.83,
	}, {
		{
			icon = "unlock",
			text = "Crack Safe",
			event = "Robbery:Client:Paleto:Safe",
			item = "paleto_access_codes",
			data = {},
			isEnabled = function(data, entity)
				return IsPaletoExploitInstalled()
					and not Doors:IsLocked("bank_savings_paleto_office_3")
					and (not _bankStates.paleto.officeSafe or GetCloudTimeAsInt() > _bankStates.paleto.officeSafe)
			end,
		},
	}, 3.0, true)

	for k, v in ipairs(_pbOfficeSearch) do
		Targeting.Zones:AddBox(
			string.format("paleto_searchpoint_%s", v.data.searchId),
			"magnifying-glass",
			v.coords,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "magnifying-glass",
					text = "Search",
					event = "Robbery:Client:Paleto:Search",
					data = v.data,
					isEnabled = function(data, entity)
						return IsPaletoExploitInstalled()
							and not Doors:IsLocked(data.door)
							and (
								not _bankStates.paleto.officeSearch[data.searchId]
								or GetCloudTimeAsInt() > _bankStates.paleto.officeSearch[data.searchId]
							)
					end,
				},
			},
			3.0,
			true
		)
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == "bank_paleto" then
		LocalPlayer.state:set("inPaletoBank", true, true)

		local powerDisabled = IsPaletoPowerDisabled()
		for k, v in ipairs(_pbLasers) do
			Lasers.Utils:SetActive(string.format("paleto_lasers_%s", k), not powerDisabled)
			Lasers.Utils:SetVisible(string.format("paleto_lasers_%s", k), not powerDisabled)
		end
	elseif id == "paleto_hack_access" and not Doors:IsLocked("bank_savings_paleto_gate") then
		LocalPlayer.state:set("inPaletoWSPoint", true, true)
	elseif data.subStationId ~= nil then
		LocalPlayer.state:set("inSubStation", data.subStationId, true)
	elseif data.pcId ~= nil then
		Targeting:AddObject(GetHashKey("xm_prop_base_staff_desk_02"), "computer", {
			{
				text = "Upload Exploit",
				icon = "terminal",
				event = "Robbery:Client:Paleto:Upload",
				item = "adv_electronics_kit",
				data = data,
				minDist = 2.0,
				isEnabled = function(data, entity)
					return (not GlobalState["Paleto:Secured"] or GetCloudTimeAsInt() > GlobalState["Paleto:Secured"])
						and (
							not _bankStates.paleto.exploits[data.pcId]
							or GetCloudTimeAsInt() > _bankStates.paleto.exploits[data.pcId]
						)
				end,
			},
		}, 3.0)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "bank_paleto" then
		LocalPlayer.state:set("inPaletoBank", false, true)
		for k, v in ipairs(_pbLasers) do
			Lasers.Utils:SetActive(string.format("paleto_lasers_%s", k), false)
			Lasers.Utils:SetVisible(string.format("paleto_lasers_%s", k), false)
		end
	elseif id == "paleto_hack_access" then
		LocalPlayer.state:set("inPaletoWSPoint", false, true)
	elseif data.subStationId ~= nil then
		LocalPlayer.state:set("inSubStation", false, true)
	elseif data.pcId ~= nil then
		Targeting:RemoveObject(GetHashKey("xm_prop_base_staff_desk_02"))
	end
end)

AddEventHandler("Robbery:Client:Update:paleto", function()
	if LocalPlayer.state.inPaletoBank then
		local powerDisabled = IsPaletoPowerDisabled()
		for k2, v2 in ipairs(_pbLasers) do
			Lasers.Utils:SetActive(string.format("paleto_lasers_%s", k2), not powerDisabled)
			Lasers.Utils:SetVisible(string.format("paleto_lasers_%s", k2), not powerDisabled)
		end
	end
end)

AddEventHandler("Robbery:Client:Paleto:ElectricBox:Hack", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:ElectricBox:Hack", data, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:Upload", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:PC:Hack", data, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:Workstation", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:Workstation", data, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:OfficeHack", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:OfficeHack", data, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:Drill", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:Drill", data.drillId, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:Search", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:Search", data, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:Safe", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:StartSafe", {}, function(s)
		if s then
			Input:Show("Input Access Code", "Access Code", {
				{
					id = "code",
					type = "number",
					options = {
						inputProps = {
							maxLength = 4,
						},
					},
				},
			}, "Robbery:Client:Paleto:SafeInput", data)
		end
	end)
end)

AddEventHandler("Robbery:Client:Paleto:SafeInput", function(values, data)
	Callbacks:ServerCallback("Robbery:Paleto:Safe", {
		code = values.code,
		data = data,
	}, function() end)
end)

AddEventHandler("Robbery:Client:Paleto:VaultTerminal", function()
	Progress:Progress({
		name = "disable_vault_pc",
		duration = math.random(45, 60) * 1000,
		label = "Disabling",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "type",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Robbery:Paleto:VaultTerminal", {})
		end
	end)
end)

AddEventHandler("Robbery:Client:Paleto:Door", function(data)
	if data.officeId ~= nil then
		Input:Show("Input Access Code", "Access Code", {
			{
				id = "code",
				type = "number",
				options = {
					inputProps = {
						maxLength = 4,
					},
				},
			},
		}, "Robbery:Client:Paleto:DoorInput", data)
	else
		Callbacks:ServerCallback("Robbery:Paleto:UnlockDoor", {
			data = data,
		})
	end
end)

AddEventHandler("Robbery:Client:Paleto:DoorInput", function(values, data)
	Callbacks:ServerCallback("Robbery:Paleto:UnlockDoor", {
		code = values.code,
		data = data,
	})
end)

AddEventHandler("Robbery:Client:Paleto:Doors", function(entity, data)
	Callbacks:ServerCallback("Robbery:Paleto:GetDoors", {}, function(menu)
		local menu = {
			main = {
				label = "Blaine Co Savings Door Controls",
				items = menu,
			},
		}

		ListMenu:Show(menu)
	end)
end)

AddEventHandler("Robbery:Client:Paleto:StartSecuring", function(entity, data)
	Progress:Progress({
		name = "secure_paleto",
		duration = 30000,
		label = "Securing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "cop3",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Robbery:Paleto:SecureBank", {})
		end
	end)
end)

AddEventHandler("Robbery:Client:Paleto:DisableAlarm", function(entity, data)
	Progress:Progress({
		name = "secure_paleto",
		duration = 3000,
		label = "Disabling",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "cop3",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Robbery:Paleto:DisableAlarm", {})
		end
	end)
end)

RegisterNetEvent("Robbery:Client:Paleto:CheckLasers", function()
	if LocalPlayer.state.inPaletoBank then
		local powerDisabled = IsPaletoPowerDisabled()
		for k2, v2 in ipairs(_pbLasers) do
			Lasers.Utils:SetActive(string.format("paleto_lasers_%s", k2), not powerDisabled)
			Lasers.Utils:SetVisible(string.format("paleto_lasers_%s", k2), not powerDisabled)
		end
	end
end)
