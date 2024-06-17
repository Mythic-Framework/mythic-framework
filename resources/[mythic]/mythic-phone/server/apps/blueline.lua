local _races = {}
local _tracks = nil

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")

		if _tracks == nil then
			Database.Game:find({
				collection = "tracks_pd",
			}, function(success, tracks)
				_tracks = tracks
				TriggerClientEvent("Phone:Client:Blueline:StoreTracks", source, _tracks)
				TriggerClientEvent("Phone:Client:SetData", source, "tracks_pd", _tracks)
			end)
		else
			TriggerClientEvent("Phone:Client:Blueline:StoreTracks", source, _tracks)
			TriggerClientEvent("Phone:Client:SetData", source, "tracks_pd", _tracks)
		end

		TriggerClientEvent("Phone:Client:SpawnBlueLine", source, {
			races = _races,
		})
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")

		if _tracks == nil then
			Database.Game:find({
				collection = "tracks_pd",
			}, function(success, tracks)
				_tracks = tracks
				TriggerClientEvent("Phone:Client:Blueline:StoreTracks", source, _tracks)
				TriggerClientEvent("Phone:Client:SetData", source, "tracks_pd", _tracks)
			end)
		else
			TriggerClientEvent("Phone:Client:Blueline:StoreTracks", source, _tracks)
			TriggerClientEvent("Phone:Client:SetData", source, "tracks_pd", _tracks)
			--TriggerClientEvent("Phone:Client:SetData", source, "races_pd", _races)
		end

		TriggerClientEvent("Phone:Client:SpawnBlueLine", source, {
			races = _races,
		})
	end, 2)

	Middleware:Add("Characters:Logout", function(source)
		LeaveAnyRacePD(source)
	end, 2)

	Middleware:Add("playerDropped", function(source)
		LeaveAnyRacePD(source)
	end, 2)
end)

function ReloadRaceTracksPD()
	Database.Game:find({
		collection = "tracks_pd",
	}, function(success, tracks)
		_tracks = tracks
		TriggerClientEvent("Phone:Client:Blueline:StoreTracks", -1, _tracks)
		TriggerClientEvent("Phone:Client:SetData", -1, "tracks_pd", _tracks)
	end)
end

function LeaveAnyRacePD(source)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		char = plyr:GetData("Character")
		if char ~= nil and char:GetData("Callsign") then
			local alias = tostring(char:GetData("Callsign"))
			for k, v in ipairs(_races) do
				if v.state == 0 then
					if v.host_id == char:GetData("ID") then
						v.state = -1
						TriggerClientEvent("Phone:Client:Blueline:CancelRace", -1, k)
					else
						if v.racers[alias] ~= nil then
							v.racers[alias] = nil
							TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, k, alias)
						end
					end
				end
			end
		end
	end
end

function FinishRacePD(id)
	local cancelled = _races[id].state == 0

	_races[id].time = os.time() * 1000
	_races[id].state = 2

	if _races[id].completed ~= nil and #_races[id].completed > 0 then
		local updateFastest = false
		local racedTrack = nil
		for k, v in ipairs(_tracks) do
			if v._id == _races[id].track then
				racedTrack = k
				break
			end
		end

		for placing, alias in ipairs(_races[id].completed) do
			local fastest = nil

			for k, v in ipairs(_races[id].racers[alias].laps) do
				if fastest == nil or (v.lapEnd - v.lapStart) < (fastest.lapEnd - fastest.lapStart) then
					fastest = v
					fastest.alias = alias
				end
			end

			if fastest ~= nil then
				if _tracks[racedTrack].Fastest == nil or #_tracks[racedTrack].Fastest == 0 then
					_tracks[racedTrack].Fastest = {
						{
							time = fastest.time,
							lapStart = fastest.lapStart,
							lapEnd = fastest.lapEnd,
							format = fastest.format,
							alias = fastest.alias,
							car = _races[id].racers[alias].car or "UNKNOWN",
							owned = _races[id].racers[alias].isOwned or false,
						},
					}
					updateFastest = true
				else
					for i = 1, 10 do
						if
							_tracks[racedTrack].Fastest[i] == nil
							or fastest.lapEnd - fastest.lapStart
								< _tracks[racedTrack].Fastest[i].lapEnd - _tracks[racedTrack].Fastest[i].lapStart
						then
							local f = Fetch:CharacterData("SID", _races[id].racers[alias].sid)
							table.insert(_tracks[racedTrack].Fastest, i, {
								time = fastest.time,
								lapStart = fastest.lapStart,
								lapEnd = fastest.lapEnd,
								format = fastest.format,
								alias = fastest.alias,
								car = _races[id].racers[alias].car or "UNKNOWN",
								owned = _races[id].racers[alias].isOwned or false,
							})
							_tracks[racedTrack].Fastest = table.slice(_tracks[racedTrack].Fastest, 1, 10)
							updateFastest = true
							break
						end
					end
				end
			end

			_races[id].racers[alias] = {
				place = placing,
				finished = os.time() * 1000,
				fastest = fastest,
				laps = _races[id].racers[alias].laps,
				sid = _races[id].racers[alias].sid,
				isOwned = _races[id].racers[alias].isOwned or false,
			}
		end

		if updateFastest then
			UpdateFastestPD(_tracks[racedTrack]._id, _tracks[racedTrack].Fastest)
			TriggerClientEvent("Phone:Client:SetData", -1, "tracks_pd", _tracks)
		end
	end

	for k, v in pairs(_races[id].racers) do
		if v.source ~= nil then
			TriggerClientEvent("Phone:Blueline:NotifyDNF", v.source, id)
		end
	end

	TriggerClientEvent("Phone:Client:Blueline:FinishRace", -1, id, _races[id])
end

function UpdateFastestPD(track, fastest)
	local p = promise.new()

	Database.Game:updateOne({
		collection = "tracks_pd",
		query = {
			_id = track,
		},
		update = {
			["$set"] = {
				Fastest = fastest,
			},
		},
	}, function(success, results)
		if success then
			return p:resolve(true)
		else
			return p:resolve(false)
		end
	end)
	return Citizen.Await(p)
end

-- TODO: Add check for player-owned vehicle
RegisterServerEvent("Phone:Blueline:FinishRace", function(nId, data, laps, plate, vehName)
	local src = source
	local char = Fetch:Source(src):GetData("Character")
	local alias = tostring(char:GetData("Callsign"))

	local vehEnt = Entity(NetworkGetEntityFromNetworkId(nId)).state
	_races[tonumber(data)].racers[alias] = {
		laps = laps.laps,
		sid = char:GetData("SID"),
		isOwned = vehEnt.Owned,
		car = vehName,
	}

	if _races[tonumber(data)].completed == nil then
		_races[tonumber(data)].completed = {}
	end
	table.insert(_races[tonumber(data)].completed, alias)

	if #_races[tonumber(data)].completed == _races[tonumber(data)].total then
		FinishRacePD(tonumber(data))
	elseif
		#_races[tonumber(data)].completed >= tonumber(_races[tonumber(data)].dnf_start)
		and not _races[tonumber(data)].dnf_started
	then
		_races[tonumber(data)].dnf_started = true
		for k, v in pairs(_races[tonumber(data)].racers) do
			if v.source ~= nil then
				TriggerClientEvent(
					"Phone:Blueline:NotifyDNFStart",
					v.source,
					tonumber(data),
					tonumber(_races[tonumber(data)].dnf_time)
				)
			end
		end
		CreateThread(function()
			Wait(tonumber(_races[tonumber(data)].dnf_time) * 1000)
			FinishRacePD(tonumber(data))
		end)
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Blueline:GetTrack", function(src, data, cb)
		for k, v in ipairs(_tracks) do
			if v._id == data then
				cb(v)
				return
			end
		end
		cb(nil)
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:SaveTrack", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = tostring(char:GetData("Callsign"))

		if alias ~= nil then
			Database.Game:insertOne({
				collection = "tracks_pd",
				document = data,
			}, function(success, result, insertedIds)
				if not success then
					cb(false)
				end
				cb(true)
				data._id = insertedIds[1]
				table.insert(_tracks, data)
				TriggerClientEvent("Phone:Client:AddData", -1, "tracks_pd", data)
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:SaveLaptimes", function(src, data, cb)
		Database.Game:update({
			collection = "tracks_pd",
			query = {
				_id = data.track,
			},
			update = {
				["$push"] = {
					History = {
						["$each"] = data.laps,
						["$sort"] = {
							time = 1,
						},
						["$slice"] = 10,
					},
				},
			},
		}, function(success, results)
			for k, v in ipairs(_tracks) do
				if v._id == data.track then
					for k2, v2 in ipairs(data.laps) do
						table.insert(v.History, v2)
					end
					TriggerClientEvent("Phone:Client:UpdateData", -1, "tracks_pd", v._id, v)
					return
				end
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:DeleteTrack", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = tostring(char:GetData("Callsign"))
		if alias ~= nil then
			Database.Game:deleteOne({
				collection = "tracks_pd",
				query = {
					_id = data,
				},
			}, function(success, results)
				cb(success)
				TriggerClientEvent("Phone:Client:RemoveData", -1, "tracks_pd", data)
				for k, v in ipairs(_tracks) do
					if v._id == data then
						table.remove(_tracks, k)
						return
					end
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:ResetTrackHistory", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = tostring(char:GetData("Callsign"))
		if alias ~= nil then
			Database.Game:updateOne({
				collection = "tracks_pd",
				query = {
					_id = data,
				},
				update = {
					["$set"] = {
						History = {},
					},
					["$unset"] = {
						Fastest = "",
					},
				},
			}, function(success, results)
				cb(success)
				for k, v in ipairs(_tracks) do
					if v._id == data then
						v.Fastest = nil
						v.History = {}
						TriggerClientEvent("Phone:Client:UpdateData", -1, "tracks_pd", data, v)
						return
					end
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:CreateRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		if Jobs.Permissions:HasJob(src, "police", false, false, false, false, "PD_MANAGE_TRIALS") then
			data.host_id = char:GetData("ID")
			data.host_src = src
			data.time = os.time() * 1000
			data.racers = {
				[tostring(char:GetData("Callsign"))] = {
					source = src,
					sid = char:GetData("SID"),
				},
			}
			data.state = 0
			data._id = #_races + 1
			for k, v in ipairs(_tracks) do
				if v._id == data.track then
					data.trackData = v
				end
			end

			if data.trackData ~= nil then
				table.insert(_races, data)
				cb(data)
				for k, v in pairs(Fetch:All()) do
					local c = v:GetData("Character")
					if c ~= nil then
						TriggerClientEvent("Phone:Client:Blueline:CreateRace", v:GetData("Source"), data)
					end
				end
			else
				cb({ failed = true })
			end
		else
			cb({ failed = true })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:CancelRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if _races[tonumber(data)].host_id == char:GetData("ID") then
			_races[tonumber(data)].state = -1
			cb(true)
			TriggerClientEvent("Phone:Client:Blueline:CancelRace", -1, tonumber(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:StartRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		if _races[tonumber(data)].host_id == char:GetData("ID") then
			local ploc = GetEntityCoords(GetPlayerPed(src))
			local dist = #(
					vector3(
						_races[tonumber(data)].trackData.Checkpoints[1].coords.x,
						_races[tonumber(data)].trackData.Checkpoints[1].coords.y,
						_races[tonumber(data)].trackData.Checkpoints[1].coords.z
					) - ploc
				)

			if dist > 25 then
				cb({ failed = true, message = "Too Far From Starting Point" })
			else
				_races[data].state = 1
				_races[data].total = 0
				for k, v in pairs(_races[data].racers) do
					_races[data].total = _races[data].total + 1
				end

				cb(true)
				TriggerClientEvent("Phone:Client:Blueline:StartRace", -1, tonumber(data))
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:EndRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if _races[tonumber(data)].host_id == char:GetData("ID") then
			FinishRacePD(tonumber(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:JoinRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = tostring(char:GetData("Callsign"))

		for k, v in ipairs(_races) do
			if v.state == 0 then
				_races[k].racers[alias] = nil
				TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, k, alias)
			end
		end

		if Jobs.Permissions:HasJob(src, "police") and alias ~= nil and _races[tonumber(data)].state == 0 then
			_races[tonumber(data)].racers[alias] = {
				source = src,
				sid = char:GetData("SID"),
			}
			cb(_races[tonumber(data)])
			TriggerClientEvent("Phone:Client:Blueline:JoinRace", -1, tonumber(data), alias)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Blueline:LeaveRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = tostring(char:GetData("Callsign"))

		if alias ~= nil and _races[tonumber(data)].state == 0 then
			_races[tonumber(data)].racers[alias] = nil
			cb(true)
			TriggerClientEvent("Phone:Client:Blueline:LeaveRace", -1, tonumber(data), alias)
		else
			cb(false)
		end
	end)
end)
