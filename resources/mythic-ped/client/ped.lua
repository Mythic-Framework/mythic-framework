_creatorLocation = { x = 1844.212, y = 2594.376, z = 45.016, h = 89.374 }
_currentState = nil
_data = nil
_playingIdle = false
FROZEN = false

_camOffsets = {
	[0] = "standard",
	[1] = "head",
	[2] = "body",
	[3] = "legs",
}

_glassesOff = false
_vestOff = false
attachedProps = {}

AddEventHandler("Ped:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Spawn = exports["mythic-base"]:FetchComponent("Spawn")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Ped = exports["mythic-base"]:FetchComponent("Ped")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
	Apartment = exports["mythic-base"]:FetchComponent("Apartment")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Ped", {
		"Callbacks",
		"Utils",
		"UISounds",
		"Blips",
		"Notification",
		"Sync",
		"Spawn",
		"Action",
		"Polyzone",
		"Ped",
		"Interaction",
		"Wardrobe",
		"Apartment",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterInteraction()
		CreateShops()
	end)
end)

RegisterNetEvent("Ped:Client:RemoveGlasses", function()
	if LocalPlayer.state.Character ~= nil and not LocalPed.customization.props.glass.disabled and not _glassesOff then
		_glassesOff = true
		Citizen.CreateThread(function()
			TriggerEvent("Ped:Client:HatGlassAnim")
			Citizen.Wait(500)
			ClearPedProp(LocalPlayer.state.ped, 1)
		end)
	end
end)

RegisterNetEvent("Ped:Client:RemoveKevlar", function()
	if LocalPlayer.state.Character ~= nil and not LocalPed.customization.props.glass.disabled and not _vestOff then
		_vestOff = true
		Citizen.CreateThread(function()
			TriggerEvent("Ped:Client:HatGlassAnim")
			Citizen.Wait(500)
			ClearPedProp(LocalPlayer.state.ped, 1)
		end)
	end
end)

function RegisterInteraction()
	Interaction:RegisterMenu("ped_interact", false, "face-tired", function()
		Interaction:ShowMenu({
			{
				icon = "masks-theater",
				label = "Remove Mask",
				shouldShow = function()
					return LocalPed.customization.components.mask.drawableId ~= 0
				end,
				action = function()
					Callbacks:ServerCallback("Ped:RemoveMask")
					Interaction:Hide()
				end,
			},
			{
				icon = "hat-cowboy-side",
				label = "Remove Hat",
				shouldShow = function()
					return not LocalPed.customization.props.hat.disabled
				end,
				action = function()
					Callbacks:ServerCallback("Ped:RemoveHat")
					Interaction:Hide()
				end,
			},
			{
				icon = "glasses",
				label = "Remove Glasses",
				shouldShow = function()
					return not LocalPed.customization.props.glass.disabled and not _glassesOff
				end,
				action = function()
					_glassesOff = true
					Citizen.CreateThread(function()
						TriggerEvent("Ped:Client:HatGlassAnim")
						Citizen.Wait(500)
						ClearPedProp(LocalPlayer.state.ped, 1)
					end)
					Interaction:Hide()
				end,
			},
			{
				icon = "glasses",
				label = "Put On Glasses",
				shouldShow = function()
					return not LocalPed.customization.props.glass.disabled and _glassesOff
				end,
				action = function()
					_glassesOff = false
					Citizen.CreateThread(function()
						TriggerEvent("Ped:Client:HatGlassAnim")
						Citizen.Wait(500)
						SetPedPropIndex(
							LocalPlayer.state.ped,
							LocalPed.customization.props.glass.componentId,
							LocalPed.customization.props.glass.drawableId,
							LocalPed.customization.props.glass.textureId
						)
					end)
					Interaction:Hide()
				end,
			},
			{
				icon = "rotate",
				label = false,
				shouldShow = function()
					return (
							not LocalPed.customization.props.hat.disabled
							and GetPedPropIndex(LocalPlayer.state.ped, 0) == -1
						)
						or (
							not LocalPed.customization.props.glass.disabled
							and GetPedPropIndex(LocalPlayer.state.ped, 1) == -1
							and not _glassesOff
						)
				end,
				action = function()
					Citizen.CreateThread(function()
						TriggerEvent("Ped:Client:HatGlassAnim")
						Citizen.Wait(500)

						if not LocalPed.customization.props.hat.disabled
							and GetPedPropIndex(LocalPlayer.state.ped, 0) == -1
						then
							SetPedPropIndex(
								LocalPlayer.state.ped,
								LocalPed.customization.props.hat.componentId,
								LocalPed.customization.props.hat.drawableId,
								LocalPed.customization.props.hat.textureId
							)
						end

						if not LocalPed.customization.props.glass.disabled
							and GetPedPropIndex(LocalPlayer.state.ped, 1) == -1
							and not _glassesOff
						then
							SetPedPropIndex(
								LocalPlayer.state.ped,
								LocalPed.customization.props.glass.componentId,
								LocalPed.customization.props.glass.drawableId,
								LocalPed.customization.props.glass.textureId
							)
						end
					end)
					Interaction:Hide()
					-- Interaction:ShowMenu({
					-- 	{
					-- 		icon = "face-sunglasses",
					-- 		label = "Put On Hat & Glasses",
					-- 		shouldShow = function()
					-- 			return (
					-- 					not LocalPed.customization.props.hat.disabled
					-- 					and GetPedPropIndex(LocalPlayer.state.ped, 0) == -1
					-- 				)
					-- 				and (
					-- 					not LocalPed.customization.props.glass.disabled
					-- 					and GetPedPropIndex(LocalPlayer.state.ped, 1) == -1
					-- 					and not _glassesOff
					-- 				)
					-- 		end,
					-- 		action = function()
					-- 			Citizen.CreateThread(function()
					-- 				TriggerEvent("Ped:Client:HatGlassAnim")
					-- 				Citizen.Wait(500)
					-- 				SetPedPropIndex(
					-- 					LocalPlayer.state.ped,
					-- 					LocalPed.customization.props.hat.componentId,
					-- 					LocalPed.customization.props.hat.drawableId,
					-- 					LocalPed.customization.props.hat.textureId
					-- 				)
					-- 				SetPedPropIndex(
					-- 					LocalPlayer.state.ped,
					-- 					LocalPed.customization.props.glass.componentId,
					-- 					LocalPed.customization.props.glass.drawableId,
					-- 					LocalPed.customization.props.glass.textureId
					-- 				)
					-- 			end)
					-- 			Interaction:Hide()
					-- 		end,
					-- 	},
					-- 	{
					-- 		icon = "hat-cowboy-side",
					-- 		label = "Put On Hat",
					-- 		shouldShow = function()
					-- 			return (
					-- 					not LocalPed.customization.props.hat.disabled
					-- 					and GetPedPropIndex(LocalPlayer.state.ped, 0) == -1
					-- 				)
					-- 		end,
					-- 		action = function()
					-- 			Citizen.CreateThread(function()
					-- 				TriggerEvent("Ped:Client:HatGlassAnim")
					-- 				Citizen.Wait(500)
					-- 				SetPedPropIndex(
					-- 					LocalPlayer.state.ped,
					-- 					LocalPed.customization.props.hat.componentId,
					-- 					LocalPed.customization.props.hat.drawableId,
					-- 					LocalPed.customization.props.hat.textureId
					-- 				)
					-- 			end)
					-- 			Interaction:Hide()
					-- 		end,
					-- 	},
					-- 	{
					-- 		icon = "glasses",
					-- 		label = "Put On Glasses",
					-- 		shouldShow = function()
					-- 			return (
					-- 					not LocalPed.customization.props.glass.disabled
					-- 					and GetPedPropIndex(LocalPlayer.state.ped, 1) == -1
					-- 					and not _glassesOff
					-- 				)
					-- 		end,
					-- 		action = function()
					-- 			Citizen.CreateThread(function()
					-- 				TriggerEvent("Ped:Client:HatGlassAnim")
					-- 				Citizen.Wait(500)
					-- 				SetPedPropIndex(
					-- 					LocalPlayer.state.ped,
					-- 					LocalPed.customization.props.glass.componentId,
					-- 					LocalPed.customization.props.glass.drawableId,
					-- 					LocalPed.customization.props.glass.textureId
					-- 				)
					-- 			end)
					-- 			Interaction:Hide()
					-- 		end,
					-- 	},
					-- })
				end,
			},
		})
	end, function()
		return not LocalPlayer.state.isDead
			and (
				not LocalPed.customization.props.hat.disabled
				or not LocalPed.customization.props.glass.disabled
				or (LocalPed.customization.components.mask.drawableId ~= 0)
				or (Inventory.Items:GetWithStaticMetadata("accessory", "drawableId", "textureId", LocalPlayer.state.Character:GetData("Gender"), LocalPed.customization.components.accessory) ~= nil)
			)
	end)
end

RegisterNetEvent("Characters:Client:Logout", function()
	withinPedShop = false
	_glassesOff = false
	if cam ~= nil then
		cam = nil
		_currentState = nil
	end
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	CreateShopsBlips()

	SendNUIMessage({
		type = "SET_PRICING",
		data = {
			pricing = GlobalState["Ped:Pricing"],
		},
	})
end)

function getBonePos(bone)
	if bone == "standard" then
		local coords = GetPedBoneCoords(PlayerPedId(), 11816)
		return vector3(coords.x - 0.3, coords.y + 1.0, coords.z + 0.5)
	elseif bone == "head" then
		local coords = GetPedBoneCoords(PlayerPedId(), 31086)
		return vector3(coords.x - 0.195, coords.y + 0.4, coords.z + 0.05)
	elseif bone == "torso" then
		local coords = GetPedBoneCoords(PlayerPedId(), 11816)
		return vector3(coords.x - 0.3, coords.y + 0.6, coords.z + 0.3)
	elseif bone == "legs" then
		local coords = GetPedBoneCoords(PlayerPedId(), 11816)
		return vector3(coords.x - 0.3, coords.y + 0.7, coords.z - 0.5)
	elseif bone == "feet" then
		local coords = GetPedBoneCoords(PlayerPedId(), 11816)
		return vector3(coords.x - 0.2, coords.y + 0.45, coords.z - 0.8)
	end
end

function PlayIdleAnimation()
	_playingIdle = true
	ClearPedTasksImmediately(PlayerPedId())
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_HUMAN_STATUE", 0, false)
end

function RemoveAttached(propId)
	if attachedProps[propId] ~= nil then
		DeleteEntity(attachedProps[propId])
		attachedProps[propId] = nil
	end
end

function AttachProp(propId, attachModel, boneNumberSent, x, y, z, xR, yR, zR, keepOtherProps, altVertex)
	if attachedProps[propId] ~= nil then
		RemoveAttached(propId)
	end

	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(0)
	end
	local attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	attachedProps[propId] = attachedProp
	AttachEntityToEntity(
		attachedProp,
		PlayerPedId(),
		bone,
		x,
		y,
		z,
		xR,
		yR,
		zR,
		1,
		1,
		0,
		1,
		not altVertex and 2 or 0,
		1
	)
	SetModelAsNoLongerNeeded(attachModel)
end

PED = {
	_required = {},
	ApplyToPed = function(self, ped, skip, entityOverride)
		local playerPed = entityOverride or PlayerPedId()

		if not skip then
			local gender = LocalPlayer.state.Character:GetData("Gender")
			local gangChain = LocalPlayer.state.Character:GetData("GangChain")
			local gangChainData = gangChain ~= nil and GlobalState["GangChains"][gangChain] or nil

			SetPedEyeColor(playerPed, ped.customization.eyeColor)
			local playerModel = GetEntityModel(playerPed)
			if playerModel == GetHashKey("mp_f_freemode_01") or playerModel == GetHashKey("mp_m_freemode_01") then
				SetPedHeadBlendData(
					playerPed,
					ped.customization.face.face1.index,
					ped.customization.face.face2.index,
					ped.customization.face.face3.index,
					ped.customization.face.face1.texture,
					ped.customization.face.face2.texture,
					ped.customization.face.face3.index,
					(ped.customization.face.face1.mix / 100) + 0.0,
					(ped.customization.face.face2.mix / 100) + 0.0,
					(ped.customization.face.face3.mix / 100) + 0.0,
					false
				)
			end

			-- for index, value in pairs(ped.customization.face.features) do
			-- 	SetPedFaceFeature(playerPed, tonumber(index), (value / 100) + 0.0)
			-- end

			for i = 0, 20 do
				local val = 0.0
				if ped.customization.face.features[i] then
					val = (ped.customization.face.features[i] / 100) + 0.0
				elseif ped.customization.face.features[tostring(i)] then
					val = (ped.customization.face.features[tostring(i)] / 100) + 0.0
				end

				SetPedFaceFeature(playerPed, i, val)
			end

			for k, value in pairs(ped.customization.overlay) do
				if value.disabled then
					SetPedHeadOverlay(playerPed, value.id, 255, (value.opacity / 100) + 0.0)
				else
					SetPedHeadOverlay(playerPed, value.id, value.index, (value.opacity / 100) + 0.0)

					if value.color1 and value.color1 > 0 then
						if type(value.color2) == "number" then
							SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, 0)
						else
							SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, value.color2)
						end
					else
						SetPedHeadOverlayColor(playerPed, value.id, 0, 0, 0)
					end
				end
			end
			for k, component in pairs(ped.customization.components) do
				if gangChain ~= nil and gangChain ~= "NONE" and gangChainData ~= nil and gangChainData.type == "component" and gangChainData.componentId == component.componentId then
					SetPedComponentVariation(
						playerPed,
						gangChainData.componentId,
						gangChainData.data[gender].drawableId,
						gangChainData.data[gender].textureId,
						gangChainData.data[gender].paletteId
					)
				else
					SetPedComponentVariation(
						playerPed,
						component.componentId,
						component.drawableId,
						component.textureId,
						component.paletteId
					)
				end
			end
			SetPedHairColor(
				playerPed,
				ped.customization.colors.hair.color1.index,
				ped.customization.colors.hair.color2.index
			)
			SetPedHeadOverlayColor(
				playerPed,
				1,
				1,
				ped.customization.colors.facialhair.color1.index,
				ped.customization.colors.facialhair.color2.index
			)
			SetPedHeadOverlayColor(
				playerPed,
				2,
				1,
				ped.customization.colors.eyebrows.color1.index,
				ped.customization.colors.eyebrows.color2.index
			)
			for k, prop in pairs(ped.customization.props) do
				if prop.disabled or (not FROZEN and k == "glass" and _glassesOff) then
					ClearPedProp(playerPed, prop.componentId)
				else
					SetPedPropIndex(playerPed, prop.componentId, prop.drawableId, prop.textureId)
				end
			end
		end

		ClearPedDecorations(playerPed)
		if LocalPlayer.state.Character ~= nil then
			if ped.customization.tattoos ~= nil then
				local isMale = LocalPlayer.state.Character:GetData("Gender") == 0
				for i, tattoo in ipairs(ped.customization.tattoos) do
					if tattoo.Name ~= "" then
						if isMale then
							AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameMale)
						else
							AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameFemale)
						end
					end
				end
			end
		end

		if ped.customization.hairOverlay and ped.customization.hairOverlay > -1 then
			if ped.customization.hairOverlay > 0 and Config.CustomHairOverlays[ped.customization.hairOverlay] then
				local overlay = Config.CustomHairOverlays[ped.customization.hairOverlay]
				if overlay and overlay.collection and overlay.overlay then
					AddPedDecorationFromHashes(
						playerPed,
						GetHashKey(overlay.collection),
						GetHashKey(overlay.overlay)
					)
				end
			end
		else
			local modelHairOverlays = Config.HairOverlays[GetEntityModel(playerPed)]
			if modelHairOverlays and ped.customization.components?.hair?.drawableId then
				local hairHasOverlays = modelHairOverlays[ped.customization.components.hair.drawableId]
				if hairHasOverlays and hairHasOverlays.collection then
					AddPedDecorationFromHashes(
						playerPed,
						GetHashKey(hairHasOverlays.collection),
						GetHashKey(hairHasOverlays.overlay)
					)
				end
			end
		end
	end,
	Preview = function(self, entity, gender, ped, skip, gangChain)
		local playerPed = entity

		if not skip then
			local gangChainData = gangChain ~= nil and GlobalState["GangChains"][gangChain] or nil

			SetPedEyeColor(playerPed, ped.customization.eyeColor)
			local playerModel = GetEntityModel(playerPed)
			if playerModel == GetHashKey("mp_f_freemode_01") or playerModel == GetHashKey("mp_m_freemode_01") then
				SetPedHeadBlendData(
					playerPed,
					ped.customization.face.face1.index,
					ped.customization.face.face2.index,
					ped.customization.face.face3.index,
					ped.customization.face.face1.texture,
					ped.customization.face.face2.texture,
					ped.customization.face.face3.index,
					(ped.customization.face.face1.mix / 100) + 0.0,
					(ped.customization.face.face2.mix / 100) + 0.0,
					(ped.customization.face.face3.mix / 100) + 0.0,
					false
				)
			end

			-- for index, value in pairs(ped.customization.face.features) do
			-- 	SetPedFaceFeature(playerPed, tonumber(index), (value / 100) + 0.0)
			-- end

			for i = 0, 20 do
				local val = 0.0
				if ped.customization.face.features[i] then
					val = (ped.customization.face.features[i] / 100) + 0.0
				elseif ped.customization.face.features[tostring(i)] then
					val = (ped.customization.face.features[tostring(i)] / 100) + 0.0
				end

				SetPedFaceFeature(playerPed, i, val)
			end

			for k, value in pairs(ped.customization.overlay) do
				if value.disabled then
					SetPedHeadOverlay(playerPed, value.id, 255, (value.opacity / 100) + 0.0)
				else
					SetPedHeadOverlay(playerPed, value.id, value.index, (value.opacity / 100) + 0.0)

					if value.color1 and value.color1 > 0 then
						if type(value.color2) == "number" then
							SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, 0)
						else
							SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, value.color2)
						end
					else
						SetPedHeadOverlayColor(playerPed, value.id, 0, 0, 0)
					end
				end
			end
			for k, component in pairs(ped.customization.components) do
				if gangChain ~= nil and gangChain ~= "NONE" and gangChainData ~= nil and gangChainData.type == "component" and gangChainData.componentId == component.componentId then
					SetPedComponentVariation(
						playerPed,
						gangChainData.componentId,
						gangChainData.data[gender].drawableId,
						gangChainData.data[gender].textureId,
						gangChainData.data[gender].paletteId
					)
				else
					SetPedComponentVariation(
						playerPed,
						component.componentId,
						component.drawableId,
						component.textureId,
						component.paletteId
					)
				end
			end
			SetPedHairColor(
				playerPed,
				ped.customization.colors.hair.color1.index,
				ped.customization.colors.hair.color2.index
			)
			SetPedHeadOverlayColor(
				playerPed,
				1,
				1,
				ped.customization.colors.facialhair.color1.index,
				ped.customization.colors.facialhair.color2.index
			)
			SetPedHeadOverlayColor(
				playerPed,
				2,
				1,
				ped.customization.colors.eyebrows.color1.index,
				ped.customization.colors.eyebrows.color2.index
			)
			for k, prop in pairs(ped.customization.props) do
				if prop.disabled or (not FROZEN and k == "glass" and _glassesOff) then
					ClearPedProp(playerPed, prop.componentId)
				else
					SetPedPropIndex(playerPed, prop.componentId, prop.drawableId, prop.textureId)
				end
			end
		end

		ClearPedDecorations(playerPed)
		if LocalPlayer.state.Character ~= nil then
			if ped.customization.tattoos ~= nil then
				local isMale = LocalPlayer.state.Character:GetData("Gender") == 0
				for i, tattoo in ipairs(ped.customization.tattoos) do
					if tattoo.Name ~= "" then
						if isMale then
							AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameMale)
						else
							AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameFemale)
						end
					end
				end
			end
		end

		if ped.customization.hairOverlay and ped.customization.hairOverlay > -1 then
			if ped.customization.hairOverlay > 0 and Config.CustomHairOverlays[ped.customization.hairOverlay] then
				local overlay = Config.CustomHairOverlays[ped.customization.hairOverlay]
				if overlay and overlay.collection and overlay.overlay then
					AddPedDecorationFromHashes(
						playerPed,
						GetHashKey(overlay.collection),
						GetHashKey(overlay.overlay)
					)
				end
			end
		else
			local modelHairOverlays = Config.HairOverlays[GetEntityModel(playerPed)]
			if modelHairOverlays and ped.customization.components?.hair?.drawableId then
				local hairHasOverlays = modelHairOverlays[ped.customization.components.hair.drawableId]
				if hairHasOverlays and hairHasOverlays.collection then
					AddPedDecorationFromHashes(
						playerPed,
						GetHashKey(hairHasOverlays.collection),
						GetHashKey(hairHasOverlays.overlay)
					)
				end
			end
		end
	end,
	-- ApplyToPed = function(self, ped, skip)
	-- 	local playerPed = PlayerPedId()

	-- 	if not skip then
	-- 		SetPedEyeColor(playerPed, ped.customization.eyeColor)
	-- 		local playerModel = GetEntityModel(playerPed)
	-- 		if playerModel == GetHashKey("mp_f_freemode_01") or playerModel == GetHashKey("mp_m_freemode_01") then
	-- 			SetPedHeadBlendData(
	-- 				playerPed,
	-- 				ped.customization.face.face1.index,
	-- 				ped.customization.face.face2.index,
	-- 				ped.customization.face.face3.index,
	-- 				ped.customization.face.face1.texture,
	-- 				ped.customization.face.face2.texture,
	-- 				ped.customization.face.face3.index,
	-- 				(ped.customization.face.face1.mix / 100) + 0.0,
	-- 				(ped.customization.face.face2.mix / 100) + 0.0,
	-- 				(ped.customization.face.face3.mix / 100) + 0.0,
	-- 				false
	-- 			)
	-- 		end
	-- 		for index, value in pairs(ped.customization.face.features) do
	-- 			SetPedFaceFeature(playerPed, tonumber(index), (value / 100) + 0.0)
	-- 		end
	-- 		for k, value in pairs(ped.customization.overlay) do
	-- 			if value.disabled then
	-- 				SetPedHeadOverlay(playerPed, value.id, 255, (value.opacity / 100) + 0.0)
	-- 			else
	-- 				SetPedHeadOverlay(playerPed, value.id, value.index, (value.opacity / 100) + 0.0)

	-- 				if value.color1 and value.color1 > 0 then
	-- 					if type(value.color2) == "number" then
	-- 						SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, 0)
	-- 					else
	-- 						SetPedHeadOverlayColor(playerPed, value.id, 2, value.color1, value.color2)
	-- 					end
	-- 				else
	-- 					SetPedHeadOverlayColor(playerPed, value.id, 0, 0, 0)
	-- 				end
	-- 			end
	-- 		end
	-- 		for k, component in pairs(ped.customization.components) do
	-- 			SetPedComponentVariation(
	-- 				playerPed,
	-- 				component.componentId,
	-- 				component.drawableId,
	-- 				component.textureId,
	-- 				component.paletteId
	-- 			)
	-- 		end
	-- 		SetPedHairColor(
	-- 			playerPed,
	-- 			ped.customization.colors.hair.color1.index,
	-- 			ped.customization.colors.hair.color2.index
	-- 		)
	-- 		SetPedHeadOverlayColor(
	-- 			playerPed,
	-- 			1,
	-- 			1,
	-- 			ped.customization.colors.facialhair.color1.index,
	-- 			ped.customization.colors.facialhair.color2.index
	-- 		)
	-- 		SetPedHeadOverlayColor(
	-- 			playerPed,
	-- 			2,
	-- 			1,
	-- 			ped.customization.colors.eyebrows.color1.index,
	-- 			ped.customization.colors.eyebrows.color2.index
	-- 		)
	-- 		for k, prop in pairs(ped.customization.props) do
	-- 			if prop.disabled or (not FROZEN and k == "glass" and _glassesOff) then
	-- 				ClearPedProp(playerPed, prop.componentId)
	-- 			else
	-- 				SetPedPropIndex(playerPed, prop.componentId, prop.drawableId, prop.textureId)
	-- 			end
	-- 		end
	-- 	end

	-- 	ClearPedDecorations(playerPed)
	-- 	if LocalPlayer.state.Character ~= nil then
	-- 		if ped.customization.tattoos ~= nil then
	-- 			local isMale = LocalPlayer.state.Character:GetData("Gender") == 0
	-- 			for i, tattoo in ipairs(ped.customization.tattoos) do
	-- 				if tattoo.Name ~= "" then
	-- 					if isMale then
	-- 						AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameMale)
	-- 					else
	-- 						AddPedDecorationFromHashes(playerPed, tattoo.Collection, tattoo.HashNameFemale)
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- 	local modelHairOverlays = Config.HairOverlays[GetEntityModel(playerPed)]
	-- 	if modelHairOverlays and ped.customization.components?.hair?.drawableId then
	-- 		local hairHasOverlays = modelHairOverlays[ped.customization.components.hair.drawableId]
	-- 		if hairHasOverlays and hairHasOverlays.collection then
	-- 			AddPedDecorationFromHashes(
	-- 				playerPed,
	-- 				GetHashKey(hairHasOverlays.collection),
	-- 				GetHashKey(hairHasOverlays.overlay)
	-- 			)
	-- 		end
	-- 	end
	-- end,
	Creator = {
		Start = function(self, data)
			_data = data

			LocalPlayer.state.inCreator = true
			_currentState = "CREATOR"

			Sync:Start()
			Citizen.Wait(300)
			Sync:Stop(true)

			FROZEN = true
			local player = PlayerPedId()

			SetTimecycleModifier("default")

			local model = GetHashKey("mp_f_freemode_01")
			if tonumber(data.Gender) == 0 then
				model = GetHashKey("mp_m_freemode_01")
			end
			if data.Ped.model ~= "" then
				model = GetHashKey(data.Ped.model)
			end

			RequestModel(model)

			while not HasModelLoaded(model) do
				Citizen.Wait(500)
			end
			SetPlayerModel(PlayerId(), model)
			player = PlayerPedId()
			SetEntityMaxHealth(player, 200)
			SetEntityHealth(player, GetEntityMaxHealth(player))
			FreezePedCameraRotation(player, true)
			SetPedDefaultComponentVariation(player)
			SetEntityAsMissionEntity(player, true, true)
			SetModelAsNoLongerNeeded(model)
			Ped:ApplyToPed(LocalPed)
			SetEntityCoords(player, _creatorLocation.x, _creatorLocation.y, _creatorLocation.z)
			Citizen.Wait(200)
			SetEntityHeading(player, _creatorLocation.h)

			PlayIdleAnimation()

			TriggerServerEvent("Ped:EnterCreator")

			DoScreenFadeIn(500)
			while not IsScreenFadedIn() do
				Citizen.Wait(10)
			end

			TransitionFromBlurred(500)

			Camera.Activate(500)

			NetworkSetEntityInvisibleToNetwork(player, false)
			SetEntityVisible(player, true)
			SetNuiFocus(true, true)
			Citizen.Wait(100)
			SendNUIMessage({
				type = "SET_STATE",
				data = {
					state = "CREATOR",
				},
			})
			SendNUIMessage({
				type = "APP_SHOW",
			})
		end,
		End = function(self)
			Sync:Start()
			TriggerServerEvent("Ped:LeaveCreator")
			Spawn:PlacePedIntoWorld(_data)
			Ped.Customization:Hide()
			LocalPlayer.state.inCreator = false
			FROZEN = false
			_data = nil

			Callbacks:ServerCallback("Apartment:SpawnInside", {})
		end,
	},
	Customization = {
		Show = function(self, type, data)
			FROZEN = true
			local player = PlayerPedId()

			LocalPed = LocalPlayer.state.Character:GetData("Ped")
			Ped:ApplyToPed(LocalPed)
			_currentState = type

			Camera.Activate()

			NetworkSetEntityInvisibleToNetwork(player, false)
			SetEntityVisible(player, true)
			SetNuiFocus(true, true)
			Citizen.Wait(100)
			SendNUIMessage({
				type = "SET_STATE",
				data = {
					state = type,
				},
			})
			SendNUIMessage({
				type = "APP_SHOW",
			})
		end,
		Hide = function(self)
			local player = PlayerPedId()
			Camera.Deactivate()
			SetNuiFocus(false, false)
			_currentState = nil
			FROZEN = false
		end,
		Save = function(self, cb)
			FROZEN = false
			Callbacks:ServerCallback("Ped:MakePayment", {
				type = _currentState,
			}, function(status, paid)
				if status then
					if LocalPlayer.state.isNaked then
						ToggleNekked(false)
					end

					Ped:ApplyToPed(LocalPed)
					Callbacks:ServerCallback("Ped:SavePed", {
						ped = LocalPed,
					}, function(saved)
						if _currentState == "CREATOR" then
							Ped.Creator:End()
						else
							Ped.Customization:Hide()
							Notification:Success(string.format("You Paid $%s", paid))
						end
					end)
				else
					Notification:Error("You Don't Have Enough Cash")
				end
				cb(status)
			end)
		end,
		Cancel = function(self)
			if LocalPlayer.state.isNaked then
				ToggleNekked(false)
			end

			Ped:ApplyToPed(LocalPlayer.state.Character:GetData("Ped"))

			SendNUIMessage({
				type = "SET_PED_DATA",
				data = {
					ped = LocalPlayer.state.Character:GetData("Ped"),
					gender = LocalPlayer.state.Character:GetData("Gender"),
				},
			})
			Ped.Customization:Hide()

			Citizen.Wait(1000) -- When naked it overrides the cancel so just do this again after a second for a lazy fix idk

			Ped:ApplyToPed(LocalPlayer.state.Character:GetData("Ped"))
			return true
		end,
	},
}
LocalPed = {}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Ped", PED)
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "Ped" or key == "GangChain" then
		LocalPed = LocalPlayer.state.Character:GetData("Ped")
		Ped:ApplyToPed(LocalPed)
		SendNUIMessage({
			type = "SET_PED_DATA",
			data = {
				ped = LocalPed,
				gender = LocalPlayer.state.Character:GetData("Gender"),
			},
		})
	end
end)

-- AddEventHandler("Characters:Client:Updated", function(key)
-- 	print(key)
-- 	if key == "Ped" then
-- 		LocalPed = LocalPlayer.state.Character:GetData("Ped")
-- 		Ped:ApplyToPed(LocalPed)
-- 		SendNUIMessage({
-- 			type = "SET_PED_DATA",
-- 			data = {
-- 				ped = LocalPed,
-- 				gender = LocalPlayer.state.Character:GetData("Gender"),
-- 			},
-- 		})
-- 	elseif key == "GangChain" then
-- 		local gang = LocalPlayer.state.Character:GetData("GangChain")
-- 		if gang == nil then
-- 			RemoveAttached('GangChain')
-- 		else
-- 			AttachProp('GangChain', GlobalState["GangChains"][gang].prop, 10706, 0.111, 0.044, -0.481997, -1.75, 17.75, -163.75, true, true)
-- 		end
-- 	end
-- end)

-- RegisterNetEvent("Characters:Client:Spawn", function()
-- 	local gang = LocalPlayer.state.Character:GetData("GangChain")
-- 	if gang ~= nil and gang ~= "NONE" then
-- 		AttachProp('GangChain', GlobalState["GangChains"][gang].prop, 10706, 0.111, 0.044, -0.481997, -1.75, 17.75, -163.750, true, true)
-- 	end
-- end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent("Ped:Client:Hat", function()
	SetPedPropIndex(
		LocalPlayer.state.ped,
		LocalPed.customization.props.hat.componentId,
		LocalPed.customization.props.hat.drawableId,
		LocalPed.customization.props.hat.textureId
	)
end)

RegisterNetEvent("Ped:Client:Glasses", function()
	SetPedPropIndex(
		LocalPlayer.state.ped,
		LocalPed.customization.props.glass.componentId,
		LocalPed.customization.props.glass.drawableId,
		LocalPed.customization.props.glass.textureId
	)
end)

RegisterNetEvent("Ped:Client:MaskAnim", function()
	loadAnimDict("missfbi4")
	TaskPlayAnim(LocalPlayer.state.ped, "missfbi4", "takeoff_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
	Citizen.Wait(1000)
	ClearPedTasks(LocalPlayer.state.ped)
end)

RegisterNetEvent("Ped:Client:HatGlassAnim", function()
	loadAnimDict("mp_masks@on_foot")
	TaskPlayAnim(LocalPlayer.state.ped, "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
	Citizen.Wait(500)
	ClearPedTasks(LocalPlayer.state.ped)
end)

RegisterNetEvent("Ped:Client:ChainAnim", function()
	loadAnimDict("clothingtie")
	TaskPlayAnim(LocalPlayer.state.ped, "clothingtie", "try_tie_positive_a", 1.0, 1.0, -1, 48, -1, 0, 0, 0)
	Citizen.Wait(4000)
	ClearPedTasks(LocalPlayer.state.ped)
end)
