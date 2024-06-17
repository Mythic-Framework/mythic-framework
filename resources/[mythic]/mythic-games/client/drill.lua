Drilling = {}

Drilling.Sounds = {
	Playing = false,
	Sound = nil,
	PinSound = nil,
	FailSound = nil,
}

Drilling.Pins = nil

Drilling.DisabledControls = { 30, 31, 32, 33, 34, 35 }

function loadModel(model)
	if IsModelInCdimage(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(5)
		end
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end

function ShittyDrillAnim()
	if
		Drilling.DrillSpeed <= 0
		and not IsEntityPlayingAnim(LocalPlayer.state.ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3)
	then
		TaskPlayAnim(LocalPlayer.state.ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 8.0, 8.0, -1, 33)
	elseif
		Drilling.DrillSpeed > 0
		and not IsEntityPlayingAnim(
			LocalPlayer.state.ped,
			"anim@heists@fleeca_bank@drilling",
			"drill_straight_start",
			3
		)
	then
		TaskPlayAnim(
			LocalPlayer.state.ped,
			"anim@heists@fleeca_bank@drilling",
			"drill_straight_start",
			8.0,
			8.0,
			-1,
			33
		)
	end
end

function YouFuckingSuck()
	local waitTime = math.random(5000, 10000)
	StopAnimTask(LocalPlayer.state.ped, "anim@heists@fleeca_bank@drilling", "drill_straight_start")
	StopAnimTask(LocalPlayer.state.ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle")
	Wait(50)
	TaskPlayAnim(
		LocalPlayer.state.ped,
		"anim@heists@fleeca_bank@drilling",
		"drill_straight_fail",
		8.0,
		8.0,
		waitTime,
		33
	)
	StopSound(Drilling.Sounds.Sound)

	PlaySoundFrontend(Drilling.Sounds.FailSound, "Drill_Jam", "DLC_HEIST_FLEECA_SOUNDSET", true)
	--ToggleDrillParticleFx( false, _drillPropHandle, ref _drillFx );
	Wait(waitTime)
	StopSound(Drilling.Sounds.FailSound)
end

function CreateAndAttchProp()
	loadModel(GetHashKey("hei_prop_heist_drill"))

	local myPos = GetEntityCoords(LocalPlayer.state.ped)
	local prop = CreateObject(GetHashKey("hei_prop_heist_drill"), myPos.x, myPos.y, myPos.z, true, false, false)
	FreezeEntityPosition(prop, true)
	SetEntityCollision(prop, false, false)

	AttachEntityToEntity(
		prop,
		LocalPlayer.state.ped,
		GetPedBoneIndex(LocalPlayer.state.ped, 28422),
		0,
		0,
		0,
		0,
		0,
		0,
		false,
		false,
		false,
		false,
		2,
		true
	)
	SetEntityInvincible(prop, true)

	SetModelAsNoLongerNeeded(GetHashKey("hei_prop_heist_drill"))

	Drilling.DrillProp = prop
end

Drilling.Start = function(callback)
	if not Drilling.Active then
		Drilling.Active = true
		Drilling.Init()
		Drilling.Update(callback)
	end
end

Drilling.Init = function()
	if Drilling.Scaleform then
		Scaleforms.UnloadMovie(Drilling.Scaleform)
	end

	LoadAnim("anim@heists@fleeca_bank@drilling")
	Drilling.Scaleform = Scaleforms.LoadMovie("DRILLING")

	Drilling.DrillSpeed = 0.0
	Drilling.DrillPos = 0.0
	Drilling.DrillTemp = 0.0
	Drilling.HoleDepth = 0.0

	Drilling.Pins = {
		Pin1 = {
			Position = 0.325,
			Broken = false,
		},
		Pin2 = {
			Position = 0.475,
			Broken = false,
		},
		Pin3 = {
			Position = 0.625,
			Broken = false,
		},
		Pin4 = {
			Position = 0.775,
			Broken = false,
		},
	}

	Drilling.Sounds.Sound = GetSoundId()
	Drilling.Sounds.PinSound = GetSoundId()
	Drilling.Sounds.FailSound = GetSoundId()

	RequestAmbientAudioBank("HEIST_FLEECA_DRILL")
	RequestAmbientAudioBank("HEIST_FLEECA_DRILL_2")
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL") 
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2") 
	RequestAmbientAudioBank("SAFE_CRACK") 
	RequestAmbientAudioBank("HUD_MINI_GAME_SOUNDSET") 
	RequestAmbientAudioBank("dlc_heist_fleeca_bank_door_sounds") 
	RequestAmbientAudioBank("vault_door")
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET")

	CreateAndAttchProp()

	Scaleforms.PopFloat(Drilling.Scaleform, "SET_SPEED", 0.0)
	Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", 0.0)
	Scaleforms.PopFloat(Drilling.Scaleform, "SET_TEMPERATURE", 0.0)
	Scaleforms.PopFloat(Drilling.Scaleform, "SET_HOLE_DEPTH", 0.0)

	TaskPlayAnim(LocalPlayer.state.ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 8.0, 8.0, -1, 33)
end

Drilling.Update = function(callback)
	FreezeEntityPosition(PlayerPedId(), true)
	while Drilling.Active do
		Drilling.Draw()
		ShittyDrillAnim()
		--Drilling.DisableControls()

		for k, v in pairs(Drilling.Pins) do
			if not v.Broken and Drilling.DrillPos >= v.Position then
				PlaySoundFrontend(Drilling.Sounds.PinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", true)
				Drilling.Pins[k].Broken = true
			end
		end

		if Drilling.DrillSpeed > 0 and Drilling.Sounds.Playing then
			SetVariableOnSound(Drilling.Sounds.Sound, "DrillState", 0)
		elseif Drilling.DrillSpeed > 0 and not Drilling.Sounds.Playing then
			PlaySoundFromEntity(
				Drilling.Sounds.Sound,
				"Drill",
				Drilling.DrillProp,
				"DLC_HEIST_FLEECA_SOUNDSET",
				false,
				0
			)
			Drilling.Sounds.Playing = true
		elseif Drilling.DrillSpeed <= 0 and Drilling.Sounds.Playing then
			StopSound(Drilling.Sounds.Sound)
			Drilling.Sounds.Playing = false
		end

		Drilling.HandleControls()

		Wait(0)
	end

	FreezeEntityPosition(PlayerPedId(), false)
	DeleteEntity(Drilling.DrillProp)
	Drilling.DrillProp = nil
	callback(Drilling.Result)
end

Drilling.Draw = function()
	DrawScaleformMovieFullscreen(Drilling.Scaleform, 255, 255, 255, 255, 255)
end

Drilling.HandleControls = function()
	local last_pos = Drilling.DrillPos
	if IsControlJustPressed(0, 32) then
		Drilling.DrillPos = math.min(1.0, Drilling.DrillPos + 0.01)
	elseif IsControlPressed(0, 32) then
		Drilling.DrillPos =
			math.min(1.0, Drilling.DrillPos + (0.1 * GetFrameTime() / (math.max(0.1, Drilling.DrillTemp) * 10)))
	elseif IsControlJustPressed(0, 33) then
		Drilling.DrillPos = math.max(0.0, Drilling.DrillPos - 0.01)
	elseif IsControlPressed(0, 33) then
		Drilling.DrillPos = math.max(0.0, Drilling.DrillPos - (0.1 * GetFrameTime()))
	end

	local last_speed = Drilling.DrillSpeed
	if IsControlJustPressed(0, 35) then
		Drilling.DrillSpeed = math.min(1.0, Drilling.DrillSpeed + 0.05)
	elseif IsControlPressed(0, 35) then
		Drilling.DrillSpeed = math.min(1.0, Drilling.DrillSpeed + (0.5 * GetFrameTime()))
	elseif IsControlJustPressed(0, 34) then
		Drilling.DrillSpeed = math.max(0.0, Drilling.DrillSpeed - 0.05)
	elseif IsControlPressed(0, 34) then
		Drilling.DrillSpeed = math.max(0.0, Drilling.DrillSpeed - (0.5 * GetFrameTime()))
	end

	if Drilling.HoleDepth >= 0.1 and Drilling.DrillPos >= Drilling.HoleDepth then
		SetVariableOnSound(Drilling.Sounds.Sound, "DrillState", 1.0)
	end

	local last_temp = Drilling.DrillTemp
	if last_pos < Drilling.DrillPos then
		if Drilling.DrillSpeed > 0.4 then
			if Drilling.HoleDepth >= 0.1 and Drilling.DrillPos >= Drilling.HoleDepth then
				Drilling.DrillTemp =
					math.min(1.0, Drilling.DrillTemp + ((0.05 * GetFrameTime()) * (Drilling.DrillSpeed * 10)))
			end
			Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
		else
			if Drilling.DrillPos < 0.1 or Drilling.DrillPos < Drilling.HoleDepth then
				Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
			else
				if Drilling.DrillPos >= Drilling.HoleDepth then
					Drilling.DrillTemp = math.min(1.0, Drilling.DrillTemp + (0.01 * GetFrameTime()))
				end
				Drilling.DrillPos = last_pos
			end
		end
	else
		if Drilling.DrillPos < Drilling.HoleDepth then
			if Drilling.DrillPos < Drilling.HoleDepth then
				Drilling.DrillTemp = math.max(
					0.0,
					Drilling.DrillTemp - ((0.05 * GetFrameTime()) * math.max(0.005, (Drilling.DrillSpeed * 10) / 2))
				)
			end
		end

		if Drilling.DrillPos ~= Drilling.HoleDepth then
			Scaleforms.PopFloat(Drilling.Scaleform, "SET_DRILL_POSITION", Drilling.DrillPos)
		end
	end

	if last_speed ~= Drilling.DrillSpeed then
		Scaleforms.PopFloat(Drilling.Scaleform, "SET_SPEED", Drilling.DrillSpeed)
	end

	if last_temp ~= Drilling.DrillTemp then
		Scaleforms.PopFloat(Drilling.Scaleform, "SET_TEMPERATURE", Drilling.DrillTemp)
	end

	if Drilling.DrillTemp >= 1.0 then
		YouFuckingSuck()
		Drilling.Result = false
		Drilling.Active = false
	elseif Drilling.DrillPos >= 1.0 then
		StopSound(Drilling.Sounds.Sound)
		Drilling.Result = true
		Drilling.Active = false
	end

	Drilling.HoleDepth = (Drilling.DrillPos > Drilling.HoleDepth and Drilling.DrillPos or Drilling.HoleDepth)
end

Drilling.DisableControls = function()
	for _, control in ipairs(Drilling.DisabledControls) do
		DisableControlAction(0, control, true)
	end
end

Drilling.EnableControls = function()
	for _, control in ipairs(Drilling.DisabledControls) do
		DisableControlAction(0, control, true)
	end
end
