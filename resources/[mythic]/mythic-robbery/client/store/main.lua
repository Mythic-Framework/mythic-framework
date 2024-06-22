local _models = {
	303280717,
}

local _inPoly = nil
local _polys = {}
AddEventHandler("Robbery:Client:Setup", function()
	_polys = {}
	for k, v in pairs(GlobalState["StoreRobberies"]) do
		Polyzone.Create:Box(v.id, v.coords, v.width, v.length, v.options)
		_polys[v.id] = true
	end

	for k, v in ipairs(GlobalState["StoreSafes"]) do
		Targeting.Zones:AddBox(v.id, "vault", v.coords, v.length, v.width, v.options, {
			{
				icon = "unlock",
				text = "Crack Safe",
				event = "Robbery:Client:Store:ActualCrackSafe",
				item = "safecrack_kit",
				data = v.data,
				isEnabled = function(data, entity)
					return (
							not GlobalState["StoreAntiShitlord"]
							or GetCloudTimeAsInt() > GlobalState["StoreAntiShitlord"]
						) and GlobalState[string.format("Safe:%s", data.id)] == nil
				end,
			},
			{
				icon = "terminal",
				text = "Use Sequencer",
				event = "Robbery:Client:Store:SequenceSafe",
				item = "sequencer",
				data = v.data,
				isEnabled = function(data, entity)
					return (
							not GlobalState["StoreAntiShitlord"]
							or GetCloudTimeAsInt() > GlobalState["StoreAntiShitlord"]
						) and GlobalState[string.format("Safe:%s", data.id)] == nil
				end,
			},
			{
				icon = "fingerprint",
				text = "Open Safe",
				event = "Robbery:Client:Store:OpenSafe",
				data = v.data,
				isEnabled = function(data, entity)
					local safeData = GlobalState[string.format("Safe:%s", data.id)]
					return safeData ~= nil and safeData.state == 2
				end,
			},
			{
				icon = "shield-keyhole",
				text = "Secure Safe",
				event = "Robbery:Client:Store:SecureSafe",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					},
				},
				data = v.data,
				isEnabled = function(data, entity)
					local safeData = GlobalState[string.format("Safe:%s", data.id)]
					return safeData ~= nil and safeData.state ~= 4
				end,
			},
		}, 2.0)
	end

	Callbacks:RegisterClientCallback("Robbery:Store:DoSafeCrack", function(data, cb)
		_memPass = 1
		DoMemory(data.passes, data.config, data.data, function(isSuccess, extra)
			cb(isSuccess, extra)
		end)
	end)
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if _polys[id] and GlobalState[id] == nil then
		LocalPlayer.state:set("storePoly", id, true)
		_inPoly = id
		for k, v in ipairs(_models) do
			Targeting:RemoveObject(v)
			Targeting:AddObject(v, "cash-register", {
				{
					icon = "cash-register",
					text = "Lockpick Register",
					event = "Robbery:Client:Store:LockpickRegister",
					item = "lockpick",
					data = id,
					isEnabled = function(s, s2)
						local coords = GetEntityCoords(s2.entity)
						return _polys[s]
							and (
								not GlobalState[string.format("Register:%s:%s", coords.x, coords.y)]
								or (
									GlobalState[string.format("Register:%s:%s", coords.x, coords.y)]
									and GlobalState[string.format("Register:%s:%s", coords.x, coords.y)].expires
										< GlobalState["OS:Time"]
								)
							)
					end,
				},
			}, 2.0)
		end
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if _polys[id] then
		LocalPlayer.state:set("storePoly", nil, true)
		_inPoly = nil
		for k, v in ipairs(_models) do
			Targeting:RemoveObject(v)
		end
	end
end)

local _timer = 50
local _lpPass = 1
function LPScan(coords)
	if not _inPoly then
		return
	end
	Minigame.Play:Scanner(5, _timer, 5000 - (750 * _lpPass), 20, 1, true, {
		onSuccess = "Robbery:Client:Store:LockpickSuccess",
		onFail = "Robbery:Client:Store:LockpickFail",
	}, {
		playableWhileDead = false,
		animation = {
			animDict = "veh@break_in@0h@p_m_one@",
			anim = "low_force_entry_ds",
			flags = 17,
		},
	}, coords)
end

local _scPass = 1
function SCSeq(id)
	if not _inPoly then
		return
	end
	Minigame.Play:Sequencer(5, 500, 7500 - (500 * _scPass), 2 + _scPass, true, {
		onSuccess = "Robbery:Client:Store:SafeCrackSuccess",
		onFail = "Robbery:Client:Store:SafeCrackFail",
	}, {
		playableWhileDead = false,
		animation = {
			animDict = "anim@heists@ornate_bank@hack",
			anim = "hack_loop",
			flags = 49,
		},
	}, id)
end

AddEventHandler("Robbery:Client:Store:LockpickRegister", function(entity, data)
	if not entity or not _inPoly then
		return
	end
	local coords = GetEntityCoords(entity.entity)
	if
		not GlobalState[string.format("Register:%s:%s", coords.x, coords.y)]
		or (
			GlobalState[string.format("Register:%s:%s", coords.x, coords.y)]
			and GlobalState[string.format("Register:%s:%s", coords.x, coords.y)].expires < GlobalState["OS:Time"]
		)
	then
		Callbacks:ServerCallback("Robbery:Store:StartLockpick", coords, function(s)
			if s then
				if Inventory.Items:Has("lockpick", 1) then
					_lpPass = 1
					LPScan(coords)
				end
			end
		end)
	end
end)

AddEventHandler("Robbery:Client:Store:LockpickSuccess", function(data)
	if not _inPoly then
		return
	end

	if _lpPass then
		if _lpPass >= 4 then
			_lpPass = false
			Callbacks:ServerCallback("Robbery:Store:Register", {
				results = true,
				coords = data,
				store = _inPoly,
			}, function(s) end)
		else
			_lpPass = _lpPass + 1
			Wait(800)
			LPScan(data)
		end
	end
end)

AddEventHandler("Robbery:Client:Store:LockpickFail", function(data)
	if not _inPoly then
		return
	end
	Callbacks:ServerCallback("Robbery:Store:Register", {
		results = false,
		coords = data,
		store = _inPoly,
	}, function(s) end)
end)

AddEventHandler("Robbery:Client:Store:ActualCrackSafe", function(entity, data)
	if not entity or not _inPoly then
		return
	end
	local coords = GetEntityCoords(entity.entity)
	if GlobalState[string.format("Safe:%s", data.id)] == nil then
		Callbacks:ServerCallback("Robbery:Store:StartSafeCrack", data, function(s) end)
	end
end)

AddEventHandler("Robbery:Client:Store:SequenceSafe", function(entity, data)
	if not entity or not _inPoly then
		return
	end
	local coords = GetEntityCoords(entity.entity)
	if GlobalState[string.format("Safe:%s", data.id)] == nil then
		Callbacks:ServerCallback("Robbery:Store:StartSafeSequence", {}, function(r)
			if r then
				if Inventory.Items:Has("sequencer", 1) then
					_scPass = 1
					SCSeq(data)
				end
			end
		end)
	end
end)

AddEventHandler("Robbery:Client:Store:OpenSafe", function(entity, data)
	if not _inPoly then
		return
	end
	data.store = _inPoly
	Callbacks:ServerCallback("Robbery:Store:LootSafe", data, function(s) end)
end)

AddEventHandler("Robbery:Client:Store:SecureSafe", function(entity, data)
	if not _inPoly then
		return
	end

	Progress:Progress({
		name = "secure_safe",
		duration = 5000,
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
			data.store = _inPoly
			Callbacks:ServerCallback("Robbery:Store:SecureSafe", data, function(s) end)
		end
	end)
end)

AddEventHandler("Robbery:Client:Store:SafeCrackSuccess", function(data)
	if not _inPoly then
		return
	end

	if _scPass >= 3 then
		_scPass = 1
		data.results = true
		data.store = _inPoly
		Callbacks:ServerCallback("Robbery:Store:Safe", data, function(s) end)
	else
		_scPass = _scPass + 1
		Wait(1500)
		SCSeq(data)
	end
end)

AddEventHandler("Robbery:Client:Store:SafeCrackFail", function(data)
	if not _inPoly then
		return
	end
	data.results = false
	data.store = _inPoly
	Callbacks:ServerCallback("Robbery:Store:Safe", data, function(s) end)
end)
