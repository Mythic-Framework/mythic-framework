_moneyTruckPeds = {}
_moneyTrucks = {}
_truckSpawnEnabled = true

CreateThread(function()
	while true do
		for k, v in pairs(_moneyTruckPeds) do
			for i = #v, 1, -1 do
				if DoesEntityExist(v[i].entity) then
					if GetEntityHealth(v[i].entity) == 0 then
						if v[i].detectedDead then
							DeleteEntity(v[i].entity)
							table.remove(v, i)
						else
							v[i].detectedDead = true
						end
					end
				else
					table.remove(v, i)
				end
			end

			if #v == 0 then
				_moneyTruckPeds[k] = nil
			end
		end
		Wait(60000)
	end
end)

CreateThread(function()
	while true do
		for k, v in pairs(_moneyTrucks) do
			if os.time() > v.delete then
				DeleteEntity(v.entity)
			end
		end
		Wait(60000)
	end
end)

function IsTruckAtCoords(coords)
	for k, v in pairs(_moneyTrucks) do
		if #(vector3(coords[1], coords[2], coords[3]) - vector3(v.position[1], v.position[2], v.position[3])) <= 1.0 then
			return true
		end
	end
	return false
end

AddEventHandler('entityRemoved', function(entity)
	if _moneyTrucks[entity] ~= nil then
		_moneyTrucks[entity] = nil
	end
end)

AddEventHandler("Robbery:Server:Setup", function()
	GlobalState["Bobcat:LootLocations"] = _bobcatLootLocs

	_moneyTruckSpawns = table.copy(_spawnHoldingShit)

	Chat:RegisterAdminCommand("togglemoneytruck", function(source, args, rawCommand)
		_truckSpawnEnabled = not _truckSpawnEnabled
		if _truckSpawnEnabled then
			Chat.Send.System:Single(source, "Truck Spawns Enabled")
		else
			Chat.Send.System:Single(source, "Truck Spawns Disabled")
		end
	end, {
		help = "Toggle Bobcat Truck Spawning",
	}, 0)
end)

function SpawnBobcatTruck(truckModel, skipCooldown)
	if #_moneyTruckSpawns == 0 then
		_moneyTruckSpawns = table.copy(_spawnHoldingShit)
	end

	local p = promise.new()
	local sel = math.random(#_moneyTruckSpawns)
	local coords = table.copy(_moneyTruckSpawns[sel])

	local attmps = 0
	while IsTruckAtCoords(coords) and attmps < 100 do
		attmps += 1
		sel = math.random(#_moneyTruckSpawns)
		coords = table.copy(_moneyTruckSpawns[sel])
		Wait(1)
	end

	if not IsTruckAtCoords(coords) then
		table.remove(_moneyTruckSpawns, sel)
		Vehicles:SpawnTemp(-1, truckModel, vector3(coords[1], coords[2], coords[3]), coords[4], function(veh, VIN)
			_moneyTrucks[veh] = {
				position = coords,
				delete = os.time() + (60 * 30),
				entity = veh,
				looted = false
			}
	
			Entity(veh).state.moneyTruck = true
			SetEntityDistanceCullingRadius(veh, 20000.0)
			Wait(1000)
			p:resolve(NetworkGetNetworkIdFromEntity(veh))
		end)
		return Citizen.Await(p)
	else
		return false
	end
end

local _blueGiven = false
AddEventHandler("Robbery:Server:Setup", function()
	Callbacks:RegisterServerCallback("Robbery:MoneyTruck:EnteredTruck", function(source, data, cb)
		local ent = NetworkGetEntityFromNetworkId(data)
		if ent ~= 0 then
			local entState = Entity(ent).state
			if entState?.VIN ~= nil then
				if _moneyTruckPeds[entState.VIN] ~= nil then
					for k, v in ipairs(_moneyTruckPeds[entState.VIN]) do

					end
				end
			end
		end
	end)


	Callbacks:RegisterServerCallback("Robbery:MoneyTruck:CheckLoot", function(source, data, cb)
		local pState = Player(source).state
		local ent = NetworkGetEntityFromNetworkId(data)
		if ent ~= 0 then
			local entState = Entity(ent).state
			if entState.wasThermited and not entState.wasLooted then
				if not entState.beingLooted then
					GlobalState[string.format("MoneyTruck:Loot:%s", entState.VIN)] = true
					entState.beingLooted = source
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MoneyTruck:CancelLoot", function(source, data, cb)
		local pState = Player(source).state
		local ent = NetworkGetEntityFromNetworkId(data)
		if ent ~= 0 then
			local entState = Entity(ent).state
			if entState.wasThermited and not entState.wasLooted then
				if entState.beingLooted == source then
					GlobalState[string.format("MoneyTruck:Loot:%s", entState.VIN)] = false
					entState.beingLooted = false
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:MoneyTruck:Loot", function(source, data, cb)
		local pState = Player(source).state
		local ent = NetworkGetEntityFromNetworkId(data)
		if ent ~= 0 then
			local entState = Entity(ent).state
			if entState.wasThermited and not entState.wasLooted then
				if entState.beingLooted == source then
					local plyr = Fetch:Source(source)
					if plyr ~= nil then
						local char = plyr:GetData("Character")
						if char ~= nil then
							_moneyTrucks[ent] = {
								position = _moneyTrucks[ent].position,
								delete = os.time() + (60 * 10),
								entity = ent,
								looted = true,
							}
							Entity(ent).state.wasLooted = true

							Logger:Info("Robbery", string.format("%s %s (%s) Looted A Money Truck (VIN: %s)", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), Entity(ent).state.VIN))

							local model = GetEntityModel(ent)
							if model == `stockade` then
								Loot:CustomWeightedSetWithCount(_moneyTruckLoot.fleeca, char:GetData("SID"), 1)
								Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
									CryptoCoin = "HEIST",
									Quantity = 1,
								}, 1)
								-- if math.random(100) <= 10 and not _blueGiven then
								-- 	_blueGiven = true
								-- 	Inventory:AddItem(char:GetData("SID"), "blue_dongle", 1, {}, 1)
								-- else
								-- 	Inventory:AddItem(char:GetData("SID"), "green_dongle", 1, {}, 1)
								-- end
							elseif model == `stockade2` then
								Loot:CustomWeightedSetWithCount(_moneyTruckLoot.bobcat, char:GetData("SID"), 1)
								Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
									CryptoCoin = "HEIST",
									Quantity = 2,
								}, 1)
								--Inventory:AddItem(char:GetData("SID"), "blue_dongle", 1, {}, 1)
							end

							entState.beingLooted = false
						else
							GlobalState[string.format("MoneyTruck:Loot:%s", entState.VIN)] = true
							entState.beingLooted = false
							cb(false)
						end
					else
						GlobalState[string.format("MoneyTruck:Loot:%s", entState.VIN)] = true
						entState.beingLooted = false
						cb(false)
					end
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)