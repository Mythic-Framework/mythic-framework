
function CheckBusinessPermissions(source, permission)
    local onDuty = Jobs.Duty:Get(source)
	if onDuty and onDuty.Id and _businessTablets[onDuty.Id] then
		if (not permission) or Jobs.Permissions:HasPermissionInJob(source, onDuty.Id, permission) then
			return onDuty.Id
		end
	end
	return false
end

function MDTBusinessLogin(dutyData, source)
    local businessTablet = _businessTablets[dutyData.Id]
    if businessTablet then
        local job = Jobs.Permissions:HasJob(source, dutyData.Id)
        if job then
            local permissions = Jobs.Permissions:GetPermissionsFromJob(source, job.Id)
            TriggerClientEvent("MDT:Client:BusinessLogin", source, job, permissions, businessTablet)

			TriggerClientEvent("MDT:Client:SetData", source, "businessNotices", GetBusinessNotices(job.Id))
        end
    end
end

AddEventHandler('Job:Server:DutyAdd', function(dutyData, source)
    MDTBusinessLogin(dutyData, source)
end)

RegisterNetEvent('MDT:Server:CloseMDT', function()
	local src = source

	local dutyData = Jobs.Duty:Get(src)

	if dutyData then
		MDTBusinessLogin(dutyData, src)
	end
end)

AddEventHandler('Jobs:Server:JobUpdate', function(source)
	local dutyData = Jobs.Duty:Get(source)
	if dutyData and _businessTablets[dutyData.Id] then
		local job = Jobs.Permissions:HasJob(source, dutyData.Id)
		if job then
			local permissions = Jobs.Permissions:GetPermissionsFromJob(source, job.Id)
			TriggerClientEvent('MDT:Client:UpdateJobData', source, job, permissions)
		end
	end
end)

AddEventHandler('Job:Server:DutyRemove', function(dutyData, source, SID)
    local businessTablet = _businessTablets[dutyData.Id]
    if businessTablet then
		TriggerClientEvent("MDT:Client:Logout", source)
	end
end)

function GetBusinessNotices(job)
	local notices = {}
	for k, v in ipairs(_businessNotices) do
		if v.job == job then
			table.insert(notices, v)
		end
	end

	return notices
end

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Database.Game:find({
		collection = "business_notices",
		query = {}
	}, function(success, results)
		if not success then
			return
		end

		Logger:Trace("MDT", "[Business] Loaded ^2" .. #results .. "^7 Business Notices", { console = true })
		_businessNotices = results
	end)

	Callbacks:RegisterServerCallback("MDT:Business:Notice:Create", function(source, data, cb)
		local job = CheckBusinessPermissions(source, 'TABLET_CREATE_NOTICE')
		if job then
			cb(MDT.Business.Create:Notice(source, job, data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Business:Notice:Delete", function(source, data, cb)
		local job = CheckBusinessPermissions(source, 'TABLET_DELETE_NOTICE')
		if job then
			cb(MDT.Business.Delete:Notice(job, data.id))
		else
			cb(false)
		end
	end)
end)

_MDT.Business = {
	Create = {
		Notice = function(self, source, job, data)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local p = promise.new()

					data.job = job
					data.author = {
						SID = char:GetData('SID'),
						First = char:GetData('First'),
						Last = char:GetData('Last'),
					}

					Database.Game:insertOne({
						collection = 'business_notices',
						document = data,
					}, function (success, result, insertIds)
						if not success then
							p:resolve(false)
							return
						end

						data._id = insertIds[1]
						table.insert(_businessNotices, data)

						local jobDutyData = Jobs.Duty:GetDutyData(job)
						if jobDutyData and jobDutyData.DutyPlayers then
							for k, v in ipairs(jobDutyData.DutyPlayers) do
								TriggerClientEvent("MDT:Client:AddData", v, "businessNotices", data)
							end
						end

						p:resolve(insertIds[1])
					end)
					return Citizen.Await(p)
				end
			end
			return false
		end,
	},
	Update = {
		Tag = function(self, id, data)
			local p = promise.new()
			Database.Game:updateOne({
				collection = 'mdt_tags',
				query = {
					_id = id,
				},
                update = {
                    ["$set"] = {
						name = data.name,
						requiredPermission = data.requiredPermission,
						restrictViewing = data.restrictViewing,
						style = data.style,
					},
                },
			}, function (success, result)
				if not success then
					p:resolve(false)
					return
				end

				for k, v in ipairs(_tags) do
					if (v._id == id) then
						_tags[k] = data
						break
					end
				end

				for user, _ in pairs(_onDutyUsers) do
					TriggerClientEvent("MDT:Client:UpdateData", user, "tags", id, data)
				end
				for user, _ in pairs(_onDutyLawyers) do
					TriggerClientEvent("MDT:Client:UpdateData", user, "tags", id, data)
				end
				p:resolve(true)
			end)
			return Citizen.Await(p)
		end,
	},
	Delete = {
		Notice = function(self, job, id)
			local p = promise.new()
			Database.Game:deleteOne({
				collection = 'business_notices',
				query = {
					_id = id,
					job = job,
				},
			}, function (success, deleted)
				if not success then
					p:resolve(false)
					return
				end

				for k, v in ipairs(_businessNotices) do
					if (v._id == id) then
						table.remove(_businessNotices, k)
						break
					end
				end

				local jobDutyData = Jobs.Duty:GetDutyData(job)
				if jobDutyData and jobDutyData.DutyPlayers then
					for k, v in ipairs(jobDutyData.DutyPlayers) do
						TriggerClientEvent("MDT:Client:RemoveData", v, "businessNotices", id)
					end
				end

				p:resolve(true)
			end)
			return Citizen.Await(p)
		end,
	}
}
