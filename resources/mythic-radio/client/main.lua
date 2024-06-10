local radioOpen = false
_radioProp = 0

HAS_RADIO = false

RADIO_FREQUENCY_LAST = 0
RADIO_POWER = false
RADIO_FREQUENCY = 0
RADIO_FREQUENCY_NAME = ''
RADIO_VOLUME = 100
RADIO_CLICKS_VOLUME = 100

-- Lowest Level Gets Used
local radioLevels = {
	RADIO_ENCRYPTED = 1,
	RADIO_CIV = 2,
}

local radioNames = {
	'Encrypted Radio',
	'P6900 Radio',
}

AddEventHandler("Radio:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	VOIP = exports["mythic-base"]:FetchComponent("VOIP")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
end

local radioChannelCycle = false

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Radio", {
		"Callbacks",
		"Notification",
		"Action",
		"Progress",
		"VOIP",
		"Keybinds",
		"Utils",
		"Sounds",
		"Jobs",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Keybinds:Add('voip_radio_power', '', 'keyboard', 'Voice - Radio - Toggle Power On/Off', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and not radioChannelCycle then
				radioChannelCycle = true
				ToggleRadioPower(false)
				Citizen.SetTimeout(1000, function()
					radioChannelCycle = false
				end)
			end
		end)

		Keybinds:Add('voip_radio_open', '', 'keyboard', 'Voice - Radio - Open Radio', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and not LocalPlayer.state.doingAction then
				OpenRadio()
			end
		end)

		Keybinds:Add('voip_radio_vol_down', '', 'keyboard', 'Voice - Radio - Volume Down', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and RADIO_POWER then
				RadioVolumeDown(true)
			end
		end)

		Keybinds:Add('voip_radio_vol_up', '', 'keyboard', 'Voice - Radio - Volume Up', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and RADIO_POWER then
				RadioVolumeUp(true)
			end
		end)

		Keybinds:Add('voip_radio_next', '', 'keyboard', 'Voice - Radio - Channel Next', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and RADIO_POWER then
				CycleRadioChannel(true)
			end
		end)

		Keybinds:Add('voip_radio_prev', '', 'keyboard', 'Voice - Radio - Channel Prev.', function()
			if LocalPlayer.state.loggedIn and HAS_RADIO and RADIO_POWER then
				CycleRadioChannel(false)
			end
		end)
	end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	RADIO_FREQUENCY_LAST = 0
	RADIO_POWER = false
	RADIO_FREQUENCY = 0
	RADIO_FREQUENCY_NAME = ''

	RADIO_VOLUME = VOIP.Settings.Volumes.Radio:Get()
	RADIO_CLICKS_VOLUME = VOIP.Settings.Volumes.RadioClicks:Get()
	HAS_RADIO = false
	
	Citizen.Wait(1000)
	
	HAS_RADIO = CheckCharacterHasRadio()
	SendUpdates()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	CloseRadio()
	SendNUIMessage({
		type = "UPDATE_DATA",
		data = {
			frequency = 0,
			frequencyName = '',
			power = false,
			volume = 100,
		}
	})
end)

RegisterNetEvent('Radio:Client:OpenUI', function(rType)
	if HAS_RADIO ~= rType then
		HAS_RADIO = rType
		SendUpdates()
	end

	OpenRadio()
end)

function OpenRadio()
	if radioOpen then return end

	radioOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "APP_SHOW",
	})

	Weapons:UnequipIfEquippedNoAnim()

	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		LoadAnim('cellphone@')
		LoadModel(`prop_cs_hand_radio`)

		_radioProp = CreateObject(`prop_cs_hand_radio`, GetEntityCoords(playerPed), 1, 1, 0)
		AttachEntityToEntity(_radioProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)

		while radioOpen do
			if not IsEntityPlayingAnim(playerPed, 'cellphone@', 'cellphone_text_read_base', 3) then
				TaskPlayAnim(playerPed, 'cellphone@', 'cellphone_text_read_base', 3.0, 3.0, -1, 49, 0, false, false, false)
			end
			Citizen.Wait(250)
		end

		StopAnimTask(playerPed, 'cellphone@', 'cellphone_text_read_base', 3.0)
		DeleteEntity(_radioProp)
	end)
end

function CloseRadio()
	if not radioOpen then return end
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "APP_HIDE",
	})
	radioOpen = false

	DeleteEntity(_radioProp)
end

function SendUpdates()
	SendNUIMessage({
		type = "UPDATE_DATA",
		data = {
			frequency = RADIO_FREQUENCY,
			frequencyName = RADIO_FREQUENCY_NAME,
			power = RADIO_POWER,
			volume = Utils:Round(RADIO_VOLUME, 0),
			typeName = radioNames[HAS_RADIO] or 'Radio',
		}
	})
end

RegisterNUICallback("Close", function(data, cb)
	CloseRadio()
	cb('ok')
end)

RegisterNUICallback("TogglePower", function(data, cb)
	if HAS_RADIO then
		ToggleRadioPower(true)
	end
	cb('ok')
end)

function ToggleRadioPower(fromUI)
	Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
	if RADIO_POWER then
		RADIO_POWER = false
		SetCharacterRadioFrequency(0)
		if not fromUI then
			Notification:Error('Radio Turned Off', 2500)
		end
	else
		if not fromUI then
			Notification:Success('Radio Turned On', 2500)
		end
		RADIO_POWER = true
		if RADIO_FREQUENCY_LAST and RADIO_FREQUENCY_LAST > 0 then
			SetCharacterRadioFrequency(RADIO_FREQUENCY_LAST, not fromUI)
		end
	end

	SendUpdates()
end

function SetCharacterRadioFrequency(freq, notifyChange)
	if not freq then freq = 0 end
	if freq ~= RADIO_FREQUENCY then
		local canUseFrequency = freq == 0
		local frequencyName = false

		if freq > 0 and RADIO_POWER then
			if CanRadioAccessChannel(HAS_RADIO, freq) then
				local access, name = GetHasRadioChannelAuth(freq)
				if access then
					canUseFrequency = true
					frequencyName = name
				else
					canUseFrequency = false
					Notification:Error('Encrypted Radio Channel')
				end
			else
				Notification:Error('Out of Range Frequency With This Radio')
				canUseFrequency = false
			end
		end
	
		if canUseFrequency then
			RADIO_FREQUENCY = freq

			if RADIO_FREQUENCY and RADIO_FREQUENCY > 0 then
				RADIO_FREQUENCY_LAST = RADIO_FREQUENCY
			end
			
			RADIO_FREQUENCY_NAME = frequencyName or ''
			TriggerServerEvent('VOIP:Radio:Server:SetChannel', RADIO_FREQUENCY)
			SendUpdates()
	
			if notifyChange then
				Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
				if frequencyName then
					Notification:Info('Changed Radio Channel to '.. frequencyName)
				else
					Notification:Info('Changed Radio Channel to #'.. RADIO_FREQUENCY)
				end
			end
		else
			SendUpdates()
		end
	end
end

function CycleRadioChannel(up)
	if radioChannelCycle then return end
	radioChannelCycle = true
	local switchingRadioChannel
	if up then
		switchingRadioChannel = RADIO_FREQUENCY + 1
		if switchingRadioChannel > 2000 then
			switchingRadioChannel = false
		end
	else
		switchingRadioChannel = RADIO_FREQUENCY - 1
		if switchingRadioChannel < 0 then
			switchingRadioChannel = false
		end
	end

	if switchingRadioChannel then
		SetCharacterRadioFrequency(switchingRadioChannel, true)
	end

	Citizen.SetTimeout(1000, function()
		radioChannelCycle = false
	end)
end

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	Citizen.Wait(1000)
	if LocalPlayer.state.loggedIn then
		CheckRadioChannelAuth()
	end
end)

RegisterNetEvent("Characters:Client:SetData", function()
	Citizen.Wait(1000)
	if LocalPlayer.state.loggedIn then
		
		local hasRadio = CheckCharacterHasRadio()
		if HAS_RADIO and not hasRadio then
			HAS_RADIO = false

			if RADIO_POWER then
				RADIO_POWER = false
				SetCharacterRadioFrequency(0)
				Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
			end

			CloseRadio()
		elseif not HAS_RADIO and hasRadio then
			HAS_RADIO = hasRadio
		elseif HAS_RADIO and HAS_RADIO ~= hasRadio then
			HAS_RADIO = hasRadio

			SendUpdates()
		end

		CheckRadioChannelAuth()
	end
end)

function GetHasRadioChannelAuth(freq)
	if freq <= 20 then
		if DoesCharacterPassChannelRestrictions(_emergencyRestriction) then
			return true, 'Emergency #'.. freq
		end
	elseif freq == 21 then
		if LocalPlayer.state.onDuty == "dgang" then
			return true, 'Poggers'
		end
	elseif freq < 100 then
		return false
	else
		return true
	end

	return false
end

function CheckRadioChannelAuth()
	if HAS_RADIO and RADIO_POWER and RADIO_FREQUENCY > 0 then
		if not GetHasRadioChannelAuth(RADIO_FREQUENCY) then
			SetCharacterRadioFrequency(0, true)
		end

		if not CanRadioAccessChannel(HAS_RADIO, RADIO_FREQUENCY) then
			SetCharacterRadioFrequency(0, true)
		end
	end
end

function CheckCharacterHasRadio()
	local character = LocalPlayer.state.Character
	if character then
		local states = character:GetData('States') or {}
		local hasRadio = false
		local lowestLevel = 100
		for k, v in ipairs(states) do
			local isRadio = radioLevels[v]
			if isRadio and isRadio < lowestLevel then
				hasRadio = true
				lowestLevel = isRadio
			end
		end

		if hasRadio then
			return lowestLevel
		end
	end

	return false
end

RegisterNUICallback("SetChannel", function(data, cb)
	if data.frequency ~= RADIO_FREQUENCY and HAS_RADIO then
		Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
		SetCharacterRadioFrequency(Utils:Round(tonumber(data.frequency), 2))
	end
	cb('ok')
end)

function RadioVolumeUp(notify)
	local newVolume = RADIO_VOLUME + 10
	if newVolume > 200 then
		newVolume = 200
	end

	RADIO_VOLUME = VOIP.Settings.Volumes.Radio:Set(newVolume)

	if notify then
		Notification:Info('Radio Volume: '.. math.floor(RADIO_VOLUME) .. '%', 1500)
	end

	SendUpdates()
end

function RadioVolumeDown(notify)
	local newVolume = RADIO_VOLUME - 10
	if newVolume <= 0 then
		newVolume = 0
	end

	RADIO_VOLUME = VOIP.Settings.Volumes.Radio:Set(newVolume)

	if notify then
		Notification:Info('Radio Volume: '.. math.floor(RADIO_VOLUME) .. '%', 1500)
	end

	SendUpdates()
end

RegisterNUICallback("VolumeUp", function(data, cb)
	if HAS_RADIO then
		RadioVolumeUp()
	end

	cb('ok')
end)

RegisterNUICallback("VolumeDown", function(data, cb)
	if HAS_RADIO then
		RadioVolumeDown()
	end

	cb('ok')
end)

RegisterNUICallback("ClickVolumeUp", function(data, cb)
	if HAS_RADIO then
		local newVolume = RADIO_CLICKS_VOLUME + 5
		if newVolume > 200 then
			newVolume = 200
		end
	
		RADIO_CLICKS_VOLUME = VOIP.Settings.Volumes.RadioClicks:Set(newVolume)
	
		Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
	end
	cb('ok')
end)

RegisterNUICallback("ClickVolumeDown", function(data, cb)
	if HAS_RADIO then
		local newVolume = RADIO_CLICKS_VOLUME - 5
		if newVolume <= 0 then
			newVolume = 0
		end
	
		RADIO_CLICKS_VOLUME = VOIP.Settings.Volumes.RadioClicks:Set(newVolume)
	
		Sounds.Do.Play:One('radioclick.ogg', RADIO_CLICKS_VOLUME / 100)
	end
	cb('ok')
end)

RegisterNetEvent("UI:Client:Reset", function()
	CloseRadio()
end)