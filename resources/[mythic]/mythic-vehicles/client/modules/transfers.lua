AddEventHandler('Vehicles:Client:StartUp', function()
    Callbacks:RegisterClientCallback('Vehicles:Transfers:GetTarget', function(data, cb)
        if LocalPlayer.state.loggedIn then
            if VEHICLE_INSIDE then
                return cb(VehToNet(VEHICLE_INSIDE))
            else
                local data = Targeting:GetEntityPlayerIsLookingAt()
                if data and data.entity and DoesEntityExist(data.entity) and IsEntityAVehicle(data.entity) then
                    return cb(VehToNet(data.entity))
                end
            end
        end
        cb(false)
    end)
end)

RegisterNetEvent('Vehicles:Tranfers:BeginConfirmation', function(data)
    Confirm:Show(
        'Confirm Vehicle Ownership Transfer',
        {
            yes = 'Vehicles:Transfers:Confirm',
            no = 'Vehicles:Transfers:Deny',
        },
        string.format(
            [[
                Please confirm that you would like to transfer the vehicle below to State ID %s.<br>
                Vehicle: %s %s<br>
                Plate: %s<br>
                VIN: %s<br>
            ]],
            data.SID,
            data.Make or 'Unknown',
            data.Model or 'Unknown',
            data.Plate,
            data.VIN
        ),
        {
            VIN = data.VIN,
            SID = data.SID,
        },
        'Deny',
        'Confirm'
    )
end)

AddEventHandler('Vehicles:Transfers:Confirm', function(data)
    Callbacks:ServerCallback('Vehicles:Tranfers:CompleteTransfer', data)
end)

AddEventHandler('Vehicles:Transfers:Deny', function(data)
    Notification:Error('Vehicle Transfer Cancelled')
end)