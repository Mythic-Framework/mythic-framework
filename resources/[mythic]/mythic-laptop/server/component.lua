LAPTOP_APPS = {}

LAPTOP = {
	UpdateJobData = function(self, source, returnValues)
		local charJobs = Jobs.Permissions:GetJobs(source)
		local charJobPerms = {}
		local jobData = {}
		if charJobs and #charJobs > 0 then
			for k, v in ipairs(charJobs) do
				local perms = GlobalState[string.format(
					"JobPerms:%s:%s:%s",
					v.Id,
					(v.Workplace and v.Workplace.Id or false),
					v.Grade.Id
				)]
				if perms then
					charJobPerms[v.Id] = perms
				end
				table.insert(jobData, Jobs:Get(v.Id))
			end
		end

		if returnValues then
			return {
				charJobPerms = charJobPerms,
				jobData = jobData,
			}
		end

		TriggerClientEvent("Laptop:Client:SetData", source, "JobPermissions", charJobPerms)
		TriggerClientEvent("Laptop:Client:SetData", source, "JobData", jobData)
	end,
	Notification = {
		Add = function(self, source, title, description, time, duration, app, actions, notifData)
			TriggerClientEvent(
				"Laptop:Client:Notifications:Add",
				source,
				title,
				description,
				time,
				duration,
				app,
				actions,
				notifData
			)
		end,
		AddWithId = function(self, source, id, title, description, time, duration, app, actions, notifData)
			TriggerClientEvent(
				"Laptop:Client:Notifications:AddWithId",
				source,
				id,
				title,
				description,
				time,
				duration,
				app,
				actions,
				notifData
			)
		end,
		Update = function(self, source, id, title, description, skipSound)
			TriggerClientEvent("Laptop:Client:Notifications:Update", source, id, title, description, skipSound)
		end,
		RemoveById = function(self, source, id)
			TriggerClientEvent("Laptop:Client:Notifications:Remove", source, id)
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Laptop", LAPTOP)
end)
