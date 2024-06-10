AddEventHandler('Characters:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Middleware = exports['mythic-base']:FetchComponent('Middleware')
	Database = exports['mythic-base']:FetchComponent('Database')
	Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
	DataStore = exports['mythic-base']:FetchComponent('DataStore')
	Logger = exports['mythic-base']:FetchComponent('Logger')
	Database = exports['mythic-base']:FetchComponent('Database')
	Fetch = exports['mythic-base']:FetchComponent('Fetch')
	Logger = exports['mythic-base']:FetchComponent('Logger')
	Chat = exports['mythic-base']:FetchComponent('Chat')
	GlobalConfig = exports['mythic-base']:FetchComponent('Config')
	Routing = exports['mythic-base']:FetchComponent('Routing')
	Sequence = exports['mythic-base']:FetchComponent('Sequence')
	Reputation = exports['mythic-base']:FetchComponent('Reputation')
	Apartment = exports['mythic-base']:FetchComponent('Apartment')
	RegisterCommands()
	_spawnFuncs = {}
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mythic-base']:RequestDependencies('Characters', {
		'Callbacks',
		'Database',
		'Middleware',
		'DataStore',
		'Logger',
		'Database',
		'Fetch',
		'Logger',
		'Chat',
		'Config',
		'Routing',
		'Sequence',
		'Reputation',
		'Apartment',
	}, function(error)
		if #error > 0 then return end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		Startup()
	end)
end)