function OpenStaffMenu(data)
    if _menuOpen then
        return
    end

    _menuOpen = true
    if data then
        adminSubMenus = {}
        adminMenu = Menu:Create('adminMenu', 'Staff Menu', function(id, back)
            _menuOpen = true
        end, function()
            _menuOpen = false
            Wait(100)
            adminSubMenus = nil
            adminMenu = nil 
            collectgarbage()
        end, true)

        local kickReason, banReason
        local banLength = 1 -- Default 1 Day

        local connectedIdentifiers = {}

        -- Active Player Management
        if data.playerData then
            adminSubMenus['activePlayers'] = Menu:Create('adminActivePlayers', 'Player Management')

            if #data.playerData > 0 then

                table.sort(data.playerData, function(a, b)
                    return a.Source < b.Source
                end)
                
                for _, player in ipairs(data.playerData) do
                    connectedIdentifiers[player.Identifier] = player.Source

                    local playerMenuId = 'adminActivePlayers-' .. player.Source

                    adminSubMenus[playerMenuId] = Menu:Create(playerMenuId, string.format('Viewing Player: [%s] %s', player.Source, player.Name))
                    
                    -- PUNISH MENU
                    adminSubMenus[playerMenuId.. '-punish'] = Menu:Create('adminActivePlayersPunish-' .. player.Source, string.format('Punish Player: [%s] %s', player.Source, player.Name))

                    adminSubMenus[playerMenuId.. '-punish'].Add:Text('Kick', { 'center', 'heading' })
                    adminSubMenus[playerMenuId.. '-punish'].Add:Input('Kick Reason', {
                        disabled = false,
                        max = 255,
                        current = '',
                    }, function(data)
                        kickReason = data.data.value
                    end)
                    adminSubMenus[playerMenuId.. '-punish'].Add:Button('Kick '.. player.Name, {}, function()
                        if not kickReason then kickReason = 'No Reason Provided' end
                        TriggerServerEvent('Admin:Server:KickPlayer', player.Source, kickReason)
                    end)

                    adminSubMenus[playerMenuId.. '-punish'].Add:Text('Ban', { 'center', 'heading' })
                    adminSubMenus[playerMenuId.. '-punish'].Add:Select('Ban Length', {
                        disabled = false,
                        current = banLength,
                        list = {
                            { label = '1 Day', value = 1 },
                            { label = '2 Days', value = 2 },
                            { label = '3 Days', value = 3 },
                        }
                    }, function(data)
                        banLength = data.data.value
                    end)

                    adminSubMenus[playerMenuId.. '-punish'].Add:Input('Ban Reason', {
                        disabled = false,
                        max = 255,
                        current = '',
                    }, function(data)
                        banReason = data.data.value
                    end)

                    adminSubMenus[playerMenuId.. '-punish'].Add:Button('Ban '.. player.Name, {}, function()
                        if not banReason then banReason = 'No Reason Provided' end
                        TriggerServerEvent('Admin:Server:BanPlayer', player.Source, banLength, banReason)
                    end)
                    adminSubMenus[playerMenuId.. '-punish'].Add:SubMenuBack('Go Back', {})

                    adminSubMenus[playerMenuId].Add:Text('Player Information', { 'center', 'heading' })
                    adminSubMenus[playerMenuId].Add:Text(string.format(
                        [[
                            Name: %s<br>
                            Server ID (Source): %s<br>
                            Account ID: %s<br>
                            Identifier: %s<br>
                            Staff: %s<br>
                            Admin: %s<br>
                        ]],
                        player.Name,
                        player.Source,
                        player.AccountID,
                        player.Identifier,
                        player.IsStaff and 'Yes' or 'No',
                        player.IsAdmin and 'Yes' or 'No'
                    ), {'pad', 'center', 'code'})

                    adminSubMenus[playerMenuId].Add:SubMenu('Punishment', adminSubMenus[playerMenuId.. '-punish'], {})

                    if player.Character and player.Character.First then
                        adminSubMenus[playerMenuId].Add:Text('Character Information', { 'center', 'heading' })
                        
                        adminSubMenus[playerMenuId].Add:Text(string.format(
                            [[
                                Name: %s %s<br>
                                State ID: %s<br>
                            ]],
                            player.Character.First,
                            player.Character.Last,
                            player.Character.SID
                        ), {'pad', 'center', 'code'})
                    end
                    
                    -- adminSubMenus[playerMenuId].Add:Button('Goto Player', { disabled = not player.Character, success = true }, function(data)
                    --     Callbacks:ServerCallback('Admin:PlayerTeleportAction', {
                    --         action = 'GOTO',
                    --         target = player.Source,
                    --     }, function(success)
                    --         if success then
                    --             Notification:Success('Successfully Teleported to '.. player.Name)
                    --         else
                    --             Notification:Error('Failed to Teleport to '.. player.Name)
                    --         end
                    --     end)
                    -- end)
                    
                    -- adminSubMenus[playerMenuId].Add:Button('Bring Player', { disabled = not player.Character, success = true }, function(data)
                    --     Callbacks:ServerCallback('Admin:PlayerTeleportAction', {
                    --         action = 'BRING',
                    --         target = player.Source,
                    --     }, function(success)
                    --         if success then
                    --             Notification:Success('Successfully Brought '.. player.Name)
                    --         else
                    --             Notification:Error('Failed to Bring '.. player.Name)
                    --         end
                    --     end)
                    -- end)

                    -- adminSubMenus[playerMenuId].Add:Button('Revive Player', { disabled = not player.Character }, function(data)
                    --     ExecuteCommand('heal '.. player.Source)
                    -- end)

                    adminSubMenus[playerMenuId].Add:Button('Attach To (Spectate)', { disabled = not player.Character, success = _attached }, function(data)
                        if _attached then
                            AdminStopAttach()
                        else
                            Callbacks:ServerCallback('Admin:AttachToPlayer', player.Source, function(targetCoords)
                                if targetCoords then
                                    AdminAttachToEntity(player.Source, targetCoords)
                                else
                                    AdminStopAttach()
                                end
                            end)
                        end
                    end)

                    local playerString
                    if player.Character then
                        playerString = string.format('[%s] %s - %s %s', player.Source, player.Name, player.Character.First, player.Character.Last)
                    else
                        playerString = string.format('[%s] %s', player.Source, player.Name)
                    end

                    if data.callingSource == player.Source then
                        playerString = playerString .. ' (You)'
                    end

                    adminSubMenus[playerMenuId].Add:SubMenuBack('Go Back', {})
                    adminSubMenus['activePlayers'].Add:SubMenu(playerString, adminSubMenus[playerMenuId], {})
                end
            else
                adminSubMenus['activePlayers'].Add:Button("No Active Players", { disabled = true }, function() end)
            end

            adminSubMenus['activePlayers'].Add:SubMenuBack('Go Back', {})

            adminMenu.Add:SubMenu('Player Management', adminSubMenus['activePlayers'], {})
        end

        adminSubMenus['recentDisconnects'] = Menu:Create('adminRecentDisconnects', 'Recent Disconnects')
        if data.recentDisconnects then
            if #data.recentDisconnects > 0 then
                -- Highest Source should be at the top because it is the most recent disconnections
                table.sort(data.recentDisconnects, function(a, b)
                    return a.Source > b.Source
                end)

                for _, player in ipairs(data.recentDisconnects) do
                    local playerMenuId = 'adminRecentDisconnects-' .. player.Source
                    adminSubMenus[playerMenuId] = Menu:Create(playerMenuId, string.format('Disconnected Player: [%s] %s', player.Source, player.Name))

                    local hasReconnected = connectedIdentifiers[player.Identifier]

                    adminSubMenus[playerMenuId].Add:Text('Player Information', { 'center', 'heading' })
                    adminSubMenus[playerMenuId].Add:Text(string.format(
                        [[
                            Name: %s<br>
                            Server ID (Source): %s<br>
                            Identifier: %s<br>
                            Staff: %s<br>
                            Admin: %s<br>
                            Disconnect Reason: %s<br>
                            Reconnected: %s<br>
                        ]],
                        player.Name,
                        player.Source,
                        player.Identifier,
                        player.IsStaff and 'Yes' or 'No',
                        player.IsAdmin and 'Yes' or 'No',
                        player.Reason,
                        hasReconnected and ('Yes, as ID '.. hasReconnected) or 'No'
                    ), {'pad', 'center', 'code'})

                    if player.Character then
                        adminSubMenus[playerMenuId].Add:Text('Character Information', { 'center', 'heading' })
                        adminSubMenus[playerMenuId].Add:Text(string.format(
                            [[
                                Name: %s %s<br>
                                State ID: %s<br>
                            ]],
                            player.Character.First,
                            player.Character.Last,
                            player.Character.SID
                        ), {'pad', 'center', 'code'})
                    end
                    adminSubMenus[playerMenuId].Add:SubMenuBack('Go Back', {})

                    local playerString
                    if player.Character then
                        playerString = string.format('[%s] %s - %s %s', player.Source, player.Name, player.Character.First, player.Character.Last)
                    else
                        playerString = string.format('[%s] %s', player.Source, player.Name)
                    end

                    if hasReconnected then
                        playerString = playerString .. ' (Reconnected)'
                    end

                    adminSubMenus['recentDisconnects'].Add:SubMenu(playerString, adminSubMenus[playerMenuId], {})
                end
            else
                adminSubMenus['recentDisconnects'].Add:Button("No Recent Disconnects", { disabled = true }, function() end)
            end

            adminSubMenus['recentDisconnects'].Add:SubMenuBack('Go Back', {})
            adminMenu.Add:SubMenu('Recent Disconnects', adminSubMenus['recentDisconnects'], {})
        end

        if _attached then
            adminMenu.Add:Button('Force Detach From All Players', { success = true }, function()
                AdminStopAttach()
            end)
        end

        adminMenu:Show()
    else
        _menuOpen = false
    end
end

RegisterNetEvent('Admin:Client:OpenStaffMenu', function()
    Callbacks:ServerCallback('Admin:GetMenuData', {}, function(isAdmin, data)
        OpenStaffMenu(data)
    end)
end)