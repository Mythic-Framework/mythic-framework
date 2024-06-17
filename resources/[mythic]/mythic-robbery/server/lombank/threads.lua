local _threading = false
function StartLombankThreads()
    if _threading then return end
    _threading = true

    CreateThread(function()
        while _threading do
            if _lbGlobalReset ~= nil then
                if os.time() > _lbGlobalReset then
					Logger:Info("Robbery", "Lombank Heist Has Been Reset")
                    ResetLombank()
                end
            end
            Wait(30000)
        end
    end)

    CreateThread(function()
        while _threading do
            local powerDisabled = IsLBPowerDisabled()
            if not powerDisabled and not Doors:IsLocked("lombank_hidden_entrance") then
                Doors:SetLock("lombank_hidden_entrance", true)
                Doors:SetLock("lombank_lasers", true)
            elseif powerDisabled and Doors:IsLocked("lombank_hidden_entrance") then
                Doors:SetLock("lombank_hidden_entrance", false)
            end
            Wait((1000 * 60) * 1)
        end
    end)

    CreateThread(function()
        while _threading do
            for i = #_unlockingDoors, 1, -1 do
                local v = _unlockingDoors[i]
                if os.time() > v.expires then
                    Doors:SetLock(v.door, false)
                    if v.forceOpen then
                        Doors:SetForcedOpen(v.door)
                    end
                    Execute:Client(v.source, "Notification", "Info", "Door Unlocked")
                    table.remove(_unlockingDoors, i)
                end
            end
            Wait(30000)
        end
    end)

    CreateThread(function()
        while _threading do
            if _lbGlobalReset ~= nil and os.time() > _lbGlobalReset then
                ResetLombank()
                _lbGlobalReset = nil
            end
            Wait(60000)
        end
    end)

    -- CreateThread(function()
    --     while _threading do
    --         local powerDisabled = IsLBPowerDisabled()
    --         if not powerDisabled and not Doors:IsLocked("lombank_hidden_entrance") then
    --             Doors:SetLock("lombank_hidden_entrance", true)
    --         end
    --         Wait((1000 * 60) * 1)
    --     end
    -- end)
end