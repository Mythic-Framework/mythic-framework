AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		TriggerClientEvent("Phone:Client:SetData", source, "workGroups", Labor.Get:Groups())
		TriggerClientEvent("Phone:Client:SetData", source, "jobs",Labor.Get:Jobs())
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		TriggerClientEvent("Phone:Client:SetData", source, "workGroups", Labor.Get:Groups())
		TriggerClientEvent("Phone:Client:SetData", source, "jobs",Labor.Get:Jobs())
	end, 2)
end)

PHONE.Labor = {}

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Labor:CreateWorkgroup", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Workgroups:Create(source))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Labor:DisbandWorkgroup", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Workgroups:Disband(source, true))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Labor:JoinWorkgroup", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Workgroups:Request(data, source))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Labor:LeaveWorkgroup", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Workgroups:Leave(data, source))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Labor:StartLaborJob", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Duty:On(data.job, source, data.isWorkgroup))
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Labor:QuitLaborJob", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(Labor.Duty:Off(data, source))
		end
	end)
end)
