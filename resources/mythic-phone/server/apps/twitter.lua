local _tweets = {}
AddEventHandler("Phone:Server:AliasUpdated", function(src)
	local char = Fetch:Source(src):GetData("Character")
	local cid = char:GetData("ID")
	for k, v in ipairs(_tweets) do
		if v.cid == cid then
			v.author = char:GetData("Alias").twitter
		end
	end
	TriggerClientEvent("Phone:Client:SetData", -1, "tweets", _tweets)
end)

function ClearAllTweets(stateId)
	if stateId then
		local newTweets = {}

		for k, v in ipairs(_tweets) do
			if v.SID ~= stateId then
				table.insert(newTweets, v)
			end
		end

		_tweets = newTweets
		TriggerClientEvent("Phone:Client:SetData", -1, "tweets", _tweets)
	else
		_tweets = {}
		TriggerClientEvent("Phone:Client:SetData", -1, "tweets", _tweets)
	end
end

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		TriggerClientEvent("Phone:Client:SetData", source, "tweets", _tweets)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		TriggerClientEvent("Phone:Client:SetData", source, "tweets", _tweets)
	end, 2)
	Middleware:Add("Phone:CharacterCreated", function(source, cData)
		return {{
			app = "twitter",
			alias = {
				avatar = nil,
				name = string.format("%s%s%s", cData.First, cData.Last, cData.SID),
			},
		}}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Twitter:CreateTweet", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		data.source = src
		data._id = #_tweets + 1
		data.SID = char:GetData("SID")
		data.cid = char:GetData("ID")
		data.author = char:GetData("Alias").twitter
		data.time = os.time() * 1000
		table.insert(_tweets, data)
		TriggerClientEvent("Phone:Client:Twitter:Notify", -1, data)
		cb(true)
	end, 1)

	Callbacks:RegisterServerCallback("Phone:Twitter:Favorite", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		local _id = char:GetData("ID")
		if not data.state then
			table.insert(_tweets[data.id].likes, _id)
		else
			local t = {}
			for k, v in ipairs(_tweets[data.id].likes) do
				if v ~= _id then
					table.insert(t, v)
				end
			end
			_tweets[data.id].likes = t
		end
		TriggerClientEvent("Phone:Client:Twitter:UpdateLikes", -1, _tweets[data.id])
		cb(true)
	end)
end)
