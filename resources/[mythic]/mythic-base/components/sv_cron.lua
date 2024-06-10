local _jobs = {}
local LastTime = nil

AddEventHandler('Proxy:Shared:RegisterReady', function()
    if LastTime == nil then
        LastTime = GetTime()
        CronTick()
    end
end)

function GetTime()
    local date = os.date("*t")

    return {
        day = date.wday,
        hour = date.hour,
        min = date.min
    }
end

function OnTime(day, hour, min)
    for k, v in pairs(_jobs) do
        if v.pause or v.skip then
            if v.skip then
                v.skip = false
            end
        else
            if v.day == day and v.hour == hour and v.min == min then
                v.callback()
            end
        end
    end
end

function CronTick()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(60000)
            local time = GetTime()
        
            if time.hour ~= LastTime.hour or time.min ~= LastTime.min then
                OnTime(time.day, time.hour, time.min)
                LastTime = time
            end
        end
    end)
end

COMPONENTS.Cron = {
    _required = { 'Register', 'Delete', 'Pause', 'Resume', 'Skip' },
    _name = 'base',
    Register = function(self, id, day, hour, min, cb)
        if _jobs[id] ~= nil then
            COMPONENTS.Logger:Warn('Cron', 'Overriding Already Existing Cron Job: '.. id, { console = true })
        end

        _jobs[id] = {
            id = id,
            day = day,
            hour = hour,
            min = min,
            pause = false,
            skip = false,
            callback = cb
        }
    end,
    Delete = function(self, id)
        if _jobs[id] ~= nil then
            _jobs[id] = nil
        else
            COMPONENTS.Logger:Warn('Cron', 'Attempt To Delete Non-Existing Cron Job: ' .. id, { console = true })
        end
    end,
    Pause = function(self, id)
        if _jobs[id] ~= nil then
            _jobs[id].pause = true
        else
            COMPONENTS.Logger:Warn('Cron', 'Attempt To Pause Non-Existing Cron Job: ' .. id, { console = true })
        end
    end,
    Resume = function(self, id)
        if _jobs[id] ~= nil then
            _jobs[id].pause = false
        else
            COMPONENTS.Logger:Warn('Cron', 'Attempt To Resume Non-Existing Cron Job: ' .. id, { console = true })
        end
    end,
    Skip = function(self, id)
        if _jobs[id] ~= nil then
            _jobs[id].skip = false
            _jobs[id].pause = false
        else
            COMPONENTS.Logger:Warn('Cron', 'Attempt To Skip Non-Existing Cron Job: ' .. id, { console = true })
        end
    end
}