_weapons = {}
local disabled = false
local weaponLimit = 4
local attachedObjects = {}

function LoadModel(model)
	RequestModel(model)
	local attempts = 0
	while not HasModelLoaded(model) and attempts < 10 do
		Citizen.Wait(100)
		attempts += 1
	end
end

function CountType(type)
	local count = 0
	for k, v in ipairs(attachedObjects) do
		if v.type == type then
			count += 1
		end
	end
	return count
end

function HasAttachedItem(item)
	for k, v in ipairs(attachedObjects) do
		if v.item == item then
			return k
		end
	end

	return false
end

function GetNextSlot(type) end

function DeleteAttached()
	for k, v in ipairs(attachedObjects) do
		DeleteEntity(v.object)
	end
	attachedObjects = {}
end

RegisterNetEvent("Weapons:Client:AttachToggle", function(state)
	disabled = state
	if disabled then
		DeleteAttached()
	else
		TriggerEvent("Weapons:Client:Attach")
	end
end)

RegisterNetEvent("Weapons:Client:Attach", function(force)
	if disabled then
		return
	end

	local curw = Weapons:GetEquippedHash()
	DeleteAttached()
	for k, v in ipairs(WEAPON_PROPS) do
		local itemData = Inventory.Items:GetData(v.item)
		local hasItem = Inventory.Items:Has(itemData?.weapon or v.item, 1, true)
		local hasAttchItem = HasAttachedItem(v.item)
		if hasItem and not hasAttchItem then
			LoadModel(v.model)
			if v.type == "weapon" then
				local isEquipped = curw == GetHashKey(itemData.weapon or itemData.name)
				local count = CountType(v.type)
				if count < weaponLimit and not isEquipped then
					local bone = GetPedBoneIndex(PlayerPedId(), 24818)
					local obj = CreateObject(v.model, 1.0, 1.0, 1.0, 1, 1, 0)
					Entity(obj).state:set("WeaponOwner", GetPlayerServerId(LocalPlayer.state.PlayerID), true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})
					AttachEntityToEntity(
						obj,
						PlayerPedId(),
						bone,
						v.x,
						v.y,
						v.z - ((count + 1) / 10),
						v.rx,
						v.ry,
						v.rz,
						0,
						1,
						0,
						1,
						0,
						1
					)
				elseif isEquipped and attachedObjects[hasAttchItem] ~= nil then
					DeleteEntity(attachedObjects[hasAttchItem].object)
					table.remove(attachedObjects, hasAttchItem)
				end
			elseif v.type == "melee" then
				local isEquipped = curw == GetHashKey(itemData.weapon or itemData.name)
				local count = CountType(v.type)
				if isEquipped and attachedObjects[hasAttchItem] ~= nil then
					DeleteEntity(attachedObjects[hasAttchItem].object)
					table.remove(attachedObjects, hasAttchItem)
				elseif count < weaponLimit and not isEquipped then
					local bone = GetPedBoneIndex(PlayerPedId(), v.bone or 24818)
					local obj = CreateObject(v.model, 1.0, 1.0, 1.0, 1, 1, 0)
					Entity(obj).state:set("WeaponOwner", GetPlayerServerId(LocalPlayer.state.PlayerID), true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})
					AttachEntityToEntity(obj, PlayerPedId(), bone, v.x, v.y, v.z, v.rx, v.ry, v.rz, 0, 1, 0, 1, 0, 1)
				end
			elseif v.type == "object" then
				local count = CountType(v.type)
				if count < weaponLimit then
					local bone = GetPedBoneIndex(PlayerPedId(), 24818)
					local obj = CreateObject(v.model, 1.0, 1.0, 1.0, 1, 1, 0)
					Entity(obj).state:set("WeaponOwner", GetPlayerServerId(LocalPlayer.state.PlayerID), true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})
					AttachEntityToEntity(obj, PlayerPedId(), bone, v.x, v.y, v.z, v.rx, v.ry, v.rz, 0, 1, 0, 1, 0, 1)
				end
			end
		elseif not hasItem and hasAttchItem then
			DeleteEntity(attachedObjects[hasAttchItem].object)
			table.remove(attachedObjects, hasAttchItem)
		elseif hasItem and hasAttchItem then
			if v.type == "weapon" or v.type == "melee" then
				local isEquipped = curw == GetHashKey(itemData.weapon or itemData.name)
				if isEquipped and attachedObjects[hasAttchItem] ~= nil then
					DeleteEntity(attachedObjects[hasAttchItem].object)
					table.remove(attachedObjects, hasAttchItem)
				end
			end
		end
		Citizen.Wait(1)
	end
end)

AddEventHandler("Characters:Client:Spawn", function()
	Citizen.Wait(1500)
	TriggerEvent("Weapons:Client:Attach")
end)

RegisterNetEvent("Characters:Client:Logout", function()
	DeleteAttached()
end)
