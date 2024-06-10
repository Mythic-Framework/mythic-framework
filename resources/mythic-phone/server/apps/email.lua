PHONE.Email = {
	Read = function(self, charId, id)
		Database.Game:update({
			collection = "character_emails",
			query = {
				owner = owner,
				_id = id,
			},
			update = {
				["$set"] = {
					unread = false,
				},
			},
		}, function(success, res)
			return res > 0
		end)
	end,
	Send = function(self, serverId, sender, time, subject, body, flags)
		local plyr = Fetch:Source(serverId)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local doc = {
					owner = char:GetData("ID"),
					sender = sender,
					time = time,
					subject = subject,
					body = body,
					unread = true,
					flags = flags,
				}
				Database.Game:insertOne({
					collection = "character_emails",
					document = doc,
				}, function(success, res, insertedIds)
					if not success then
						return
					end
					doc._id = insertedIds[1]
					TriggerClientEvent("Phone:Client:Email:Receive", serverId, doc)
				end)
			end
		end
	end,
	Delete = function(self, charId, id)
		Database.Game:deleteOne({
			collection = "character_emails",
			query = {
				owner = charId,
				_id = id,
			},
		}, function(success)
			if success then
				local char = Fetch:ID(charId)
				if char then
					TriggerClientEvent("Phone:Client:Email:Delete", char:GetData("Source"), id)
				end
			end
		end)
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "character_emails",
			query = {
				owner = char:GetData("ID"),
			},
		}, function(success, emails)
			TriggerClientEvent("Phone:Client:SetData", source, "emails", emails)
		end)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "character_emails",
			query = {
				owner = char:GetData("ID"),
			},
		}, function(success, emails)
			TriggerClientEvent("Phone:Client:SetData", source, "emails", emails)
		end)
	end, 2)
	Middleware:Add("Phone:CharacterCreated", function(source, cData)
		return {
			{
				app = "email",
				alias = string.format("%s_%s%s@mythicmail.net", cData.First, cData.Last, cData.SID),
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Chat:RegisterAdminCommand("email", function(source, args, rawCommand)
		local plyr = Fetch:CharacterData("SID", tonumber(args[1]))
		if plyr ~= nil then
			Phone.Email:Send(plyr:GetData("Source"), args[2], os.time() * 1000, args[3], args[4])
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
	end, {
		help = "Send Email To Player",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "Sender Email",
				help = "Email To Show As Sender, EX: scaryman@something.net",
			},
			{
				name = "Subject",
				help = "Subject Line Of Email",
			},
			{
				name = "Body",
				help = "Body of email to send",
			},
		},
	}, 4)

	Callbacks:RegisterServerCallback("Phone:Email:Read", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		cb(Phone.Email:Read(char:GetData("Phone"), data))
	end)

	Callbacks:RegisterServerCallback("Phone:Email:Delete", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		cb(Phone.Email:Delete(char:GetData("ID"), data))
	end)

	Callbacks:RegisterServerCallback("Phone:Email:DeleteExpired", function(source, data, cb)
		local src = source

		local plyr = Fetch:Source(src)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Database.Game:find({
					collection = "character_emails",
					query = {
						owner = char:GetData("ID"),
						["flags.expires"] = {
							["$lt"] = os.time() * 1e3,
						},
					},
				}, function(success, res)
					Database.Game:delete({
						collection = "character_emails",
						query = {
							owner = char:GetData("ID"),
							["flags.expires"] = {
								["$lt"] = os.time() * 1e3,
							},
						},
					}, function(success2, res2)
						local ids = {}
						for k, v in ipairs(res) do
							table.insert(ids, v._id)
						end
						cb(ids)
					end)
				end)
			end
		end
	end)
end)
