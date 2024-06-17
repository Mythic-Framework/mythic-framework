RegisterNetEvent("Phone:Client:Twitter:Notify")
AddEventHandler("Phone:Client:Twitter:Notify", function(tweet)
	SendNUIMessage({
		type = "ADD_DATA",
		data = {
			type = "tweets",
			data = tweet,
		},
	})
	if Phone == nil then return end
	
	if tweet.source ~= GetPlayerServerId(PlayerId()) then
		Wait(1e3)
		Phone.Notification:Add(tweet.author.name, tweet.content, tweet.time, 6000, "twitter", {
			view = "#" .. tweet._id,
		}, nil)
	end
end)

RegisterNetEvent("Phone:Client:Twitter:UpdateLikes")
AddEventHandler("Phone:Client:Twitter:UpdateLikes", function(tweet)
	SendNUIMessage({
		type = "UPDATE_DATA",
		data = {
			type = "tweets",
			id = tweet._id,
			data = tweet,
		},
	})
end)

RegisterNUICallback("SendTweet", function(data, cb)
	Callbacks:ServerCallback("Phone:Twitter:CreateTweet", data, cb)
end)

RegisterNUICallback("FavoriteTweet", function(data, cb)
	Callbacks:ServerCallback("Phone:Twitter:Favorite", data, cb)
end)
