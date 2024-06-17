local _equipped = nil
local _equippedData = nil
local _ammo = nil

local _interacting = false

AddEventHandler("Weapons:Shared:DependencyUpdate", WeaponsComponents)
function WeaponsComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Weapons", {
		"Callbacks",
		"Notification",
		"Weapons",
		"Progress",
		"Hud",
		"Interaction",
		"Inventory",
		"Sounds",
	}, function(error)
		if #error > 0 then
			return
		end
		WeaponsComponents()

		Interaction:RegisterMenu("weapon-attachments", false, "gun", function(data)
			local menu = {}

			if _equipped ~= nil and _equipped.MetaData?.WeaponComponents ~= nil then
				for k, v in pairs(_equipped.MetaData.WeaponComponents) do
					local itemData = Inventory.Items:GetData(v.item)
					table.insert(menu, {
						icon = "xmark",
						label = string.format("Remove %s", itemData.label),
						action = function()
							Interaction:Hide()
							TriggerEvent("Weapons:Client:RemoveAttachment", k)
						end,
					})
				end
			end

			Interaction:ShowMenu(menu)
		end, function()
			return _equipped ~= nil and _equipped.MetaData?.WeaponComponents ~= nil
		end)

		Callbacks:RegisterClientCallback("Weapons:Check", function(data, cb)
			if _equipped ~= nil then
				cb({
					id = _equipped.id,
					item = _equipped.Name,
				})
			else
				cb(false)
			end
		end)

		Callbacks:RegisterClientCallback("Weapons:EquipAttachment", function(data, cb)
			if _equipped ~= nil then
				Progress:Progress({
					name = "attch_action",
					duration = 5000,
					label = "Equipping " .. data,
					useWhileDead = false,
					canCancel = true,
					ignoreModifier = true,
					disarm = false,
					controlDisables = {
						disableMovement = false,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
					-- animation = {
					-- 	animDict = "weapons@rifle@lo@carbine_str",
					-- 	anim = "reload_aim",
					-- 	flags = 48,
					-- },
				}, function(status)
					cb(not status)
				end)
			else
				cb(false)
			end
		end)

		Callbacks:RegisterClientCallback("Weapons:Logout", function(data, cb)
			if _equipped ~= nil then
				_interacting = true
				local ped = PlayerPedId()
				local hash = GetHashKey(_items[_equipped.Name].weapon or _equipped.Name)
				local itemData = _items[_equipped.Name]
				local f, clip = GetAmmoInClip(ped, hash)

				local data = {
					ammo = GetAmmoInPedWeapon(ped, hash),
					clip = clip,
					slot = _equipped.Slot,
				}

				RemoveWeaponFromPed(ped, hash)
				SetPedAmmoByType(ped, GetHashKey(itemData.ammoType), 0)
				_equipped = nil
				_equippedData = nil
				TriggerEvent("Weapons:Client:SwitchedWeapon", false)
				SendNUIMessage({
					type = "SET_EQUIPPED",
					data = {
						item = _equipped,
					}
				})
				cb(data)
				_interacting = true
			else
				cb(nil)
			end
		end)

		Callbacks:RegisterClientCallback("Weapons:AddAmmo", function(data, cb)
			if _equipped ~= nil and _items[_equipped.Name].ammoType == data.ammoType then
				Progress:Progress({
					name = "ammo_action",
					duration = 2500,
					label = "Loading Ammunition",
					useWhileDead = false,
					canCancel = true,
					ignoreModifier = true,
					disarm = false,
					controlDisables = {
						disableMovement = false,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "weapons@rifle@lo@carbine_str",
						anim = "reload_aim",
						flags = 48,
					},
					-- prop = {
					-- 	model = "prop_ld_ammo_pack_01",
					-- }
				}, function(status)
					if not status then
						Weapons.Ammo:Add(data)
						cb(true)
					end
				end)
			else
				if _equipped == nil then
					Notification:Error("No Weapon Equipped")
				else
					Notification:Error("Wrong Ammo Type")
				end

				cb(false)
			end
		end)

		Callbacks:RegisterClientCallback("Weapons:CanEquipParachute", function(data, cb)
			if not IsPedInParachuteFreeFall(LocalPlayer.state.ped) and not IsPedFalling(LocalPlayer.state.ped) and (GetPedParachuteState(LocalPlayer.state.ped) == -1 or GetPedParachuteState(LocalPlayer.state.ped) == 0) then
				Progress:ProgressWithTickEvent({
					name = 'equipping_parachute',
					duration = 3000,
					label = 'Equipping Parachute',
					useWhileDead = false,
					canCancel = true,
					ignoreModifier = true,
					controlDisables = {
						disableMovement = false,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						anim = 'adjusttie',
					},
				}, function()
					if not IsPedInParachuteFreeFall(LocalPlayer.state.ped) and not IsPedFalling(LocalPlayer.state.ped) and (GetPedParachuteState(LocalPlayer.state.ped) == -1 or GetPedParachuteState(LocalPlayer.state.ped) == 0) then
						return
					end

					Progress:Cancel()
				end, function(cancelled)
					cb(not cancelled)
				end)
			else
				cb(false)
			end
		end)
	end)
end)

RegisterNetEvent("Weapons:Client:Use", function(data)
	_interacting = true
	if _equipped ~= nil and _equipped.Slot == data.Slot then
		Weapons:Unequip(data)
	else
		Weapons:Equip(data)
		SetWeaponsNoAutoswap(true)
	end
	TriggerEvent("Weapons:Client:Attach")
	_interacting = false
end)

RegisterNetEvent("Weapons:Client:Move", function(from, to)
	if _equipped ~= nil and _equipped.Slot == from then
		_equipped.Slot = to
	end
end)

RegisterNetEvent("Weapons:Client:Remove", function(data, from, diff)
	_interacting = true
	if _equipped ~= nil and _equipped.Slot == from then
		Weapons:Unequip(data, diff)
	end
	_interacting = false
end)

RegisterNetEvent("Weapons:Client:ForceUnequip", function()
	_interacting = true
	if _equipped ~= nil then
		Weapons:UnequipIfEquippedNoAnim()
	end
	_interacting = false
end)

RegisterNetEvent("Weapons:Client:UpdateCount", function(slot, count)
	_interacting = true
	if _equipped ~= nil and _equipped.Slot == slot then
		SetPedAmmoByType(LocalPlayer.state.ped, GetHashKey(_equippedData.ammoType), count)
	end
	_interacting = false
end)

RegisterNetEvent("Weapons:Client:UpdateThrowable", function()
	_interacting = true
	if _equipped ~= nil and _equippedData.isThrowable then
		SetPedAmmoByType(LocalPlayer.state.ped, GetHashKey(_equippedData.ammoType), 1)
	end
	_interacting = false
end)

RegisterNetEvent("Weapons:Client:UpdateAttachments", function(components)
	_interacting = true
	if _equipped ~= nil then
		local hash = Weapons:GetEquippedHash()
		for k, v in pairs(_equipped.MetaData.WeaponComponents or {}) do
			if components[k] == nil then
				RemoveWeaponComponentFromPed(LocalPlayer.state.ped, hash, GetHashKey(v.attachment))
			end
		end

		for k, v in pairs(components) do
			GiveWeaponComponentToPed(LocalPlayer.state.ped, hash, GetHashKey(v.attachment))
		end

		_equipped.MetaData.WeaponComponents = components
	end
	_interacting = false
end)

-- AddEventHandler("Characters:Client:Spawn", function()
-- 	CreateThread(function()
-- 		while LocalPlayer.state.loggedIn do
-- 			local fa = IsPlayerFreeAiming(PlayerId())
-- 			local sh = IsPedShooting(LocalPlayer.state.ped)
-- 			if (fa or sh) and not xhair then
--                 local _, wep = GetCurrentPedWeapon(LocalPlayer.state.ped, true)
-- 				if wep ~= `WEAPON_UNARMED` then
-- 					xhair = true
-- 					Hud:XHair(true)
-- 				end
-- 			elseif not (fa or sh) and xhair then
-- 				xhair = false
-- 				Hud:XHair(false)
-- 			end
-- 			Wait(3)
-- 		end
-- 		Hud:XHair(false)
-- 	end)
-- end)

AddEventHandler("Weapons:Client:RemoveAttachment", function(attachment)
	if _equipped ~= nil then
		Progress:Progress({
			name = "attch_action",
			duration = 5000,
			label = "Removing Attachment",
			useWhileDead = false,
			canCancel = true,
			ignoreModifier = true,
			disarm = false,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			-- animation = {
			-- 	animDict = "weapons@rifle@lo@carbine_str",
			-- 	anim = "reload_aim",
			-- 	flags = 48,
			-- },
		}, function(status)
			if not status then
				TriggerServerEvent("Weapons:Server:RemoveAttachment", _equipped.Slot, attachment)
			end
		end)
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if _equipped ~= nil then
		_interacting = true
		local ped = PlayerPedId()
		local itemData = _items[_equipped.Name]
		UpdateAmmo(_equipped)
		SetPedAmmoByType(ped, GetHashKey(itemData.ammoType), 0)
		_equipped = nil
		_equippedData = nil
		TriggerEvent("Weapons:Client:SwitchedWeapon", false)
		SendNUIMessage({
			type = "SET_EQUIPPED",
			data = {
				item = _equipped,
			}
		})
		_interacting = false
		TriggerEvent("Weapons:Client:Attach")
	end
end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

local anims = {
	Cop = {
		Holster = function(self, ped)
			LocalPlayer.state.holstering = true
			DoHolsterBlockers()
			local dict = "reaction@intimidation@cop@unarmed"
			local anim = "intro"
			loadAnimDict(dict)
			TaskPlayAnim(ped, dict, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0)
			Wait(600)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			RemoveAllPedWeapons(ped)
			ClearPedTasks(ped)
			LocalPlayer.state.holstering = false
		end,
		Draw = function(self, ped, hash, ammoHash, ammo, clip, item, itemData)
			LocalPlayer.state.holstering = true
			DoHolsterBlockers()
			local dict = "reaction@intimidation@cop@unarmed"
			local anim = "intro"

			RemoveAllPedWeapons(ped)

			if hash ~= -538741184 then
				loadAnimDict(dict)
				TaskPlayAnim(ped, dict, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0)
				Wait(600)

				SetPedAmmoToDrop(ped, 0)
				GiveWeaponToPed(ped, hash, 0, true, true)
				SetAmmoInClip(ped, hash, clip or GetWeaponClipSize(hash))

				if itemData.isThrowable then
					SetPedAmmoByType(ped, ammoHash, item.Count)
				else
					SetPedAmmoByType(ped, ammoHash, ammo)
				end

				if item.MetaData.WeaponTint ~= nil then
					SetPedWeaponTintIndex(ped, hash, item.MetaData.WeaponTint)
				else
					SetPedWeaponTintIndex(ped, hash, 0)
				end
				if item.MetaData.WeaponComponents ~= nil then
					for k, v in pairs(item.MetaData.WeaponComponents) do
						GiveWeaponComponentToPed(ped, hash, v.attachment)
					end
				end

				SetCurrentPedWeapon(ped, hash, 1)
			else
				GiveWeaponToPed(ped, hash, 0, true, false)

				if item.MetaData.WeaponTint ~= nil then
					SetPedWeaponTintIndex(ped, hash, item.MetaData.WeaponTint)
				else
					SetPedWeaponTintIndex(ped, hash, 0)
				end
				if item.MetaData.WeaponComponents ~= nil then
					for k, v in pairs(item.MetaData.WeaponComponents) do
						GiveWeaponComponentToPed(ped, hash, v.attachment)
					end
				end

				SetCurrentPedWeapon(ped, hash, 0)
			end

			ClearPedTasks(ped)
			LocalPlayer.state.holstering = false
		end,
	},
	Holster = {
		OH = function(self, ped)
			LocalPlayer.state.holstering = true
			DoHolsterBlockers()
			local dict = "reaction@intimidation@1h"
			local anim = "outro"
			local animLength = GetAnimDuration(dict, anim) * 1000
			loadAnimDict(dict)
			TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
			Wait(animLength - 2200)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			Wait(300)
			RemoveAllPedWeapons(ped)
			ClearPedTasks(ped)
			Wait(800)
			LocalPlayer.state.holstering = false
		end,
		-- TH = function(self, ped)
		-- 	LocalPlayer.state.holstering = true
		-- 	DoHolsterBlockers()
		-- 	local dict = "amb@world_human_golf_player@male@idle_a"
		-- 	local anim = "idle_a"

		-- 	loadAnimDict(dict)
		-- 	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		-- 	TaskPlayAnim(ped, dict, anim, 1.5, 1.5, -1, 49, 10, 0, 0, 0)
		-- 	Wait(1200)
		-- 	RemoveAllPedWeapons(ped)
		-- 	ClearPedTasks(ped)
		-- 	Wait(500)

		-- 	LocalPlayer.state.holstering = false
		-- end,
	},
	Draw = {
		OH = function(self, ped, hash, ammoHash, ammo, clip, item, itemData)
			LocalPlayer.state.holstering = true
			DoHolsterBlockers()
			local dict = "reaction@intimidation@1h"
			local anim = "intro"
			RemoveAllPedWeapons(ped)
			if hash ~= -538741184 then
				local animLength = GetAnimDuration(dict, anim) * 1000
				loadAnimDict(dict)
				TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
				Wait(900)

				SetPedAmmoToDrop(ped, 0)
				GiveWeaponToPed(ped, hash, 0, true, true)
				SetAmmoInClip(ped, hash, clip or GetWeaponClipSize(hash))

				if itemData.isThrowable then
					SetPedAmmoByType(ped, ammoHash, item.Count)
				else
					SetPedAmmoByType(ped, ammoHash, ammo)
				end

				if item.MetaData.WeaponTint ~= nil then
					SetPedWeaponTintIndex(ped, hash, item.MetaData.WeaponTint)
				else
					SetPedWeaponTintIndex(ped, hash, 0)
				end
				if item.MetaData.WeaponComponents ~= nil then
					for k, v in pairs(item.MetaData.WeaponComponents) do
						GiveWeaponComponentToPed(ped, hash, v.attachment)
					end
				end

				SetCurrentPedWeapon(ped, hash, 1)
			else
				GiveWeaponToPed(ped, hash, 0, true, false)

				if item.MetaData.WeaponTint ~= nil then
					SetPedWeaponTintIndex(ped, hash, item.MetaData.WeaponTint)
				else
					SetPedWeaponTintIndex(ped, hash, 0)
				end
				if item.MetaData.WeaponComponents ~= nil then
					for k, v in pairs(item.MetaData.WeaponComponents) do
						GiveWeaponComponentToPed(ped, hash, v.attachment)
					end
				end

				SetCurrentPedWeapon(ped, hash, 0)
			end

			Wait(500)

			ClearPedTasks(ped)
			Wait(1200)
			LocalPlayer.state.holstering = false
		end,
		-- TH = function(self, ped, hash, ammo, clip)
		-- 	LocalPlayer.state.holstering = true
		-- 	local dict = "amb@world_human_golf_player@male@idle_a"
		-- 	local anim = "idle_a"

		-- 	RemoveAllPedWeapons(ped)
		-- 	loadAnimDict(dict)
		-- 	TaskPlayAnim(ped, dict, anim, 1.5, 1.5, -1, 49, 10, 0, 0, 0)
		-- 	Wait(1100)
		-- 	ClearPedTasks(ped)
		-- 	Wait(650)
		-- 	local givingAmmo = ammo
		-- 	if givingAmmo <= GetWeaponClipSize(hash) then
		-- 		givingAmmo = 0
		-- 	end
		-- 	GiveWeaponToPed(ped, hash, givingAmmo, true, true)
		-- 	SetAmmoInClip(ped, hash, clip or GetWeaponClipSize(hash))
		-- 	SetCurrentPedWeapon(ped, hash, 1)
		-- 	ClearPedTasks(ped)
		-- 	Wait(600)

		-- 	LocalPlayer.state.holstering = false
		-- end,
	},
}

WEAPONS = {
	GetEquippedHash = function(self)
		if _equipped ~= nil then
			return GetHashKey(_items[_equipped.Name].weapon or _equipped.Name)
		else
			return nil
		end
	end,
	GetEquippedItem = function(self)
		return _equipped
	end,
	IsEligible = function(self)
		local licenses = LocalPlayer.state.Character:GetData("Licenses")
		if licenses ~= nil and licenses.Weapons ~= nil then
			return licenses.Weapons.Active
		else
			return false
		end
	end,
	Equip = function(self, item)
		local ped = PlayerPedId()
		local hash = GetHashKey(_items[item.Name].weapon or item.Name)
		local itemData = _items[item.Name]

		-- print(string.format("Equipping Weapon, Total Ammo: %s, Clip: %s", item.MetaData.ammo or 0, item.MetaData.clip or 0))
		if LocalPlayer.state.onDuty == "police" then
			if _equipped ~= nil then
				Weapons:Unequip(_equipped)
			end
			anims.Cop:Draw(ped, hash, GetHashKey(itemData.ammoType), item.MetaData.ammo or 0, item.MetaData.clip or 0, item, itemData)
		else
			if _equipped ~= nil then
				Weapons:Unequip(_equipped)
			end
			anims.Draw:OH(ped, hash, GetHashKey(itemData.ammoType), item.MetaData.ammo or 0, item.MetaData.clip or 0, item, itemData)
		end

		_equipped = item
		_equippedData = itemData
		TriggerEvent("Weapons:Client:SwitchedWeapon", _equipped.Name, _equipped, _items[_equipped.Name])

		SendNUIMessage({
			type = "SET_EQUIPPED",
			data = {
				item = _equipped,
			}
		})

		RunDegenThread()
	end,
	UnequipIfEquipped = function(self)
		if _equipped ~= nil then
			Weapons:Unequip(_equipped)
			TriggerEvent('Weapons:Client:Attach')
		end
	end,
	UnequipIfEquippedNoAnim = function(self)
		if _equipped ~= nil then
			local ped = PlayerPedId()
			local itemData = _items[_equipped.Name]
			UpdateAmmo(_equipped, diff)
			SetPedAmmoByType(ped, GetHashKey(itemData.ammoType), 0)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			RemoveAllPedWeapons(ped)
			_equipped = nil
			_equippedData = nil
			TriggerEvent("Weapons:Client:SwitchedWeapon", false)
			SendNUIMessage({
				type = "SET_EQUIPPED",
				data = {
					item = _equipped,
				}
			})
			TriggerEvent('Weapons:Client:Attach')
		end
	end,
	Unequip = function(self, item, diff)
		if item == nil then
			return
		end
		local ped = PlayerPedId()
		local hash = GetHashKey(_items[item.Name].weapon or item.Name)
		local itemData = _items[item.Name]
		UpdateAmmo(item, diff)
		if LocalPlayer.state.onDuty == "police" then
			anims.Cop:Holster(ped)
		else
			anims.Holster:OH(ped)
		end

		SetPedAmmoByType(ped, GetHashKey(itemData.ammoType), 0)

		if item.MetaData.WeaponComponents ~= nil then
			for k, v in pairs(item.MetaData.WeaponComponents) do
				RemoveWeaponComponentFromPed(ped, hash, v.attachment)
			end
		end

		_equipped = nil
		_equippedData = nil
		TriggerEvent("Weapons:Client:SwitchedWeapon", false)
		SendNUIMessage({
			type = "SET_EQUIPPED",
			data = {
				item = _equipped,
			}
		})
	end,
	Ammo = {
		Add = function(self, item)
			if _equipped ~= nil then
				local ped = PlayerPedId()
				local hash = GetHashKey(_items[_equipped.Name].weapon or _equipped.Name)
				AddAmmoToPed(ped, hash, item.bulletCount or 10)
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Weapons", WEAPONS)
end)

function WeaponsThread()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if not _interacting then
				UpdateAmmo(_equipped)
			end
			Wait(20000)
		end
	end)
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if _equipped ~= nil then
				if IsPedShooting(LocalPlayer.state.ped) and _equippedData.isThrowable then
					local slot = _equipped.Slot

					_disabled = true
					SendNUIMessage({
						type = "USE_ITEM_PLAYER",
						data = {
							originSlot = slot,
						},
					})
					Inventory.Close:All()
					Callbacks:ServerCallback("Weapons:UseThrowable", _equipped, function()
						SendNUIMessage({
							type = "SLOT_NOT_USED",
							data = {
								originSlot = slot,
							},
						})
						_disabled = false
					end, GetGameTimer())

					if _equippedData.name == "WEAPON_SMOKEGRENADE" then
						TriggerEvent("Weapons:Client:SmokeGrenade")
					elseif _equippedData.name == "WEAPON_FLASHBANG" then
						TriggerEvent("Weapons:Client:Flashbang")
					end
				end
			end
			Wait(1)
		end
	end)
end

function UpdateAmmo(item, isDiff)
	if item == nil or _items[item.Name].isThrowable then
		return
	end

	local ped = PlayerPedId()
	local _, wep = GetCurrentPedWeapon(ped, true)
	local hash = GetHashKey(_items[item.Name].weapon or item.Name)

	if hash ~= wep or LocalPlayer.state.adjustingCam then
		return
	end

	local f, clip = GetAmmoInClip(ped, hash)
	local ammo = GetAmmoInPedWeapon(ped, hash)

	if ammo == item.MetaData.ammo and clip == item.MetaData.clip then
		return
	end

	if isDiff then
		-- print(string.format("Save Ammo (Diff) - Total: %s, Clip: %s (Before - Total: %s, Clip: %s)", ammo, clip, item.MetaData.ammo, item.MetaData.clip))
		TriggerServerEvent("Weapon:Server:UpdateAmmoDiff", isDiff, ammo, clip)
	else
		-- print(string.format("Save Ammo - Total: %s, Clip: %s (Before - Total: %s, Clip: %s)", ammo, clip, item.MetaData.ammo, item.MetaData.clip))
		TriggerServerEvent("Weapon:Server:UpdateAmmo", item.id, ammo, clip)
	end
end

function RunDegenThread()
	CreateThread(function()
		while _equipped ~= nil do
			local itemData = _items[_equipped.Name]
			if itemData.durability ~= nil and (GetCloudTimeAsInt() - (_equipped?.MetaData?.CreateDate or GetCloudTimeAsInt()) >= itemData.durability) then
				Weapons:UnequipIfEquippedNoAnim()
				TriggerEvent("Weapons:Client:Attach")
			end
			Wait(10000)
		end
	end)
end

function DoHolsterBlockers()
	CreateThread(function()
		while LocalPlayer.state.holstering do
			DisablePlayerFiring(PlayerPedId(), true)
			DisableControlAction(0, 14, true)
			DisableControlAction(0, 15, true)
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 50, true)
			DisableControlAction(0, 68, true)
			DisableControlAction(0, 91, true)
			DisableControlAction(0, 99, true)
			DisableControlAction(0, 115, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 261, true)
			DisableControlAction(0, 262, true)
			Wait(1)
		end
	end)
end

local _parachuteThread = false

function RunParachuteUpdate()
	if LocalPlayer.state.loggedIn then
		local hasChute = hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_PARACHUTE")
		if hasChute then
			if not HasPedGotWeapon(LocalPlayer.state.ped, -72657034) then
				GiveWeaponToPed(LocalPlayer.state.ped, -72657034, 1, 0, 1)
				SetPlayerHasReserveParachute(PlayerId())

				SetPedParachuteTintIndex(LocalPlayer.state.ped, 6)
        		SetPlayerReserveParachuteTintIndex(PlayerId(), 6)
			end

			StartParachuteThread()
		else
			_parachuteThread = false
			RemoveWeaponFromPed(LocalPlayer.state.ped, -72657034)
		end

		TriggerEvent("Status:Client:Update", "parachute", hasChute and 100 or 0)
	end
end

function StartParachuteThread()
	if not _parachuteThread then
		_parachuteThread = true
		CreateThread(function()
			while _parachuteThread and LocalPlayer.state.loggedIn do
				Wait(500)

				if GetPedParachuteState(LocalPlayer.state.ped) >= 2 then
					Wait(2500)
					Callbacks:ServerCallback("Inventory:UsedParachute", {})
					break
				end
			end
		end)
	end
end

RegisterNetEvent("Characters:Client:SetData", function()
	Wait(1000)
	RunParachuteUpdate()
end)

AddEventHandler("Weapons:Client:SwitchedWeapon", function()
	RunParachuteUpdate()
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	Wait(1000)
	Hud:RegisterStatus("parachute", 0, 100, "parachute-box", "#A72929", false, false, {
        hideZero = true,
    })
end)

local prevCoords = 0
AddEventHandler("Weapons:Client:SmokeGrenade", function()
	CreateThread(function()
		local finalizingPosition = true
		while finalizingPosition do
			local outCoords = vector3(0, 0, 0)
			local outProjectile = 0
			local _, coords = GetProjectileNearPed(PlayerPedId(), `WEAPON_SMOKEGRENADE`, 1000.0, outCoords, outProjectile, 1)
			if prevCoords ~= 0 and #(coords - prevCoords) < 0.5 then
				finalizingPosition = false
			end
			prevCoords = coords
			Wait(1000)
		end
		TriggerServerEvent("Particles:Server:DoFx", prevCoords, "smoke")
	end)
end)

AddEventHandler("Weapons:Client:Flashbang", function()
	SetTimeout(1500, function()
		local _, coords, prop = GetProjectileNearPed(PlayerPedId(), `WEAPON_FLASHBANG`, 1000.0, false)
		AddExplosion(coords.x, coords.y, coords.z, 25, 1.0, true, true, true)
		TriggerServerEvent("Weapons:Server:DoFlashFx", coords, NetworkGetNetworkIdFromEntity(prop) or prop)
		ClearAreaOfProjectiles(coords.x, coords.y, coords.z, 10.0)
	end)
end)

local maxShakeAmp = 25.0
local shakeCam = nil
local shakeCamActive = false
local totalFlashShakeAmp = 0.0
local flashTimersRunning = 0

local afterTimersRunning = 0.0
local totalAfterShakeAmp = 0

function DisableFiring(duration)
	local finished = GetGameTimer() + duration
	CreateThread(function()
		while GetGameTimer() < finished do
			DisablePlayerFiring(LocalPlayer.state.clientID, true)
			Wait(1)
		end
	end)
end

function DoFlashFx(shakeAmp, time)
	flashTimersRunning += 1
	totalFlashShakeAmp += shakeAmp


	AnimpostfxPlay("Dont_tazeme_bro", 0, true)
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, time, 50, 8.0)
	DisableFiring(time * 0.75)

	Hud.Flashbang:Do(time, totalFlashShakeAmp)
	Sounds.Loop:One("flashbang.ogg", 0.1 * totalFlashShakeAmp)

	Wait(time)

	flashTimersRunning -= 1
	totalFlashShakeAmp -= shakeAmp

	if flashTimersRunning == 0 then
		ClearPedTasks(PlayerPedId())
		AnimpostfxStop("Dont_tazeme_bro")
		Sounds.Fade:One("flashbang.ogg")
	else
		Sounds.Loop:One("flashbang.ogg", 0.1 * totalFlashShakeAmp)
	end
end

RegisterNetEvent("Weapons:Client:DoFlashFx", function(x, y, z, stunTime, afterTime, radius, netId, damage, lethalRange)
	if #(vector3(x, y, z) - GetEntityCoords(PlayerPedId())) < 100 then
		loadAnimDict("anim@heists@ornate_bank@thermal_charge")

		local prop = NetworkGetEntityFromNetworkId(netId)
		local ped = PlayerPedId()
	
		local headPos = GetPedBoneCoords(ped, `SKEL_Head`, 0, 0, 0)
		local pos = vector3(x, y, z)
		local hitreg = vector3(headPos.x - x, headPos.y - y, headPos.z - z)
	
		local dist = #(GetEntityCoords(ped) - pos)
		local fDist = #(headPos - pos)
		local dSq = dist * dist
	
		local falloutMulti = 0.02 / (radius / 8.0)
		local stunMulti = falloutMulti * dSq
		local shakeCamAmp = 15.0
	
		local effectFalloffStunTime = math.round(stunTime * stunMulti)
		local effectFalloffAfterTime = math.round(afterTime * stunMulti)
		local actualStunTime = (stunTime * effectFalloffStunTime) * 1000
		local actualAfterTime = (afterTime * effectFalloffAfterTime) * 1000
		local stunTimeFalloffMulti = actualStunTime / (stunTime * 1000)
	
		if actualStunTime <= 0 then
			actualStunTime = 1
		end
	
		if actualAfterTime <= 0 then
			actualAfterTime = 1
		end

		local handle = StartShapeTestLosProbe(x, y, z, headPos.x, headPos.y, headPos.z, 293, 0, 4)
		local result, hit, endCoords, surfNorm, entityHit = 1, nil, nil, nil, nil

		while result == 1 do
			result, hit, endCoords, surfNorm, entityHit = GetShapeTestResult(handle)
			Wait(1)
		end


		playerHit = (result == 2) and (entityHit == PlayerPedId())

		if fDist <= radius and playerHit then
			local pct = (radius - fDist) / radius
			DoFlashFx(pct, stunTime * pct)
		end
	end
end)