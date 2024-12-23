function RegisterBallisticsCallbacks()
    Callbacks:RegisterServerCallback('Evidence:Ballistics:FileGun', function(source, data, cb)
		local player = Fetch:Source(source)
		if player and data and data.slotNum and data.serial then
			local char = player:GetData('Character')
			if char then
				local charId = char:GetData('SID')
				-- Files a Gun So Evidence Can Be Found
		
				local item = Inventory:GetSlot(charId, data.slotNum, 1)
				if item and item.MetaData and (item.MetaData.ScratchedSerialNumber or item.MetaData.SerialNumber) then
					local firearmRecord, policeWeapId

					if item.MetaData.ScratchedSerialNumber and item.MetaData.ScratchedSerialNumber == data.serial then
						firearmRecord = GetFirearmsRecord(item.MetaData.ScratchedSerialNumber, true)
					elseif item.MetaData.SerialNumber and item.MetaData.SerialNumber == data.serial then
						firearmRecord = GetFirearmsRecord(item.MetaData.SerialNumber, false)
					end

					if firearmRecord then
						if not firearmRecord.FiledByPolice then
							local update
							if item.MetaData.ScratchedSerialNumber then
								policeWeapId = string.format('PWI-%s', Sequence:Get('PoliceWeaponId'))

								update = {
									['$set'] = {
										FiledByPolice = true,
										PoliceWeaponId = policeWeapId,
									}
								}

								Inventory:SetMetaDataKey(item.id, 'PoliceWeaponId', policeWeapId)
							elseif item.MetaData.SerialNumber then
								update = {
									['$set'] = {
										FiledByPolice = true,
									}
								}
							end

							if update then
								Database.Game:updateOne({
									collection = 'firearms',
									query = {
										Serial = firearmRecord.Serial
									},
									update = update,
								}, function(success, updated)
									if success and updated > 0 then
										cb(true, false, GetMatchingEvidenceProjectiles(firearmRecord.Serial), policeWeapId)
									else
										cb(false)
									end
								end)
							end
						else
							return cb(true, true, GetMatchingEvidenceProjectiles(firearmRecord.Serial), firearmRecord.PoliceWeaponId)
						end
					else
						cb(false)
					end
				else
					cb(false)
				end
				return
			end
		end
		cb(false)
    end)
end

function RegisterBallisticsItemUses()
	Inventory.Items:RegisterUse('evidence-projectile', 'Evidence', function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceWeapon then
			Callbacks:ClientCallback(source, 'Polyzone:IsCoordsInZone', {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = 'ballistics',
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local filedEvidence = GetEvidenceProjectileRecord(itemData.MetaData.EvidenceId)
						local matchingWeapon = GetFirearmsRecord(itemData.MetaData.EvidenceWeapon.serial, nil, true)
	
						if filedEvidence then -- Already Exists
							TriggerClientEvent('Evidence:Client:FiledProjectile', source, false, true, true, filedEvidence, matchingWeapon, itemData.MetaData.EvidenceId)
						else
							local newFiledEvidence = CreateEvidenceProjectileRecord({
								Id = itemData.MetaData.EvidenceId,
								Weapon = itemData.MetaData.EvidenceWeapon,
								Coords = itemData.MetaData.EvidenceCoords,
								AmmoType = itemData.MetaData.EvidenceAmmoType,
							})
	
							if newFiledEvidence then
								TriggerClientEvent('Evidence:Client:FiledProjectile', source, false, true, false, newFiledEvidence, matchingWeapon, itemData.MetaData.EvidenceId)
							else
								TriggerClientEvent('Evidence:Client:FiledProjectile', source, false, false)
							end
						end
					else
						TriggerClientEvent('Evidence:Client:FiledProjectile', source, true)
					end
				end
			end)
		end
	end)

	Inventory.Items:RegisterUse('evidence-dna', 'Evidence', function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceDNA then
			Callbacks:ClientCallback(source, 'Polyzone:IsCoordsInZone', {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = 'dna',
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local char = GetCharacter(itemData.MetaData.EvidenceDNA)
						if char then
							TriggerClientEvent('Evidence:Client:RanDNA', source, false, char, itemData.MetaData.EvidenceId)
						else
							TriggerClientEvent('Evidence:Client:RanDNA', source, false, false)
						end
					else
						TriggerClientEvent('Evidence:Client:RanDNA', source, true)
					end
				end
			end)
		end
	end)
end

function GetFirearmsRecord(serialNumber, scratched, filedOnly)
	if not serialNumber then
		return false
	end

	local p = promise.new()

	local query = {
		Serial = serialNumber,
		Scratched = scratched,
	}

	if filedOnly then
		query.FiledByPolice = true
	end

	Database.Game:findOne({
		collection = 'firearms',
		query = query,
	}, function(success, results)
		if success and #results > 0 and results[1] then
			p:resolve(results[1])
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function GetEvidenceProjectileRecord(evidenceId)
	local p = promise.new()

	Database.Game:findOne({
		collection = 'firearms_projectiles',
		query = {
			Id = evidenceId,
		}
	}, function(success, results)
		if success and #results > 0 and results[1] then
			p:resolve(results[1])
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function CreateEvidenceProjectileRecord(document)
	local p = promise.new()
	Database.Game:insertOne({
		collection = 'firearms_projectiles',
		document = document,
	}, function(success, result, insertId)
		if success then
			p:resolve(document)
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function GetMatchingEvidenceProjectiles(weaponSerial)
	local p = promise.new()

	Database.Game:find({
		collection = 'firearms_projectiles',
		query = {
			['Weapon.serial'] = weaponSerial,
		}
	}, function(success, results)
		if success and #results > 0 then
			local foundEvidence = {}

			for k, v in ipairs(results) do
				table.insert(foundEvidence, v.Id)
			end
			p:resolve(foundEvidence)
		else
			p:resolve({})
		end
	end)

	return Citizen.Await(p)
end

function GetCharacter(stateId)
	local p = promise.new()

	Database.Game:findOne({
		collection = 'characters',
		query = {
			SID = stateId,
		}
	}, function(success, results)
		if success and #results > 0 then
			local char = results[1]
			if char and char.SID and char.First and char.Last then
				p:resolve({
					SID = char.SID,
					First = char.First,
					Last = char.Last,
					Age = math.floor((os.time() - char.DOB) / 3.156e+7),
				})
			end
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end
