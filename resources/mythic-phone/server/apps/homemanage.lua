AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Home:CreateDigiKey", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local property = Properties:Get(data.id)
			if property ~= nil then
				local mykey = property.keys[char:GetData("ID")]
				if mykey ~= nil and mykey.Owner then
					if data.updating then
						local charId = nil
						local charSource = nil

						for k, v in pairs(property.keys) do
							if v.SID == data.target then
								charId = v.Char
							end
						end

						if charId ~= nil and property.keys[charId] ~= nil then
							local onlineChar = Fetch:ID(data.target)
							if onlineChar and onlineChar:GetData("Character") then
								charSource = onlineChar:GetData("Source")
							end

							if Properties.Keys:Give({
								ID = charId,
								SID = property.keys[charId].SID,
								First = property.keys[charId].First,
								Last = property.keys[charId].Last,
								Source = charSource,
							}, data.id, false, data.permissions, true) then
								if charSource then
									Phone.Notification:Add(
										charSource,
										"DigiKey Updated",
										"One of your DigiKey's Have Been Updated",
										os.time() * 1000,
										6000,
										"homemanage",
										{
											view = "",
										}
									)
								end
								cb({ error = false, code = 1 })
							else
								cb({ error = true, code = 7 })
							end
						else
							cb({ error = true, code = 7 })
						end
					else
						local tplyr = Fetch:SID(data.target)
						if tplyr ~= nil then
							local tchar = tplyr:GetData("Character")
							if tchar ~= nil then
								if property.keys[tchar:GetData("ID")] == nil then
									if Properties.Keys:Give({
										ID = tchar:GetData("ID"),
										SID = tchar:GetData("SID"),
										First = tchar:GetData("First"),
										Last = tchar:GetData("Last"),
										Source = tchar:GetData("Source"),
									}, data.id, false, data.permissions) then
										Phone.Notification:Add(
											tplyr:GetData("Source"),
											"DigiKey Issued",
											"You've been given a new DigiKey",
											os.time() * 1000,
											6000,
											"homemanage",
											{
												view = "",
											}
										)
										cb({ error = false, code = 1 })
									else
										cb({ error = true, code = 7 })
									end
								else
									cb({ error = true, code = 6 })
								end
							else
								cb({ error = true, code = 5 })
							end
						else
							cb({ error = true, code = 4 })
						end
					end
				else
					cb({ error = true, code = 3 })
				end
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Home:RevokeDigiKey", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local property = Properties:Get(data.id)
			if property ~= nil then
				local mykey = property.keys[char:GetData("ID")]
				if mykey ~= nil and mykey.Owner then
					if Properties.Keys:Take(data.target, data.id) then
						local tplyr = Fetch:CharacterData("ID", data.id)
						if tplyr ~= nil then
							local tchar = tplyr:GetData("Character")
							if tchar ~= nil then
								Phone.Notification:Add(
									tplyr:GetData("Source"),
									"DigiKey Revoked",
									"One of your DigiKeys have been revoked",
									os.time() * 1000,
									6000,
									"homemanage",
									{
										view = "",
									}
								)
							end
						end
						cb({ error = false, code = 1 })
					else
						cb({ error = true, code = 4 })
					end
				else
					cb({ error = true, code = 3 })
				end
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Home:RemoveMyKey", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local property = Properties:Get(data.id)
			if property ~= nil then
				local mykey = property.keys[char:GetData("ID")]
				if mykey ~= nil and not mykey.Owner then
					if Properties.Keys:Take(char:GetData("ID"), data.id) then
						Phone.Notification:Add(
							source,
							"DigiKey Revoked",
							"One of your DigiKeys have been revoked",
							os.time() * 1000,
							6000,
							"homemanage",
							{
								view = "",
							}
						)
						cb({ error = false, code = 1 })
					else
						cb({ error = true, code = 4 })
					end
				else
					cb({ error = true, code = 3 })
				end
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Home:LockProperty", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local property = Properties:Get(data.id)
			if property ~= nil then
				if property.keys ~= nil and property.keys[char:GetData("ID")] ~= nil then
					cb(Properties.Utils:ToggleLock(data.id))
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
end)
