AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Status = exports["mythic-base"]:FetchComponent("Status")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Jail = exports["mythic-base"]:FetchComponent("Jail")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Input = exports["mythic-base"]:FetchComponent("Input")
	Arcade = exports["mythic-base"]:FetchComponent("Arcade")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Arcade", {
		"Callbacks",
		"Logger",
		"Notification",
		"Hud",
		"Targeting",
		"Status",
		"Progress",
		"PedInteraction",
		"Keybinds",
		"Jail",
		"Sounds",
		"Animations",
        "Weapons",
        "Jobs",
		"Input",
		"Arcade",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

        TriggerEvent("Arcade:Client:Setup")

        PedInteraction:Add("ArcadeMaster", `IG_OldRichGuy`, vector3(-1658.916, -1062.421, 11.160), 228.868, 25.0, {
            {
                icon = "clipboard-check",
                text = "Clock In",
                event = "Arcade:Client:ClockIn",
                data = { job = "avast_arcade" },
                jobPerms = {
                    {
                        job = "avast_arcade",
						reqOffDuty = true,
                    }
                },
            },
            {
                icon = "clipboard",
                text = "Clock Out",
                event = "Arcade:Client:ClockOut",
                data = { job = "avast_arcade" },
                jobPerms = {
                    {
                        job = "avast_arcade",
                        reqDuty = true,
                    }
                },
            },
			{
				icon = "heart-pulse",
				text = "Open Arcade",
				event = "Arcade:Client:Open",
                jobPerms = {
                    {
                        job = "avast_arcade",
                        reqDuty = true,
                    }
                },
				isEnabled = function()
                    return not GlobalState["Arcade:Open"]
				end,
			},
			{
				icon = "heart-pulse",
				text = "Close Arcade",
				event = "Arcade:Client:Close",
                jobPerms = {
                    {
                        job = "arcade",
                        reqDuty = true,
                    }
                },
				isEnabled = function()
                    return GlobalState["Arcade:Open"]
				end,
			},
			{
				icon = "heart-pulse",
				text = "Create New Game",
				event = "Arcade:Client:CreateNew",
				isEnabled = function()
                    return GlobalState["Arcade:Open"]
				end,
			},
		}, "joystick", "WORLD_HUMAN_STAND_IMPATIENT")
	end)
end)

AddEventHandler("Arcade:Client:ClockIn", function(_, data)
	if data and data.job then
		Jobs.Duty:On(data.job)
	end
end)

AddEventHandler("Arcade:Client:ClockOut", function(_, data)
	if data and data.job then
		Jobs.Duty:Off(data.job)
	end
end)

AddEventHandler("Arcade:Client:Open", function()
    Callbacks:ServerCallback("Arcade:Open", false, function()
    
    end)
end)

AddEventHandler("Arcade:Client:Close", function()
    Callbacks:ServerCallback("Arcade:Close", false, function()
    
    end)
end)

AddEventHandler("Arcade:Client:CreateNew", function(entity, data)
	Input:Show("Create New Match", "Match Configuration", {
		{
			id = "gamemode",
			type = "select",
			select = {
				{
					label = "Team Deathmatch",
					value = "tdm",
				}
			},
			options = {},
		},
		{
			id = "map",
			type = "select",
			select = {
				{
					label = "Random",
					value = "random",
				},
				{
					label = "Legion Square",
					value = "legionsquare",
				},
			},
			options = {},
		},
	}, "Arcade:Client:SubmitGame", data)
end)

_ARCADE = {
	Gamemode = {
		Register = function(self, id, label)

		end,
	}
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["mythic-base"]:RegisterComponent("Arcade", _ARCADE)
end)

