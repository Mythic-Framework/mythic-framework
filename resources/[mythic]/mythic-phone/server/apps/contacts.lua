PHONE.Contacts = {
	IsContact = function(self, myId, targetNumber)
		local p = promise.new()
		Database.Game:findOne({
			collection = "phone_contacts",
			query = {
				character = myId,
				number = targetNumber,
			},
		}, function(success, results)
			if not success then
				return p:resolve(nil)
			end
			p:resolve(results[1])
		end)
		return Citizen.Await(p)
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "phone_contacts",
			query = {
				character = char:GetData("ID"),
			},
		}, function(success, contacts)
			TriggerClientEvent("Phone:Client:SetData", source, "contacts", contacts)
		end)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "phone_contacts",
			query = {
				character = char:GetData("ID"),
			},
		}, function(success, contacts)
			TriggerClientEvent("Phone:Client:SetData", source, "contacts", contacts)
		end)
	end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Contacts:Create", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		if char then
			data.character = char:GetData("ID")
			Database.Game:insertOne({
				collection = "phone_contacts",
				document = data,
			}, function(success, result, insertedIds)
				if not success then
					return cb(nil)
				end
				cb(insertedIds[1])
			end)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Contacts:Update", function(source, data, cb)
		if data.id == nil then
			return cb(nil)
		end

		local src = source
		local char = Fetch:Source(src):GetData("Character")
		if char then
			data.character = char:GetData("ID")
			Database.Game:updateOne({
				collection = "phone_contacts",
				query = {
					character = char:GetData("ID"),
					_id = data.id,
				},
				update = {
					["$set"] = {
						name = data.name,
						number = data.number,
						color = data.color,
						avatar = data.avatar,
						favorite = data.favorite,
					},
				},
			}, function(success, results)
				if not success then
					return cb(nil)
				end
				cb(true)
			end)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Contacts:Delete", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		if char and data then
			Database.Game:deleteOne({
				collection = "phone_contacts",
				query = {
					character = char:GetData("ID"),
					_id = tostring(data),
				},
			}, function(success, results)
				cb(success)
			end)
		else
			cb(false)
		end
	end)
end)
