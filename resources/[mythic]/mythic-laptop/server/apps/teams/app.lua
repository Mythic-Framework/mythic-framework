_teams = {}

_teamRequests = {}
_teamRequestIds = 0

LAPTOP.Teams = {
    GetAll = function(self)
        return _teams
    end,
    Get = function(self, id)
        for k, v in ipairs(_teams) do
            if v.ID == id then
                return v
            end
        end
    end,
    GetByMember = function(self, SID)
        for k, v in ipairs(_teams) do
            for _, member in ipairs(v.Members) do
                if member.SID == SID then
                    return v, member.Leader
                end
            end
        end

        return false
    end,
    GetByMemberSource = function(self, source)
        for k, v in ipairs(_teams) do
            for _, member in ipairs(v.Members) do
                if member.Source == source then
                    return v, member.Leader
                end
            end
        end

        return false
    end,
    Create = function(self, source, name)
        local char = Fetch:Source(source):GetData("Character")
        if char and not Laptop.Teams:GetByMemberSource(source) then

            name = string.gsub(name, '%s+', '')

            for k, v in ipairs(_teams) do
                if v.Name == name then
                    return {
                        message = "Name Already Taken"
                    }
                end
            end

            local team = {
                State = 0,
                StateName = "Available",
                Name = name,
                ID = source,
                Members = {
                    {
                        Leader = true,
                        Source = source,
                        SID = char:GetData("SID"),
                        First = char:GetData("First"),
                        Last = char:GetData("Last"),
                    }
                }
            }

            table.insert(_teams, team)

            char:SetData("Team", source)
            TriggerClientEvent("Laptop:Client:Teams:Set", source, team)

            return {
                success = true,
                team = team,
            }
        end
        return false
    end,
    Delete = function(self, id, leaderDropped)
        for k, v in ipairs(_teams) do
            if v.ID == id then
                for _, member in ipairs(v.Members) do
                    Laptop.Notification:Add(
                        member.Source,
                        "Team Deleted",
                        "You are no longer a member of a team as the one you were in was just deleted.", 
                        os.time() * 1000,
                        15000,
                        "teams",
                        {},
                        {}
                    )

                    local char = Fetch:Source(member.Source):GetData("Character")
                    if char then
                        char:SetData("Team", nil)
                    end

                    TriggerClientEvent("Laptop:Client:Teams:Set", member.Source, nil)
                end

                TriggerEvent("Laptop:Server:Teams:Deleted", id)
                table.remove(_teams, k)
                return true
            end
        end

        return false
    end,
    SetState = function(self, team, state, stateName)
        for k, v in ipairs(_teams) do
            if v.ID == team then
                v.State = state
                v.StateName = stateName

                for _, member in ipairs(v.Members) do
                    TriggerClientEvent("Laptop:Client:Teams:Set", member.Source, v)
                end

                return true
            end
        end
        return false
    end,
    ResetState = function(self, team)
        for k, v in ipairs(_teams) do
            if v.ID == team then
                v.State = 0
                v.StateName = "Available"

                for _, member in ipairs(v.Members) do
                    TriggerClientEvent("Laptop:Client:Teams:Set", member.Source, v)
                end

                return true
            end
        end
        return false
    end,
    Members = {
        Add = function(self, source, team)
            local char = Fetch:Source(source):GetData("Character")

            if char then
                for k, v in ipairs(_teams) do
                    if v.ID == team then
                        if #v.Members < 5 then
                            local data = {
                                Leader = false,
                                Source = source,
                                SID = char:GetData("SID"),
                                First = char:GetData("First"),
                                Last = char:GetData("Last"),
                            }

                            table.insert(v.Members, data)
                            char:SetData("Team", team)

                            for _, member in ipairs(v.Members) do
                                TriggerClientEvent("Laptop:Client:Teams:Set", member.Source, v)
                            end

                            TriggerEvent("Laptop:Server:Teams:MemberAdded", v.ID, data)
                            return true
                        end

                        break
                    end
                end
            end

            return false
        end,
        Remove = function(self, source, teamId, wasRemoved)
            if not teamId then
                local team = Laptop.Teams:GetByMemberSource(source)

                teamId = team?.ID
            end

            if teamId then
                local removed = false
                local leader = false
                local info = nil

                for k, v in ipairs(_teams) do
                    if v.ID == teamId then
                        for i, j in ipairs(v.Members) do
                            if j.Source == source then
                                info = j
                                leader = j.Leader
                                table.remove(v.Members, i)
                                break
                            end
                        end

                        for _, member in ipairs(v.Members) do
                            TriggerClientEvent("Laptop:Client:Teams:Set", member.Source, v)

                            Laptop.Notification:Add(
                                member.Source, 
                                wasRemoved and "Team Member Removed" or "Team Member Left", 
                                string.format("%s %s is no longer in your team.", info.First, info.Last), 
                                os.time() * 1000,
                                10000,
                                "teams",
                                {},
                                {}
                            )
                        end

                        if leader then
                            Laptop.Teams:Delete(teamId, true)
                        else
                            TriggerEvent("Laptop:Server:Teams:MemberRemoved", v.ID, info)
                        end

                        local char = Fetch:Source(source):GetData("Character")
                        if char then
                            char:SetData("Team", false)
                        end

                        TriggerClientEvent("Laptop:Client:Teams:Set", source, nil)

                        break
                    end
                end
            end
        end,
        SendEvent = function(self, team, event, ...)
            for k, v in ipairs(_teams) do
                if v.ID == team then
                    for _, member in ipairs(v.Members) do
                        TriggerClientEvent(event, member.Source, ...)
                    end

                    break
                end
            end
        end,
        Notification = function(self, team, title, description, time, duration, app, actions, notifData)
            for k, v in ipairs(_teams) do
                if v.ID == team then
                    for _, member in ipairs(v.Members) do
                        Laptop.Notification:Add(member.Source, title, description, time, duration, app, actions, notifData)
                    end

                    break
                end
            end
        end,
        NotificationAddWithId = function(self, team, id, title, description, time, duration, app, actions, notifData)
            for k, v in ipairs(_teams) do
                if v.ID == team then
                    for _, member in ipairs(v.Members) do
                        Laptop.Notification:AddWithId(member.Source, id, title, description, time, duration, app, actions, notifData)
                    end

                    break
                end
            end
        end,
        NotificationUpdate = function(self, team, id, title, description, skipSound)
            for k, v in ipairs(_teams) do
                if v.ID == team then
                    for _, member in ipairs(v.Members) do
                        Laptop.Notification:Update(member.Source, id, title, description, skipSound)
                    end

                    break
                end
            end
        end,
        NotificationRemoveById = function(self, team, id)
            for k, v in ipairs(_teams) do
                if v.ID == team then
                    for _, member in ipairs(v.Members) do
                        Laptop.Notification:RemoveById(member.Source, id)
                    end

                    break
                end
            end
        end,
    },
    Requests = {
        Add = function(self, target, isTeam, event, label, description, data, time)
            if not time then
                time = 60 * 5
            end

            local id = _teamRequestIds + 1

            table.insert(_teamRequests, {
                id = id,
                time = os.time(),
                expires = os.time() + time,
                owner = target,
                team = isTeam,
                event = event,
                label = label,
                description = description,
                data = data or {}
            })

            return id
        end,

        Clear = function(self, id)
            for k, v in ipairs(_teamRequests) do
                if v.id == id then
                    table.remove(_teamRequests, k)
                end
            end
        end,

        Get = function(self, source)
            local char = Fetch:Source(source):GetData("Character")
            local r = {}

            if char then
                local team, leader = Laptop.Teams:GetByMember(char:GetData("SID"))
                if team then
                    for k, v in ipairs(_teamRequests) do
                        if v.team and v.owner == team.ID then
                            table.insert(r, v)
                        end
                    end
                else
                    for k, v in ipairs(_teamRequests) do
                        if not v.team and v.owner == char:GetData("SID") then
                            table.insert(r, v)
                        end
                    end
                end
            end

            return r
        end,
    }
}

AddEventHandler("Laptop:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("Laptop:Teams:Get", function(source, data, cb)
        cb(Laptop.Teams:GetAll())
	end)

    Callbacks:RegisterServerCallback("Laptop:Teams:GetRequests", function(source, data, cb)
        cb(Laptop.Teams.Requests:Get(source))
	end)

    Callbacks:RegisterServerCallback("Laptop:Teams:Create", function(source, data, cb)
        cb(Laptop.Teams:Create(source, data.Name))
	end)

    Callbacks:RegisterServerCallback("Laptop:Teams:Delete", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char then
            local team, leader = Laptop.Teams:GetByMemberSource(source)

            if team and leader and team.State == 0 then
                cb(Laptop.Teams:Delete(team.ID))
            else
                cb(false)
            end
        else
            cb(false)
        end
	end)

    Callbacks:RegisterServerCallback("Laptop:Teams:Members:Invite", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        local target = Fetch:SID(data?.SID)
        if char and target and target:GetData("Character") then
            local myTeam = Laptop.Teams:GetByMember(char:GetData("SID"))

            target = target:GetData("Character")

            if target:GetData("Team") or not myTeam or myTeam?.State ~= 0 then
                cb(false)
                return
            end

            for k, v in ipairs(_teamRequests) do
                if v.owner == target:GetData("SID") and v.data.invite and v.data.team == myTeam.ID then
                    cb(false)
                    return
                end
            end

            local req = Laptop.Teams.Requests:Add(
                target:GetData("SID"),
                false,
                "Laptop:Server:Teams:Invite",
                "New Team Invite",
                string.format("To Join %s", myTeam.Name),
                {
                    invite = true,
                    team = myTeam.ID,
                },
                60 * 2 -- 2 Minutes
            )

            Laptop.Notification:Add(target:GetData("Source"), "New Invitation", string.format("You have been invited to team: %s", myTeam.Name), os.time() * 1000, 10000, "teams", {
                accept = "Laptop:Client:Teams:RequestNotifAccept",
                cancel = "Laptop:Client:Teams:RequestNotifDeny",
            }, {
                request = req,
            })

            cb({ success = true })
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Laptop:Teams:Members:Remove", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and data?.SID and data?.Source then
            if data.SID == char:GetData("SID") then -- Leaving Group
                local team = Laptop.Teams:GetByMemberSource(char:GetData("Source"))
                Laptop.Teams.Members:Remove(char:GetData("Source"), team.ID)

                cb(true)
            else -- Kicking From Group
                local team = Laptop.Teams:GetByMember(data.SID)

                if team and team.State == 0 and team.ID == char:GetData("Source") then -- Is Leader
                    Laptop.Teams.Members:Remove(data.Source, team.ID, true)

                    cb(true)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Laptop:Teams:ActionRequest", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and data.id then
            local team, leader = Laptop.Teams:GetByMember(char:GetData("SID"))

            for k, v in ipairs(_teamRequests) do
                if v.id == data.id and ((not v.team and v.owner == char:GetData("SID")) or (v.team and team and v.owner == team.ID and leader)) then
                    TriggerEvent(v.event, source, v.data, data.action, data.id)

                    Laptop.Teams.Requests:Clear(data.id)
                    break
                end
            end
        end

        cb()
    end)

    Callbacks:RegisterServerCallback("Laptop:Teams:RequestInvite", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and data and not char:GetData("Team") then
            local team = Laptop.Teams:Get(data)

            if team and team.State == 0 then
                for k, v in ipairs(_teamRequests) do
                    if v.owner == team.ID and v.data.request and v.data.team == team.ID then
                        cb(false)
                        return
                    end
                end

                local req = Laptop.Teams.Requests:Add(
                    team.ID,
                    true,
                    "Laptop:Server:Teams:InviteRequest",
                    "New Join Request",
                    string.format("Request to join your team from %s %s (%s).", char:GetData("First"), char:GetData("Last"), char:GetData("SID")),
                    {
                        request = true,
                        team = team.ID,
                        joiner = source,
                    },
                    60 * 2 -- 2 Minutes
                )
    
                Laptop.Notification:Add(team.ID, "New Join Request", string.format("%s %s (%s) requested to join your team.", char:GetData("First"), char:GetData("Last"), char:GetData("SID")), os.time() * 1000, 10000, "teams", {
                    accept = "Laptop:Client:Teams:RequestNotifAccept",
                    cancel = "Laptop:Client:Teams:RequestNotifDeny",
                }, {
                    request = req,
                })

                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    StartTeamsThread()
end)

local started = false
function StartTeamsThread()
    if started then return; end
    started = true

    CreateThread(function()
        while true do
            Wait(60 * 1000 * 0.5)

            for k, v in ipairs(_teamRequests) do
                if v.expires <= os.time() then
                    table.remove(_teamRequests, k)
                end
            end
        end
    end)
end

AddEventHandler("Laptop:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Logout", function(source)
		Laptop.Teams.Members:Remove(source)
	end, 2)

	Middleware:Add("playerDropped", function(source)
        Laptop.Teams.Members:Remove(source)
	end, 2)
end)

AddEventHandler("Laptop:Server:Teams:Invite", function(source, data, action)
    if action == "accept" then
        Laptop.Teams.Members:Add(source, data.team)
    end
end)

AddEventHandler("Laptop:Server:Teams:InviteRequest", function(source, data, action)
    if action == "accept" then
        Laptop.Teams.Members:Add(data.joiner, data.team)
    end
end)
