local _calls = {}
PHONE.Call = {
	End = function(self, source)
		if _calls[source] ~= nil then
			_calls[source].data.duration = math.ceil(os.time() - _calls[source].start)
			Phone.Call:CreateRecord(_calls[source].data)

			TriggerClientEvent("Phone:Client:Phone:EndCall", source)
			TriggerClientEvent("Phone:Client:AddData", source, "calls", _calls[source].data)

			Phone.Notification:RemoveById(source, "PHONE_CALL")
			VOIP.Phone:SetCall(source, 0)

			if _calls[source].target ~= nil and _calls[_calls[source].target] ~= nil then
				Logger:Trace("Phone", string.format("%s Ending Call With %s", source, _calls[source].target))
				_calls[_calls[source].target].data.duration = _calls[source].data.duration
				TriggerClientEvent("Phone:Client:Phone:EndCall", _calls[source].target)
				TriggerClientEvent(
					"Phone:Client:AddData",
					_calls[source].target,
					"calls",
					_calls[_calls[source].target].data
				)
				Phone.Call:CreateRecord(_calls[_calls[source].target].data)
				Phone.Notification:RemoveById(_calls[source].target, "PHONE_CALL")
				VOIP.Phone:SetCall(_calls[source].target, 0)
				_calls[_calls[source].target] = nil
			else
				Logger:Trace(
					"Phone",
					string.format("%s Ending Call With Second Client Not Registered In A Call", source)
				)
			end
			_calls[source] = nil
		end
	end,
	CreateRecord = function(self, record)
		Database.Game:insertOne({
			collection = "phone_calls",
			document = record,
		})
	end,
	Decrypt = function(self, owner, number)
		Database.Game:update({
			collection = "phone_calls",
			document = {
				owner = owner,
				number = number,
				decryptable = true,
			},
			update = {
				["$set"] = {
					anonymouse = false,
				},
			},
		})
	end,
	Read = function(self, owner)
		Database.Game:update({
			collection = "phone_calls",
			query = {
				owner = owner,
			},
			update = {
				["$set"] = {
					unread = false,
				},
			},
		})
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:aggregate({
			collection = "phone_calls",
			aggregate = {
				{
					["$match"] = {
						owner = char:GetData("Phone"),
						deleted = false or nil,
					},
				},
				{
					["$sort"] = {
						time = -1,
					},
				},
				{
					["$limit"] = 100,
				},
			},
		}, function(success, calls)
			TriggerClientEvent("Phone:Client:SetData", source, "calls", calls or {})
		end)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:aggregate({
			collection = "phone_calls",
			aggregate = {
				{
					["$match"] = {
						owner = char:GetData("Phone"),
						deleted = false or nil,
					},
				},
				{
					["$sort"] = {
						time = -1,
					},
				},
				{
					["$limit"] = 100,
				},
			},
		}, function(success, calls)
			TriggerClientEvent("Phone:Client:SetData", source, "calls", calls or {})
		end)
	end, 2)
	Middleware:Add("playerDropped", function(source, message)
		if _calls[source] ~= nil then
			Phone.Call:End(source)
		end
	end, 5)
	Middleware:Add("Characters:Logout", function(source)
		if _calls[source] ~= nil then
			Phone.Call:End(source)
		end
	end, 5)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Phone:CreateCall", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		if _calls[src] == nil and char:GetData("Phone") ~= data.number then
			local callingContact = Phone.Contacts:IsContact(char:GetData("ID"), data.number)
			local callingStr = data.number
			if callingContact and not data.limited then
				callingStr = callingContact.name
			end

			_calls[src] = {
				id = char:GetData("Source"),
				owner = char:GetData("Phone"),
				number = data.number,
				duration = -1,
				start = os.time() * 1000,
				callingStr = callingStr,
				data = {
					owner = char:GetData("Phone"),
					number = data.number,
					time = os.time() * 1000,
					duration = -1,
					method = true,
					limited = false,--data.limited,
					anonymous = false,--data.isAnon,
					decryptable = hasValue(char:GetData("States") or {}, "ADV_VPN"),
					unread = false,
				},
			}
			Phone.Notification:AddWithId(src, "PHONE_CALL", "Dialing", callingStr, os.time() * 1000, -1, "phone", {
				cancel = "Phone:Nui:Phone:EndCall",
			}, nil)

			local tplyr = Fetch:CharacterData("Phone", data.number)
			if tplyr ~= nil then
				local target = tplyr:GetData("Character")

				if target ~= nil and hasValue(target:GetData("States"), "PHONE") then
					if _calls[target:GetData("Source")] == nil then
						cb(true)

						Logger:Trace("Phone", string.format("%s Starting Call With %s", src, tplyr:GetData("Source")))

						_calls[src].target = target:GetData("Source")

						local destContact = Phone.Contacts:IsContact(target:GetData("ID"), char:GetData("Phone"))
						local destStr = char:GetData("Phone")
						if destContact then
							destStr = destContact.name
						end

						if data.limited then
							destStr = "Unknown Number"
						end

						_calls[target:GetData("Source")] = {
							id = target:GetData("Source"),
							owner = target:GetData("Phone"),
							number = char:GetData("Phone"),
							duration = -1,
							start = os.time() * 1000,
							target = char:GetData("Source"),
							callingStr = destStr,
							data = {
								owner = data.number,
								number = char:GetData("Phone"),
								time = os.time() * 1000,
								duration = 0,
								method = false,
								limited = data.limited,
								anonymous = data.isAnon,
								decryptable = hasValue(target:GetData("States") or {}, "ADV_VPN"),
								unread = false,
							},
						}

						Phone.Notification:AddWithId(
							target:GetData("Source"),
							"PHONE_CALL",
							"Incoming Call",
							destStr,
							os.time() * 1000,
							-1,
							"phone",
							{
								accept = "Phone:Nui:Phone:AcceptCall",
								cancel = "Phone:Nui:Phone:EndCall",
							}
						)

						TriggerClientEvent(
							"Phone:Client:Phone:RecieveCall",
							target:GetData("Source"),
							char:GetData("Source"),
							char:GetData("Phone"),
							data.limited
						)
					else
						Logger:Trace(
							"Phone",
							string.format(
								"%s Starting Call With Number %s Which Is Already On A Call",
								src,
								data.number
							)
						)

						-- Caller
						local callerData = {
							owner = char:GetData("Phone"),
							number = data.number,
							time = os.time() * 1000,
							duration = -1,
							method = true,
							limited = data.limited,
							anonymous = data.isAnon,
							unread = false,
						}
						Phone.Call:CreateRecord(callerData)
						Phone.Notification:Add(
							src,
							"Number Busy",
							"The Number You Dialed Is Busy",
							os.time() * 1000,
							6000,
							"phone"
						)

						-- Recipient
						local recipData = {
							owner = data.number,
							number = char:GetData("Phone"),
							time = os.time() * 1000,
							duration = -1,
							method = false,
							limited = data.limited,
							anonymous = data.isAnon,
							unread = true,
						}
						Phone.Call:CreateRecord(recipData)
						TriggerClientEvent("Phone:Client:AddData", target:GetData("Source"), "calls", recipData)
						Phone.Notification:Add(
							target:GetData("Source"),
							"Missed Call",
							"You Missed A Call",
							os.time() * 1000,
							6000,
							"phone"
						)

						cb(false)
						Phone.Call:End(src)
					end
				else
					Logger:Trace(
						"Phone",
						string.format("%s Starting Call With Number %s Which Is Not Online", src, data.number)
					)
					Phone.Call:CreateRecord({
						owner = data.number,
						number = char:GetData("Phone"),
						time = os.time() * 1000,
						duration = -1,
						method = false,
						limited = data.limited,
						anonymous = data.isAnon,
						decryptable = false,
						unread = true,
					})
					cb(true)
					return
				end
			else
				Logger:Trace(
					"Phone",
					string.format("%s Starting Call With Number %s Which Is Not Online", src, data.number)
				)
				Phone.Call:CreateRecord({
					owner = data.number,
					number = char:GetData("Phone"),
					time = os.time() * 1000,
					duration = -1,
					method = false,
					limited = data.limited,
					anonymous = data.isAnon,
					decryptable = false,
					unread = true,
				})
				cb(true)
				return
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Phone:AcceptCall", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if _calls[src] ~= nil and _calls[src].target ~= nil and _calls[_calls[src].target] ~= nil then
			_calls[src].state = 2
			_calls[_calls[src].target].state = 2

			TriggerClientEvent("Phone:Client:Phone:AcceptCall", src, _calls[src].number)
			TriggerClientEvent("Phone:Client:Phone:AcceptCall", _calls[src].target, _calls[_calls[src].target].number)

			local cid = src
			if not _calls[src].data.method then
				cid = _calls[src].target
			end

			Logger:Trace(
				"Phone",
				string.format("%s Accepted Call With %s, Setting To Call Channel %s", src, _calls[src].target, cid)
			)

			Phone.Notification:AddWithId(
				src,
				"PHONE_CALL",
				"On Call",
				_calls[src].callingStr,
				os.time() * 1000,
				-1,
				"phone",
				{
					cancel = "Phone:Nui:Phone:EndCall",
				}
			)

			Phone.Notification:AddWithId(
				_calls[src].target,
				"PHONE_CALL",
				"On Call",
				_calls[_calls[src].target].callingStr,
				os.time() * 1000,
				-1,
				"phone",
				{
					cancel = "Phone:Nui:Phone:EndCall",
				}
			)

			VOIP.Phone:SetCall(src, cid)
			VOIP.Phone:SetCall(_calls[src].target, cid)
		else
			Logger:Trace(
				"Phone",
				string.format("%s Attempted Accepting A Call But Server Didn't Have One Registered", source)
			)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Phone:EndCall", function(src, data, cb)
		Phone.Call:End(src)
	end)

	Callbacks:RegisterServerCallback("Phone:Phone:ReadCalls", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		Phone.Call:Read(char:GetData("Phone"))
	end)
end)
