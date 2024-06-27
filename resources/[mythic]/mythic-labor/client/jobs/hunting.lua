local _joiner = nil
local _working = false
local _blips = {}
local _state = nil
local eventHandlers = {}

local _localConfig = nil

local gms = {
	[581794674] = true,
	[-2041329971] = true,
	[-309121453] = true,
	[-913351839] = true,
	[-1885547121] = true,
	[-1915425863] = true,
	[-1833527165] = true,
	[2128369009] = true,
	[-124769592] = true,
	[-840216541] = true,
	[-461750719] = true,
	[930824497] = true,
	[1333033863] = true,
	[223086562] = true,
	[1109728704] = true,
	[-1286696947] = true,
	[-1942898710] = true,
	[509508168] = true,
	[-2073312001] = true,
	[627123000] = true,
	[-1595148316] = true,
	[435688960] = true,
}

local wepHash = `WEAPON_SNIPERRIFLE2`
local knifeHash = `WEAPON_KNIFE`
local wepEquipped = false
local wepBlocking = false

local _sellers = {
	{
		coords = vector3(725.447, 4188.729, 39.709),
		heading = 231.814,
		model = `cs_old_man1a`
	},
}

function Block()
	if wepBlocking then
		return
	end
	wepBlocking = true
	CreateThread(function()
		while LocalPlayer.state.loggedIn and wepEquipped do
			local ply = PlayerId()
			local ped = PlayerPedId()
			local ent = nil
			local aiming, ent = GetEntityPlayerIsFreeAimingAt(ply)
			local freeAiming = IsPlayerFreeAiming(ply)
			local et = GetEntityType(ent)
			if not freeAiming or IsPedAPlayer(ent) or et == 2 or (et == 1 and IsPedInAnyVehicle(ent)) then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 47, true)
				DisableControlAction(0, 58, true)
				DisablePlayerFiring(LocalPlayer.state.ped, true)
			end
			Wait(1)
		end
		wepBlocking = false
	end)
end

CreateThread(function()
	DecorRegister("HuntingSpawn", 2)
	DecorRegister("HuntingIllegal", 2)
	DecorRegister("BeingHarvested", 2)
	DecorRegister("HuntingHarvested", 2)

    while true do
        if LocalPlayer.state.loggedIn and Hud ~= nil then
            if GetSelectedPedWeapon(LocalPlayer.state.ped) == wepHash then
                wepEquipped = true
                Block()
            else
                wepEquipped = false
            end
        end
        Wait(1000)
    end
end)

local _baited = false
function StartBait(item, loc)
    if _baited then return end
    _baited = true

	local baitConf = _localConfig.Baits[item]
    CreateThread(function()
		local dist = 0
        while dist <= baitConf.distance and _baited and LocalPlayer.state.loggedIn do
            dist = #(vector3(LocalPlayer.state.position) - vector3(loc.x, loc.y, loc.z))
			Wait(500)
        end

		if _baited and LocalPlayer.state.loggedIn then
			local t = (1000 * 60 * math.random(1, baitConf.time))
			Wait(t)
			Callbacks:ServerCallback("Hunting:GenerateAnimal", item, function(r)
				if r ~= nil then
					SpawnAnimal(r, loc, baitConf)
				end
				_baited = false
			end)
		end

        _baited = false
    end)
end

local function GenerateSpawnLocation(bait, baitLoc)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil
    while spawnCoords == nil do
        local xVariance = math.random(-bait.distance, bait.distance)
        local yVariance = math.random(-bait.distance, bait.distance)
		local zLoc = baitLoc.z
		local pos = vector3(baitLoc.x + xVariance, baitLoc.y + yVariance, zLoc)
        if #(baitLoc - pos) > bait.distance then
            spawnCoords = pos
        end
    end
    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    return vector3(spawnCoords.x, spawnCoords.y, groundZ)
end

function SpawnAnimal(data, loc, bait)
    local modelName = data.animal.Model
    RequestModel(modelName)
    while not HasModelLoaded(modelName) do
        Wait(100)
    end
    local spawn = GenerateSpawnLocation(bait, loc)
    local spawnedAnimal = CreatePed(28, data.animal.Model, spawn, true, true, true)
	print(spawnedAnimal)
	SetEntityAsMissionEntity(spawnedAnimal, true, true)

    DecorSetBool(spawnedAnimal, "HuntingSpawn", true)
    DecorSetBool(spawnedAnimal, "HuntingIllegal", data.animal.Illegal)
    if data.isIllegal then
		TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "illegalHunting")
    end
    
    SetModelAsNoLongerNeeded(modelName)
    TaskGoStraightToCoord(spawnedAnimal, loc, 1.0, -1, 0.0, 0.0)
    CreateThread(function()
        local startFlee = false
        while not IsPedDeadOrDying(spawnedAnimal) and not startFlee do
            local spawnedAnimalCoords = GetEntityCoords(spawnedAnimal)
            if #(loc - spawnedAnimalCoords) < 0.5 then
                ClearPedTasks(spawnedAnimal)
                Wait(1500)
                TaskStartScenarioInPlace(spawnedAnimal, "WORLD_DEER_GRAZING", 0, true)
                SetTimeout(12500, function()
                    startFlee = true
                end)
            end
            if #(spawnedAnimalCoords - GetEntityCoords(PlayerPedId())) < bait.distance then
                ClearPedTasks(spawnedAnimal)
                TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 750.0, -1)
            	startFlee = true
            end
            Wait(1000)
        end
        if not IsPedDeadOrDying(spawnedAnimal) then
            TaskSmartFleePed(spawnedAnimal, PlayerPedId(), 750.0, -1)
        end
    end)
end

RegisterNetEvent("Hunting:Client:Polys", function(c)
	_localConfig = c
	for k, v in ipairs(_localConfig.Zones) do
		Polyzone.Create:Circle(string.format("hunting%s", k), v.coords, v.radius, v.options)
	end

	for k, v in pairs(_localConfig.Animals) do
		Targeting:AddPedModel(v.Model, "magnifying-glass", {
			{
				icon = "cow",
				text = string.format("Harvest %s", v.Name),
				event = "Hunting:Client:Harvest",
				minDist = 2.0,
				data = v.ID,
				isEnabled = function(data, entity)
					local isEquipped, hash = GetCurrentPedWeapon(LocalPlayer.state.ped, 1)
					return hash == knifeHash
						and IsPedDeadOrDying(entity.entity) and (
							not DecorExistOn(entity.entity, "BeingHarvested")
							or not DecorGetBool(entity.entity, "BeingHarvested")
						)
						and (
							not DecorExistOn(entity.entity, "HuntingHarvested")
							or not DecorGetBool(entity.entity, "HuntingHarvested")
						)
				end,
			},
			{
				icon = "magnifying-glass",
				text = "Inspect Corpse",
				event = "Hunting:Client:Inspect",
				minDist = 2.0,
				jobs = { "tow", "police" },
				jobDuty = true,
				data = v.ID,
				isEnabled = function(data, entity)
					return IsPedDeadOrDying(entity.entity)
				end,
			},
		}, 3.0)
	end
end)

AddEventHandler("Labor:Client:Setup", function()
	for k, v in ipairs(_sellers) do
		PedInteraction:Add(string.format("HideSeller%s", k), v.model, v.coords, v.heading, 25.0, {
			{
				icon = "sack-dollar",
				text = "Sell Tier 1 Hides",
				event = "Hunting:Client:Sell",
				data = { tier = 1 },
				rep = { id = "Hunting", level = 3 },
				isEnabled = function()
					return true
				end,
			},
			{
				icon = "sack-dollar",
				text = "Sell Tier 2 Hides",
				event = "Hunting:Client:Sell",
				data = { tier = 2 },
				rep = { id = "Hunting", level = 4 },
				isEnabled = function()
					return true
				end,
			},
			{
				icon = "sack-dollar",
				text = "Sell Tier 3 Hides",
				event = "Hunting:Client:Sell",
				data = { tier = 3 },
				rep = { id = "Hunting", level = 5 },
				isEnabled = function()
					return true
				end,
			},
			{
				icon = "sack-dollar",
				text = "Sell Tier 4 Hides",
				event = "Hunting:Client:Sell",
				data = { tier = 4 },
				rep = { id = "Hunting", level = 6 },
				isEnabled = function()
					return true
				end,
			},
		}, 'paw', 'WORLD_HUMAN_SMOKING')
	end

	PedInteraction:Add("HuntingJob", `cs_hunter`, vector3(-773.955, 5604.745, 32.741), 167.427, 25.0, {
		{
			icon = "cart-shopping",
			text = "Shop",
			event = "Hunting:Client:OpenShop",
		},
		{
			icon = "clipboard-list",
			text = "Check In",
			event = "Hunting:Client:StartJob",
			tempjob = "Hunting",
			isEnabled = function()
				return not _working
			end,
		},
		{
			icon = "clipboard-list",
			text = "Finish Job",
			event = "Hunting:Client:FinishJob",
			tempjob = "Hunting",
			isEnabled = function()
				return _working and _state == 2
			end,
		},
	}, "cow")

	Callbacks:RegisterClientCallback("Hunting:PlaceTrap", function(item, cb)
		if _baited then
			return cb(false)
		end

		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.7, 0))
		local foundGround, zPos = GetGroundZFor_3dCoord(x, y, z - 0.5, 0)
		if foundGround then
			z = zPos
		end
		local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 4, x, y, z - 2, 1, 0, 4)
		local retval, hit, endCoords, _, materialHash, _ = GetShapeTestResultIncludingMaterial(rayHandle)
		
		if hit then
			if gms[materialHash] then
				Progress:Progress({
					name = 'trap-action',
					duration = (math.random(5) + 10) * 1000,
					label = "Placing Bait",
					useWhileDead = false,
					canCancel = true,
					vehicle = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableCombat = true,
					},
					animation = {
						task = "WORLD_HUMAN_GARDENER_PLANT"
					},
				}, function(cancelled)
					cb(not cancelled)
					if not cancelled then
						StartBait(item, vector3(x, y, z))
					end
				end)
			else
				Notification:Error("Cannot Place Trap Here")
				cb(false)
			end
		else
			Notification:Error("Cannot Place Trap Here")
			cb(false)
		end

	end)

	Callbacks:RegisterClientCallback("Hunting:SpawnAnimal", function(item, cb)
		if _baited then
			return cb(false)
		end

		Progress:Progress({
			name = 'trap-action',
			duration = (math.random(5) + 10) * 1000,
			label = "Placing Bait",
			useWhileDead = false,
			canCancel = true,
			vehicle = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			},
			animation = {
                task = "WORLD_HUMAN_GARDENER_PLANT"
			},
		}, function(cancelled)
			cb(not cancelled)
            if not cancelled then
                StartBait(item, GetEntityCoords(LocalPlayer.state.ped))
            end
		end)
	end)
end)

RegisterNetEvent("Hunting:Client:OnDuty", function(joiner, time)
	_joiner = joiner
	DeleteWaypoint()
	SetNewWaypoint(-773.955, 5604.745)
	_blip = Blips:Add("HuntingStart", "Shop Owner", { x = -773.955, y = 5604.745, z = 32.741 }, 480, 2, 1.4)

	eventHandlers["startup"] = RegisterNetEvent(string.format("Hunting:Client:%s:Startup", joiner), function()
		_working = true
		_state = 1

		if _blip ~= nil then
			Blips:Remove("HuntingStart")
			RemoveBlip(_blip)
		end
	end)

	eventHandlers["finish"] = RegisterNetEvent(string.format("Hunting:Client:%s:Finish", joiner), function()
		_state = 2
		if _blip ~= nil then
			Blips:Remove("HuntingStart")
			RemoveBlip(_blip)
		end
		_blip = Blips:Add("HuntingStart", "Shop Owner", { x = -773.955, y = 5604.745, z = 32.741 }, 480, 2, 1.4)
	end)

	eventHandlers["end"] = RegisterNetEvent(string.format("Hunting:Client:%s:FinishJob", joiner), function()
		_state = 3
	end)
end)

AddEventHandler("Hunting:Client:OpenShop", function()
	Inventory.Shop:Open("hunting-supplies")
end)

AddEventHandler("Hunting:Client:Sell", function(entity, data)
	Callbacks:ServerCallback("Hunting:Sell", data.tier)
end)

AddEventHandler("Hunting:Client:StartJob", function()
	Callbacks:ServerCallback("Hunting:StartJob", _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
	end)
end)

AddEventHandler("Hunting:Client:FinishJob", function()
	Callbacks:ServerCallback("Hunting:FinishJob", _joiner, function(state)

	end)
end)

AddEventHandler("Hunting:Client:Harvest", function(entity, data)
	if not entity then return end
	DecorSetBool(entity.entity, "BeingHarvested", true)
	TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entity.entity, -1)
	Wait(1000)
	Progress:ProgressWithTickEvent({
		name = 'trap-action',
		duration = 18000,
		label = "Harvesting",
		useWhileDead = false,
		canCancel = true,
		vehicle = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableCombat = true,
		},
		animation = {
			task = "WORLD_HUMAN_GARDENER_PLANT"
		},
	}, function()
		if DecorGetBool(entity.entity, "HuntingHarvested") then
			Progress:Cancel()
		end
	end, function(cancelled)
		if not cancelled and not DecorGetBool(entity.entity, "HuntingHarvested") then
			DecorSetBool(entity.entity, "HuntingHarvested", true)

			if _localConfig.Animals[data] ~= nil and _localConfig.Animals[data].Illegal then
				TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "illegalHunting")
				Status.Modify:Add("PLAYER_STRESS", 10, false, true)
			else
				Status.Modify:Add("PLAYER_STRESS", 5, false, true)
			end
			Callbacks:ServerCallback("Hunting:HarvestAnimal", data)
		end

		DecorSetBool(entity.entity, "BeingHarvested", false)
	end)
end)

AddEventHandler("Hunting:Client:StartJob", function()
	-- Callbacks:ServerCallback("Mining:StartJob", _joiner, function(state)
	-- 	if not state then
	-- 		Notification:Error("Unable To Start Job")
	-- 	end
	-- end)
end)

RegisterNetEvent("Hunting:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	if _blip ~= nil then
		Blips:Remove("HuntingStart")
		RemoveBlip(_blip)
	end

	eventHandlers = {}
	_joiner = nil
	_state = nil
	_working = false
end)