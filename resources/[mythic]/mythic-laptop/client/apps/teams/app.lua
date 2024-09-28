_myTeam = nil

RegisterNetEvent("Laptop:Client:Teams:Set", function(teamData)
    _myTeam = teamData

    Laptop.Data:Set("myGroup", _myTeam)
end)

RegisterNUICallback("GetTeams", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:Get", {}, cb)
end)

RegisterNUICallback("GetTeamRequests", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:GetRequests", {}, cb)
end)

RegisterNUICallback("CreateTeam", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:Create", data, cb)
end)

RegisterNUICallback("InviteTeamMember", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:Members:Invite", data, cb)
end)

RegisterNUICallback("RemoveTeamMember", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:Members:Remove", data, cb)
end)

RegisterNUICallback("RequestTeamInvite", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:RequestInvite", data, cb)
end)

RegisterNUICallback("DeleteTeam", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:Delete", data, cb)
end)

RegisterNUICallback("TeamRequest", function(data, cb)
	Callbacks:ServerCallback("Laptop:Teams:ActionRequest", data, function()
		cb('OK')
	end)
end)

AddEventHandler("Laptop:Client:Teams:RequestNotifAccept", function(data)
	if not data.request then
		return
	end

	Callbacks:ServerCallback("Laptop:Teams:ActionRequest", {
		id = data.request,
		action = "accept",
	})
end)

AddEventHandler("Laptop:Client:Teams:RequestNotifDeny", function(data)
	if not data.request then
		return
	end

	Callbacks:ServerCallback("Laptop:Teams:ActionRequest", {
		id = data.request,
		action = "deny",
	})
end)