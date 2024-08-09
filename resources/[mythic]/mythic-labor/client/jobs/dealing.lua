local eventHandlers = {}
local _working = false
local _state = 0
local _joiner = nil

local _startTime = nil

local _SellingVeh = nil
local _SellingPed = nil
local _SellingCorner = nil

local _hasSellingMenu = false

function SendPedToPlayer(ped, coords)
	ClearPedTasks(ped)
	local animDict, anim = getRandomIdle()
	loadAnimDict(animDict)

	local randomLength = (math.random() * 7.0) + 3.0
	local taskSeq = OpenSequenceTask()
	TaskSetBlockingOfNonTemporaryEvents(0, true)
	TaskFollowNavMeshToCoord(0, coords, 1.0, -1, randomLength, true, 40000.0)
	TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 0)
	TaskPlayAnim(0, animDict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	TaskPause(0, 10000)
	TaskSetBlockingOfNonTemporaryEvents(0, false)
	TaskWanderStandard(0, 10.0, 10)
	CloseSequenceTask(taskSeq)

	TaskPerformSequence(ped, taskSeq)
	Entity(ped).state:set("sentToPed", true, true)
	ClearSequenceTask()
	SetPedKeepTask(ped, true)

	SetEntityAsMissionEntity(ped, true, true)
	SetTimeout((1000 * 60) * 2, function()
		if not Entity(ped).state.boughtDrugs and _working then
			Callbacks:ServerCallback("CornerDealing:PedTimeout", {})
			NetSync:DeletePed(ped)
		end
	end)
end

function DoHandoff(ped)
	loadAnimDict("mp_safehouselost@")
	ClearPedTasks(ped)

    PlayAmbientSpeech1(ped, 'Chat_State', 'Speech_Params_Force')

	local taskSeq = OpenSequenceTask()
	TaskSetBlockingOfNonTemporaryEvents(0, true)
	TaskTurnPedToFaceEntity(0, PlayerPedId(), 0)
	TaskPlayAnim(0, "mp_safehouselost@", "package_dropoff", 8.0, -8.0, -1, 0, 0, false, false, false)
	TaskSetBlockingOfNonTemporaryEvents(0, false)
	TaskWanderStandard(0, 10.0, 10)
	CloseSequenceTask(taskSeq)

	TaskPerformSequence(ped, taskSeq)
	ClearSequenceTask()
	SetPedKeepTask(ped)
end

function AddTargetingShit(ped)
	Targeting:AddPed(ped, "hands-holding-dollar", {
		{
			icon = "timeline",
			text = "Sell Product",
			event = "CornerDealing:Client:ShowMenu",
			minDist = 2.0,
			isEnabled = function(data, entity)
				return not Entity(entity.entity).state.boughtDrugs and not IsPedDeadOrDying(entity.entity)
			end,
		},
	}, 3.0)
end

function getRandomIdle()
	local idles = {
		["anim@mp_corona_idles@male_c@idle_a"] = "idle_a",
		["friends@fra@ig_1"] = "base_idle",
		["amb@world_human_hang_out_street@male_b@idle_a"] = "idle_b",
		["anim@heists@heist_corona@team_idles@male_a"] = "idle",
		["anim@mp_celebration@idles@female"] = "celebration_idle_f_a",
		["anim@mp_corona_idles@female_b@idle_a"] = "idle_a",
		["random@shop_tattoo"] = "_idle_a",
	}
	for animDict, anim in pairs(idles) do
		if math.random() < 0.2 then
			return animDict, anim
		end
	end
	return "rcmjosh1", "idle"
end

function loadAnimDict(pDict)
	while not HasAnimDictLoaded(pDict) do
		RequestAnimDict(pDict)
		Wait(5)
	end
end

local _queueLoc = nil
RegisterNetEvent("Labor:Client:GetLocs", function(locs)
	_queueLoc = locs.corner or {}
end)

AddEventHandler("Labor:Client:Setup", function()
	if _queueLoc.coords == nil then
		return
	end
	PedInteraction:Add("CornerDealing", GetHashKey("csb_grove_str_dlr"), _queueLoc.coords, _queueLoc.heading, 25.0, {
		{
			icon = "clock",
			text = "Sign Up",
			event = "CornerDealing:Client:Enable",
			data = {},
			isEnabled = function()
				return not hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_CORNER_DEALING")
					and LocalPlayer.state.onDuty ~= "police"
			end,
		},
		{
			icon = "clock",
			text = "Sign Off",
			event = "CornerDealing:Client:Disable",
			data = {},
			isEnabled = function()
				return hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_CORNER_DEALING")
					and LocalPlayer.state.onDuty ~= "police"
			end,
		},
		{
			icon = "list",
			text = "View Offers",
			event = "Vendor:Client:GetItems",
			data = {
				id = "CornerDealer",
			}
		},
	}, "question", "WORLD_HUMAN_SMOKING")
end)

RegisterNetEvent("CornerDealing:Client:DoSequence", function(seqType, netId, arg2)
	if seqType == "goto" then
		SendPedToPlayer(NetworkGetEntityFromNetworkId(netId), arg2)
	elseif seqType == "handoff" then
		
		local ped = NetworkGetEntityFromNetworkId(netId)
		local relation = GetPedRelationshipGroupHash(ped)
		SetRelationshipBetweenGroups(0, `PLAYER`, relation)
		SetRelationshipBetweenGroups(0, relation, `PLAYER`)

		DoHandoff(NetworkGetEntityFromNetworkId(netId))
	end
end)

_threading = false
_onDutyTime = nil

RegisterNetEvent("CornerDealing:Client:OnDuty", function(joiner, time)
	_working = true
	_joiner = joiner
	_state = 0
	LocalPlayer.state.cornerJoiner = joiner
	LocalPlayer.state:set("cornering", false, true)

	local dutyTime = GetGameTimer()
	_onDutyTime = dutyTime

	eventHandlers["sync-ped"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:SyncPed", joiner),
		function(netId)
			if _working and _state == 1 then
				if _SellingPed == nil then
					_SellingPed = NetworkGetEntityFromNetworkId(netId)
					if _SellingPed ~= 0 then
						AddTargetingShit(_SellingPed)
					else
						CreateThread(function()
							while _working and _state == 1 and _SellingPed == nil and _onDutyTime == dutyTime do
								while not DoesEntityExist(NetworkGetEntityFromNetworkId(netId)) do
									Wait(3000)
								end

								if _working and _state == 1 and _SellingPed == nil then
									_SellingPed = NetworkGetEntityFromNetworkId(netId)
									AddTargetingShit(_SellingPed)
								end
							end
						end)
					end
				end
			end
		end
	)

	eventHandlers["start-cornering"] = AddEventHandler("CornerDealing:Client:StartCornering", function(entity, data)
		if not entity?.entity then
			return
		end

		if _working and _state == 0 then
			Callbacks:ServerCallback("CornerDealing:CheckCorner", {
				coords = GetEntityCoords(LocalPlayer.state.ped)
			}, function(s)
				if s then
					_SellingVeh = entity.entity
					_SellingCorner = GetEntityCoords(LocalPlayer.state.ped)
					LocalPlayer.state:set("cornering", true, true)
					Entity(_SellingVeh).state:set("cornering", true, true)
		
					Vehicles.Sync.Doors:Open(entity.entity, 5, true, true)
		
					Callbacks:ServerCallback("CornerDealing:StartCornering", {
						netId = NetworkGetNetworkIdFromEntity(entity.entity),
						corner = _SellingCorner,
					})
				end
			end)
		end
	end)

	eventHandlers["stop-cornering"] = AddEventHandler("CornerDealing:Client:StopCornering", function(data, entity)
		if _working then
			Callbacks:ServerCallback("CornerDealing:StopCornering")
		end
	end)

	eventHandlers["start-selling"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:StartSelling", joiner),
		function(netId, corner)
			_state = 1

			local start = GetGameTimer()
			_startTime = start

			CreateThread(function()
				while _working and _state == 1 and _startTime == start do
					if _SellingPed ~= nil then
						local myCoords = GetEntityCoords(LocalPlayer.state.ped)
						local pedCoords = GetEntityCoords(_SellingPed)

						local dist = #(pedCoords - myCoords)
						if dist <= 30.0 then
							DrawMarker(2, pedCoords.x, pedCoords.y, pedCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 0, 0, 150, true, true, 0, 0)
							Wait(1)
						else
							Wait(dist)
						end
					else
						Wait(1000)
					end
				end
			end)

			if joiner == GetPlayerServerId(PlayerId()) then
				if not _threading then
					local notFoundCount = 0
					CreateThread(function()
						local ending = false
						while _working and _state == 1 and _startTime == start do
							if not ending then
								if DoesEntityExist(_SellingVeh) then
									if GetEntityHealth(_SellingVeh) == 0 or not IsVehicleDriveable(_SellingVeh) then
										Logger:Trace("CornerDealing", "Vehicle Health 0 or Not Drivable")
										ending = true
										Callbacks:ServerCallback("CornerDealing:DestroyVehicle")
									end
								end
							end
							Wait(10)
						end
					end)
		
					CreateThread(function()
						local ending = false
						while _working and _state == 1 and _startTime == start do
							if not ending and _SellingVeh ~= 0 and _SellingVeh ~= nil then
								local myPos = GetEntityCoords(LocalPlayer.state.ped)
								local vehPos = GetEntityCoords(_SellingVeh)
								if #(vehPos - _SellingCorner) > 50.0 then
									Logger:Trace("CornerDealing", "Vehicle Too Far From Corner")
									ending = true
									Callbacks:ServerCallback("CornerDealing:LeaveArea")
								end
							end
							Wait(10)
						end
					end)

					CreateThread(function()
						while _working and _state == 1 and LocalPlayer.state.loggedIn do
							PopulateNow()
							Wait(1000)
						end
					end)
	
					CreateThread(function()
						while _working and _state == 1 and LocalPlayer.state.loggedIn and notFoundCount < 10 and _startTime == start do
							if _SellingPed == nil then
								local peds = GetGamePool("CPed")
								for _, ped in ipairs(peds) do
									local entState = Entity(ped).state
									if
										not IsPedDeadOrDying(ped, true)
										and not IsPedAPlayer(ped)
										and not IsPedFleeing(ped)
										and IsPedOnFoot(ped)
										and not IsPedInAnyVehicle(ped, true)
										and IsPedHuman(ped)
										and NetworkGetEntityIsNetworked(ped)
										and not IsPedInMeleeCombat(ped)
										and not entState.isDrugBuyer
										and not entState.boughtDrugs
										and #(_SellingCorner - GetEntityCoords(ped)) < 50.0
									then
										entState:set("isDrugBuyer", joiner,  true)
										SetPedSeeingRange(ped, 0.0)
										SetPedHearingRange(ped, 0.0)
										SetPedFleeAttributes(ped, 0, false)
										SetPedCombatAttributes(ped, 17, 1)
										SetPedConfigFlag(ped, 17, true)
										SetPedConfigFlag(ped, 117, true)
										TaskSetBlockingOfNonTemporaryEvents(ped, 1)
										SetBlockingOfNonTemporaryEvents(ped, 1)
										_SellingPed = ped

										print(string.format("Cornering Buyer Found: %s (%s - %s)", ped, json.encode(GetEntityCoords(ped)), #(_SellingCorner - GetEntityCoords(ped))))

										notFoundCount = 0
										break
									end
								end
	
								if not _SellingPed then
									notFoundCount += 1
								else
									if not Entity(_SellingPed).state.sentToPed then
										if NetworkGetEntityIsNetworked(_SellingPed) then
											Callbacks:ServerCallback(
												"CornerDealing:SyncPed",
												NetworkGetNetworkIdFromEntity(_SellingPed)
											)
		
											if NetworkHasControlOfEntity(_SellingPed) then
												SendPedToPlayer(_SellingPed, _SellingCorner)
											else
												Callbacks:ServerCallback("CornderDealing:SyncEvent", {
													event = "goto",
													netId = NetworkGetNetworkIdFromEntity(_SellingPed),
													coords = _SellingCorner
												})
											end
											AddTargetingShit(_SellingPed)
										else
											SendPedToPlayer(_SellingPed, _SellingCorner)
											AddTargetingShit(_SellingPed)
										end
									end
								end
	
								if notFoundCount >= 10 then
									Callbacks:ServerCallback("CornerDealing:NoPeds", {})
									return
								end
							end
							Wait(10000)
						end
						_threading = false
					end)
					_threading = true
				end
			else
				_SellingVeh = netId
				_SellingCorner = corner
			end
		end
	)

	eventHandlers["remove-targeting"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:RemoveTargetting", joiner),
		function()
			if _SellingPed ~= nil then
				Targeting:RemovePed(_SellingPed)
			end
		end
	)

	eventHandlers["sold-to-ped"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:SoldToPed", joiner),
		function()
			if _SellingPed ~= nil then
				Targeting:RemovePed(_SellingPed)
			end
			_SellingPed = nil
		end
	)

	eventHandlers["end-selling"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:EndSelling", joiner),
		function()
			if _SellingPed ~= nil then
				Targeting:RemovePed(_SellingPed)
			end
			if _SellingVeh ~= nil then
				Entity(_SellingVeh).state:set("cornering", false, true)
			end
			_state = 0
			_SellingPed = nil
			_SellingCorner = nil
			_SellingVeh = nil
			_threading = false
			LocalPlayer.state:set("cornering", false, true)
		end
	)

	eventHandlers["ped-died"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:PedDied", joiner),
		function()
			if _SellingPed ~= nil then
				Targeting:RemovePed(_SellingPed)
			end
			_SellingPed = nil
		end
	)

	eventHandlers["ped-timeout"] = RegisterNetEvent(
		string.format("CornerDealing:Client:%s:PedTimeout", joiner),
		function()
			if _SellingPed ~= nil then
				Targeting:RemovePed(_SellingPed)
			end
			_SellingPed = nil
		end
	)
end)

AddEventHandler("CornerDealing:Client:ShowMenu", function(entity, data)
	if _SellingPed == nil or entity.entity ~= _SellingPed then
		return
	end

	if _working and _state == 1 then
		Callbacks:ServerCallback("CornerDealing:GetSaleMenu", {
			netId = NetworkGetNetworkIdFromEntity(entity.entity),
		}, function(data)
			if data ~= nil and #data > 0 then
				ListMenu:Show({
					main = {
						label = "Corner Dealing",
						items = data,
					},
				})
				_hasSellingMenu = true
			else
				Notification:Error("You Have Nothing To Sell")
			end
		end)
	end
end)

AddEventHandler("CornerDealing:Client:Sell", function(data)
	Entity(_SellingPed).state:set("boughtDrugs", true, true)
	Callbacks:ServerCallback("CornerDealing:DoSale", {
		item = data,
		netId = NetworkGetNetworkIdFromEntity(_SellingPed),
	}, function(r)
		if r then
			local pda = math.random(100)
			if pda >= 60 then
				EmergencyAlerts:CreateIfReported(100.0, "oxysale", true)
			end

			if NetworkHasControlOfEntity(_SellingPed) then
				DoHandoff(_SellingPed)
			else
				local attempt = 0
				while not NetworkHasControlOfEntity(_SellingPed) and attempt < 100 do
					NetworkRequestControlOfEntity(_SellingPed)
					Wait(10)
					attempt += 10
				end

				if NetworkHasControlOfEntity(_SellingPed) then
					DoHandoff(_SellingPed)
				else
					Callbacks:ServerCallback("CornderDealing:SyncEvent", {
						event = "handoff",
						netId = NetworkGetNetworkIdFromEntity(_SellingPed),
						coords = _SellingCorner
					})
				end
			end

			PlayAmbientSpeech1(_SellingPed, 'Generic_Hi', 'Speech_Params_Force')
			TaskTurnPedToFaceEntity(LocalPlayer.state.ped, _SellingPed, 1000)
			Animations.Emotes:Play("handoff", false, 3000, true, true)
		end
		
		_hasSellingMenu = false
	end)
end)

AddEventHandler("CornerDealing:Client:StartJob", function()
	Callbacks:ServerCallback("CornerDealing:StartJob", _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
	end)
end)

RegisterNetEvent("CornerDealing:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	if _SellingPed ~= nil then
		Targeting:RemovePed(_SellingPed)
	end
	if _SellingVeh ~= nil then
		Entity(_SellingVeh).state:set("cornering", false, true)
	end

	NetSync:SetEntityAsNoLongerNeeded(_SellingPed)
	NetSync:SetPedKeepTask(_SellingPed, false)
	_SellingPed = nil
	_SellingCorner = nil
	_SellingVeh = nil

	_working = false
	_state = 0

	LocalPlayer.state:set("cornering", false, true)
end)

-- AddEventHandler("gameEventTriggered", function(name, args)
-- 	if name == "CEventNetworkEntityDamage" then
-- 		if _working and _joiner ~= nil then
-- 			if args[6] == 1 then --damage leads to entity death
-- 				if IsEntityAPed(args[1]) then --both victim and killer are peds.
-- 					local entState = Entity(args[1]).state
-- 					if entState.isDrugBuyer == _joiner then
-- 						Callbacks:ServerCallback("CornerDealing:PedDied", {})
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end)

AddEventHandler("CornerDealing:Client:Enable", function()
	Callbacks:ServerCallback("CornerDealing:Enable", {})
end)

AddEventHandler("CornerDealing:Client:Disable", function()
	Callbacks:ServerCallback("CornerDealing:Disable", {})
end)
