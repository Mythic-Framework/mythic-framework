local _channels = {}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find(
			{ collection = "irc_channels", query = { character = char:GetData("ID") } },
			function(success, channels)
				_channels[char:GetData("ID")] = channels
				TriggerClientEvent("Phone:Client:SetData", source, "ircChannels", channels)
			end
		)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find(
			{ collection = "irc_channels", query = { character = char:GetData("ID") } },
			function(success, channels)
				_channels[char:GetData("ID")] = channels
				TriggerClientEvent("Phone:Client:SetData", source, "ircChannels", channels)
			end
		)
	end, 2)
	Middleware:Add("Phone:CharacterCreated", function(source, cData)
		return {
			{
				app = "irc",
				alias = string.format("anon%s", cData.SID * (math.random(math.random(1000)))),
			},
		}
	end)
	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			_channels[char:GetData("ID")] = nil
		end
	end)
end)

local _cachedMessages = {}
AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:IRC:GetMessages", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")

		local v = -1
		if _cachedMessages[data] == nil then
			Database.Game:find({ collection = "irc_messages", query = { channel = data } }, function(success, messages)
				if not success then
					_cachedMessages[data] = {}
				else
					_cachedMessages[data] = messages
				end
				v = true
			end)
		else
			v = true
		end

		while v == -1 do
			Wait(10)
		end

		cb(_cachedMessages[data])
	end)
	Callbacks:RegisterServerCallback("Phone:IRC:SendMessage", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias").irc
		_cachedMessages[data.channel] = _cachedMessages[data.channel] or {}

		local data2 = {
			from = alias,
			channel = data.channel,
			message = data.message,
			time = data.time,
		}
		Database.Game:insertOne(
			{ collection = "irc_messages", document = data2 },
			function(success, result, insertedIds)
				if not success then
					cb(nil)
					return
				end
				data2._id = insertedIds[1]
				data2.time = data2.time * 1.0 -- Dear Lue, Die In A Fire
				table.insert(_cachedMessages[data.channel], data2)

				for k, v in pairs(_channels) do
					if k ~= char:GetData("ID") then
						for k2, channel in ipairs(v) do
							if channel.slug == data.channel then
								local tPlyr = Fetch:CharacterData("ID", k)
								if tPlyr ~= nil then
									local tChar = tPlyr:GetData("Character")
									if tChar ~= nil then
										TriggerClientEvent(
											"Phone:Client:IRC:Notify",
											tPlyr:GetData("Source"),
											data2,
											false
										)
									end
								end
								break
							end
						end
					end
				end
				cb(insertedIds[1])
			end
		)
	end)

	Callbacks:RegisterServerCallback("Phone:IRC:JoinChannel", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		local data2 = {
			slug = data.slug,
			joined = data.joined,
			character = char:GetData("ID"),
		}

		for k, v in ipairs(_channels[char:GetData("ID")]) do
			if v.slug == data2.slug then
				cb(false)
				return
			end
		end

		Database.Game:insertOne(
			{ collection = "irc_channels", document = data2 },
			function(success, result, insertedIds)
				if not success then
					cb(false)
					return
				end

				data2._id = insertedIds[1]
				table.insert(_channels[char:GetData("ID")], data2)

				cb(true)
			end
		)
	end)

	Callbacks:RegisterServerCallback("Phone:IRC:LeaveChannel", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		Database.Game:deleteOne(
			{ collection = "irc_channels", query = { character = char:GetData("ID"), slug = data } },
			function(success, result, insertedIds)
				if not success then
					cb(false)
					return
				end

				for k, v in ipairs(_channels[char:GetData("ID")]) do
					if v.slug == data then
						table.remove(_channels[char:GetData("ID")], k)
						break
					end
				end

				cb(true)
			end
		)
	end)
end)
