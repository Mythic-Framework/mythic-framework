RegisterNetEvent('Damage:Server:LogDeath', function(killer, reason)
    local player = Fetch:Source(source)
    if player then
        local char = player:GetData('Character')
        if char then
            if killer then
                local killerPlayer = Fetch:Source(killer)
                if killerPlayer then
                    killerChar = killerPlayer:GetData('Character')
                    if killerChar then
                        killer = string.format('%s %s (%s) [%s]', killerChar:GetData('First'), killerChar:GetData('Last'), killerChar:GetData('SID'), killerPlayer:GetData('AccountID'))
                    end
                end

                Logger:Info("Damage", string.format("%s %s (%s) [%s] Killed By %s. Method: %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), player:GetData("AccountID"), killer, reason), {
                    console = true,
                    file = true,
                    database = true,
                    discord = {
                        embed = true,
                        type = 'info',
                        webhook = GetConvar('discord_kill_webhook', ''),
                    }
                })
            else
                Logger:Info("Damage", string.format("%s %s (%s) [%s] Killed Themself. Method: %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), player:GetData("AccountID"), reason), {
                    console = true,
                    file = true,
                    database = true,
                    discord = {
                        embed = true,
                        type = 'info',
                        webhook = GetConvar('discord_kill_webhook', ''),
                    }
                })
            end
        end
    end
end)