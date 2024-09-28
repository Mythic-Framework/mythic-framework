function RegisterChatCommands()
    Chat:RegisterAdminCommand("boostingevent", function(source, args, rawCommand)
        if _boostingEvent then
            _boostingEvent = false
            Chat.Send.System:Single(source, "Boosting Event Disabled")
        else
            _boostingEvent = true
            Chat.Send.System:Single(source, "Boosting Event Enabled")
        end
	end, {
		help = "[Admin] Toggle Boosting Event Mode",
	}, 0)

    Chat:RegisterAdminCommand("boostingevent2", function(source, args, rawCommand)
        local player = Fetch:SID(tonumber(args[1]))
        if player then
            local char = player:GetData("Character")
            if char then
                local alias = char:GetData("Alias")
                if alias?.redline then
                    Chat.Send.System:Single(source, string.format("%s %s (%s) - Alias %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), alias.redline))
                end
            end
        end
	end, {
		help = "[Admin] Get Racing Alias",
        params = {
			{
				name = "SID",
				help = "SID",
			},
		}
	}, 1)

    local allowedCoins = {
        VRM = "VRM",
        PLEB = "PLEB",
        HEIST = "HEIST"
    }

    Chat:RegisterAdminCommand("addcrypto", function(source, args, rawCommand)
        local player = Fetch:SID(tonumber(args[1]))
        if player then
            local char = player:GetData("Character")
            if char then
                local coin = args[2]:upper()
                local amount = tonumber(args[3])

                if allowedCoins[coin] and amount then
                    Crypto.Exchange:Add(coin, char:GetData("CryptoWallet"), amount)
                    Chat.Send.System:Single(source, string.format("Added %d %s (%s) to %s %s (%s)", amount, allowedCoins[coin], coin, char:GetData("First"), char:GetData("Last"), char:GetData("SID")))
                else
                    Chat.Send.System:Single(source, "Error: Invalid coin type or amount. Allowed coins: VRM, PLEB, HEIST.")
                end
            else
                Chat.Send.System:Single(source, "Error: Character not found.")
            end
        else
            Chat.Send.System:Single(source, "Error: Player not found.")
        end
    end, {
        help = "[Admin] Give cryptocurrency to a character",
        params = {
            {
                name = "SID",
                help = "SID of the player",
            },
            {
                name = "Coin",
                help = "Type of cryptocurrency to give (VRM, PLEB or HEIST)",
            },
            {
                name = "Amount",
                help = "Amount of cryptocurrency to give",
            },
        }
    }, 3)
end
