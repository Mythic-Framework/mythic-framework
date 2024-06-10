function RegisterChatCommands()
    Chat:RegisterAdminCommand('addprop', function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local pos = {
            x = coords.x,
            y = coords.y,
            z = coords.z - 1.2,
            h = GetEntityHeading(ped)
        }

        Properties.Manage:Add(source, args[1], tonumber(args[2]), tonumber(args[3]), args[4], pos)
    end, {
        help = 'Add New Property To Database (Enter Is Where You\'re At)',
        params = {
            {
                name = 'Property Type',
                help = 'Type of the property e.g. house, warehouse, office, container'
            },
            {
                name = 'Interior ID',
                help = 'ID of Which Interior This Will Spawn'
            },
            {
                name = 'Property Price',
                help = 'Cost of the property'
            },
            {
                name = 'Property Label',
                help = 'Name for the property'
            }
        }
    }, 4)

    Chat:RegisterAdminCommand('delprop', function(source, args, rawCommand)
        if Properties.Manage:Delete(args[1]) then
            Chat.Send.Server:Single(source, id .. " Has Been Deleted")
        end
    end, {
        help = 'Delete Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of the Property You Want To Delete'
        }}
    }, 1)

    Chat:RegisterAdminCommand('addfd', function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local pos = {
            x = coords.x + 0.0,
            y = coords.y + 0.0,
            z = coords.z - 1.2,
            h = GetEntityHeading(ped) + 0.0
        }

        if Properties.Manage:AddFrontdoor(args[1], pos) then
            Chat.Send.Server:Single(source, "Frontdoor Added to Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Set The Front Door Location Of A Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of The Property'
        }}
    }, 1)

    Chat:RegisterAdminCommand('addbd', function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local pos = {
            x = coords.x + 0.0,
            y = coords.y + 0.0,
            z = coords.z - 1.2,
            h = GetEntityHeading(ped) + 0.0
        }

        if Properties.Manage:AddBackdoor(args[1], pos) then
            Chat.Send.Server:Single(source, "Backdoor Added to Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Set The Backdoor Location Of A Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of The Property'
        }}
    }, 1)

    Chat:RegisterAdminCommand('addgarage', function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local pos = {
            x = coords.x + 0.0,
            y = coords.y + 0.0,
            z = coords.z + 0.0,
            h = GetEntityHeading(ped) + 0.0
        }

        if Properties.Manage:AddGarage(args[1], pos) then
            Chat.Send.Server:Single(source, "Garage Added to Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Set The Garage Location Of A Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of The Property'
        }}
    }, 1)

    Chat:RegisterAdminCommand('removegarage', function(source, args, rawCommand)
        if Properties.Manage:AddGarage(args[1], false) then
            Chat.Send.Server:Single(source, "Garage Removed From Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Remove The Garage Location Of A Property',
        params = {{
            name = 'Property ID',
            help = 'Unique ID of The Property'
        }}
    }, 1)

    Chat:RegisterAdminCommand('setint', function(source, args, rawCommand)
        local tier = tonumber(args[2])
        if tier and tier >= 0 then
            if Properties.Manage:SetInterior(args[1], tier) then
                Chat.Send.Server:Single(source, "Interior Set For Property: " .. args[1])
            else
                Chat.Send.Server:Single(source, "No Existing Property")
            end
        end
    end, {
        help = 'Set The Interior Of A Property',
        params = {
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
            {
                name = 'Interior',
                help = 'Interior ID'
            }
        }
    }, 2)

    Chat:RegisterAdminCommand('setlabel', function(source, args, rawCommand)
        if Properties.Manage:SetLabel(args[1], args[2]) then
            Chat.Send.Server:Single(source, "Label Set For Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Set The Label Of A Property',
        params = {
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
            {
                name = 'Label',
                help = 'The Label to Use'
            }
        }
    }, 2)

    Chat:RegisterAdminCommand('setprice', function(source, args, rawCommand)
        local price = tonumber(args[2])
        if price and price > 0 then
            if Properties.Manage:SetPrice(args[1], price) then
                Chat.Send.Server:Single(source, "Price Set For Property: " .. args[1])
            else
                Chat.Send.Server:Single(source, "No Existing Property")
            end
        end
    end, {
        help = 'Set The Interior Of A Property',
        params = {
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
            {
                name = 'Price',
                help = 'New Price'
            }
        }
    }, 2)

    Chat:RegisterAdminCommand('setpropdata', function(source, args, rawCommand)
        if Properties.Manage:SetData(args[1], args[2], ParseCommandData(args[3])) then
            Chat.Send.Server:Single(source, "Data Set For Property: " .. args[1])
        else
            Chat.Send.Server:Single(source, "No Existing Property")
        end
    end, {
        help = 'Set Data on a Property',
        params = {
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
            {
                name = 'Key',
                help = 'Key'
            },
            {
                name = 'Value',
                help = 'Value'
            },
        }
    }, 3)

    Chat:RegisterAdminCommand('ownproperty', function(source, args, rawCommand)
        local player = Fetch:Source(source)
        if player.Permissions:GetLevel() >= 100 then
            local target = Fetch:SID(tonumber(args[1]))
            if target then
                local char = target:GetData('Character')
                if char then
                    if GlobalState[string.format("Property:%s", args[2])] then
                        if Properties.Commerce:Buy(args[2], {
                            Char = char:GetData("ID"),
                            SID = char:GetData("SID"),
                            First = char:GetData("First"),
                            Last = char:GetData("Last"),
                            Owner = true,
                        }) then
                            Chat.Send.System:Single(source, "Added Owned Property")
                        else
                            Chat.Send.System:Single(source, "Failed Adding Owned Property")
                        end
                    else
                        Chat.Send.System:Single(source, "No Property With That ID")
                    end
                end
            else
                Chat.Send.System:Single(source, "Character Not Online")
            end
        end
    end, {
        help = 'Set Owner of a Property',
        params = {
            {
                name = 'State ID',
                help = 'State ID of New Owner'
            },
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
        }
    }, 2)

    Chat:RegisterAdminCommand('unownproperty', function(source, args, rawCommand)
        local player = Fetch:Source(source)
        if player.Permissions:GetLevel() >= 100 then
            if GlobalState[string.format("Property:%s", args[1])] then
                if Properties.Commerce:Sell(args[1]) then
                    Chat.Send.System:Single(source, "Removed property owner")
                else
                    Chat.Send.System:Single(source, "Failed to remove property owner")
                end
            else
                Chat.Send.System:Single(source, "No Property With That ID")
            end
        end
    end, {
        help = 'Remove Owner of a Property',
        params = {
            {
                name = 'Property ID',
                help = 'Unique ID of The Property'
            },
        }
    }, 1)
end

function ParseCommandData(cmd)
    if cmd:lower() == 'true' then
        return true
    elseif cmd:lower() == 'false' then
        return false
    elseif tonumber(cmd) then
        return tonumber(cmd)
    else
        return cmd
    end
end