RegisterNetEvent("Damage:Client:RecieveUpdate", function(h)
	Damage:Heal(h)
end)

AddEventHandler("Damage:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Status = exports["mythic-base"]:FetchComponent("Status")
	Hospital = exports["mythic-base"]:FetchComponent("Hospital")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Jail = exports["mythic-base"]:FetchComponent("Jail")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Damage", {
		"Callbacks",
		"Damage",
		"Logger",
		"Notification",
		"Hud",
		"Targeting",
		"Status",
		"Hospital",
		"Progress",
		"EmergencyAlerts",
		"PedInteraction",
		"Keybinds",
		"Jail",
		"Sounds",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Callbacks:RegisterClientCallback("Damage:ApplyPainkiller", function(data, cb)
			LocalPlayer.state.onPainKillers = data
			LocalPlayer.state.wasOnPainKillers = true
		end)

		Callbacks:RegisterClientCallback("Damage:ApplyAdrenaline", function(data, cb)
			LocalPlayer.state.onDrugs = data
			LocalPlayer.state.wasOnDrugs = true
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Damage", DAMAGE)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	Hud:Dead(false)
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "Damage" then
		LocalDamage = LocalPlayer.state.Character:GetData("Damage")
		local t = {}
		for k, v in pairs(LocalDamage.Limbs) do
			if v.severity > 0 then
				t[k] = {
					label = v.label,
					severity = v.severity,
				}
			end
		end
		_damagedLimbs = t
	end
end)

AddEventHandler("Characters:Client:Spawn", function()
	LocalDamage = LocalPlayer.state.Character:GetData("Damage")
	Callbacks:ServerCallback("Damage:CheckDead", {}, function(isDead)
		local p = PlayerPedId()
		if isDead or GetEntityHealth(p) <= GetEntityMaxHealth(p) / 2 then
			diecunt(p)
		end
	end)
	
	local t = {}
	for k, v in pairs(LocalDamage.Limbs) do
		if v.severity > 0 then
			t[k] = {
				label = v.label,
				severity = v.severity,
			}
		end
	end
	_damagedLimbs = t

	StartTracking()
end)
