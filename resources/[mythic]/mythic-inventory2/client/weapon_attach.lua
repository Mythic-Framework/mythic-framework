_weapons = {}
local disabled = false
local weaponLimit = 4
local attachedObjects = {}

local weaponOffsets = {
	[1] = {
		x = 0.1, y = -0.155, z = 0.21, rx = 0.0, ry = 150.0, rz = 0.0, diff = 0.1
	},
	[2] = {
		x = 0.1, y = -0.155, z = 0.21, rx = 0.0, ry = 150.0, rz = 0.0, diff = 0.2
	},
	[3] = {
		x = 0.1, y = -0.155, z = 0.21, rx = 180.0, ry = -150.0, rz = 0.0, diff = 0.2
	},
	[4] = {
		x = 0.1, y = -0.155, z = 0.21, rx = 180.0, ry = 180.0, rz = 0.0, diff = 0.3
	},
}

function LoadModel(model)
	RequestModel(model)
	local attempts = 0
	while not HasModelLoaded(model) and attempts < 10 do
		Wait(100)
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

local attaching = false
RegisterNetEvent("Weapons:Client:Attach", function(force)
	if not LocalPlayer.state.loggedIn or disabled then
		return
	end

	while Weapons == nil do
		Wait(1)
	end

	if attaching then
		return
	end
	attaching = true

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

					while not DoesEntityExist(obj) do
						Wait(1)
					end

					Entity(obj).state:set("WeaponOwner", LocalPlayer.state.serverID, true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})

					local offset = weaponOffsets[count+1]

					if v.override then
						AttachEntityToEntity(
							obj,
							PlayerPedId(),
							bone,
							v.x,
							v.y,
							v.z,
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
					else
						AttachEntityToEntity(
							obj,
							PlayerPedId(),
							bone,
							(offset.x + v.x),
							(offset.y + v.y),
							(offset.z + v.z) - offset.diff,
							(offset.rx + v.rx),
							(offset.ry + v.ry),
							(offset.rz + v.rz),
							0,
							1,
							0,
							1,
							0,
							1
						)
					end
					SetEntityCollision(obj, false, true)
					SetEntityCompletelyDisableCollision(obj, false, true)
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
					Entity(obj).state:set("WeaponOwner", LocalPlayer.state.serverID, true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})
					AttachEntityToEntity(obj, PlayerPedId(), bone, v.x, v.y, v.z, v.rx, v.ry, v.rz, 0, 1, 0, 1, 0, 1)
					SetEntityCollision(obj, false, true)
					SetEntityCompletelyDisableCollision(obj, false, true)
				end
			elseif v.type == "object" then
				local count = CountType(v.type)
				if count < weaponLimit then
					local bone = GetPedBoneIndex(PlayerPedId(), 24818)
					local obj = CreateObject(v.model, 1.0, 1.0, 1.0, 1, 1, 0)
					Entity(obj).state:set("WeaponOwner", LocalPlayer.state.serverID, true)
					table.insert(attachedObjects, {
						object = obj,
						type = v.type,
						item = v.item,
					})
					AttachEntityToEntity(obj, PlayerPedId(), bone, v.x, v.y, v.z, v.rx, v.ry, v.rz, 0, 1, 0, 1, 0, 1)
					SetEntityCollision(obj, false, true)
					SetEntityCompletelyDisableCollision(obj, false, true)
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
	end

	attaching = false
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	CreateThread(function()
		while _cachedInventory == nil do
			Wait(100)
		end
	
		Wait(1000)
		
		TriggerEvent("Weapons:Client:Attach")
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	DeleteAttached()
end)
