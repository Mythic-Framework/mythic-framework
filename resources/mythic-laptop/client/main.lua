_openCd = false -- Prevents spamm open/close
_settings = {}
_loggedIn = false

local _ignoreEvents = {
	"Health",
	"HP",
	"Armor",
	"Status",
	"Damage",
	"Wardrobe",
	"Animations",
	"Ped",
}

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Labor = exports["mythic-base"]:FetchComponent("Labor")
	Jail = exports["mythic-base"]:FetchComponent("Jail")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	NetSync = exports["mythic-base"]:FetchComponent("NetSync")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Laptop = exports["mythic-base"]:FetchComponent("Laptop")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Laptop", {
		"Callbacks",
		"Logger",
		"Notification",
		"UISounds",
		"Sounds",
		"Hud",
		"Keybinds",
		"Interaction",
		"Inventory",
		"Hud",
		"Targeting",
		"ListMenu",
		"Labor",
		"Jail",
		"Blips",
		"Reputation",
		"Polyzone",
		"NetSync",
		"Vehicles",
		"Progress",
		"Jobs",
		"Laptop",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
	end)
end)

AddEventHandler("Inventory:Client:ItemsLoaded", function()
	while Laptop == nil do
		Citizen.Wait(10)
	end
	Laptop.Data:Set('items', Inventory.items:GetData())
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if hasValue(_ignoreEvents, key) then
		return
	end
	_settings = LocalPlayer.state.Character:GetData("LaptopSettings")
	Laptop.Data:Set("player", LocalPlayer.state.Character:GetData())

	if
		key == "States"
		and LocalPlayer.state.laptopOpen
		and (not hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP"))
	then
		Laptop:Close()
	end
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	Laptop.Data:Set("onDuty", state)
end)

RegisterNetEvent("UI:Client:Reset", function(manual)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "UI_RESET",
		data = {},
	})

	if manual then
		TriggerServerEvent("Laptop:Server:UIReset")
		if LocalPlayer.state.tabletOpen then
			Laptop:Close()
		end
	end
end)

AddEventHandler("UI:Client:Close", function(context)
	if context ~= "laptop" then
		Laptop:Close()
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if LocalPlayer.state.laptopOpen then
		Laptop:Close()
	end
end)

RegisterNetEvent("Laptop:Client:SetApps", function(apps)
	LAPTOP_APPS = apps
	SendNUIMessage({
		type = "SET_APPS",
		data = apps,
	})
end)

AddEventHandler("Characters:Client:Spawn", function()
	_loggedIn = true

	if LocalPlayer.state.Character then
		local settings = LocalPlayer.state.Character:GetData("LaptopSettings")
		if settings then
			Laptop:SetExpanded(settings.Expanded)
		end
	end

	Citizen.CreateThread(function()
		while _loggedIn do
			SendNUIMessage({
				type = "SET_TIME",
				data = GlobalState["Sync:Time"],
			})
			Citizen.Wait(15000)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_loggedIn = false
end)

function hasValue(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

RegisterNUICallback("UpdateAlias", function(data, cb)
	Callbacks:ServerCallback("Laptop:UpdateAlias", data, cb)
end)

RegisterNUICallback("AcceptPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)

RegisterNUICallback("CancelPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)