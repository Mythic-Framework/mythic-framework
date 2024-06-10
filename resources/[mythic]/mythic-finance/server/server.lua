AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
    Execute = exports["mythic-base"]:FetchComponent("Execute")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
    Chat = exports["mythic-base"]:FetchComponent("Chat")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Generator = exports["mythic-base"]:FetchComponent("Generator")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
    Banking = exports["mythic-base"]:FetchComponent("Banking")
	Billing = exports["mythic-base"]:FetchComponent("Billing")
	Loans = exports["mythic-base"]:FetchComponent("Loans")
    Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Tasks = exports["mythic-base"]:FetchComponent("Tasks")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Finance", {
		"Fetch",
		"Utils",
        "Execute",
        "Chat",
		"Database",
		"Middleware",
		"Callbacks",
		"Logger",
		"Generator",
		"Phone",
        "Wallet",
        "Banking",
		"Billing",
		"Loans",
		"Crypto",
		"Jobs",
		"Tasks",
		"Vehicles",
		"Inventory",
	}, function(error)
		if #error > 0 then
			exports["mythic-base"]:FetchComponent("Logger"):Critical("Finance", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent('Finance:Server:Startup')
	end)
end)