local cam = nil

local inBedDict = "anim@gangops@morgue@table@"
local inBedAnim = "ko_front"
local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'

function SetBedCam(bed)
	_curBed = bed
    local player = PlayerPedId()

	if not IsScreenFadedOut() then
		DoScreenFadeOut(1000)
		while not IsScreenFadedOut() do
			Wait(1)
		end
	end

    FreezeEntityPosition(player, false)

	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end

    SetEntityCoords(player, _curBed.x, _curBed.y, _curBed.z)
	SetEntityHeading(player, _curBed.h)

    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Wait(0)
    end

    SetEntityHeading(player, _curBed.h + 180)

    Wait(150)

    TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    CreateThread(function()
        Wait(500)
        while LocalPlayer.state.isHospitalized and not _leavingBed do
            TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
            FreezeEntityPosition(player, true)
            SetEntityInvincible(player, true)
            Wait(200)
        end
        SetEntityInvincible(player, false) -- Please
        ClearPedTasksImmediately(player)
    end)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -90.0, 0.0, GetEntityHeading(player) + 180, true)

    LocalPlayer.state:set("isHospitalized", true, true)
    DoScreenFadeIn(1000)
    while not IsScreenFadedIn() do
        Wait(1)
    end
    _leavingBed = false
end

function LeaveBed()
    local player = PlayerPedId()

    if LocalPlayer.state.isDead then
        DoDeadEvent()
    else
        RequestAnimDict(getOutDict)
        while not HasAnimDictLoaded(getOutDict) do
            Wait(0)
        end

        SetEntityInvincible(player, false)
        SetEntityHeading(player, _curBed.h - 90)
        TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
        ClearPedTasksImmediately(player)
    end

    Callbacks:ServerCallback('Hospital:LeaveBed')
	if _curBed ~= nil and not _curBed.freeBed then
		Hospital:LeaveBed()
	end

    FreezeEntityPosition(player, false)
    
    if LocalPlayer.state.isCuffed then
        SetPedConfigFlag(ped, 120, true)
        SetPedConfigFlag(ped, 121, LocalPlayer.state.isHardCuffed)
    end

    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)
    Hud.DeathTexts:Hide()
    _curBed = nil
    _leavingBed = false
    LocalPlayer.state:set("isHospitalized", false, true)
end