PHONE.Messages = {
	Read = function(self, owner, number)
		Database.Game:update({
			collection = "phone_messages",
			query = {
				owner = owner,
				number = number,
			},
			update = {
				["$set"] = {
					unread = false,
				},
			},
		})
	end,
	Delete = function(self, owner, number)
		Database.Game:update({
			collection = "phone_messages",
			query = {
				owner = owner,
				number = number,
			},
			update = {
				["$set"] = {
					deleted = true,
				},
			},
		})
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "phone_messages",
			query = {
				owner = char:GetData("Phone"),
				deleted = {
					["$ne"] = true,
				},
			},
		}, function(success, messages)
			TriggerClientEvent("Phone:Client:SetData", source, "messages", messages)
		end)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "phone_messages",
			query = {
				owner = char:GetData("Phone"),
				deleted = {
					["$ne"] = true,
				},
			},
		}, function(success, messages)
			TriggerClientEvent("Phone:Client:SetData", source, "messages", messages)
		end)
	end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Messages:SendMessage", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		local data2 = {
			owner = data.number,
			number = data.owner,
			message = data.message,
			time = data.time + 1,
			-- I Wanna Die Omegalul
			method = 0,
			unread = true,
		}
		Database.Game:insert({
			collection = "phone_messages",
			documents = { data, data2 },
		}, function(success, result, insertedIds)
			if not success then
				cb(nil)
				return
			end
			local target = Fetch:CharacterData("Phone", data.number)
			if target ~= nil then
				data2.contact = Phone.Contacts:IsContact(char:GetData("ID"), data2.number)
				TriggerClientEvent("Phone:Client:Messages:Notify", target:GetData("Source"), data2, false)
			end
			cb(insertedIds[1])
		end)
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:ReadConvo", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		Phone.Messages:Read(char:GetData("Phone"), data)
	end)

	Callbacks:RegisterServerCallback("Phone:Messages:DeleteConvo", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		Phone.Messages:Delete(char:GetData("Phone"), data.number)
	end)
end)
