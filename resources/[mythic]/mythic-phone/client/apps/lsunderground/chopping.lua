local _blips = {}

local _doingActions = false
local _validVeh = nil
local _validBone = nil
local _delay = false
local _vehBones = {
	car = {
		{ name = "wheel_lf", distance = 1.6, index = 0, type = "tire", duration = 3000 },
		{ name = "wheel_rf", distance = 1.6, index = 1, type = "tire", duration = 3000 },
		{ name = "wheel_lm", distance = 1.6, index = 2, type = "tire", duration = 3000 },
		{ name = "wheel_rm", distance = 1.6, index = 3, type = "tire", duration = 3000 },
		{ name = "wheel_lr", distance = 1.6, index = 4, type = "tire", duration = 3000 },
		{ name = "wheel_rr", distance = 1.6, index = 5, type = "tire", duration = 3000 },
		{ name = "wheel_lm1", distance = 1.6, index = 2, type = "tire", duration = 3000 },
		{ name = "wheel_rm1", distance = 1.6, index = 3, type = "tire", duration = 3000 },

		{ name = "wheel_lf", distance = 1.6, index = 0, type = "wheel", duration = 6000 },
		{ name = "wheel_rf", distance = 1.6, index = 1, type = "wheel", duration = 6000 },
		{ name = "wheel_lr", distance = 1.6, index = 2, type = "wheel", duration = 6000 },
		{ name = "wheel_rr", distance = 1.6, index = 3, type = "wheel", duration = 6000 },
		{ name = "wheel_lm", distance = 1.6, index = 2, type = "wheel", duration = 6000 },
		{ name = "wheel_rm", distance = 1.6, index = 3, type = "wheel", duration = 6000 },
		{ name = "wheel_lm1", distance = 1.6, index = 2, type = "wheel", duration = 6000 },
		{ name = "wheel_rm1", distance = 1.6, index = 3, type = "wheel", duration = 6000 },

		{ name = "door_dside_f", distance = 1.8, index = 0, type = "door", duration = 6000 },
		{ name = "door_pside_f", distance = 1.8, index = 1, type = "door", duration = 6000 },
		{ name = "door_dside_r", distance = 1.8, index = 2, type = "door", duration = 6000 },
		{ name = "door_pside_r", distance = 1.8, index = 3, type = "door", duration = 6000 },
		{ name = "bonnet", distance = 2.8, index = 4, type = "door", duration = 9000 },
		{ name = "boot", distance = 1.6, index = 5, type = "door", duration = 9000 },
	},

	bikes = {
		{ name = "wheel_lf", distance = 1.6, index = 0, type = "tire", duration = 3000 },
		{ name = "wheel_rf", distance = 1.6, index = 1, type = "tire", duration = 3000 },
		{ name = "wheel_lm", distance = 1.6, index = 2, type = "tire", duration = 3000 },
		{ name = "wheel_rm", distance = 1.6, index = 3, type = "tire", duration = 3000 },
		{ name = "wheel_lr", distance = 1.6, index = 4, type = "tire", duration = 3000 },
		{ name = "wheel_rr", distance = 1.6, index = 5, type = "tire", duration = 3000 },
		{ name = "wheel_lm1", distance = 1.6, index = 2, type = "tire", duration = 3000 },
		{ name = "wheel_rm1", distance = 1.6, index = 3, type = "tire", duration = 3000 },

		{ name = "wheel_rf", distance = 1.6, index = 0, type = "wheel", duration = 6000 },
		{ name = "wheel_lf", distance = 1.6, index = 1, type = "wheel", duration = 6000 }
	}
}
local _brokenVehWheels = {}

RegisterNetEvent("Phone:Client:Spawn", function(data)
	Polyzone.Create:Box(
		"chopping_public",
		GlobalState["PublicDropoff"].coords,
		GlobalState["PublicDropoff"].length,
		GlobalState["PublicDropoff"].width,
		GlobalState["PublicDropoff"].options,
		{}
	)
	Polyzone.Create:Box(
		"chopping_private",
		GlobalState["PrivateDropoff"].coords,
		GlobalState["PrivateDropoff"].length,
		GlobalState["PrivateDropoff"].width,
		GlobalState["PrivateDropoff"].options,
		{}
	)
	Polyzone.Create:Box(
		"chopping_personal",
		GlobalState["PersonalDropoff"].coords,
		GlobalState["PersonalDropoff"].length,
		GlobalState["PersonalDropoff"].width,
		GlobalState["PersonalDropoff"].options,
		{}
	)

	Phone.LSUnderground.Chopping:CreateBlips()
end)

PHONE.LSUnderground = PHONE.LSUnderground or {}
PHONE.LSUnderground.Chopping = {
	CreateBlips = function(self)
		if Reputation:HasLevel("Salvaging", 3) or hasValue(LocalPlayer.state.Character:GetData("States") or {}, "ACCESS_LSUNDERGROUND") then
			_blips.public = Blips:Add(
				"chopping_public",
				"LSUNDG Public Dropoff",
				GlobalState["PublicDropoff"].coords,
				524,
				35,
				0.4
			)

			-- Only add personal blip if you have a personal chop list
			if LocalPlayer.state.Character:GetData("ChopLists") ~= nil
			and TableLength(LocalPlayer.state.Character:GetData("ChopLists")) > 0 then
				_blips.private = Blips:Add(
					"chopping_personal",
					"LSUNDG Personal Dropoff",
					GlobalState["PersonalDropoff"].coords,
					524,
					43,
					0.4
				)
			end
		else
			Blips:Remove("chopping_public")
			Blips:Remove("chopping_personal")
		end

		if hasValue(LocalPlayer.state.Character:GetData("States") or {}, "ACCESS_LSUNDERGROUND") then
			_blips.vip = Blips:Add(
				"chopping_private",
				"LSUNDG Private Dropoff",
				GlobalState["PrivateDropoff"].coords,
				524,
				36,
				0.4
			)
		else
			Blips:Remove("chopping_private")
		end
	end,
	AttemptChop = function(self)
		if _validBone ~= nil and _validVeh ~= nil then
			if _validBone?.type == "door" then
				if not IsVehicleDoorDamaged(_validVeh, _validBone?.index) then
					_delay = true
					PedFaceCoord(LocalPlayer.state.ped, _validBone?.coords)
					NetSync:SetVehicleDoorOpen(_validVeh, _validBone?.index, false, true)
					Progress:ProgressWithTickEvent({
						name = "chopping_action",
						duration = _validBone?.duration,
						label = "Removing Door",
						useWhileDead = true,
						canCancel = true,
						ignoreModifier = true,
						tickrate = 100,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							task = "WORLD_HUMAN_WELDING",
						},
					}, function()
						if _validVeh == nil or _validBone == nil then
							Progress:Cancel()
						end
					end, function(status)
						if not status then
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:ChopPart", {
								vNet = VehToNet(_validVeh),
								index = _validBone?.index,
							}, function(c) end)
						else
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
							NetSync:SetVehicleDoorShut(_validVeh, _validBone?.index, true)
						end

						SetTimeout(1500, function()
							_delay = false
						end)
					end)
				end
			elseif _validBone?.type == "tire" then
				if not IsVehicleTyreBurst(_validVeh, _validBone?.index) then
					_delay = true
					PedFaceCoord(LocalPlayer.state.ped, _validBone?.coords)
					Progress:ProgressWithTickEvent({
						name = "chopping_action",
						duration = _validBone?.duration,
						label = "Removing Tire",
						useWhileDead = true,
						canCancel = true,
						ignoreModifier = true,
						tickrate = 100,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
							anim = "machinic_loop_mechandplayer",
							flags = 1,
						},
					}, function()
						if _validVeh == nil or _validBone == nil then
							Progress:Cancel()
						end
					end, function(status)
						if not status then
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:ChopTire", {
								vNet = VehToNet(_validVeh),
								index = _validBone?.index,
							}, function(r)
								if r then
									SetTyreHealth(_validVeh, _validBone?.index, true, 0)
									SetVehicleTyreBurst(_validVeh, _validBone?.index, true, 1000)
									NetSync:SetVehicleTyreBurst(_validVeh, _validBone?.index, true, 1000)
								end
							end)
						else
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
						end
						SetTimeout(1500, function()
							_delay = false
						end)
					end)
				end
			elseif _validBone?.type == "wheel" then
				local vState = Entity(_validVeh).state
				local wheels = vState.brokenWheels or {}
				local boneIndex = _validBone?.index
				if not wheels[boneIndex] then
					_delay = true
					PedFaceCoord(LocalPlayer.state.ped, _validBone?.coords)
					Progress:ProgressWithTickEvent({
						name = "chopping_action",
						duration = _validBone?.duration,
						label = "Removing Wheel",
						useWhileDead = true,
						canCancel = true,
						ignoreModifier = true,
						tickrate = 100,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
							anim = "machinic_loop_mechandplayer",
							flags = 1,
						},
					}, function()
						if _validVeh == nil or _validBone == nil then
							Progress:Cancel()
						end
					end, function(status)
						if not status then
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:ChopWheel", {
								vNet = VehToNet(_validVeh),
								index = _validBone?.index,
							}, function(r)
								if r then
									BreakOffVehicleWheel(_validVeh, _validBone?.index, false, true, true, false)
									NetSync:BreakOffVehicleWheel(_validVeh, _validBone?.index, false, true, true, false)
									Wait(100)
									local vState = Entity(_validVeh).state
									local wheels = vState.brokenWheels or {}
									wheels[boneIndex] = true
									Entity(_validVeh).state:set("brokenWheels", wheels, true)
								end
							end)
						else
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
						end
						SetTimeout(1500, function()
							_delay = false
						end)
					end)
				end
			elseif _validBone?.type == "body" then
				if DoesEntityExist(_validVeh) then
					_delay = true
					PedFaceCoord(LocalPlayer.state.ped, _validBone?.coords)
					Progress:ProgressWithTickEvent({
						name = "chopping_action",
						duration = _validBone?.duration,
						label = "Scrapping Vehicle",
						useWhileDead = true,
						canCancel = true,
						ignoreModifier = true,
						tickrate = 100,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "mini@repair",
							anim = "fixing_a_ped",
							flags = 17,
						},
					}, function()
						if _validVeh == nil or _validBone == nil then
							Progress:Cancel()
						end
					end, function(status)
						if not status then
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:ChopVehicle", {
								vNet = VehToNet(_validVeh),
							}, function(r)
								-- if r then
								-- 	NetSync:DeleteVehicle(_validVeh)
								-- end
							end)
						else
							Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
						end
						SetTimeout(1500, function()
							_delay = false
						end)
					end)
				end
			end
		end
	end,
}

function DoChoppingThings(veh)
	local vehClass = GetVehicleClass(veh)
	local isBike = vehClass == 8 or vehClass == 13
	local vehBones = _vehBones[isBike and "bike" or "car"]
	local bones = GetValidBones(veh, vehBones)

	Citizen.CreateThread(function()
		while LocalPlayer.state.chopping ~= nil and DoesEntityExist(NetToVeh(LocalPlayer.state.chopping)) do
			Citizen.Wait(100)
		end
		LocalPlayer.state:set("chopping", nil, true)
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.inChopZone ~= nil and LocalPlayer.state.chopping ~= nil do
			bones = GetValidBones(veh, vehBones)
			Citizen.Wait(100)
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn and not LocalPlayer.state.isDead and LocalPlayer.state.inChopZone ~= nil and LocalPlayer.state.chopping ~= nil do
			local bone, coords, distance = GetClosestBone(veh, bones)

			if not IsPedInAnyVehicle(LocalPlayer.state.ped) and distance and distance <= 30.0 then
				local inDistance, text = false, nil

				if bone.type ~= "body" and distance <= bone.distance then
					inDistance, text = true, string.format(
						"Chop Vehicle %s",
						bone.type == "tire" and "Tire" or bone.type == "wheel" and "Wheel" or bone.type == "door" and "Door" or "Part"
					)
				elseif bone.type == "body" and distance <= 18.0 then
					inDistance, text = true, "Scrap Vehicle"
				end

				if inDistance then
					if not LocalPlayer.state.doingAction and not _delay then
						Action:Show(string.format("{keybind}primary_action{/keybind} %s", text))
					else
						Action:Hide()
					end
					_validBone = {
						label = bone.label,
						index = bone.index,
						duration = bone.duration,
						type = bone.type,
						coords = coords,
						distance = distance,
					}
					_validVeh = veh
					Citizen.Wait(1)
				else
					Action:Hide()
					_validBone = nil
					if not _delay then
						_validVeh = nil
					end
					Citizen.Wait(10)
				end
			else
				_validBone = nil
				if not _delay then
					_validVeh = nil
				end
				Citizen.Wait(250)
			end
		end

		_validBone = nil
		_validVeh = nil
	end)
end

function GetValidBones(entity, list)
	local bones = {}

	local vState = Entity(entity).state
	local wheels = vState.brokenWheels or {}

	for _, bone in ipairs(list) do
		local bId = GetEntityBoneIndexByName(entity, bone.name)
		if bId ~= -1 then
			if
				bone.type == "door" and not IsVehicleDoorDamaged(entity, bone.index)
				or bone.type == "tire" and not IsVehicleTyreBurst(entity, bone.index, 1)
				or bone.type == "wheel" and not wheels[bone.index]
			then
				bone.id = bId
				table.insert(bones, bone)
			end
		end
	end

	return bones
end

function GetClosestBone(entity, list)
	local playerCoords, bone, coords, distance = GetEntityCoords(LocalPlayer.state.ped)

	for _, element in pairs(list) do
		local boneCoords = GetWorldPositionOfEntityBone(entity, element.id or element)
		local boneDistance = #(playerCoords - boneCoords)

		if not coords then
			bone, coords, distance = element, boneCoords, boneDistance
		elseif distance > boneDistance then
			bone, coords, distance = element, boneCoords, boneDistance
		end
	end

	if not bone then
		bone = {
			id = GetEntityBoneIndexByName(entity, "bodyshell"),
			type = "body",
			name = "bodyshell",
			duration = 20000,
		}
		coords = GetEntityCoords(entity)
		distance = #(coords - playerCoords)
	end

	return bone, coords, distance
end

RegisterNetEvent("Ped:Client:Died", function()
	if LocalPlayer.state.chopping ~= nil then
		Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
		LocalPlayer.state:set("chopping", nil, true)
		_validBone = nil
		_validVeh = nil
	end
end)

RegisterNetEvent('Phone:Client:LSUnderground:Chopping:CancelCurrent', function()
	if LocalPlayer.state.inChopZone ~= nil and LocalPlayer.state.chopping ~= nil then
		if _delay then
			Notification:Error("Choplist Has Refreshed")
			Progress:Cancel()
		end
		LocalPlayer.state:set("chopping", nil, true)
		_validBone = nil
		_validVeh = nil
	end
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "Reputations" or key == "States" or key == "ChopLists" then
		Phone.LSUnderground.Chopping:CreateBlips()
	end
end)

function TableLength(tbl)
	local cnt = 0
	for k, v in pairs(tbl) do
		cnt += 1
	end
	return cnt
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if
		(id == "chopping_public" and Reputation:HasLevel("Salvaging", 3))
		or (id == "chopping_private" and LocalPlayer.state.Character ~= nil and hasValue(
			LocalPlayer.state.Character:GetData("States"),
			"ACCESS_LSUNDERGROUND"
		))
		or (
			id == "chopping_personal"
			and (
				LocalPlayer.state.Character:GetData("ChopLists") ~= nil
				and TableLength(LocalPlayer.state.Character:GetData("ChopLists")) > 0
			)
		)
	then
		LocalPlayer.state:set("inChopZone", id, true)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "chopping_public" or id == "chopping_private" or id == "chopping_personal" then
		if LocalPlayer.state.chopping ~= nil then
			Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CancelChop")
		end
		LocalPlayer.state:set("inChopZone", nil, true)
		LocalPlayer.state:set("chopping", nil, true)
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if
		LocalPlayer.state.inChopZone ~= nil
		and not LocalPlayer.state.isDead
		and LocalPlayer.state.chopping
		and _validBone ~= nil
		and not LocalPlayer.state.doingAction
		and not _delay
	then
		_doingActions = true
		Phone.LSUnderground.Chopping:AttemptChop()
		_doingActions = false
	end
end)

AddEventHandler("Phone:Client:LSUnderground:Chopping:Pickup", function()
	Callbacks:ServerCallback("Phone:LSUnderground:Chopping:Pickup")
end)

AddEventHandler("Phone:Client:LSUnderground:Chopping:GetPublicList", function()
	Callbacks:ServerCallback("Phone:LSUnderground:Chopping:GetPublicList")
end)

AddEventHandler("Phone:Client:LSUnderground:Chopping:StartChop", function(entity, data)
	if
		not LocalPlayer.state.isDead
		and LocalPlayer.state.inChopZone ~= nil
		and not LocalPlayer.state.chopping
	then
		local vNet = VehToNet(entity.entity)
		Callbacks:ServerCallback("Phone:LSUnderground:Chopping:CheckVehicle", { vNet = vNet }, function(res)
			if res then
				while not NetworkHasControlOfEntity(entity.entity) do
					NetworkRequestControlOfEntity(entity.entity)
					Wait(1)
				end
				LocalPlayer.state:set("chopping", vNet, true)
				DoChoppingThings(entity.entity)
			else
				LocalPlayer.state:set("chopping", nil, true)
			end
		end)
	end
end)
