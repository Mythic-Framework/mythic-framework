function RegisterChatCommands()
    Chat:RegisterAdminCommand('freezetime', function(source, args, rawCommand)
        Sync:FreezeTime()
        Chat.Send.Server:Single(source, 'Time Has Been '.. (Sync.Get:TimeFrozen() and 'Frozen' or 'Unfrozen'))
    end, {
        help = 'Freeze Time',
        params = {}
    })

    Chat:RegisterAdminCommand('freezeweather', function(source, args, rawCommand)
        Sync:FreezeWeather()
        Chat.Send.Server:Single(source, 'Weather Has Been '.. (Sync.Get:WeatherFrozen() and 'Frozen' or 'Unfrozen'))
    end, {
        help = 'Freeze the Weather',
        params = {}
    })

    Chat:RegisterAdminCommand('weather', function(source, args, rawCommand)
        for _, v in pairs(AvailableWeatherTypes) do
            if args[1]:upper() == v then
                Sync.Set:Weather(args[1])
                return
            end
        end
        Chat.Send.Server:Single(source, 'Invalid Weather Type')
    end, {
        help = 'Set Weather',
        params = {{
                name = 'Type',
                help = 'EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN'
            }
        }
    }, 1)

    Chat:RegisterAdminCommand('time', function(src, args, raw)
        Sync.Set:TimeType(args[1])
    end, {
        help = 'Set Time',
        params = {
            { name = 'Type', help = 'MORNING, NOON, EVENING, NIGHT' }
        }
    }, 1)

    Chat:RegisterAdminCommand('clock', function(src, args, raw)
        Sync.Set:Time(tonumber(args[1]), 0)
    end, {
        help = 'Set Specific Hour',
        params = {
            { name = 'Hour', help = '0 - 23' },
        }
    }, 1)

    Chat:RegisterAdminCommand('blackout', function(source, args, rawCommand)
        Sync.Set:Blackout()
        Chat.Send.Server:Single(source, 'Blackout Has Been '.. (Sync.Get:Blackout() and 'Enabled' or 'Disabled'))
    end, {
        help = 'Toggle Blackout'
    }, 0)
end