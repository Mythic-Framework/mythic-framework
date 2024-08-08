local _tempLastLocation = {}
local _lastSpawnLocations = {}

RegisterNetEvent('characters:Server:StoreUpdate')
AddEventHandler('characters:Server:StoreUpdate', function()
	local src = source
	local char = Fetch:Source(src):GetData('Character')

	if char ~= nil then
		local data = char:GetData()
	end
end)

function RegisterCallbacks()
	Callbacks:RegisterServerCallback('Characters:GetServerData', function(source, data, cb)
		while Fetch:Source(source) == nil do
			Wait(100)
		end

		local motd = GetConvar('motd', 'Welcome to Mythic RP')
		Database.Game:find({
			collection = 'changelogs',
			options = {
				sort = {
					date = -1,
				},
			},
			limit = 1,
		}, function(success, results)
			if not success then
				cb({ changelog = nil, motd = '' })
				return
			end

			if #results > 0 then
				cb({ changelog = results[1], motd = motd })
			else
				cb({ changelog = nil, motd = motd })
			end
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:GetCharacters', function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:find({
			collection = 'characters',
			query = {
				User = player:GetData('AccountID'),
				Deleted = {
					['$ne'] = true,
				},
			},
		}, function(success, results)
			if not success then
				cb(nil)
				return
			end
			local cData = {}
			for k, v in ipairs(results) do
				local p = promise.new()

				Database.Game:findOne({
					collection = 'peds',
					query = {
						Char = v._id
					}
				}, function(s2, pedData)
					table.insert(cData, {
						ID = v._id,
						First = v.First,
						Last = v.Last,
						Phone = v.Phone,
						DOB = v.DOB,
						Gender = v.Gender,
						LastPlayed = v.LastPlayed,
						Jobs = v.Jobs,
						SID = v.SID,
						GangChain = v.GangChain,
						Preview = pedData[1]?.Ped or false
					})
					p:resolve(true)
				end)

				Citizen.Await(p)
			end
			player:SetData('Characters', cData)
			cb(cData)
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:CreateCharacter', function(source, data, cb)
		local player = Fetch:Source(source)
		local pNumber = GeneratePhoneNumber()
		while IsNumberInUse(pNumber) do
			pNumber = GeneratePhoneNumber()
		end

		local doc = {
			User = player:GetData('AccountID'),
			First = data.first,
			Last = data.last,
			Phone = pNumber,
			Gender = tonumber(data.gender),
			Bio = data.bio,
			Origin = data.origin,
			DOB = data.dob,
			LastPlayed = -1,
			Jobs = {},
			SID = Sequence:Get('Character'),
			Cash = 5000,
			New = true,
			Licenses = {
				Drivers = {
					Active = true,
					Points = 0,
					Suspended = false,
				},
				Weapons = {
					Active = false,
					Suspended = false,
				},
				Hunting = {
					Active = false,
					Suspended = false,
				},
				Fishing = {
					Active = false,
					Suspended = false,
				},
				Pilot = {
					Active = false,
					Suspended = false,
				},
			},
		}

		local extra = Middleware:TriggerEventWithData('Characters:Creating', source, doc)
		for _, v in ipairs(extra) do
			for k2, v2 in pairs(v) do
				if k2 ~= 'ID' then
					doc[k2] = v2
				end
			end
		end

		Database.Game:insertOne({
			collection = 'characters',
			document = doc,
		}, function(success, result, insertedIds)
			if not success then
				cb(nil)
				return nil
			end
			doc.ID = insertedIds[1]
			TriggerEvent('Characters:Server:CharacterCreated', doc)
			Middleware:TriggerEvent('Characters:Created', source, doc)
			cb(doc)

			Logger:Info(
				'Characters',
				string.format(
					'%s [%s] Created a New Character %s %s (%s)',
					player:GetData('Name'),
					player:GetData('AccountID'),
					doc.First,
					doc.Last,
					doc.SID
				),
				{
					console = true,
					file = true,
					database = true,
				}
			)
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:DeleteCharacter', function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = 'characters',
			query = {
				User = player:GetData('AccountID'),
				_id = data,
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end
			local deletingChar = results[1]
			Database.Game:updateOne({
				collection = 'characters',
				query = {
					User = player:GetData('AccountID'),
					_id = data,
				},
				update = {
					['$set'] = {
						Deleted = true,
					},
				},
			}, function(success, results)
				TriggerEvent('Characters:Server:CharacterDeleted', data)
				cb(success)

				if success then
					Logger:Warn(
						'Characters',
						string.format(
							'%s [%s] Deleted Character %s %s (%s)',
							player:GetData('Name'),
							player:GetData('AccountID'),
							deletingChar.First,
							deletingChar.Last,
							deletingChar.SID
						),
						{
							console = true,
							file = true,
							database = true,
							discord = {
								embed = true,
							},
						}
					)
				end
			end)
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:GetSpawnPoints', function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = 'characters',
			query = {
				User = player:GetData('AccountID'),
				_id = data,
			},
			options = {
				projection = {
					SID = 1,
					New = 1,
					Jailed = 1,
					ICU = 1,
					Apartment = 1,
					Jobs = 1,
				},
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end
			if results[1].New then
				cb({
					{
						id = 1,
						label = 'Character Creation',
						location = Apartment:GetInteriorLocation(results[1].Apartment or 1),
					},
				})
			elseif results[1].Jailed and not results[1].Jailed.Released ~= nil then
				cb({ Config.PrisonSpawn })
			elseif results[1].ICU and not results[1].ICU.Released then
				cb({ Config.ICUSpawn })
			else
				local spawns = Middleware:TriggerEventWithData('Characters:GetSpawnPoints', source, data, results[1])
				cb(spawns)
			end
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:GetCharacterData', function(source, data, cb)
		local player = Fetch:Source(source)
		Database.Game:findOne({
			collection = 'characters',
			query = {
				User = player:GetData('AccountID'),
				_id = data,
			},
		}, function(success, results)
			if not success or not #results then
				cb(nil)
				return
			end

			local cData = results[1]
			cData.Source = source
			cData.ID = results[1]._id
			cData._id = nil

			local store = DataStore:CreateStore(source, 'Character', cData)

			player:SetData('Character', store)
			GlobalState[string.format('SID:%s', source)] = cData.SID
			GlobalState[string.format('Account:%s', source)] = player:GetData('AccountID')

			Middleware:TriggerEvent('Characters:CharacterSelected', source)

			cb(cData)
		end)
	end)

	Callbacks:RegisterServerCallback('Characters:Logout', function(source, data, cb)
		local player = Fetch:Source(source)
		Middleware:TriggerEvent('Characters:Logout', source)
		player:SetData('Character', nil)
		GlobalState[string.format('SID:%s', source)] = nil
		GlobalState[string.format('Account:%s', source)] = nil
		cb('ok')
		TriggerClientEvent('Characters:Client:Logout', source)
		Routing:RoutePlayerToHiddenRoute(source)
	end)

	Callbacks:RegisterServerCallback('Characters:GlobalSpawn', function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		cb()
	end)
end

function HandleLastLocation(source)
	local player = Fetch:Source(source)
	if player ~= nil then
		local char = player:GetData('Character')
		if char ~= nil then
			local lastLocation = _tempLastLocation[source]
			if lastLocation and type(lastLocation) == 'vector3' then
				_lastSpawnLocations[char:GetData('ID')] = {
					coords = lastLocation,
					time = os.time(),
				}
			end
		end
	end

	_tempLastLocation[source] = nil
end

function RegisterMiddleware()
	Middleware:Add('Characters:Spawning', function(source)
		TriggerClientEvent('Characters:Client:Spawned', source)
	end, 100000)
	Middleware:Add('Characters:ForceStore', function(source)
		local player = Fetch:Source(source)
		if player ~= nil then
			local char = player:GetData('Character')
			if char ~= nil then
				StoreData(source)
			end
		end
	end, 100000)
	Middleware:Add('Characters:Logout', function(source)
		local player = Fetch:Source(source)
		if player ~= nil then
			local char = player:GetData('Character')
			if char ~= nil then
				StoreData(source)
			end
		end
	end, 10000)

	Middleware:Add('Characters:GetSpawnPoints', function(source, id)
		if id then
			local hasLastLocation = _lastSpawnLocations[id]
			if hasLastLocation and hasLastLocation.time and (os.time() - hasLastLocation.time) <= (60 * 5) then
				return {
					{
						id = 'LastLocation',
						label = 'Last Location',
						location = {
							x = hasLastLocation.coords.x,
							y = hasLastLocation.coords.y,
							z = hasLastLocation.coords.z,
							h = 0.0,
						},
						icon = 'location-dot',
						event = 'Characters:GlobalSpawn',
					},
				}
			end
		end
		return {}
	end, 1)

	Middleware:Add('Characters:GetSpawnPoints', function(source)
		local spawns = {}
		for _, v in ipairs(Spawns) do
			v.event = 'Characters:GlobalSpawn'
			table.insert(spawns, v)
		end
		return spawns
	end, 5)

	Middleware:Add('playerDropped', function(source, message)
		local player = Fetch:Source(source)
		if player ~= nil then
			local char = player:GetData('Character')
			if char ~= nil then
				StoreData(source)
			end
		end
	end, 10000)

	Middleware:Add('Characters:Logout', HandleLastLocation, 6)
	Middleware:Add('playerDropped', HandleLastLocation, 6)
end

function IsNumberInUse(number)
	local var = nil
	Database.Game:findOne({
		collection = 'characters',
		query = {
			phone = number,
		},
	}, function(success, results)
		if not success then
			var = true
			return
		end
		var = #results > 0
	end)

	while var == nil do
		Wait(10)
	end
end

function GeneratePhoneNumber()
	local phone = ''

	for i = 1, 10, 1 do
		local d = math.random(0, 9)
		phone = phone .. d

		if i == 3 or i == 6 then
			phone = phone .. '-'
		end
	end

	return phone
end

RegisterNetEvent('Characters:Server:LastLocation',function(coords) -- Probably Going to make the server explode but ¯\_(ツ)_/¯
	local src = source
	_tempLastLocation[src] = coords
end)