local _inPoly = nil
local _polys = {}

_lpStage = 0
_seqPass = 1
_scramPass = 1
_memPass = 1
_capPass = 1

local _cleanup = false

AddEventHandler("Characters:Client:Spawn", function()
	FleecaThreads()
end)

AddEventHandler("Robbery:Client:Setup", function()
	_polys = {}

	while GlobalState["FleecaRobberies"] == nil do
		Wait(10)
	end

	for k, v in ipairs(GlobalState["FleecaRobberies"]) do
		local bankData = GlobalState[string.format("FleecaRobberies:%s", v)]
		Polyzone.Create:Box(bankData.id, bankData.coords, bankData.width, bankData.length, bankData.options)
		_polys[bankData.id] = true

		if bankData.reset ~= nil then
			Targeting.Zones:AddBox(
				string.format("fleeca-%s-reset", bankData.id),
				"shield-keyhole",
				bankData.reset.coords,
				bankData.reset.length,
				bankData.reset.width,
				bankData.reset.options,
				{
					{
						icon = "phone",
						text = "Secure Bank",
						event = "Robbery:Client:Fleeca:StartSecuring",
						jobPerms = {
							{
								job = "police",
								reqDuty = true,
							},
						},
						data = bankData.id,
						isEnabled = function(s, s2)
							return (
								(
									GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)]
											~= nil
										and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 2
									or GlobalState[string.format(
												"Fleeca:%s:VaultDoor",
												LocalPlayer.state.fleeca
											)]
											~= nil
										and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 3
								)
								or (not Doors:IsLocked(string.format("%s_gate", LocalPlayer.state.fleeca)))
							)
						end,
					},
				},
				2.0,
				true
			)
		end

		if
			GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)] ~= nil
			and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 1
		then
		end
	end

	Callbacks:RegisterClientCallback("Robbery:Fleeca:Keypad:Vault", function(data, cb)
		Minigame.Play:Keypad(data, 5, 10000, false, {
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		}, {
			useWhileDead = false,
			vehicle = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
		})
	end)
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if _polys[id] and GlobalState[id] == nil and GlobalState[string.format("FleecaRobberies:%s", id)] ~= nil then
		_inPoly = id
		LocalPlayer.state:set("fleeca", id, true)
		SpawnCarts()
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if _polys[id] then
		DespawnCarts()
		_inPoly = nil
		LocalPlayer.state:set("fleeca", nil, true)
	end
end)

RegisterNetEvent("Robbery:Client:Fleeca:OpenVaultDoor", function(fleecaId)
	if GlobalState[string.format("FleecaRobberies:%s", fleecaId)] ~= nil then
		local myCoords = GetEntityCoords(LocalPlayer.state.ped)
		if #(myCoords - GlobalState[string.format("FleecaRobberies:%s", fleecaId)].coords) <= 100 then
			OpenDoor(
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].points.vaultPC.coords,
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].doors.vaultDoor
			)
		end
	end
end)

RegisterNetEvent("Robbery:Client:Fleeca:CloseVaultDoor", function(fleecaId)
	if GlobalState[string.format("FleecaRobberies:%s", fleecaId)] ~= nil then
		local myCoords = GetEntityCoords(LocalPlayer.state.ped)
		if #(myCoords - GlobalState[string.format("FleecaRobberies:%s", fleecaId)].coords) <= 100 then
			CloseDoor(
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].points.vaultPC.coords,
				GlobalState[string.format("FleecaRobberies:%s", fleecaId)].doors.vaultDoor
			)
		end
	end
end)

AddEventHandler("Robbery:Client:Fleeca:StartSecuring", function(entity, data)
	Progress:Progress({
		name = "secure_fleeca",
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
			Callbacks:ServerCallback("Robbery:Fleeca:SecureBank", {})
		end
	end)
end)

AddEventHandler("Robbery:Client:Fleeca:SequenceGate", function()
	Callbacks:ServerCallback("Robbery:Fleeca:SequenceGate", {}, function(r) end)
end)

AddEventHandler("Robbery:Client:Fleeca:LootTrolley", function(entity, data)
	Callbacks:ServerCallback("Robbery:Fleeca:Vault:StartLootTrolley", { cart = data }, function(proc)
		if proc then
			if
				GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)] ~= nil
				and GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)].carts[data] ~= nil
			then
				local cartData = GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)].carts[data]
				local myCoords = GetEntityCoords(LocalPlayer.state.ped)
				if #(myCoords - cartData.coords) <= 3.0 then
					local CashAppear = function()
						RequestModel(cartData.type.hand)
						while not HasModelLoaded(cartData.type.hand) do
							Wait(1)
						end
						local grabobj = CreateObject(cartData.type.hand, myCoords, true)

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

					if
						IsEntityPlayingAnim(
							entity.entity,
							"anim@heists@ornate_bank@grab_cash",
							"cart_cash_dissapear",
							3
						)
					then
						return
					end
					local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

					RequestAnimDict("anim@heists@ornate_bank@grab_cash")
					RequestModel(baghash)
					RequestModel(cartData.type.empty)
					while
						not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash")
						and not HasModelLoaded(cartData.type.empty)
						and not HasModelLoaded(baghash)
					do
						Wait(100)
					end
					while not NetworkHasControlOfEntity(entity.entity) do
						Wait(1)
						NetworkRequestControlOfEntity(entity.entity)
					end
					local GrabBag = CreateObject(
						GetHashKey("hei_p_m_bag_var22_arm_s"),
						GetEntityCoords(PlayerPedId()),
						true,
						false,
						false
					)
					local Grab1 = NetworkCreateSynchronisedScene(
						GetEntityCoords(entity.entity),
						GetEntityRotation(entity.entity),
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
						GetEntityCoords(entity.entity),
						GetEntityRotation(entity.entity),
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
					NetworkAddEntityToSynchronisedScene(
						entity.entity,
						Grab2,
						"anim@heists@ornate_bank@grab_cash",
						"cart_cash_dissapear",
						4.0,
						-8.0,
						1
					)
					NetworkStartSynchronisedScene(Grab2)
					Wait(37000)
					local Grab3 = NetworkCreateSynchronisedScene(
						GetEntityCoords(entity.entity),
						GetEntityRotation(entity.entity),
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
					local NewTrolley = CreateObject(
						cartData.type.empty,
						GetEntityCoords(entity.entity) + vector3(0.0, 0.0, -0.985),
						true,
						false,
						false
					)
					SetEntityRotation(NewTrolley, GetEntityRotation(entity.entity))
					local timout = 0
					while not NetworkHasControlOfEntity(entity.entity) and timeout <= 1000 do
						Wait(1)
						NetworkRequestControlOfEntity(entity.entity)
						timeout += 1
					end
					DeleteObject(entity.entity)
					local timout2 = 0
					while DoesEntityExist(entity.entity) and timout2 <= 1000 do
						Wait(1)
						DeleteObject(entity.entity)
						timout2 += 1
					end
					PlaceObjectOnGroundProperly(NewTrolley)
					Callbacks:ServerCallback("Robbery:Fleeca:Vault:FinishLootTrolley", {
						cart = data,
					})
					Wait(1800)
					if DoesEntityExist(GrabBag) then
						DeleteEntity(GrabBag)
					end
					--SetPedComponentVariation(LocalPlayer.state.ped, 5, 45, 0, 0)
					RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
					SetModelAsNoLongerNeeded(cartData.type.empty)
					SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
				end
			end
		end
	end)
end)

local stageComplete = 0
function DoLockpick(data, base, cb)
	local size = 10 - (stageComplete * 2)
	if size <= 1 then
		size = 2
	end

	Minigame.Play:RoundSkillbar(base + (0.2 * stageComplete), size, {
		onSuccess = function()
			Wait(400)

			if stageComplete >= (data.stages or 3) then
				stageComplete = 0
				cb(true)
			else
				stageComplete += 1
				DoLockpick(data, base, cb)
			end
		end,
		onFail = function()
			stageComplete = 0
			cb(false)
		end,
	}, {
		useWhileDead = false,
		vehicle = false,
		animation = {
			animDict = "veh@break_in@0h@p_m_one@",
			anim = "low_force_entry_ds",
			flags = 16,
		},
	})
end

function DoSequence(passes, config, data, cb)
	Minigame.Play:Sequencer(
		config.countdown or 3,
		config.preview or 300,
		(config.timer or 10000) - ((config.passReduce or 500) * _seqPass),
		(config.base or 5) + _seqPass,
		config.isMasked,
		{
			onSuccess = function(data)
				if _seqPass < passes then
					_seqPass += 1
					DoSequence(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoMemory(passes, config, data, cb)
	Minigame.Play:Memory(
		config.countdown or 3,
		config.preview or 3000,
		config.timer - ((config.passReduce or 300) * _memPass),
		config.cols or 5,
		config.rows or 5,
		(config.base or 5) + _memPass,
		config.strikes or 3,
		{
			onSuccess = function(data)
				if _memPass < passes then
					_memPass += 1
					DoMemory(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoCaptcha(passes, config, data, cb)
	Minigame.Play:Captcha(
		config.countdown or 3,
		config.timer or 1500,
		config.limit - ((config.passReduce or 1000) * _capPass),
		config.difficulty or 4,
		config.difficulty2 or 2,
		{
			onSuccess = function(data)
				if _capPass < passes then
					_capPass += 1
					Wait(1500)
					DoCaptcha(passes, config, data, cb)
				else
					cb(true, data)
				end
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoAim(config, data, cb)
	Minigame.Play:Aim(
		config.countdown or 3,
		config.limit or 15750,
		config.timer or 1000,
		config.startSize or 25,
		config.maxSize or 75,
		config.growthRate or 15,
		config.accuracy or 50,
		config.isMoving or false,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onPerfect = function(data)
				cb(true, data, true)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoKeymaster(config, data, cb)
	Minigame.Play:Keymaster(
		config.countdown or 3,
		config.timer or { 2000, 4000 },
		config.limit or 40000,
		config.difficulty or 3,
		config.chances or 5,
		config.isShuffled or false,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoTracking(config, data, cb)
	Minigame.Play:Tracking(config.countdown or 3, config.delay or 2500, config.limit or 20000, config.difficulty or 5, {
		onSuccess = function(data)
			cb(true, data)
		end,
		onFail = function(data)
			cb(false, data)
		end,
	}, {
		playableWhileDead = false,
		animation = config.anim,
	}, data)
end

function DoIcons(config, data, cb)
	Minigame.Play:Icons(
		config.countdown or 3,
		config.timer or 5,
		config.limit or 7500,
		config.delay or 1500,
		config.difficulty or 4,
		config.chances or 4,
		{
			onSuccess = function(data)
				cb(true, data)
			end,
			onFail = function(data)
				cb(false, data)
			end,
		},
		{
			playableWhileDead = false,
			animation = config.anim,
		},
		data
	)
end

function DoDrill(data, cb)
	Minigame.Play:Drill({
		onSuccess = function(data)
			cb(true, data)
		end,
		onFail = function(data)
			cb(false, data)
		end,
	}, data)
end

function DoScrambler(passes, base, strikes, data, cb)
	Minigame.Play:Scrambler(3, 4000, 14000 + ((_scramPass or 1) * 4000), strikes or 2, (base or 12) + (_scramPass * 4), {
		onSuccess = function(data)
			if _scramPass < passes then
				_scramPass += 1
				DoScrambler(passes, base, strikes, data, cb)
			else
				cb(true, data)
			end
		end,
		onFail = function(data)
			cb(false, data)
		end,
	}, {
		useWhileDead = false,
		vehicle = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "amb@prop_human_atm@male@idle_a",
			anim = "idle_b",
			flags = 49,
		},
	}, data)
end

function OpenDoor(checkOrigin, door)
	local obj =
		GetClosestObjectOfType(checkOrigin[1], checkOrigin[2], checkOrigin[3], 25.0, door.object, false, false, false)

	if obj ~= 0 and tonumber(string.format("%.3f", GetEntityHeading(obj))) == door.originalHeading then
		local count = 0
		repeat
			SetEntityHeading(obj, GetEntityHeading(obj) + door.step)
			count = count + 1
			Wait(10)
		until count == 150
	end
end

function CloseDoor(checkOrigin, door)
	local obj =
		GetClosestObjectOfType(checkOrigin[1], checkOrigin[2], checkOrigin[3], 25.0, door.object, false, false, false)

	if obj ~= 0 and tonumber(string.format("%.3f", GetEntityHeading(obj))) ~= door.originalHeading then
		local count = 0
		repeat
			SetEntityHeading(obj, GetEntityHeading(obj) - door.step)
			count = count + 1
			Wait(10)
		until count == 150
	end
end

RegisterNetEvent("Robbery:Client:Fleeca:RefreshTrolleys", function()
	_cleanup = true
	DespawnCarts(true)
	_cleanup = false
	SpawnCarts()
end)

function SpawnCarts()
	while _cleanup do
		Wait(3)
	end

	if LocalPlayer.state.fleeca ~= nil then
		if
			GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)] ~= nil
			and GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)].carts ~= nil
		then
			for k, v in ipairs(GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)].carts) do
				local hash = v.type.hash
				if
					GlobalState[string.format("Fleeca:%s:Trolly:%s", LocalPlayer.state.fleeca, k)] ~= nil
					and GlobalState[string.format("Fleeca:%s:Trolly:%s", LocalPlayer.state.fleeca, k)]
						> GlobalState["OS:Time"]
				then
					hash = v.type.empty
				end

				local obj =
					GetClosestObjectOfType(v.coords[1], v.coords[2], v.coords[3], 1.0, hash, false, false, false)
				if obj == 0 then
					RequestModel(hash)
					while not HasModelLoaded(hash) do
						Wait(1)
					end
					obj = CreateObject(hash, v.coords[1], v.coords[2], v.coords[3], 1, 0, 0)
					SetEntityRotation(obj, v.rotate.x, v.rotate.y, v.rotate.z, 0, true)
					PlaceObjectOnGroundProperly(obj)
					FreezeEntityPosition(obj, true)
				elseif
					GlobalState[string.format("Fleeca:%s:Trolly:%s", LocalPlayer.state.fleeca, k)] ~= nil
					and v.type.hash == hash
				then
					DeleteObject(obj)
					obj = CreateObject(v.type.empty, v.coords[1], v.coords[2], v.coords[3], 1, 0, 0)
					SetEntityRotation(obj, v.rotate.x, v.rotate.y, v.rotate.z, 0, true)
					PlaceObjectOnGroundProperly(obj)
					FreezeEntityPosition(obj, true)
				end
				Targeting:AddEntity(obj, "coins", {
					{
						icon = "coins",
						text = "Take Loot",
						event = "Robbery:Client:Fleeca:LootTrolley",
						minDist = 2.0,
						data = k,
						isEnabled = function()
							return GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)] ~= nil
								and GlobalState[string.format("Fleeca:%s:VaultDoor", LocalPlayer.state.fleeca)].state == 3
								and GlobalState[string.format("Fleeca:%s:Trolly:%s", LocalPlayer.state.fleeca, k)] == nil
								and (k == 1 or not Doors:IsLocked(string.format("%s_gate", LocalPlayer.state.fleeca)))
						end,
					},
				}, 3.0)
			end
		end
	end
end

function DespawnCarts(removeObject)
	if LocalPlayer.state.fleeca then
		for k, v in ipairs(GlobalState[string.format("FleecaRobberies:%s", LocalPlayer.state.fleeca)].carts) do
			for k2, v2 in ipairs(TROLLY_TYPES) do
				local obj = GetClosestObjectOfType(v.coords[1], v.coords[2], v.coords[3], 1.0, v2.hash, false, false, false)
				if obj ~= 0 then
					if removeObject then
						DeleteObject(obj)
					end
					Targeting:RemoveEntity(obj)
				end
				local obj2 = GetClosestObjectOfType(v.coords[1], v.coords[2], v.coords[3], 1.0, v2.empty, false, false, false)
				if obj2 ~= 0 then
					if removeObject then
						DeleteObject(obj2)
					end
					Targeting:RemoveEntity(obj2)
				end
			end
		end
	end
end
