
AddEventHandler("Businesses:Server:Startup", function()
    GlobalState["rockford_dj"] = false

    Callbacks:RegisterServerCallback("Businesses:ToggleRockfordStage", function(source, data, cb)
        if Player(source).state.onDuty == "rockford_records" then
            GlobalState["rockford_dj"] = not GlobalState["rockford_dj"]

            cb(GlobalState["rockford_dj"])
        else
            cb(false)
        end
    end)
end)