local hackAnimDict = "anim@heists@ornate_bank@hack"

function loadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function loadModel(model)
	if IsModelInCdimage(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(5)
		end
	end
end

local function loadDicts()
    RequestAnimDict(hackAnimDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestModel("hei_prop_heist_card_hack_02")
    while not HasAnimDictLoaded(hackAnimDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
        or not HasModelLoaded("hei_prop_heist_card_hack_02") do
        Wait(0)
    end
end

RegisterNetEvent("Robbery:Client:ThermiteFx", function(delay, netId)
	local bombObj = NetworkGetEntityFromNetworkId(netId)
	if bombObj ~= 0 then
		if not HasNamedPtfxAssetLoaded("scr_ornate_heist") then
			RequestNamedPtfxAsset("scr_ornate_heist")
			while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
				Wait(1)
			end
		end
	
		UseParticleFxAssetNextCall("scr_ornate_heist")
		local effect1 = StartNetworkedParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn", bombObj,0,1.0,0,0,0,0,1.0,false,false,false)
		local effect2 = StartNetworkedParticleFxLoopedOnEntity("scr_heist_ornate_thermal_sparks", bombObj,0,1.0,0,0,0,0,1.0,false,false,false)
		local effect3 = StartNetworkedParticleFxLoopedOnEntity("scr_heist_ornate_thermal_glow", bombObj,0,1.0,0,0,0,0,1.0,false,false,false)
		local effect4 = StartNetworkedParticleFxLoopedOnEntity("sp_fbi_fire_trail_smoke", bombObj,0,1.0,0,0,0,0,1.0,false,false,false)
		RemoveNamedPtfxAsset("scr_ornate_heist")
	
		Wait(delay or 13000)
	
		StopParticleFxLooped(effect1, 0)
		StopParticleFxLooped(effect2, 0)
		StopParticleFxLooped(effect3, 0)
		StopParticleFxLooped(effect4, 0)
	end
end)

RegisterNetEvent("Robbery:Client:BombFx", function(loc)
	if not HasNamedPtfxAssetLoaded("des_gas_station") then
		RequestNamedPtfxAsset("des_gas_station")
		while not HasNamedPtfxAssetLoaded("des_gas_station") do
			Wait(1)
		end
	end

	UseParticleFxAssetNextCall("des_gas_station")
	SetParticleFxNonLoopedColour(1.0, 0.0, 0.0)
	StartNetworkedParticleFxNonLoopedAtCoord("ent_ray_paleto_gas_explosion", loc.x, loc.y, loc.z, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
	AddExplosion(
		loc.x,
		loc.y,
		loc.z,
		9,
		100.0,
		true,
		false,
		1.0,
		false
	)

	RemoveNamedPtfxAsset("des_gas_station")
end)

function LaptopShit(loc, data, cb)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local p = promise:new()

    ClearPedTasksImmediately(ply)
    Wait(0)
    TaskGoStraightToCoord(ply, vector3(loc.x, loc.y, loc.z), 2.0, -1, loc.h)
    loadDicts()
    Wait(0)
    while GetIsTaskActive(ply, 35) do
        Wait(0)
    end
    ClearPedTasksImmediately(ply)
    Wait(0)
    SetEntityHeading(ply, loc.h)
    Wait(0)
    TaskPlayAnimAdvanced(ply, hackAnimDict, "hack_enter", vector3(loc.x, loc.y, loc.z), 0, 0, 0, 1.0, 0.0, 8300, 0, 0.3, false, false, false)
    Wait(0)
    SetEntityHeading(ply, loc.h)
    while IsEntityPlayingAnim(ply, hackAnimDict, "hack_enter", 3) do
        Wait(0)
    end
    local laptop = CreateObject(`hei_prop_hst_laptop`, GetOffsetFromEntityInWorldCoords(ply, 0.2, 0.6, 0.0), 1, 1, 0)
    Wait(0)
    SetEntityRotation(laptop, GetEntityRotation(ply, 2), 2, true)
    PlaceObjectOnGroundProperly(laptop)
    Wait(0)
    TaskPlayAnim(ply, hackAnimDict, "hack_loop", 1.0, 0.0, -1, 1, 0, false, false, false)

    Wait(1000)
    
    DoKeymaster(data.config, data.data, function(isSuccess, data)
        p:resolve(isSuccess)
        NetSync:DeleteObject(laptop)
        ClearPedTasksImmediately(ply)
    end)

    cb(Citizen.Await(p))
end

function CaptchaShit(loc, data, cb)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)
    local p = promise:new()

    ClearPedTasksImmediately(ply)
    Wait(0)
    TaskGoStraightToCoord(ply, vector3(loc.x, loc.y, loc.z), 2.0, -1, loc.h)
    loadDicts()
    Wait(0)
    while GetIsTaskActive(ply, 35) do
        Wait(0)
    end
    ClearPedTasksImmediately(ply)
    Wait(0)
    SetEntityHeading(ply, loc.h)
    Wait(0)
    TaskPlayAnimAdvanced(ply, hackAnimDict, "hack_enter", vector3(loc.x, loc.y, loc.z), 0, 0, 0, 1.0, 0.0, 8300, 0, 0.3, false, false, false)
    Wait(0)
    SetEntityHeading(ply, loc.h)
    while IsEntityPlayingAnim(ply, hackAnimDict, "hack_enter", 3) do
        Wait(0)
    end
    local laptop = CreateObject(`hei_prop_hst_laptop`, GetOffsetFromEntityInWorldCoords(ply, 0.2, 0.6, 0.0), 1, 1, 0)
    Wait(0)
    SetEntityRotation(laptop, GetEntityRotation(ply, 2), 2, true)
    PlaceObjectOnGroundProperly(laptop)
    Wait(0)
    TaskPlayAnim(ply, hackAnimDict, "hack_loop", 1.0, 0.0, -1, 1, 0, false, false, false)

    Wait(1000)
    
	DoCaptcha(data.passes, data.config, data.data, function(isSuccess, data)
        p:resolve(isSuccess)
        NetSync:DeleteObject(laptop)
        ClearPedTasksImmediately(ply)
	end)

    cb(Citizen.Await(p))
end

-- This probably needs to be refactored to not have so much duplicated code
function ThermiteShit(loc, data, cb)
	local p = promise:new()
	CreateThread(function()
		RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
		while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") do
			Wait(0)
		end
		local ped = PlayerPedId()
		SetEntityHeading(ped, loc.h)
		Wait(100)
		local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
		local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + 0.0, 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(bagscene)
		Wait(1500)
		local x, y, z = table.unpack(GetEntityCoords(ped))
		local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
		SetEntityCollision(bomba, false, true)
		AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
		Wait(3500)

		DetachEntity(bomba, 1, 1)
		FreezeEntityPosition(bomba, true)
		NetworkStopSynchronisedScene(bagscene)

		DoMemory(data.passes, data.config, data.data, function(isSuccess, extra)
			if isSuccess then
				Callbacks:ServerCallback("Robbery:DoThermiteFx", {
					delay = ((data.duration + 2000) or 13000),
					netId = ObjToNet(bomba)
				}, function() end)
				TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
				TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
				Wait(2000)
				ClearPedTasks(ped)

				Wait(data.duration or 11000)
			end
			DeleteObject(bomba)
			p:resolve(isSuccess)
		end)
	end)
	cb(Citizen.Await(p))
end

function BombShit(loc, data, cb)
	local p = promise:new()
	CreateThread(function()
		RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
		while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") do
			Wait(0)
		end
		local ped = PlayerPedId()
		SetEntityHeading(ped, loc.h)
		Wait(100)
		local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
		local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz + 0.0, 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(bagscene)
		Wait(1500)
		local x, y, z = table.unpack(GetEntityCoords(ped))
		local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
		SetEntityCollision(bomba, false, true)
		AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
		Wait(3500)

		DetachEntity(bomba, 1, 1)
		FreezeEntityPosition(bomba, true)
		NetworkStopSynchronisedScene(bagscene)

		DoAim(data.config, data.data, function(isSuccess, extra)
			if isSuccess then
				Callbacks:ServerCallback("Robbery:DoThermiteFx", {
					delay = ((data.duration + 2000) or 13000),
					netId = ObjToNet(bomba)
				}, function() end)
				TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
				TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
				Wait(2000)
				ClearPedTasks(ped)

				Wait(data.duration or 11000)
			end
			DeleteObject(bomba)
			p:resolve(isSuccess)
		end)
	end)
	cb(Citizen.Await(p))
end

function AimHackShit(data, cb)
	local p = promise:new()
	CreateThread(function()
		DoAim(data.config, data.data, function(isSuccess, extra)
			p:resolve(isSuccess)
		end)
	end)
	cb(Citizen.Await(p))
end

function HackShit(data, cb)
    local ply = PlayerPedId()
    local p = promise:new()

	loadAnim("amb@code_human_in_bus_passenger_idles@female@tablet@base")
	loadModel(`prop_cs_tablet`)

	_mdtProp = CreateObject(`prop_cs_tablet`, GetEntityCoords(ply), 1, 1, 0)
	SetEntityCollision(_mdtProp, false, true)
	AttachEntityToEntity(_mdtProp, ply, GetPedBoneIndex(ply, 60309), 0.02, -0.01, -0.03, 0.0, 0.0, -10.0, 1, 0, 0, 0, 2, 1)
    
	local doingShit = true

	CreateThread(function()
		while doingShit do
			if not IsEntityPlayingAnim(ply, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3) then
				TaskPlayAnim(ply, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, false, false, false)
			end
			Wait(250)
		end
	end)

    DoIcons(data.config, data.data, function(isSuccess, data)
		doingShit = false
        p:resolve(isSuccess)
		StopAnimTask(ply, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0)
		NetSync:DeleteObject(_mdtProp)
        ClearPedTasksImmediately(ply)
    end)

    cb(Citizen.Await(p))
end

function TrackingGameShit(data, cb)
	local p = promise:new()
    DoTracking(data.config, data.data, function(isSuccess, data)
        p:resolve(isSuccess)
        NetSync:DeleteObject(laptop)
        ClearPedTasksImmediately(ply)
    end)
    cb(Citizen.Await(p))
end