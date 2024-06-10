local _dThread = false

function StartDashboardThread()
    if _dThread then return; end
    _dThread = true

    Citizen.CreateThread(function()
        GlobalState.AdminPlayerHistory = {}
        Citizen.Wait(5000)
        while true do
            local t = GlobalState.AdminPlayerHistory or {}
            if #t >= 12 then
                table.remove(t, 1)
            end

            table.insert(t, {
                count = Fetch:Count(),
                time = os.time(),
            })

            GlobalState.AdminPlayerHistory = t

            Citizen.Wait((1000 * 60) * 30)
        end
    end)
end