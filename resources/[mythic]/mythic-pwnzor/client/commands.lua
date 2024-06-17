function RegisterCommands()
    CreateThread(function()
        Callbacks:ServerCallback('Pwnzor:GetCommands', {}, function(cmds)
            CreateThread(function()
                while true do
                    local cmds2 = GetRegisteredCommands()
                    for k, v in ipairs(cmds) do
                        for k2, v2 in ipairs(cmds2) do
                            if (string.lower(v) == string.lower(v2.name) or
                                string.lower(v) == string.lower('+' .. v2.name) or
                                string.lower(v) == string.lower('_' .. v2.name) or
                                string.lower(v) == string.lower('-' .. v2.name) or
                                string.lower(v) == string.lower('/' .. v2.name)) then
                                Callbacks:ServerCallback('Pwnzor:Trigger', {
                                    check = v,
                                    match = v2.name,
                                })
                            end
                        end

                        Wait((60000 / #cmds))
                    end
                end
            end)
        end)
    end)
end