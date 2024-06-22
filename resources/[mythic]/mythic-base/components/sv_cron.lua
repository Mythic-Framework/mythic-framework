local _jobs = {}
local lastTime = nil

local function getTime()
    local date = os.date("*t")

    return {
        day = date.wday,
        hour = date.hour,
        min = date.min
    }
end

local function onTime(day, hour, min)
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

local function cronTick()
    CreateThread(function()
        while true do
            Wait(60000)
            local time = getTime()

            if not lastTime then
                lastTime = time
            end

            if time.hour ~= lastTime.hour or time.min ~= lastTime.min then
                onTime(time.day, time.hour, time.min)
                lastTime = time
            end
        end
    end)
end

AddEventHandler('Proxy:Shared:RegisterReady', function()
    if not lastTime then
        lastTime = getTime()
        cronTick()
    end
end)

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