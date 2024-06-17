AddEventHandler("Casino:Server:Startup", function()
    Chat:RegisterStaffCommand("setcasinovehicle", function(source, args, rawCommand)
        Callbacks:ClientCallback(source, "Vehicles:Admin:GetVehicleInsideData", false, function(vehData)
            if vehData and vehData.model then
                local newData = {
                    vehicle = vehData.model,
                    properties = vehData.properties,
                }

                if Casino.Config:Set("vehicle", newData) then
                    GlobalState["Casino:Vehicle"] = newData
                end
            end
        end)
    end, {
        help = "Set the Casino Vehicle to a Copy of the Vehicle You Are In",
        params = {},
    }, 0)

    Chat:RegisterStaffCommand("clearcasinovehicle", function(source, args, rawCommand)
        if Casino.Config:Set("vehicle", false) then
            GlobalState["Casino:Vehicle"] = false
        end
    end, {
        help = "Clear the Casino Vehicle",
        params = {},
    }, 0)

    while not _casinoConfigLoaded do
        Wait(250)
    end

    GlobalState["Casino:Vehicle"] = Casino.Config:Get("vehicle")

    Chat:RegisterStaffCommand("refreshcasinoint", function(source, args, rawCommand)
        TriggerClientEvent("Casino:Client:RefreshInt", source)
    end, {
        help = "Clear the Casino Vehicle",
        params = {},
    }, 0)
end)