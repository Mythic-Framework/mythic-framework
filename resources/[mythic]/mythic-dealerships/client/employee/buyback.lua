AddEventHandler("Dealerships:Client:StartBuyback", function(entity, data)
    print(json.encode(entity))

    local vehNet = VehToNet(entity.entity)
    local vehEnt = Entity(entity.entity)

    Callbacks:ServerCallback("Dealerships:BuyBackStart", {
        netId = vehNet,
        dealerId = LocalPlayer.state.onDuty,
    }, function(success, data, strikes, price, strikeLoss)
        if success then
            local dealerData = _dealerships[LocalPlayer.state.onDuty]

            Confirm:Show(
                string.format("Confirm %s Vehicle Buy Back", dealerData.abbreviation),
                {
                    yes = "Dealerships:BuyBack:Confirm",
                    no = "Dealerships:BuyBack:Deny",
                },
                string.format(
                    [[
                        Please confirm that %s wants to buy back this vehicle.<br>
                        Vehicle: %s %s<br>
                        Class: %s<br>
                        Plate: %s<br>
                        VIN: %s<br>
                        Buyback Price: $%s %s<br>
                    ]],
                    dealerData.name,
                    data.make or "Unknown",
                    data.model or "Unknown",
                    data.class or "?",
                    vehEnt.state.RegisteredPlate,
                    vehEnt.state.VIN,
                    formatNumberToCurrency(price),
                    strikes > 0 and string.format("<i>-$%s (%s Strikes)</i>", formatNumberToCurrency(strikeLoss), strikes) or ""
                ),
                {
                    netId = vehNet,
                    dealerId = LocalPlayer.state.onDuty,
                },
                "Deny",
                "Confirm"
            )
        else
            if data then
                Notification:Error(data)
            else
                Notification:Error("Error")
            end
        end
    end)
end)

AddEventHandler("Dealerships:BuyBack:Confirm", function(data)
    Callbacks:ServerCallback("Dealerships:BuyBack", data, function(success)
        
    end)
end)

AddEventHandler("Dealerships:BuyBack:Deny", function(data)
    Notification:Error("Vehicle Buy Back Cancelled")
end)