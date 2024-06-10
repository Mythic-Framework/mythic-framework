AddEventHandler("Restaurant:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Restaurant", {
		"Callbacks",
		"Inventory",
		"Targeting",
        "Notification",
		"Jobs",
		"Blips",
	}, function(error)
		if error then
		end
		RetrieveComponents()
        Startup()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Restaurant", _RESTAURANT)
end)

function Startup()
	Targeting.Zones:AddBox("burgershot-clockinoff", "chess-clock", vector3(-1189.17, -901.79, 13.97), 2.2, 2, {
		heading = 30,
		--debugPoly=true,
		minZ = 12.37,
		maxZ = 15.77
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'burgershot' },
			jobPerms = {
				{
					job = 'burgershot',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'burgershot' },
			jobPerms = {
				{
					job = 'burgershot',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("lasttrain-clockinoff", "chess-clock", vector3(-384.8, 268.03, 86.46), 1, 0.8, {
		heading = 305,
        --debugPoly = true,
		minZ = 86.41,
		maxZ = 87.41
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'lasttrain' },
			jobPerms = {
				{
					job = 'lasttrain',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'lasttrain' },
			jobPerms = {
				{
					job = 'lasttrain',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("triad-clockinoff", "chess-clock", vector3(-830.56, -730.64, 28.06), 1, 1, {
		heading = 0,
		--debugPoly=true,
		minZ = 27.06,
		maxZ = 28.66
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'triad' },
			jobPerms = {
				{
					job = 'triad',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'triad' },
			jobPerms = {
				{
					job = 'triad',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("uwu-clockinoff", "chess-clock", vector3(-593.97, -1053.52, 22.34), 0.6, 2.8, {
		heading = 90,
		--debugPoly=true,
		minZ = 21.94,
		maxZ = 23.94
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'uwu' },
			jobPerms = {
				{
					job = 'uwu',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'uwu' },
			jobPerms = {
				{
					job = 'uwu',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("pizza_this-clockinoff", "chess-clock", vector3(804.4, -760.87, 31.27), 1, 1, {
		heading = 0,
		--debugPoly=true,
		minZ = 30.27,
		maxZ = 32.07
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'pizza_this' },
			jobPerms = {
				{
					job = 'pizza_this',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'pizza_this' },
			jobPerms = {
				{
					job = 'pizza_this',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("avast_arcade-clockinoff", "chess-clock", vector3(-1659.51, -1061.26, 12.16), 1, 1, {
		name = "duty",
		heading = 46,
		--debugPoly=true,
		minZ = 11.56,
		maxZ = 13.36
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'avast_arcade' },
			jobPerms = {
				{
					job = 'avast_arcade',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'avast_arcade' },
			jobPerms = {
				{
					job = 'avast_arcade',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("bballs-clockinoff", "bowling-ball", vector3(755.73, -775.51, 26.34), 1.0, 0.6, {
		heading = 0,
		--debugPoly=true,
		minZ = 26.34,
		maxZ = 27.14
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'bowling' },
			jobPerms = {
				{
					job = 'bowling',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'bowling' },
			jobPerms = {
				{
					job = 'bowling',
					reqDuty = true,
				}
			},
        },
		{
			icon = "tv",
            text = "Set TV Link",
            event = "Bowling:Client:SetTV",
			jobPerms = {
				{
					job = 'bowling',
					reqDuty = true,
				}
			},
        },
		{
			icon = "bowling-pins",
			text = "Reset All Lanes",
			event = "Bowling:Client:ResetAll",
			data = { job = 'bowling' },
			jobPerms = {
				{
					job = 'bowling',
					reqDuty = true,
				}
			},
		},
		{
            icon = "bowling-pins",
            text = "Clear Pins",
            event = "Bowling:Client:ClearPins",
			jobPerms = {
				{
					job = 'bowling',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("beanmachine-clockinoff", "chess-clock", vector3(126.86, -1035.47, 29.28), 2.0, 0.4, {
		heading = 340,
		--debugPoly=true,
		minZ = 28.48,
		maxZ = 31.48
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'beanmachine' },
			jobPerms = {
				{
					job = 'beanmachine',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'beanmachine' },
			jobPerms = {
				{
					job = 'beanmachine',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("vu-clockinoff", "chess-clock", vector3(133.06, -1286.17, 29.27), 0.9, 0.7, {
		heading = 30,
		--debugPoly=true,
		minZ = 29.07,
		maxZ = 30.07
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'unicorn' },
			jobPerms = {
				{
					job = 'unicorn',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'unicorn' },
			jobPerms = {
				{
					job = 'unicorn',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("vu-clockinoff2", "chess-clock", vector3(102.0, -1299.66, 28.77), 1, 1, {
		heading = 30,
		--debugPoly=true,
		minZ = 28.37,
		maxZ = 30.77
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'unicorn' },
			jobPerms = {
				{
					job = 'unicorn',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'unicorn' },
			jobPerms = {
				{
					job = 'unicorn',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("bakery-clockinoff", "chess-clock", vector3(-1264.53, -291.36, 37.39), 0.6, 1, {
		heading = 20,
		--debugPoly=true,
		minZ = 36.39,
		maxZ = 37.99
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'bakery' },
			jobPerms = {
				{
					job = 'bakery',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'bakery' },
			jobPerms = {
				{
					job = 'bakery',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("noodle-clockinoff", "chess-clock", vector3(-1185.77, -1149.25, 7.67), 0.8, 2, {
		heading = 15,
		--debugPoly=true,
		minZ = 6.67,
		maxZ = 8.87
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'noodle' },
			jobPerms = {
				{
					job = 'noodle',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'noodle' },
			jobPerms = {
				{
					job = 'noodle',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("tequila-clockinoff", "chess-clock", vector3(-562.95, 283.25, 82.18), 1, 1, {
		heading = 0,
		--debugPoly=true,
		minZ = 81.58,
		maxZ = 83.38
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'tequila' },
			jobPerms = {
				{
					job = 'tequila',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'tequila' },
			jobPerms = {
				{
					job = 'tequila',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("rockford_records-clockinoff", "chess-clock", vector3(-1004.61, -269.61, 39.04), 1.2, 2.2, {
		heading = 20,
		--debugPoly=true,
		minZ = 38.44,
		maxZ = 40.24
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'rockford_records' },
			jobPerms = {
				{
					job = 'rockford_records',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'rockford_records' },
			jobPerms = {
				{
					job = 'rockford_records',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("rockford_records-clockinoff2", "chess-clock", vector3(-990.76, -279.55, 38.2), 0.8, 3.0, {
		heading = 25,
		--debugPoly=true,
		minZ = 37.6,
		maxZ = 39.4
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'rockford_records' },
			jobPerms = {
				{
					job = 'rockford_records',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'rockford_records' },
			jobPerms = {
				{
					job = 'rockford_records',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)

	Targeting.Zones:AddBox("prego-clockinoff", "chess-clock", vector3(-1122.19, -1456.06, 5.11), 0.6, 1.6, {
		heading = 35,
		--debugPoly=true,
		minZ = 4.71,
		maxZ = 6.71
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'prego' },
			jobPerms = {
				{
					job = 'prego',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'prego' },
			jobPerms = {
				{
					job = 'prego',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)
end

_RESTAURANT = {}

RegisterNetEvent("Restaurant:Client:CreatePoly", function(pickups, warmersList, onSpawn)
	for k, v in ipairs(pickups) do
		local data = GlobalState[string.format("Restaurant:Pickup:%s", v)]
		if data ~= nil then
			Targeting.Zones:AddBox(data.id, "fork-knife", data.coords, data.width, data.length, data.options, {
				{
					icon = "fork-knife",
					text = string.format("Pickup Order (#%s)", data.num),
					event = "Restaurant:Client:Pickup",
					data = data.data,
				},
				{
					icon = "money-check-dollar-pen",
					text = "Set Contactless Payment",
					event = "Businesses:Client:CreateContactlessPayment",
					isEnabled = function(data)
						return not GlobalState[string.format("PendingContactless:%s", data.id)]
					end,
					data = data,
					jobPerms = {
						{
							job = data.job,
							reqDuty = true,
						}
					},
				},
				{
					icon = "money-check-dollar-pen",
					text = "Clear Contactless Payment",
					event = "Businesses:Client:ClearContactlessPayment",
					isEnabled = function(data)
						return GlobalState[string.format("PendingContactless:%s", data.id)]
					end,
					data = data,
					jobPerms = {
						{
							job = data.job,
							reqDuty = true,
						}
					},
				},
				{
					icon = "money-check-dollar",
					isEnabled = function(data)
						return GlobalState[string.format("PendingContactless:%s", data.id)] and GlobalState[string.format("PendingContactless:%s", data.id)] > 0
					end,
					textFunc = function(data)
						if GlobalState[string.format("PendingContactless:%s", data.id)] and GlobalState[string.format("PendingContactless:%s", data.id)] > 0 then
							return string.format("Pay Contactless ($%s)", GlobalState[string.format("PendingContactless:%s", data.id)])
						end
					end,
					event = "Businesses:Client:PayContactlessPayment",
					data = data,
					item = "phone",
				},
			}, 2.0, true)
		end
	end

	for k, v in ipairs(warmersList) do
		for k2, v2 in ipairs(v) do
			local data = GlobalState[string.format("Restaurant:Warmers:%s", v2)]
			if data ~= nil then
				local icon = data.fridge and "refrigerator" or "oven"
				Targeting.Zones:AddBox(data.id, icon, data.coords, data.width, data.length, data.options, {
					{
						icon = icon,
						text = data.fridge and "Open Fridge" or "Open Warmer",
						event = "Restaurant:Client:Pickup",
						jobDuty = true,
						data = data.data,
					},
				}, 2.0, true)
			end
		end
	end

	if not onSpawn then
		Targeting.Zones:Refresh()
	end
end)

AddEventHandler("Restaurant:Client:Pickup", function(entity, data)
	Inventory.Dumbfuck:Open(data.inventory)
end)

AddEventHandler("Restaurant:Client:ClockIn", function(_, data)
	if data and data.job then
		Jobs.Duty:On(data.job)
	end
end)

AddEventHandler("Restaurant:Client:ClockOut", function(_, data)
	if data and data.job then
		Jobs.Duty:Off(data.job)
	end
end)