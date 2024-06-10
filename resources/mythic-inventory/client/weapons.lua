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
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Weapons", {
		"Callbacks",
		"Notification",
		"Weapons",
		"Progress",
		"Hud",
	}, function(error)
		if #error > 0 then
			return
		end
		WeaponsComponents()

		Callbacks:RegisterClientCallback("Weapons:Check", function(data, cb)
			if _equipped ~= nil then
				cb({
					item = _equipped.Name,
					slot = _equipped.Slot,
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
-- 	Citizen.CreateThread(function()
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
-- 			Citizen.Wait(3)
-- 		end
-- 		Hud:XHair(false)
-- 	end)
-- end)

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
		_interacting = false
	end
end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
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
			Citizen.Wait(600)
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
				Citizen.Wait(600)

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
			Citizen.Wait(animLength - 2200)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			Citizen.Wait(300)
			RemoveAllPedWeapons(ped)
			ClearPedTasks(ped)
			Citizen.Wait(800)
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
		-- 	Citizen.Wait(1200)
		-- 	RemoveAllPedWeapons(ped)
		-- 	ClearPedTasks(ped)
		-- 	Citizen.Wait(500)

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
				Citizen.Wait(900)

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

			Citizen.Wait(500)

			ClearPedTasks(ped)
			Citizen.Wait(1200)
			LocalPlayer.state.holstering = false
		end,
		-- TH = function(self, ped, hash, ammo, clip)
		-- 	LocalPlayer.state.holstering = true
		-- 	local dict = "amb@world_human_golf_player@male@idle_a"
		-- 	local anim = "idle_a"

		-- 	RemoveAllPedWeapons(ped)
		-- 	loadAnimDict(dict)
		-- 	TaskPlayAnim(ped, dict, anim, 1.5, 1.5, -1, 49, 10, 0, 0, 0)
		-- 	Citizen.Wait(1100)
		-- 	ClearPedTasks(ped)
		-- 	Citizen.Wait(650)
		-- 	local givingAmmo = ammo
		-- 	if givingAmmo <= GetWeaponClipSize(hash) then
		-- 		givingAmmo = 0
		-- 	end
		-- 	GiveWeaponToPed(ped, hash, givingAmmo, true, true)
		-- 	SetAmmoInClip(ped, hash, clip or GetWeaponClipSize(hash))
		-- 	SetCurrentPedWeapon(ped, hash, 1)
		-- 	ClearPedTasks(ped)
		-- 	Citizen.Wait(600)

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
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if not _interacting then
				UpdateAmmo(_equipped)
			end
			Citizen.Wait(20000)
		end
	end)
	Citizen.CreateThread(function()
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
				end
			end
			Citizen.Wait(1)
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
		TriggerServerEvent("Weapon:Server:UpdateAmmo", item.Slot, ammo, clip)
	end
end

function RunDegenThread()
	Citizen.CreateThread(function()
		while _equipped ~= nil do
			local itemData = _items[_equipped.Name]
			if itemData.durability ~= nil and (GetCloudTimeAsInt() - (_equipped?.MetaData?.CreateDate or GetCloudTimeAsInt()) >= itemData.durability) then
				Weapons:UnequipIfEquippedNoAnim()
				TriggerEvent("Weapons:Client:Attach")
			end
			Citizen.Wait(10000)
		end
	end)
end

function DoHolsterBlockers()
	Citizen.CreateThread(function()
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
			Citizen.Wait(1)
		end
	end)
end
