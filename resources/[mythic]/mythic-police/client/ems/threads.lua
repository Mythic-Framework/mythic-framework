

AddEventHandler('Characters:Client:Spawn', function()
    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            for k, v in pairs(_evald) do
                if (GetGameTimer() - v) >= 600000 then
                    _evald[k] = nil
                end
            end
            Wait(10000)
        end
    end)
end)