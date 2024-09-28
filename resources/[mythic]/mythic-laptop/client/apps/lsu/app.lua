local disabledContracts = {}

RegisterNetEvent("Laptop:Client:Spawn", function(data)

end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
    while not GlobalState.LSUPickupLocation do
        Wait(100)
    end

    PedInteraction:Add("lsu-pickup-guy", `s_m_y_dockwork_01`, GlobalState.LSUPickupLocation.coords, GlobalState.LSUPickupLocation.heading, 50.0, {
		{
			icon = "box-archive",
			text = "Collect Order",
			event = "Laptop:Client:LSUnderground:Collect",
		},
	}, 'truck-ramp-box', 'WORLD_HUMAN_SMOKING', true)
end)

LAPTOP.LSUnderground = {

}

RegisterNUICallback("GetLSUDetails", function(data, cb)
	Callbacks:ServerCallback("Laptop:LSUnderground:GetDetails", {}, function(data)
        cb(data)
    end)
end)

RegisterNUICallback("LSUNDG:Market:Checkout", function(data, cb)
	Callbacks:ServerCallback("Laptop:LSUnderground:Market:Checkout", data, function(data)
        cb(data)

        if data?.success and data.coords then
            Blips:Add(
                "lsu-pickup-location",
                "LSUNDG Pickup Location",
                data.coords,
                478,
                17,
                0.7,
                2,
                false,
                false
            )

            ClearGpsPlayerWaypoint()
            SetNewWaypoint(data.coords.x, data.coords.y)
        end
    end)
end)

RegisterNUICallback("Boosting:EnterQueue", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:EnterQueue", {}, cb)
end)

RegisterNUICallback("Boosting:ExitQueue", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:ExitQueue", {}, cb)
end)

RegisterNUICallback("Boosting:AcceptContract", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:AcceptContract", data, function(res)
        if res?.success then
            Laptop.Data:Add("disabledBoostingContracts", data.id)

            Citizen.SetTimeout(120000, function()
                Laptop.Data:Remove("disabledBoostingContracts", data.id)
            end)
        end

        cb(res)
    end)
end)

RegisterNUICallback("Boosting:TransferContract", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:TransferContract", data, cb)
end)

RegisterNUICallback("Boosting:DeclineContract", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:DeclineContract", data, cb)
end)

AddEventHandler("Laptop:Client:LSUnderground:Collect", function()
    Callbacks:ServerCallback("Laptop:LSUnderground:Market:Collect", {})
end)

RegisterNUICallback("Boosting:Admin:CreateContract", function(data, cb)

    if data?.vehicle then
        local h = GetHashKey(data.vehicle)
        if not IsModelValid(h) or not IsModelAVehicle(h) then

            cb({
                success = false,
                message = 'Invalid Vehicle (Doesn\'t Exist)'
            })
            return
        end
    end

    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Admin:CreateContract", data, cb)
end)

RegisterNUICallback("Boosting:Admin:GetBans", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Admin:GetBans", data, cb)
end)

RegisterNUICallback("Boosting:Admin:Ban", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Admin:Ban", data, cb)
end)

RegisterNUICallback("Boosting:Admin:Unban", function(data, cb)
    Callbacks:ServerCallback("Laptop:LSUnderground:Boosting:Admin:Unban", data, cb)
end)