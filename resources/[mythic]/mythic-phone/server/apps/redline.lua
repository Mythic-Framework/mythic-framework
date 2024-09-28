-- CRYPTO SETTINGS
local _awardedCoin = "VRM"
local _awardedAmount = 5
local _cryptoPayout = 16

local _reqForCrypto = 5

local _races = {}
local _tracks = nil

--[[local _raceItems = {
	{ item = "racing_crappy", coin = "PLEB", price = 10, qty = 100, vpn = false },
	{ item = "racedongle", coin = "VRM", rep = "Racing", repLvl = 3, price = 15, qty = 25, vpn = false },
	{ item = "harness", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, qty = 25, vpn = false },

	{ item = "racedongle", coin = "PLEB", rep = "Racing", repLvl = 3, price = 30, qty = 25, vpn = true },
	{ item = "choplist", coin = "VRM", rep = "Chopping", repLvl = 3, price = 25, qty = 100, vpn = true },
	{ item = "choplist", coin = "PLEB", rep = "Chopping", repLvl = 3, price = 50, qty = 100, vpn = true },
	{ item = "fakeplates", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, qty = 5, vpn = true },
	{ item = "fakeplates", coin = "PLEB", price = 48, qty = 2, vpn = true },

	{ item = "nitrous", coin = "VRM", price = 10, qty = -1, vpn = true },
	{ item = "nitrous", coin = "PLEB", price = 50, qty = 10, vpn = true },
}]]

function table.slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	--[[Vendor:Create("RaceGear", "poly", "Race Gear", false, {
		coords = vector3(725.49, -1063.3, 22.17),
		length = 0.8,
		width = 0.6,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 21.97,
			maxZ = 22.97,
		},
	}, _raceItems, "flag-checkered", "View Items")]]

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")

		if _tracks == nil then
			Database.Game:find({
				collection = "tracks",
			}, function(success, tracks)
				_tracks = tracks
				TriggerClientEvent("Phone:Client:Redline:StoreTracks", source, _tracks)
				TriggerClientEvent("Phone:Client:SetData", source, "tracks", _tracks)
			end)
		else
			TriggerClientEvent("Phone:Client:Redline:StoreTracks", source, _tracks)
			TriggerClientEvent("Phone:Client:SetData", source, "tracks", _tracks)
		end

		TriggerClientEvent("Phone:Client:Spawn", source, {
			races = _races,
		})
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")

		if _tracks == nil then
			Database.Game:find({
				collection = "tracks",
			}, function(success, tracks)
				_tracks = tracks
				TriggerClientEvent("Phone:Client:Redline:StoreTracks", source, _tracks)
				TriggerClientEvent("Phone:Client:SetData", source, "tracks", _tracks)
			end)
		else
			TriggerClientEvent("Phone:Client:Redline:StoreTracks", source, _tracks)
			TriggerClientEvent("Phone:Client:SetData", source, "tracks", _tracks)
			TriggerClientEvent("Phone:Client:SetData", source, "races", _races)
		end

		TriggerClientEvent("Phone:Client:Spawn", source, {
			races = _races,
		})
	end, 2)

	Middleware:Add("Characters:Logout", function(source)
		LeaveAnyRace(source)
	end, 2)

	Middleware:Add("playerDropped", function(source)
		LeaveAnyRace(source)
	end, 2)
end)

function ReloadRaceTracks()
	Database.Game:find({
		collection = "tracks",
	}, function(success, tracks)
		_tracks = tracks
		TriggerClientEvent("Phone:Client:Redline:StoreTracks", -1, _tracks)
		TriggerClientEvent("Phone:Client:SetData", -1, "tracks", _tracks)
	end)
end

function LeaveAnyRace(source)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		char = plyr:GetData("Character")
		if char ~= nil then
			local alias = char:GetData("Alias").redline
			for k, v in ipairs(_races) do
				if v.state == 0 then
					if v.host_id == char:GetData("ID") then
						v.state = -1
						TriggerClientEvent("Phone:Client:Redline:CancelRace", -1, k)
					else
						if v.racers[alias] ~= nil then
							v.racers[alias] = nil
							TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
						end
					end
				end
			end
		end
	end
end

function FinishRace(id)
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

		_races[id].competitive = _races[id].total >= _reqForCrypto

		for placing, alias in ipairs(_races[id].completed) do
			local fastest = nil
			local pCash = 0
			local pCrypto = 0

			if _races[id].total < 2 then
				pCash = _races[id].buyin
			else
				if placing == 1 or placing == 2 and _races[id].total == 2 then
					pCash = (_races[id].buyin * _races[id].total) / 2
					if _races[id].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 2
					end
				elseif placing == 2 and _races[id].total > 2 then
					pCash = (_races[id].buyin * _races[id].total) / 4
					if _races[id].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 4
					end
				elseif placing == 3 or placing == 4 then
					pCash = (_races[id].buyin * _races[id].total) / 8
					if _races[id].total >= _reqForCrypto then
						pCrypto = _cryptoPayout / 8
					end
				end
			end

			for k, v in ipairs(_races[id].racers[alias].laps) do
				if fastest == nil or (v.lapEnd - v.lapStart) < (fastest.lapEnd - fastest.lapStart) then
					fastest = v
				end
			end

			if _races[id].total >= _reqForCrypto then
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
						pCrypto = pCrypto + _awardedAmount
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
								pCrypto = pCrypto + _awardedAmount
								updateFastest = true
								break
							end
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
				reward = {
					cash = pCash,
					coin = _awardedCoin,
					crypto = pCrypto,
				},
			}
		end

		if updateFastest then
			UpdateFastest(_tracks[racedTrack]._id, _tracks[racedTrack].Fastest)
			TriggerClientEvent("Phone:Client:SetData", -1, "tracks", _tracks)
		end
	end

	for k, v in pairs(_races[id].racers) do
		if v.source ~= nil then
			TriggerClientEvent("Phone:Redline:NotifyDNF", v.source, id)
		end
	end

	TriggerClientEvent("Phone:Client:Redline:FinishRace", -1, id, _races[id])
	Payout(_races[id].total, _races[id].racers, _races[id].competitive)

	for k, v in pairs(Fetch:All()) do
		local c = v:GetData("Character")
		if c ~= nil then
			local dutyData = Jobs.Duty:Get(v:GetData("Source"))
			if hasValue(c:GetData("States") or {}, "RACE_DONGLE") and (not dutyData or dutyData.Id ~= "police") then
				Phone.Notification:Add(
					v:GetData("Source"),
					string.format("%s", cancelled and "Event Cancelled" or "Event Finished"),
					string.format("%s has %s", _races[id].name, cancelled and "been cancelled" or "finished"),
					os.time() * 1000,
					10000,
					"redline",
					{
						view = "2",
					}
				)
			end
		end
	end
end

-- TODO: Add payout for crypto
function Payout(numRacers, results, isCompetitive)
	for k, v in pairs(results) do
		if isCompetitive and v.place ~= nil then
			local plyr = Fetch:CharacterData("SID", v.sid)
			if plyr ~= nil then
				local target = plyr:GetData("Character")
				Reputation.Modify:Add(target:GetData("Source"), "Racing", 25 + (25 * (numRacers - v.place)))
				if v.reward ~= nil and v.reward.crypto > 0 then
					Crypto.Exchange:Add(_awardedCoin, target:GetData("CryptoWallet"), v.reward.crypto)
				end
			end
		end
	end
end

function UpdateFastest(track, fastest)
	local p = promise.new()

	Database.Game:updateOne({
		collection = "tracks",
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
RegisterServerEvent("Phone:Redline:FinishRace", function(nId, data, laps, plate, vehName)
	local src = source
	local char = Fetch:Source(src):GetData("Character")
	local alias = char:GetData("Alias").redline

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
		FinishRace(tonumber(data))
	elseif
		#_races[tonumber(data)].completed >= tonumber(_races[tonumber(data)].dnf_start)
		and not _races[tonumber(data)].dnf_started
	then
		_races[tonumber(data)].dnf_started = true
		for k, v in pairs(_races[tonumber(data)].racers) do
			if v.source ~= nil then
				TriggerClientEvent(
					"Phone:Redline:NotifyDNFStart",
					v.source,
					tonumber(data),
					tonumber(_races[tonumber(data)].dnf_time)
				)
			end
		end
		CreateThread(function()
			Wait(tonumber(_races[tonumber(data)].dnf_time) * 1000)
			FinishRace(tonumber(data))
		end)
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Redline:GetTrack", function(src, data, cb)
		for k, v in ipairs(_tracks) do
			if v._id == data then
				cb(v)
				return
			end
		end
		cb(nil)
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:SaveTrack", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").redline

		if alias ~= nil then
			Database.Game:insertOne({
				collection = "tracks",
				document = data,
			}, function(success, result, insertedIds)
				if not success then
					cb(false)
				end
				cb(true)
				data._id = insertedIds[1]
				table.insert(_tracks, data)
				TriggerClientEvent("Phone:Client:AddData", -1, "tracks", data)
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:SaveLaptimes", function(src, data, cb)
		Database.Game:update({
			collection = "tracks",
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
					TriggerClientEvent("Phone:Client:UpdateData", -1, "tracks", v._id, v)
					return
				end
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:DeleteTrack", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").redline
		if alias ~= nil then
			Database.Game:deleteOne({
				collection = "tracks",
				query = {
					_id = data,
				},
			}, function(success, results)
				cb(success)
				TriggerClientEvent("Phone:Client:RemoveData", -1, "tracks", data)
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

	Callbacks:RegisterServerCallback("Phone:Redline:ResetTrackHistory", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").redline
		if alias ~= nil then
			Database.Game:updateOne({
				collection = "tracks",
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
						TriggerClientEvent("Phone:Client:UpdateData", -1, "tracks", data, v)
						return
					end
				end
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:CreateRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		if hasValue(char:GetData("States") or {}, "RACE_DONGLE") then
			data.host_id = char:GetData("ID")
			data.host_src = src
			data.time = os.time() * 1000
			data.racers = {
				[char:GetData("Alias").redline] = {
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
						TriggerClientEvent("Phone:Client:Redline:CreateRace", v:GetData("Source"), data)
						local dutyData = Jobs.Duty:Get(v:GetData("Source"))
						if
							v:GetData("Source") ~= src
							and hasValue(c:GetData("States") or {}, "RACE_DONGLE")
							and (not dutyData or dutyData.Id ~= "police")
						then
							Phone.Notification:Add(
								v:GetData("Source"),
								string.format("New Event: %s", data.name),
								string.format("%s created an event", char:GetData("Alias").redline),
								os.time() * 1000,
								10000,
								"redline",
								{
									view = "1",
								}
							)
						end
					end
				end
			else
				cb(nil)
			end
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:CancelRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if
			_races[tonumber(data)].host_id == char:GetData("ID")
			and hasValue(char:GetData("States") or {}, "RACE_DONGLE")
		then
			_races[tonumber(data)].state = -1
			cb(true)
			TriggerClientEvent("Phone:Client:Redline:CancelRace", -1, tonumber(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:StartRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		if
			_races[tonumber(data)].host_id == char:GetData("ID")
			and hasValue(char:GetData("States") or {}, "RACE_DONGLE")
		then
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

				Robbery:TriggerPDAlert(
					src,
					vector3(
						_races[tonumber(data)].trackData.Checkpoints[1].coords.x,
						_races[tonumber(data)].trackData.Checkpoints[1].coords.y,
						_races[tonumber(data)].trackData.Checkpoints[1].coords.z
					),
					"10-94",
					"Illegal Street Racing",
					{
						icon = 227,
						size = 0.9,
						color = 31,
						duration = (60 * 5),
					}
				)

				cb(true)
				TriggerClientEvent("Phone:Client:Redline:StartRace", -1, tonumber(data))
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:EndRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if
			_races[tonumber(data)].host_id == char:GetData("ID")
			and hasValue(char:GetData("States") or {}, "RACE_DONGLE")
		then
			FinishRace(tonumber(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:JoinRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").redline

		for k, v in ipairs(_races) do
			if v.state == 0 then
				_races[k].racers[alias] = nil
				TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, k, alias)
			end
		end

		if alias ~= nil and _races[tonumber(data)].state == 0 then
			_races[tonumber(data)].racers[alias] = {
				source = src,
				sid = char:GetData("SID"),
			}
			cb(_races[tonumber(data)])
			TriggerClientEvent("Phone:Client:Redline:JoinRace", -1, tonumber(data), alias)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Redline:LeaveRace", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").redline

		if alias ~= nil and _races[tonumber(data)].state == 0 then
			_races[tonumber(data)].racers[alias] = nil
			cb(true)
			TriggerClientEvent("Phone:Client:Redline:LeaveRace", -1, tonumber(data), alias)
		else
			cb(false)
		end
	end)
end)
