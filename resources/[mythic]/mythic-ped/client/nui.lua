local Sounds = {
	["SELECT"] = { id = -1, sound = "SELECT", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["BACK"] = { id = -1, sound = "CANCEL", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["UPDOWN"] = { id = -1, sound = "NAV_UP_DOWN", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["DISABLED"] = { id = -1, sound = "ERROR", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
}

LocalPlayer.state.isNaked = false

RegisterNetEvent("UI:Client:Reset", function(apps)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "UI_RESET",
		data = {},
	})
end)

RegisterNUICallback("FrontEndSound", function(data, cb)
	cb("ok")
	if Sounds[data.sound] ~= nil then
		UISounds.Play:FrontEnd(Sounds[data.sound].id, Sounds[data.sound].sound, Sounds[data.sound].library)
	end
end)

RegisterNUICallback("Save", function(data, cb)
	if _currentState ~= nil then
		Ped.Customization:Save(cb)
	else
		cb(false)
	end
end)

RegisterNUICallback("Cancel", function(data, cb)
	cb(Ped.Customization:Cancel())
end)

RegisterNUICallback("SaveImport", function(data, cb)
	if data.Label == '' then return Notification:Error("Outfit Label can't be empty.") end
	if data.Code == '' then return Notification:Error("Outfit Code can't be empty.") end

    TriggerEvent("Wardrobe:Client:ApplySharedOutfit", data.Label, data.Code)
end)

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

local nakedPed = nil
function ToggleNekked(data)
	if data then
		LocalPlayer.state.isNaked = true
		nakedPed = deepcopy(LocalPed)
		local isMale = LocalPlayer.state.Character:GetData("Gender") == 0
		if isMale then
			nakedPed.customization.components.torso.drawableId = 15
			nakedPed.customization.components.torso2.drawableId = 252
			nakedPed.customization.components.undershirt.drawableId = 15
			nakedPed.customization.components.leg.drawableId = 21
			nakedPed.customization.components.kevlar.drawableId = 0
			nakedPed.customization.components.shoes.drawableId = 34
		else
			nakedPed.customization.components.torso.drawableId = 15
			nakedPed.customization.components.torso2.drawableId = 15
			nakedPed.customization.components.undershirt.drawableId = 14
			nakedPed.customization.components.leg.drawableId = 15
			nakedPed.customization.components.kevlar.drawableId = 0
			nakedPed.customization.components.shoes.drawableId = 35
		end

		nakedPed.customization.components.mask.drawableId = 0
		nakedPed.customization.components.bag.drawableId = 0
		nakedPed.customization.components.badge.drawableId = 0
		nakedPed.customization.components.accessory.drawableId = 0
		nakedPed.customization.props.hat.disabled = true
		nakedPed.customization.props.glass.disabled = true
		nakedPed.customization.props.ear.disabled = true
		Ped:ApplyToPed(nakedPed)
	else
		LocalPlayer.state.isNaked = false
		Ped:ApplyToPed(LocalPed)
		nakedPed = nil
	end
end

RegisterNUICallback("ToggleNekked", function(data, cb)
	ToggleNekked(data)
	cb("ok")
end)

RegisterNUICallback("ChangeCamera", function(data, cb)
	cb("ok")
	SetEntityHeading(PlayerPedId(), _creatorLocation.h)
	Camera.SetView(_camOffsets[data])
end)

RegisterNUICallback("RotateLeft", function(data, cb)
	cb("ok")
	local playerPed = PlayerPedId()
	local heading = GetEntityHeading(playerPed)
	SetEntityHeading(playerPed, heading - 5)
end)

RegisterNUICallback("RotateRight", function(data, cb)
	cb("ok")
	local playerPed = PlayerPedId()
	local heading = GetEntityHeading(playerPed)
	SetEntityHeading(playerPed, heading + 5)
end)

RegisterNUICallback("Zoom", function(data, cb)
	cb("ok")
	Camera.radius = Camera.radius + (tonumber(data.zoom))
	Camera.updateZoom = true
end)

RegisterNUICallback("Animation", function(data, cb)
	cb("ok")
	if _playingIdle then
		ClearPedTasks(PlayerPedId())
		_playingIdle = false
	else
		PlayIdleAnimation()
	end
end)

RegisterNUICallback("SetPedHeadBlendData", function(data, cb)
	cb("OK")
	LocalPed.customization.face[data.face][data.type] = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.customization.face[data.face][data.type] = data.value
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPed", function(data, cb)
	local model = GetHashKey(data.value)
	RequestModel(model)
	local c = 0
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
		c = c + 1
		if c >= 2000 then
			cb(false)
			return
		end
	end
	cb(true)

	LocalPed.model = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.model = data.value
	end
	if _data ~= nil then
		_data.Ped.model = data.value
	end

	SetPlayerModel(PlayerId(), model)
	player = PlayerPedId()
	SetEntityMaxHealth(player, 200)
	SetEntityHealth(player, GetEntityMaxHealth(player))
	LocalPlayer.state.ped = player
	SetPedDefaultComponentVariation(player)
	SetEntityAsMissionEntity(player, true, true)
	SetModelAsNoLongerNeeded(model)
end)

RegisterNUICallback("SetPedFaceFeature", function(data, cb)
	cb("OK")
	LocalPed.customization.face.features[data.index] = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.customization.face.features[data.index] = data.value
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPedHeadOverlay", function(data, cb)
	cb("OK")
	if data.extraType == "opacity" then
		LocalPed.customization.overlay[data.type].opacity = data.value
	else
		LocalPed.customization.overlay[data.type][data.extraType] = data.value
	end
	if LocalPlayer.state.isNaked then
		if data.extraType == "opacity" then
			nakedPed.customization.overlay[data.type].opacity = data.value
		else
			nakedPed.customization.overlay[data.type][data.extraType] = data.value
		end
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPedComponentVariation", function(data, cb)
	cb("OK")
	LocalPed.customization.components[data.name][data.type] = data.value
	if not LocalPlayer.state.isNaked then
		Ped:ApplyToPed(LocalPed)
	else
		if data.name == "hair" then
			nakedPed.customization.components[data.name][data.type] = data.value
			Ped:ApplyToPed(nakedPed)
		end
	end
end)

RegisterNUICallback("SetPedPropIndex", function(data, cb)
	cb("OK")
	LocalPed.customization.props[data.name][data.type] = data.value
	if not LocalPlayer.state.isNaked then
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPedHairColor", function(data, cb)
	cb("OK")
	LocalPed.customization.colors[data.name][data.type].index = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.customization.colors[data.name][data.type].index = data.value
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPedHairOverlay", function(data, cb)
	cb("OK")

	LocalPed.customization.hairOverlay = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.customization.hairOverlay = data.value
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("SetPedEyeColor", function(data, cb)
	cb("OK")
	LocalPed.customization.eyeColor = data.value
	if LocalPlayer.state.isNaked then
		nakedPed.customization.eyeColor = data.value
		Ped:ApplyToPed(nakedPed)
	else
		Ped:ApplyToPed(LocalPed)
	end
end)

RegisterNUICallback("AddPedTattoo", function(data, cb)
	cb("OK")
	table.insert(LocalPed.customization.tattoos, {
		Name = "",
		Collection = "",
		Hash = "",
		Zone = data.type,
	})
	if LocalPlayer.state.isNaked then
		table.insert(nakedPed.customization.tattoos, {
			Name = "",
			Collection = "",
			Hash = "",
			Zone = data.type,
		})
		Ped:ApplyToPed(nakedPed, true)
	else
		Ped:ApplyToPed(LocalPed, true)
	end
end)

RegisterNUICallback("RemovePedTattoo", function(data, cb)
	cb("OK")
	table.remove(LocalPed.customization.tattoos, data.index + 1)
	if LocalPlayer.state.isNaked then
		table.remove(nakedPed.customization.tattoos, data.index + 1)
		Ped:ApplyToPed(nakedPed, true)
	else
		Ped:ApplyToPed(LocalPed, true)
	end
end)

RegisterNUICallback("SetPedTattoo", function(data, cb)
	cb("OK")
	LocalPed.customization.tattoos[data.index + 1] = data.data
	if LocalPlayer.state.isNaked then
		nakedPed.customization.tattoos[data.index + 1] = data.data
		Ped:ApplyToPed(nakedPed, true)
	else
		Ped:ApplyToPed(LocalPed, true)
	end
end)

RegisterNUICallback("GetNumHairColors", function(data, cb)
	cb("OK")
	SendNUIMessage({
		type = "SET_HAIR_COLORS_MAX",
		data = {
			max = GetNumHairColors(),
			maxOverlays = #Config.CustomHairOverlays
		},
	})
end)

RegisterNUICallback("GetPedHairRgbColor", function(data, cb)
	cb("OK")
	local red, green, blue = GetPedHairRgbColor(data.colorId)
	SendNUIMessage({
		type = "SET_HAIR_COLOR_RGB",
		data = {
			type = data.type,
			name = data.name,
			rgb = "rgb(" .. red .. ", " .. green .. ", " .. blue .. ")",
		},
	})
end)

RegisterNUICallback("GetNumberOfPedDrawableVariations", function(data, cb)
	cb("OK")

	local gender = LocalPlayer.state.Character:GetData("Gender")
	local comps = {}
	for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), data.componentId) do
		if
			GlobalState["ClothingStoreHidden"].components[data.componentId] == nil
			or GlobalState["ClothingStoreHidden"].props[data.componentId][gender] == nil
			or not GlobalState["ClothingStoreHidden"].components[data.componentId][gender][tostring(i)]
		then
			table.insert(comps, i)
		end
	end
	SendNUIMessage({
		type = "SET_MAX_DRAWABLE",
		data = {
			id = data.componentId,
			type = "components",
			max = comps,
		},
	})
end)

RegisterNUICallback("GetNumberOfPedTextureVariations", function(data, cb)
	cb("OK")
	SendNUIMessage({
		type = "SET_MAX_TEXTURE",
		data = {
			id = data.componentId,
			textureId = data.textureId,
			type = "components",
			max = GetNumberOfPedTextureVariations(PlayerPedId(), data.componentId, data.drawableId),
		},
	})
end)

RegisterNUICallback("GetNumberOfPedPropDrawableVariations", function(data, cb)
	cb("OK")

	local gender = LocalPlayer.state.Character:GetData("Gender")
	local comps = {}
	for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), data.componentId) do
		if
			GlobalState["ClothingStoreHidden"].components[data.componentId] == nil
			or GlobalState["ClothingStoreHidden"].props[data.componentId][gender] == nil
			or not GlobalState["ClothingStoreHidden"].components[data.componentId][gender][tostring(i)]
		then
			table.insert(comps, i)
		end
	end
	SendNUIMessage({
		type = "SET_MAX_DRAWABLE",
		data = {
			id = data.componentId,
			type = "props",
			max = comps,
		},
	})
end)

RegisterNUICallback("GetNumberOfPedPropTextureVariations", function(data, cb)
	cb("OK")
	SendNUIMessage({
		type = "SET_MAX_TEXTURE",
		data = {
			id = data.componentId,
			textureId = data.textureId,
			type = "props",
			max = GetNumberOfPedPropTextureVariations(PlayerPedId(), data.componentId, data.drawableId),
		},
	})
end)