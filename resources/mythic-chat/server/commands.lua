

function CHAT.RegisterCommand(self, command, callback, suggestion, arguments, job)
    if job ~= nil then
        if type(job) == 'table' and #job > 0 then
            for k,v in pairs(job) do
                if v.Id == nil then return end
                if v.Level == nil then v.Level = 1 end
            end
        end
    end

	commands[command] = {
        cb = callback,
        args = (arguments or -1),
        job = job
    }

	if suggestion ~= nil then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local pData = exports['mythic-base']:FetchComponent('Fetch'):Source(source)
        if pData ~= nil then
            -- TODO : Implement character specific data for commands (IE Jobs)
            local myDuty = Player(source).state.onDuty

            local argsStr = ""
            if #args > 0 then
                argsStr = "\n\nArguments:\n"
            end
            for k, v in ipairs(args) do
                argsStr = argsStr .. string.format("%s\n", v)
            end

            if commands[command].job ~= nil then
                for k, v in pairs(commands[command].job) do
                    if myDuty and myDuty == v.Id then
                        if Jobs.Permissions:HasJob(source, v.Id, v.Workplace, v.Grade, v.Level) then
                            if ((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                                local char = pData:GetData('Character')
                                Logger:Info(
                                    "Commands",
                                    string.format(
                                        "%s (%s [%s]) Used A Job Command: %s.%s",
                                        char and string.format('%s %s (SID %s)', char:GetData('First'), char:GetData('Last'), char:GetData('SID')) or 'No Character',
                                        pData:GetData("Name"),
                                        pData:GetData("AccountID"),
                                        command,
                                        argsStr
                                    ),
                                    {
                                        console = false,
                                        file = true,
                                        database = true,
                                    },
                                    {
                                        args = args
                                    }
                                )

                                callback(source, args, rawCommand)
                            else
                                Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                            end
                        end
                    end
                end
            else
                if ((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                    local char = pData:GetData('Character')
                    Logger:Info(
                        "Commands",
                        string.format(
                            "%s (%s [%s]) Used A Command: %s.%s",
                            char and string.format('%s %s (SID %s)', char:GetData('First'), char:GetData('Last'), char:GetData('SID')) or 'No Character',
                            pData:GetData("Name"),
                            pData:GetData("AccountID"),
                            command,
                            argsStr
                        ),
                        {
                            console = false,
                            file = true,
                            database = true,
                        },
                        {
                            args = args
                        }
                    )

                    callback(source, args, rawCommand)
                else
                    Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                end
            end
        end
    end, false)
end

function CHAT.RegisterAdminCommand(this, command, callback, suggestion, arguments)
	commands[command] = {
        cb = callback,
        args = (arguments or -1),
        admin = true
    }

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local player = exports['mythic-base']:FetchComponent('Fetch'):Source(source)
        if player ~= nil then
            local pData = player:GetData()

            local argsStr = ""
            if #args > 0 then
                argsStr = "\n\nArguments:\n"
            end
            for k, v in ipairs(args) do
                argsStr = argsStr .. string.format("%s\n", v)
            end

            if player.Permissions:IsAdmin() then
                if((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                    Logger:Info("Pwnzor", string.format("%s (%s) Used An Admin Command: %s.%s", player:GetData("Name"), player:GetData("AccountID"), command, argsStr), {
                        console = false,
                        file = false,
                        database = true,
                        discord = {
                            embed = true,
                            type = 'error',
                            webhook = GetConvar('discord_admin_webhook', ''),
                        }
                    }, {
                        args = args
                    })
                    callback(source, args, rawCommand)
                else
                    Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                end
            else
                Logger:Info("Pwnzor", string.format("%s (%s) Attempted To Use An Admin Command: %s.%s", player:GetData("Name"), player:GetData("AccountID"), command, argsStr), {
                    console = false,
                    file = true,
                    database = true,
                    discord = {
                        embed = true,
                        type = 'error',
                        webhook = GetConvar('discord_admin_webhook', ''),
                    }
                }, {
                    args = args
                })
            end
        end
    end, false)
end

function CHAT.RegisterStaffCommand(this, command, callback, suggestion, arguments)
	commands[command] = {
        cb = callback,
        args = (arguments or -1),
        staff = true
    }

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

    RegisterCommand(command, function(source, args, rawCommand)
        local player = exports['mythic-base']:FetchComponent('Fetch'):Source(source)
        if player ~= nil then
            local pData = player:GetData()

            local argsStr = ""
            if #args > 0 then
                argsStr = "\n\nArguments:\n"
            end
            for k, v in ipairs(args) do
                argsStr = argsStr .. string.format("%s\n", v)
            end

            if player.Permissions:IsStaff() then
                if((#args <= commands[command].args and #args == commands[command].args) or commands[command].args == -1) then
                    Logger:Info("Pwnzor", string.format("%s (%s) Used A Staff Command: %s.%s", player:GetData("Name"), player:GetData("AccountID"), command, argsStr), {
                        console = false,
                        file = true,
                        database = true,
                        discord = {
                            embed = true,
                            type = 'error',
                            webhook = GetConvar('discord_admin_webhook', ''),
                        }
                    }, {
                        args = args
                    })
                    callback(source, args, rawCommand)
                else
                    Chat.Send.Server:Single(source, 'Invalid Number Of Arguments')
                end
            else
                Logger:Info("Pwnzor", string.format("%s (%s) Attempted To Use A Staff Command: %s.%s", player:GetData("Name"), player:GetData("AccountID"), command, argsStr), {
                    console = false,
                    file = true,
                    database = true,
                    discord = {
                        embed = true,
                        type = 'error',
                        webhook = GetConvar('discord_admin_webhook', ''),
                    }
                }, {
                    args = args
                })
            end
        end
    end, false)
end