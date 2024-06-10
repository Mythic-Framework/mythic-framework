PLAYER_CONNECTED = false
PLAYER_SERVER_ID = GetPlayerServerId(PlayerId())
CURRENT_GRID = 0
CURRENT_VOICE_MODE = 1
CURRENT_VOICE_MODE_DATA = nil
VOIP_SETTINGS = nil
PLAYER_TALKING = false

_characterLoaded = false

USING_MEGAPHONE = false
USING_MICROPHONE = false

RADIO_TALKING = false
RADIO_CHANNEL = false
RADIO_DATA = {}

CALL_CHANNEL = false
CALL_DATA = {}

SUBMIX_DATA = {}

local started = false
function RunStartup()
	if started then
		return
	end
	started = true

	SUBMIX_DATA = CreateVOIPSubmix()
	VOIP_SETTINGS = GetPlayerVOIPSettings()
end

AddEventHandler("VOIP:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	VOIP = exports["mythic-base"]:FetchComponent("VOIP")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("VOIP", {
		"Callbacks",
		"Notification",
		"Logger",
		"Hud",
		"Keybinds",
		"Utils",
		"Sounds",
		"Animations",
		"Polyzone",
		"VOIP",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RunStartup()
		CreateMicrophonePolyzones()

		Keybinds:Add("voip_cycleproximity", "Z", "keyboard", "Voice - Cycle Proximity", function()
			if _characterLoaded and PLAYER_CONNECTED then
				VOIP:Cycle()
			end
		end)

		Keybinds:Add("voip_radio", "CAPITAL", "keyboard", "Voice - Radio - Push to Talk", function()
			if _characterLoaded and PLAYER_CONNECTED then
				RadioKeyDown()
			end
		end, function()
			if _characterLoaded and PLAYER_CONNECTED then
				RadioKeyUp()
			end
		end)
	end)
end)

AddEventHandler("mumbleConnected", function()
	if _characterLoaded then
		if not PLAYER_CONNECTED then
			PLAYER_CONNECTED = true
			TriggerEvent("VOIP:Client:ConnectionState", PLAYER_CONNECTED)
		end
	end
end)

AddEventHandler("mumbleDisconnected", function()
	if _characterLoaded then
		if PLAYER_CONNECTED then
			PLAYER_CONNECTED = false
			TriggerEvent("VOIP:Client:ConnectionState", PLAYER_CONNECTED)
		end
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	_characterLoaded = true

	USING_MEGAPHONE = false
	RADIO_TALKING = false

	CURRENT_VOICE_MODE = 2
	CURRENT_VOICE_MODE_DATA = VOIP_CONFIG.Modes[CURRENT_VOICE_MODE]

	StartVOIPGridThreads()

	Hud:RegisterStatus("VOIP", 100, 100, "microphone-slash", "#a13434", false, false, {
		id = 1,
		hideHigh = false,
		visibleWhileDead = true,
	})

	Citizen.SetTimeout(5000, function()
		UpdateVOIPIndicatorStatus()
	end)

	Citizen.CreateThread(function()
		while _characterLoaded do
			GLOBAL_PED = PlayerPedId()
			Citizen.Wait(5000)
		end
	end)

	Citizen.CreateThread(function()
		while _characterLoaded do
			Citizen.Wait(100)
			local isTalking = NetworkIsPlayerTalking(PlayerId())
			if isTalking and not PLAYER_TALKING then
				PLAYER_TALKING = true
				TriggerEvent("VOIP:Client:TalkingState", PLAYER_TALKING)
			elseif PLAYER_TALKING and not isTalking then
				PLAYER_TALKING = false
				TriggerEvent("VOIP:Client:TalkingState", PLAYER_TALKING)
			end
		end
	end)

	local address, port = GetVOIPMumbleAddress()
	MumbleSetServerAddress(address, port)
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	_characterLoaded = false

	USING_MEGAPHONE = false

	MumbleSetServerAddress("", 0)
	Logger:Info("VOIP", "Disconnecting From Mumble (Character Logging Out)")
end)

AddEventHandler("VOIP:Client:ConnectionState", function(state)
	if state then
		Logger:Info("VOIP", "Connected to Mumble Server")

		MumbleClearVoiceTarget(1)
		MumbleClearVoiceTargetPlayers(1)

		for i = 1, 4 do
			MumbleClearVoiceTarget(i)
		end

		--MumbleSetAudioInputDistance(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		NetworkSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		--MumbleSetAudioOutputDistance(50.0)
	else
		Logger:Warn("VOIP", "Disconnected from Mumble Server")
		StopUsingMegaphone()
	end

	if _characterLoaded then
		UpdateVOIPIndicatorStatus()
	end
end)

AddEventHandler("VOIP:Client:TalkingState", function()
	UpdateVOIPIndicatorStatus()
end)

function UpdateVOIPIndicatorStatus()
	local indicatorColor = "#610000"
	local indicatorIcon = "microphone-slash"
	local fillPercent = 100

	if PLAYER_CONNECTED then
		indicatorColor = "#ababab"
		indicatorIcon = "microphone"

		if RADIO_CHANNEL and RADIO_CHANNEL > 0 then
			indicatorIcon = "walkie-talkie"
		end

		if CALL_CHANNEL and CALL_CHANNEL > 0 then
			indicatorIcon = "phone-volume"
		end

		if PLAYER_TALKING then
			indicatorColor = "#eb7d34"
		end

		if RADIO_TALKING then
			indicatorColor = "#c326eb"
		end

		fillPercent = (100 / #VOIP_CONFIG.Modes) * CURRENT_VOICE_MODE

		if USING_MEGAPHONE then
			indicatorIcon = "megaphone"
			fillPercent = 100
		end

		if USING_MICROPHONE then
			indicatorIcon = "microphone-stand"
			fillPercent = 100
		end
	end

	Hud:RegisterStatus(
		"VOIP",
		fillPercent,
		100,
		indicatorIcon,
		indicatorColor,
		false,
		true,
		{ id = 1, visibleWhileDead = true }
	)
end

_fuckingVOIP = {
	Cycle = function(self, num)
		if playerMuted or USING_MEGAPHONE or USING_MICROPHONE then
			return
		end
		local newMode = CURRENT_VOICE_MODE + 1
		if num then
			newMode = num
		end
		if newMode > #VOIP_CONFIG.Modes then
			newMode = 1
		end

		CURRENT_VOICE_MODE = newMode
		CURRENT_VOICE_MODE_DATA = VOIP_CONFIG.Modes[CURRENT_VOICE_MODE]
		--MumbleSetAudioInputDistance(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		NetworkSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
		UpdateVOIPIndicatorStatus()

		LocalPlayer.state:set("proximity", CURRENT_VOICE_MODE_DATA.Range, true)
		Logger:Trace("VOIP", "New Voice Range: " .. CURRENT_VOICE_MODE)
	end,
	ToggleVoice = function(self, plySource, enabled, voiceType, volume)
		local volumeOverride = volume or GetVolumeForVoiceType(voiceType)
		if volumeOverride then
			MumbleSetVolumeOverrideByServerId(plySource, enabled and volumeOverride or -1.0)
		else
			MumbleSetVolumeOverrideByServerId(plySource, -1.0)
		end

		if enabled and voiceType and SUBMIX_DATA and SUBMIX_DATA[voiceType] then
			MumbleSetSubmixForServerId(plySource, SUBMIX_DATA[voiceType])
		else
			MumbleSetSubmixForServerId(plySource, -1)
		end
	end,
	GetGrid = function(self)
		return GetCurrentVOIPGrid()
	end,
	MicClicks = function(self, on, isLocal)
		if on then
			Sounds.Do.Play:One("mic_click_on.ogg", VOIP_SETTINGS.RadioClickVolume)
		else
			Sounds.Do.Play:One("mic_click_off.ogg", VOIP_SETTINGS.RadioClickVolume)
		end
	end,
	SetPlayerTargets = function(self, ...)
		local targets = { ... }
		local addedPlayers = {
			[PLAYER_SERVER_ID] = true,
		}

		for i = 1, #targets do
			for id, _ in pairs(targets[i]) do
				if addedPlayers[id] and id ~= PLAYER_SERVER_ID then
					goto continue
				end
				if not addedPlayers[id] then
					addedPlayers[id] = true
					MumbleAddVoiceTargetPlayerByServerId(1, id)
				end
				::continue::
			end
		end
	end,
	Settings = {
		Volumes = {
			Radio = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("RadioVolume", val / 100)
					end

					return VOIP_SETTINGS.RadioVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.RadioVolume * 100
					end
				end,
			},
			RadioClicks = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("RadioClickVolume", val / 100)
					end

					return VOIP_SETTINGS.RadioClickVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.RadioClickVolume * 100
					end
				end,
			},
			Phone = {
				Set = function(self, val)
					if type(val) == "number" and val >= 0 and val <= 200 then
						VOIP_SETTINGS = SetPlayerVOIPSetting("CallVolume", val / 100)
					end

					return VOIP_SETTINGS.CallVolume * 100
				end,
				Get = function(self)
					if VOIP_SETTINGS then
						return VOIP_SETTINGS.CallVolume * 100
					end
				end,
			},
		},
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("VOIP", _fuckingVOIP)
end)

CreateThread(function()
	MumbleSetServerAddress("", 0)
end)

function GetVolumeForVoiceType(type)
	if type == "phone" then
		return 1.0 -- VOIP_SETTINGS.CallVolume
	elseif type == "radio" or type == "radio_med" or type == "radio_far" or type == "radio_really_far" then
		return VOIP_SETTINGS.RadioVolume
	end
	return false
end

-- 	-- sets how far the player can talk
-- 	MumbleSetAudioInputDistance(Cfg.voiceModes[mode][1] + 0.0)
-- 	LocalPlayer.state:set('proximity', Cfg.voiceModes[mode][1] + 0.0, true)

-- 	-- this sets how far the player can hear.
-- 	MumbleSetAudioOutputDistance(Cfg.voiceModes[#Cfg.voiceModes][1] + 0.0)
-- end)
