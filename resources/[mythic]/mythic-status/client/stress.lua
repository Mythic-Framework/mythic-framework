local _inPoly = false
local _pzs = {}
local _pzDefs = {
	{
		type = "poly",
		multiplier = 1.5,
		action = "Workout",
		points = {
			vector2(-1203.3349609375, -1555.8671875),
			vector2(-1192.1815185547, -1571.9835205078),
			vector2(-1197.1197509766, -1575.3504638672),
			vector2(-1194.9011230469, -1578.0895996094),
			vector2(-1199.2369384766, -1580.8479003906),
			vector2(-1204.626953125, -1573.2075195312),
			vector2(-1212.3363037109, -1562.1207275391),
			vector2(-1210.8671875, -1556.8021240234),
		},
		options = {
			minZ = -5.0,
			maxZ = 14.0,
		},
		anim = {
			task = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
		},
		blip = {
			coords = vector3(-1202.282, -1566.866, 4.611),
			label = "Workout",
			blip = 311,
			color = 83,
		},
	},
	{
		type = "poly",
		multiplier = 1.8,
		action = "Meditate",
		points = {
			vector2(1105.7791748047, -704.99737548828),
			vector2(1103.8100585938, -701.02239990234),
			vector2(1100.1141357422, -698.61083984375),
			vector2(1094.6956787109, -693.71221923828),
			vector2(1092.7503662109, -684.84948730469),
			vector2(1089.0186767578, -678.51544189453),
			vector2(1082.7523193359, -674.58209228516),
			vector2(1075.7874755859, -673.30426025391),
			vector2(1070.3399658203, -674.62750244141),
			vector2(1067.5163574219, -674.88171386719),
			vector2(1066.7075195312, -676.53717041016),
			vector2(1064.0555419922, -680.88421630859),
			vector2(1063.0137939453, -686.44854736328),
			vector2(1063.2587890625, -689.57061767578),
			vector2(1063.2515869141, -692.17254638672),
			vector2(1065.2457275391, -693.62091064453),
			vector2(1068.2559814453, -699.02276611328),
			vector2(1068.8885498047, -701.32604980469),
			vector2(1071.1813964844, -702.10766601562),
			vector2(1077.6141357422, -708.52655029297),
			vector2(1082.5245361328, -709.5517578125),
			vector2(1085.1809082031, -709.39373779297),
			vector2(1090.2124023438, -708.19317626953),
			vector2(1097.2241210938, -710.32000732422),
			vector2(1100.3881835938, -710.63458251953),
			vector2(1103.9838867188, -709.87579345703),
			vector2(1105.7490234375, -707.607421875),
		},
		options = {
			minZ = 56.600723266602,
			maxZ = 59.479084014893,
		},
		anim = {
			animDict = "rcmcollect_paperleadinout@",
			anim = "meditiate_idle",
		},
		blip = {
			coords = vector3(1081.771, -690.853, 57.746),
			label = "Meditation",
			blip = 197,
			color = 83,
		},
	},
	{
		type = "box",
		multiplier = 1.2,
		action = "Do Yoga",
		coords = vector3(500.32, 5626.56, 792.8),
		length = 7.8,
		width = 17.2,
		options = {
			heading = 30,
			minZ = 790.0,
			maxZ = 797.2,
		},
		anim = {
			task = "WORLD_HUMAN_YOGA",
		},
		blip = {
			coords = vector3(500.32, 5626.56, 792.8),
			label = "Yoga",
			blip = 197,
			color = 83,
		},
	},
	{
		type = "circle",
		multiplier = 2.0,
		action = "Meditate",
		coords = vector3(-2039.74, -370.82, 48.11),
		radius = 4.4,
		options = {
			heading = 30,
			useZ = false,
		},
		anim = {
			animDict = "rcmepsilonism3",
			anim = "ep_3_rcm_marnie_meditating",
		},
		blip = {
			coords = vector3(-2039.74, -370.82, 48.11),
			label = "Meditation",
			blip = 197,
			color = 83,
		},
	},
	{
		type = "circle",
		multiplier = 2.0,
		action = "Meditate",
		coords = vector3(1537.97, 6627.04, 7.66),
		radius = 17.85,
		options = {
			useZ = true,
		},
		anim = {
			animDict = "rcmepsilonism3",
			anim = "ep_3_rcm_marnie_meditating",
		},
		blip = {
			coords = vector3(1537.97, 6627.04, 7.66),
			label = "Meditation",
			blip = 197,
			color = 83,
		},
	},
	{
		type = "circle",
		multiplier = 2.5,
		action = "Take in the View",
		coords = vector3(-442.34, 1065.3, 327.68),
		radius = 16.0,
		options = {
			useZ = true,
		},
		anim = {
			animDict = "mp_move@prostitute@m@french",
			anim = "idle",
		},
		blip = {
			coords = vector3(-442.34, 1065.3, 327.68),
			label = "Observatory",
			blip = 184,
			color = 83,
		},
	},
	{
		type = "poly",
		multipier = 2.5, -- Seconds per 1 stress
		action = "Admire Art",
		points = {
			vector2(17.969923019409, 143.41970825195),
			vector2(14.668598175049, 134.01875305176),
			vector2(38.662933349609, 125.07109069824),
			vector2(47.664123535156, 149.34446716309),
			vector2(23.297855377197, 158.41168212891),
			vector2(20.98087310791, 150.66664123535),
			vector2(21.275186538696, 148.4054107666),
			vector2(22.746814727783, 147.86557006836),
			vector2(20.798263549805, 142.44667053223)
		},
		options = {
			minZ = 87.041,
			maxZ = 99.982,
		},
		anim = {
			animDict = "misscarsteal4@aliens",
			anim = "rehearsal_base_idle_director",
			flags = 49,
		},
		blip = {
			coords = vector3(27.344, 143.101, 93.792),
			label = "Art Gallery",
			blip = 617,
			color = 18,
		},
	},
	{
		type = "circle",
		multipier = 3.0, -- Seconds per 1 stress
		action = "Stare at Fishies",
		coords = vector3(-555.73, -601.6, 34.68),
		radius = 6.05,
		options = {},
		anim = {
			animDict = "misscarsteal4@aliens",
			anim = "rehearsal_base_idle_director",
			flags = 49,
		},
	},
	{
		type = "box",
		multiplier = 1.0,
		action = "Workout",
		coords = vector3(1745.97, 2481.29, 45.74),
		length = 6.8,
		width = 8.4,
		options = {
			heading = 30,
			--debugPoly=true,
			minZ = 44.74,
			maxZ = 47.34
		},
		anim = {
			task = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
		},
		blip = {
			coords = vector3(1745.97, 2481.29, 45.74),
			label = "Workout",
			blip = 311,
			color = 83,
		},
	},
	{
		type = "circle",
		multiplier = 2.0,
		action = "Meditate By the Fire",
		coords = vector3(-579.11, -1052.83, 22.35),
		radius = 4.0,
		options = {
			useZ = true,
		},
		anim = {
			animDict = "rcmepsilonism3",
			anim = "ep_3_rcm_marnie_meditating",
		},
	},
	-- The Gym Building
	{
		type = "box",
		multiplier = 1.0,
		action = "Workout",
		coords = vector3(-1264.95, -355.01, 36.96),
		length = 4.6,
		width = 9.4,
		options = {
			heading = 27,
			--debugPoly=true,
			minZ = 35.96,
			maxZ = 38.76
		},
		anim = {
			task = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
		},
	},
	{
		type = "box",
		multiplier = 1.0,
		action = "Workout",
		coords = vector3(-1268.84, -363.87, 36.96),
		length = 4.6,
		width = 9.4,
		options = {
			heading = 117,
			--debugPoly=true,
			minZ = 35.96,
			maxZ = 38.76
		},
		anim = {
			task = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS",
		},
	},
	{
		type = "box",
		multiplier = 1.2,
		action = "Do Yoga",
		coords = vector3(-1262.5, -360.85, 36.99),
		length = 6.0,
		width = 6.0,
		options = {
			heading = 117,
			--debugPoly=true,
			minZ = 35.99,
			maxZ = 38.79
		},
		anim = {
			task = "WORLD_HUMAN_YOGA",
		},
		blip = {
			coords = vector3(-1262.5, -360.85, 36.99),
			label = "Gym",
			blip = 311,
			color = 83,
		},
	},
}

function CreateStressPolys()
	for k, v in ipairs(_pzDefs) do
		local pId = string.format("StressReleif%s", k)
		if v.type == "poly" then
			Polyzone.Create:Poly(pId, v.points, v.options or {}, v.data or {})
		elseif v.type == "box" then
			Polyzone.Create:Box(pId, v.coords, v.length, v.width, v.options or {}, v.data or {})
		else
			Polyzone.Create:Circle(pId, v.coords, v.radius, v.options or {}, v.data or {})
		end

		_pzs[pId] = k
	end
end

function CreateStressBlips()
	for k, v in ipairs(_pzDefs) do
		local pId = string.format("StressReleif%s", k)

		if v.blip ~= nil then
			Blips:Add(pId, v.blip.label or "Stress Reliever", v.blip.coords, v.blip.blip or 66, v.blip.color or 83, v.blip.scale or 0.55)
		end
	end
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if _pzs[id] and Status.Get:Single("PLAYER_STRESS").value > 0 and not _delay then
		while GetVehiclePedIsIn(LocalPlayer.state.ped) ~= 0 do
			Wait(10)
		end
		_inPoly = id
		Action:Show(string.format("{keybind}primary_action{/keybind} To %s", _pzDefs[_pzs[id]].action))
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if _pzs[id] and id == _inPoly then
		_inPoly = nil
		Action:Hide()
	end
end)

local _delay = false
AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _inPoly then
		if _pzDefs[_pzs[_inPoly]].anim ~= nil and not _delay then
			local animData = _pzDefs[_pzs[_inPoly]].anim

			local currentStress = Status.Get:Single("PLAYER_STRESS").value
			local reliefMultiplier = _pzDefs[_pzs[_inPoly]].multipier or 3.0

			local totalTime = math.ceil(currentStress * reliefMultiplier) * 1000
			local tickTime = totalTime / currentStress

			_delay = true
			Action:Hide()
			Progress:ProgressWithTickEvent({
				name = "stress_releif",
				duration = totalTime,
				label = "Relieving Stress",
				tickrate = tickTime,
				useWhileDead = false,
				canCancel = true,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = animData,
				disarm = true,
			}, function()
				Status.Modify:Remove("PLAYER_STRESS", 1, true)
			end, function(cancelled)
				if not cancelled then
					Status.Set:Single("PLAYER_STRESS", 0)
					Notification:Success("Stress Relieved")
				else
					Notification:Info("Stress Partially Relieved")
				end

				SetTimeout(tickTime * 2, function()
					_delay = false
					if _inPoly ~= nil and Status.Get:Single("PLAYER_STRESS").value > 0 then
						Action:Show(string.format("{keybind}primary_action{/keybind} To %s", _pzDefs[_pzs[_inPoly]].action))
					end
				end)
			end)
		end
	end
end)
