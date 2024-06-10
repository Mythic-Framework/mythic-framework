AddEventHandler("Businesses:Client:Startup", function()
    Targeting.Zones:AddBox("triad_boxing_receptionist", "boxing-glove", vector3(1072.02, -2400.65, 25.9), 1.8, 0.6, {
        heading = 355,
        --debugPoly=true,
        minZ = 24.9,
        maxZ = 26.3
	}, {
        {
            icon = "door-open",
            text = "Lock/Unlock Arena Door",
            event = "Businesses:Client:ToggleTriadBoxingLock",
			jobPerms = {
				{
					job = "triad_boxing",
					--reqOffDuty = true,
				}
			},
        },
    }, 3.0, true)
end)

AddEventHandler("Businesses:Client:ToggleTriadBoxingLock", function()
    Callbacks:ServerCallback("Doors:ToggleLocks", "triad_boxing_arena", function(success, newState)
        if success then
            Sounds.Do.Play:One("doorlocks.ogg", 0.2)
        end
    end)
end)