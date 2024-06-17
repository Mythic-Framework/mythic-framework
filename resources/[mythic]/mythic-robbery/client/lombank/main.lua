function LBNeedsReset()
	for k, v in pairs(lbThermPoints) do
		if not Doors:IsLocked(v.door) then
			return true
		end
	end

	for k, v in pairs(_lbHackPoints) do
		if not Doors:IsLocked(v.door) then
			return true
		end
	end

	for k, v in ipairs(_lbUpperVaultPoints) do
		if
			GlobalState[string.format("Lombank:Upper:Wall:%s", v.wallId)] ~= nil
			and GlobalState[string.format("Lombank:Upper:Wall:%s", v.wallId)] > GetCloudTimeAsInt()
		then
			return true
		end
	end

	return false
end

function IsLBPowerDisabled()
	for k, v in ipairs(_lbPowerBoxes) do
		if
			not GlobalState[string.format("Lombank:Power:%s", data.boxId)]
			or GetCloudTimeAsInt() > GlobalState[string.format("Lombank:Power:%s", data.boxId)]
		then
			return false
		end
	end
	return true
end

AddEventHandler("Robbery:Client:Setup", function()
	Polyzone.Create:Poly("dumbcunt", {
		vector2(-316.5087890625, -2439.6040039062),
		vector2(-319.24176025391, -2436.7438964844),
		vector2(-326.0520324707, -2431.16796875),
		vector2(-327.56423950195, -2433.0493164062),
		vector2(-321.0280456543, -2438.8662109375),
		vector2(-321.59643554688, -2438.9645996094),
		vector2(-328.29962158203, -2433.2578125),
		vector2(-331.92529296875, -2437.6667480469),
		vector2(-321.82626342773, -2446.1845703125)
	}, {
		minZ = 5.4941825866699,
		maxZ = 11.6915531158447
	}, {
		isDeath = true,
		tpCoords = vector3(-291.188, -2406.996, 6.901),
		door = "coke_garage",
	})

	Polyzone.Create:Poly("bank_lombank", {
		vector2(-0.41744011640549, -933.08654785156),
		vector2(14.137574195862, -893.74298095703),
		vector2(47.590084075928, -905.93432617188),
		vector2(31.678886413574, -949.58227539062),
		vector2(1.5427644252777, -938.97210693359),
	}, {
		-- debugPoly = true,
	})

	Polyzone.Create:Poly("lombank_power", {
		vector2(43.716075897217, -811.39093017578),
		vector2(43.310741424561, -812.01684570312),
		vector2(46.399833679199, -813.21368408203),
		vector2(42.919136047363, -823.21014404297),
		vector2(49.144268035889, -825.46929931641),
		vector2(53.048881530762, -814.73663330078),
		vector2(46.760047912598, -812.44616699219),
	}, {
		-- debugPoly = true,
		minZ = 29.4411277771,
		maxZ = 34.817783355713,
	}, {
		isDeath = true,
		tpCoords = vector3(2.593, -935.504, 29.905),
		door = "lombank_hidden_entrance",
	})

	Targeting.Zones:AddBox("lombank_secure", "shield-keyhole", vector3(7.69, -923.1, 29.9), 2.8, 1.6, {
		heading = 340,
		--debugPoly=true,
		minZ = 28.9,
		maxZ = 30.7,
	}, {
		{
			icon = "phone",
			text = "Secure Bank",
			event = "Robbery:Client:Lombank:StartSecuring",
			jobPerms = {
				{
					job = "police",
					reqDuty = true,
				},
			},
			data = {},
			isEnabled = LBNeedsReset,
		},
	}, 3.0, true)

	Polyzone.Create:Box("lombank_death", vector3(24.86, -921.78, 25.74), 7.4, 7.8, {
		heading = 340,
		--debugPoly=true,
		minZ = 24.74,
		maxZ = 28.74,
	}, {
		isDeath = true,
		tpCoords = vector3(2.593, -935.504, 29.905),
		door = "lombank_lasers",
	})

	for k, v in ipairs(_lombankRooms) do
		Polyzone.Create:Box(string.format("lombank_room_%s", v.roomId), v.coords, v.length, v.width, v.options, {
			isLombankRoom = true,
			roomId = v.roomId,
		})
	end

	for k, v in ipairs(_lbPowerBoxes) do
		Targeting.Zones:AddBox(
			string.format("lombank_power_%s", v.data.boxId),
			"box-taped",
			v.coords,
			v.length,
			v.width,
			v.options,
			v.isThermite
					and {
						{
							icon = "fire",
							text = "Use Thermite",
							item = "thermite",
							event = "Robbery:Client:Lombank:ElectricBox:Thermite",
							data = v.data,
							isEnabled = function(data, entity)
								return not GlobalState[string.format("Lombank:Power:%s", data.boxId)]
									or GetCloudTimeAsInt()
										> GlobalState[string.format("Lombank:Power:%s", data.boxId)]
							end,
						},
					}
				or {
					{
						icon = "terminal",
						text = "Hack Power Interface",
						item = "adv_electronics_kit",
						event = "Robbery:Client:Lombank:ElectricBox:Hack",
						data = v.data,
						isEnabled = function(data, entity)
							return not GlobalState[string.format("Lombank:Power:%s", data.boxId)]
								or GetCloudTimeAsInt() > GlobalState[string.format("Lombank:Power:%s", data.boxId)]
						end,
					},
				},
			3.0,
			true
		)
	end

	for k, v in ipairs(_lbUpperVaultPoints) do
		Targeting.Zones:AddBox(
			string.format("lombank_upper_%s", v.wallId),
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
					event = "Robbery:Client:Lombank:Drill",
					data = {
						id = v.wallId,
					},
					isEnabled = function(data, entity)
						return not GlobalState[string.format("Lombank:Upper:Wall:%s", data.id)]
							or GetCloudTimeAsInt() > GlobalState[string.format("Lombank:Upper:Wall:%s", data.id)]
					end,
				},
			},
			3.0,
			true
		)
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if type(data) == "table" then
		if data.isDeath then
			if not data.door or Doors:IsLocked(data.door) then
				Damage.Apply:StandardDamage(10000, false, true)
				TriggerServerEvent("Robbery:Server:Idiot", id)
				if data.tpCoords ~= nil then
					ClearPedTasksImmediately(PlayerPedId())
					Wait(100)
					SetEntityCoords(PlayerPedId(), data.tpCoords.x, data.tpCoords.y, data.tpCoords.z, 0, 0, 0, false)
				end
			end
		end
	end

	if id == "bank_lombank" then
		LocalPlayer.state:set("inLombank", true, true)
	elseif id == "lombank_power" then
		LocalPlayer.state:set("inLombankPower", true, true)
	elseif data.isLombankRoom then
		LocalPlayer.state:set("lombankRoom", data.roomId, true)
		for k, v in ipairs(_lbCarts) do
			Targeting:AddObject(v, "treasure-chest", {
				{
					text = "Grab Loot",
					icon = "hand",
					event = "Robbery:Client:Lombank:LootCart",
					data = data.roomId,
					minDist = 2.0,
					isEnabled = function(d, entity)
						local coords = GetEntityCoords(entity.entity)
						return not Doors:IsLocked("lombank_lower_gate")
							and not Doors:IsLocked("lombank_lower_vault")
							and not Doors:IsLocked(string.format("lombank_lower_room_%s", data.roomId))
							and GlobalState[string.format(
								"Lombank:VaultRoom:%s:%s:%s",
								d,
								math.ceil(coords.x),
								math.ceil(coords.y)
							)] == nil
							and not Entity(entity.entity).state.looted
					end,
				},
			}, 1.8)
		end
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "bank_lombank" then
		LocalPlayer.state:set("inLombank", false, true)
	elseif id == "lombank_power" then
		LocalPlayer.state:set("inLombankPower", false, true)
	elseif data.isLombankRoom then
		LocalPlayer.state:set("lombankRoom", false, true)
		for k, v in ipairs(_lbCarts) do
			Targeting:RemoveObject(v)
		end
	end
end)

AddEventHandler("Robbery:Client:Lombank:StartSecuring", function(entity, data)
	Progress:Progress({
		name = "secure_lombank",
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
			Callbacks:ServerCallback("Robbery:Lombank:SecureBank", {})
		end
	end)
end)

AddEventHandler("Robbery:Client:Lombank:ElectricBox:Hack", function(entity, data)
	Callbacks:ServerCallback("Robbery:Lombank:ElectricBox:Hack", data, function() end)
end)

AddEventHandler("Robbery:Client:Lombank:ElectricBox:Thermite", function(entity, data)
	Callbacks:ServerCallback("Robbery:Lombank:ElectricBox:Thermite", data, function() end)
end)

AddEventHandler("Robbery:Client:Lombank:Drill", function(entity, data)
	Callbacks:ServerCallback("Robbery:Lombank:Drill", data.id, function() end)
end)

AddEventHandler("Robbery:Client:Lombank:LootCart", function(entity, data)
	Callbacks:ServerCallback(
		"Robbery:Lombank:Vault:StartLootTrolley",
		{ coords = GetEntityCoords(entity.entity) },
		function(valid)
			if valid then
				local CashAppear = function()
					RequestModel(GetHashKey("ch_prop_gold_bar_01a"))
					while not HasModelLoaded(GetHashKey("ch_prop_gold_bar_01a")) do
						Wait(1)
					end
					local grabobj = CreateObject(GetHashKey("ch_prop_gold_bar_01a"), myCoords, true)

					FreezeEntityPosition(grabobj, true)
					SetEntityInvincible(grabobj, true)
					SetEntityNoCollisionEntity(grabobj, LocalPlayer.state.ped)
					SetEntityVisible(grabobj, false, false)
					AttachEntityToEntity(
						grabobj,
						LocalPlayer.state.ped,
						GetPedBoneIndex(LocalPlayer.state.ped, 60309),
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						false,
						false,
						false,
						false,
						0,
						true
					)
					local startedGrabbing = GetGameTimer()

					CreateThread(function()
						while GetGameTimer() - startedGrabbing < 37000 do
							Wait(1)
							DisableControlAction(0, 73, true)
							if HasAnimEventFired(LocalPlayer.state.ped, GetHashKey("CASH_APPEAR")) then
								if not IsEntityVisible(grabobj) then
									SetEntityVisible(grabobj, true, false)
								end
							end
							if HasAnimEventFired(LocalPlayer.state.ped, GetHashKey("RELEASE_CASH_DESTROY")) then
								if IsEntityVisible(grabobj) then
									SetEntityVisible(grabobj, false, false)
									--TODO Trigger loot
								end
							end
						end
						DeleteObject(grabobj)
					end)
				end

				local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

				local coords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0.0, 0.0, -0.5)
				local rot = GetEntityRotation(LocalPlayer.state.ped)

				RequestAnimDict("anim@heists@ornate_bank@grab_cash")
				RequestModel(baghash)
				while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(baghash) do
					Wait(100)
				end

				local GrabBag = CreateObject(
					GetHashKey("hei_p_m_bag_var22_arm_s"),
					GetEntityCoords(PlayerPedId()),
					true,
					false,
					false
				)
				local Grab1 = NetworkCreateSynchronisedScene(
					coords,
					rot.x,
					rot.y,
					rot.z + 180.0,
					2,
					false,
					false,
					1065353216,
					0,
					1.3
				)
				NetworkAddPedToSynchronisedScene(
					LocalPlayer.state.ped,
					Grab1,
					"anim@heists@ornate_bank@grab_cash",
					"intro",
					1.5,
					-4.0,
					1,
					16,
					1148846080,
					0
				)
				NetworkAddEntityToSynchronisedScene(
					GrabBag,
					Grab1,
					"anim@heists@ornate_bank@grab_cash",
					"bag_intro",
					4.0,
					-8.0,
					1
				)
				--SetPedComponentVariation(LocalPlayer.state.ped, 5, 0, 0, 0)
				NetworkStartSynchronisedScene(Grab1)
				Wait(1500)
				CashAppear()
				local Grab2 = NetworkCreateSynchronisedScene(
					coords,
					rot.x,
					rot.y,
					rot.z + 180.0,
					2,
					false,
					false,
					1065353216,
					0,
					1.3
				)
				NetworkAddPedToSynchronisedScene(
					LocalPlayer.state.ped,
					Grab2,
					"anim@heists@ornate_bank@grab_cash",
					"grab",
					1.5,
					-4.0,
					1,
					16,
					1148846080,
					0
				)
				NetworkAddEntityToSynchronisedScene(
					GrabBag,
					Grab2,
					"anim@heists@ornate_bank@grab_cash",
					"bag_grab",
					4.0,
					-8.0,
					1
				)
				NetworkStartSynchronisedScene(Grab2)
				Wait(37000)
				local Grab3 = NetworkCreateSynchronisedScene(
					coords,
					rot.x,
					rot.y,
					rot.z + 180.0,
					2,
					false,
					false,
					1065353216,
					0,
					1.3
				)
				NetworkAddPedToSynchronisedScene(
					LocalPlayer.state.ped,
					Grab3,
					"anim@heists@ornate_bank@grab_cash",
					"exit",
					1.5,
					-4.0,
					1,
					16,
					1148846080,
					0
				)
				NetworkAddEntityToSynchronisedScene(
					GrabBag,
					Grab3,
					"anim@heists@ornate_bank@grab_cash",
					"bag_exit",
					4.0,
					-8.0,
					1
				)
				NetworkStartSynchronisedScene(Grab3)

				Callbacks:ServerCallback(
					"Robbery:Lombank:Vault:FinishLootTrolley",
					{ coords = GetEntityCoords(entity.entity) }
				)
				Entity(entity.entity).state:set("looted", true, true)
				Wait(1800)
				if DoesEntityExist(GrabBag) then
					DeleteEntity(GrabBag)
				end
				--SetPedComponentVariation(LocalPlayer.state.ped, 5, 45, 0, 0)
				RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
				SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
			end
		end
	)
end)
