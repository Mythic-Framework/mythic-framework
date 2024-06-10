AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	ObjectPlacer = exports["mythic-base"]:FetchComponent("ObjectPlacer")
	Minigame = exports["mythic-base"]:FetchComponent("Minigame")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Drugs", {
        "Callbacks",
        "Inventory",
        "Targeting",
        "Progress",
        "Hud",
        "Notification",
        "ObjectPlacer",
		"Minigame",
		"ListMenu",
		"PedInteraction",
		"Polyzone",
	}, function(error)
		if #error > 0 then 
            exports["mythic-base"]:FetchComponent("Logger"):Critical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

        TriggerEvent("Drugs:Client:Startup")
	end)
end)