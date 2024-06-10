AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Minigame = exports["mythic-base"]:FetchComponent("Minigame")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	Status = exports["mythic-base"]:FetchComponent("Status")
	Labor = exports["mythic-base"]:FetchComponent("Labor")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Confirm = exports["mythic-base"]:FetchComponent("Confirm")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	NetSync = exports["mythic-base"]:FetchComponent("NetSync")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Labor", {
		"Logger",
		"Callbacks",
		"Game",
		"Phone",
		"PedInteraction",
		"Interaction",
		"Progress",
		"Minigame",
		"Notification",
		"ListMenu",
		"Blips",
		"Polyzone",
		"Targeting",
		"Hud",
		"Inventory",
		"EmergencyAlerts",
		"Status",
		"Labor",
		"Sounds",
		"Properties",
		"Action",
		"Sync",
		"Confirm",
		"Utils",
		"Keybinds",
		"Reputation",
		"NetSync",
		"Vehicles",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		TriggerEvent("Labor:Client:Setup")
	end)
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.25, 0.25)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 245)
	SetTextOutline(true)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
	TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

	Citizen.Wait(100)

	while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
		Citizen.Wait(0)
	end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
	Callbacks:ServerCallback("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
	Callbacks:ServerCallback("Labor:DeclineRequest", data)
end)

LABOR = {
	Get = {
		Jobs = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetJobs", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
		Groups = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetGroups", {}, function(groups)
				p:resolve(groups)
			end)
			return Citizen.Await(p)
		end,
		Reputations = function(self)
			local p = promise.new()
			Callbacks:ServerCallback("Labor:GetReputations", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
	},
}
