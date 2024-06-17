local _ranStartup = false
JOB_CACHE = {}
JOB_COUNT = 0

_loaded = false

AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Database = exports['mythic-base']:FetchComponent('Database')
	Middleware = exports['mythic-base']:FetchComponent('Middleware')
	Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
	Logger = exports['mythic-base']:FetchComponent('Logger')
	Utils = exports['mythic-base']:FetchComponent('Utils')
	Fetch = exports['mythic-base']:FetchComponent('Fetch')
	Chat = exports['mythic-base']:FetchComponent('Chat')
	Execute = exports['mythic-base']:FetchComponent('Execute')
	Sequence = exports['mythic-base']:FetchComponent('Sequence')
	Generator = exports['mythic-base']:FetchComponent('Generator')
	Phone = exports['mythic-base']:FetchComponent('Phone')
	Jobs = exports['mythic-base']:FetchComponent('Jobs')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mythic-base']:RequestDependencies('Jobs', {
		'Database',
		'Middleware',
		'Callbacks',
		'Logger',
		'Utils',
		'Fetch',
		'Execute',
		'Sequence',
		'Generator',
		'Chat',
		'Jobs',
		'Phone'
	}, function(error)
		if #error > 0 then return; end
		RetrieveComponents()
		RegisterJobMiddleware()
		RegisterJobCallbacks()
		RegisterJobChatCommands()

		_loaded = true

		RunStartup()

		TriggerEvent('Jobs:Server:Startup')
	end)
end)

function FindAllJobs()
	local p = promise.new()

	Database.Game:find({
		collection = 'jobs',
		query = {},
	}, function(success, results)
		if success and #results > 0 then
			p:resolve(results)
		else
			p:resolve({})
		end
	end)

	local res = Citizen.Await(p)
	return res
end

function RefreshAllJobData(job)
	local jobsFetch = FindAllJobs()
	JOB_COUNT = #jobsFetch
	for k, v in ipairs(jobsFetch) do
		JOB_CACHE[v.Id] = v
	end

	TriggerEvent('Jobs:Server:UpdatedCache', job or -1)

	local govPromise = promise.new()
	Database.Game:aggregate({
        collection = 'jobs',
        aggregate = {
			{ ["$match"] = { Type = 'Government' } },
			{ ["$project"] = { ['Type'] = 1, ['Id'] = 1, ['Name'] = 1, ['Workplaces.Grades'] = 1, ['Workplaces.Id'] = 1 } },
            { ["$unwind"] = '$Workplaces' },
            { ["$unwind"] = '$Workplaces.Grades' },
        }
    }, function(success, results)
		if success and #results > 0 then
			for k, v in ipairs(results) do
				local key = string.format('JobPerms:%s:%s:%s', v.Id, v.Workplaces.Id, v.Workplaces.Grades.Id)
				GlobalState[key] = v.Workplaces.Grades.Permissions
			end
			govPromise:resolve(true)
		else
			govPromise:resolve(false)
		end
    end)

	local companyPromise = promise.new()
	Database.Game:aggregate({
        collection = 'jobs',
        aggregate = {
			{ ["$match"] = { Type = 'Company' } },
			{ ["$project"] = { ['Type'] = 1, ['Id'] = 1, ['Name'] = 1, ['Grades'] = 1 } },
            { ["$unwind"] = '$Grades' },
        }
    }, function(success, results)
		if success and #results > 0 then
			for k, v in ipairs(results) do
				local key = string.format('JobPerms:%s:false:%s', v.Id, v.Grades.Id)
				GlobalState[key] = v.Grades.Permissions
			end
			companyPromise:resolve(true)
		else
			companyPromise:resolve(false)
		end
    end)

	return Citizen.Await(promise.all({
		govPromise,
		companyPromise,
	}))
end

function RunStartup()
    if _ranStartup then return; end
    _ranStartup = true

	local function replaceExistingDefaultJob(_id, document)
		local p = promise.new()
		Database.Game:deleteOne({
			collection = 'jobs',
			query = {
				_id = _id,
			}
		}, function(success, deleted)
			if success then
				Database.Game:insertOne({
					collection = 'jobs',
					document = document,
				}, function(success, inserted)
					if not success or inserted <= 0 then
						Logger:Error('Jobs', 'Error Inserting Job on Default Job Update')
						p:resolve(false)
					else
						Wait(10000)
						p:resolve(true)
					end
				end)
			else
				Logger:Error('Jobs', 'Error Deleting Job on Default Job Update')
				p:resolve(false)
			end
		end)
		return p
	end

	local function insertDefaultJob(document)
		local p = promise.new()
		Database.Game:insertOne({
			collection = 'jobs',
			document = document,
		}, function(success, inserted)
			if not success or inserted <= 0 then
				Logger:Error('Jobs', 'Error Inserting Job on Default Job Update')
				p:resolve(false)
			else
				p:resolve(true)
			end
		end)
		return p
	end

	local jobsFetch = FindAllJobs()
	local currentData = {}
	for k, v in ipairs(jobsFetch) do
		currentData[v.Id] = v
	end

	local awaitingPromises = {}
	for k, v in ipairs(_defaultJobData) do
		local currentDataForJob = currentData[v.Id]
		if currentDataForJob and currentDataForJob.LastUpdated < v.LastUpdated then
			table.insert(awaitingPromises, replaceExistingDefaultJob(currentDataForJob._id, v))
		elseif not currentDataForJob then
			table.insert(awaitingPromises, insertDefaultJob(v))
		end
	end

	if #awaitingPromises > 0 then
		Citizen.Await(promise.all(awaitingPromises))
		Logger:Info('Jobs', 'Inserted/Replaced ^2' .. #awaitingPromises .. '^7 Default Jobs')
		jobsFetch = FindAllJobs()
	end

	RefreshAllJobData()
	Logger:Trace('Jobs', string.format('Loaded ^2%s^7 Jobs', JOB_COUNT))
	TriggerEvent('Jobs:Server:CompleteStartup')
end