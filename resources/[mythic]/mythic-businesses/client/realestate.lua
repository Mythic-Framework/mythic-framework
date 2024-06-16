AddEventHandler('Businesses:Client:Startup', function()
    Targeting.Zones:AddBox("realestate-clockinoff", "clock", vector3(-700.38, 268.23, 83.15), 1.0, 2.2, {
		heading = 25,
		--debugPoly=true,
		minZ = 82.15,
		maxZ = 83.75
	}, {
        {
            icon = "clipboard-check",
            text = "Clock In",
            event = "Restaurant:Client:ClockIn",
			data = { job = 'realestate' },
			jobPerms = {
				{
					job = 'realestate',
					reqOffDuty = true,
				}
			},
        },
        {
            icon = "clipboard",
            text = "Clock Out",
            event = "Restaurant:Client:ClockOut",
			data = { job = 'realestate' },
			jobPerms = {
				{
					job = 'realestate',
					reqDuty = true,
				}
			},
        },
    }, 3.0, true)
end)