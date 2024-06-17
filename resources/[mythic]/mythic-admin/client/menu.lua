-- _menuOpen = false

-- _drawingCoords = false

-- local adminMenu, adminSubMenus

-- function OpenAdminMenu()
--     if _menuOpen then
--         return
--     end

--     _menuOpen = true
--     Callbacks:ServerCallback('Admin:GetMenuData', {}, function(isAdmin, data)
--         if not isAdmin and data then
--             OpenStaffMenu(data)
--             return
--         end

--         if data then
--             adminSubMenus = {}
--             adminMenu = Menu:Create('adminMenu', 'Admin Menu', function(id, back)
--                 _menuOpen = true
--             end, function()
--                 _menuOpen = false
--                 Wait(100)
--                 adminSubMenus = nil
--                 adminMenu = nil 
--                 collectgarbage()
--             end, true)

--             local kickReason, banReason
--             local banLength = 3 -- Default 3 Days

--             local connectedIdentifiers = {}

--             -- Active Player Management
--             if data.playerData then
--                 adminSubMenus['activePlayers'] = Menu:Create('adminActivePlayers', 'Player Management')

--                 -- adminSubMenus['activePlayers'].Add:Button('Revive All', {}, function()
                    
--                 -- end)

--                 if #data.playerData > 0 then

--                     table.sort(data.playerData, function(a, b)
--                         return a.Source < b.Source
--                     end)
                    
--                     for _, player in ipairs(data.playerData) do
--                         connectedIdentifiers[player.Identifier] = player.Source

--                         local playerMenuId = 'adminActivePlayers-' .. player.Source

--                         adminSubMenus[playerMenuId] = Menu:Create(playerMenuId, string.format('Viewing Player: [%s] %s', player.Source, player.Name))
                        
--                         -- PUNISH MENU
--                         adminSubMenus[playerMenuId.. '-punish'] = Menu:Create('adminActivePlayersPunish-' .. player.Source, string.format('Punish Player: [%s] %s', player.Source, player.Name))

--                         adminSubMenus[playerMenuId.. '-punish'].Add:Text('Kick', { 'center', 'heading' })
--                         adminSubMenus[playerMenuId.. '-punish'].Add:Input('Kick Reason', {
--                             disabled = false,
--                             max = 255,
--                             current = '',
--                         }, function(data)
--                             kickReason = data.data.value
--                         end)
--                         adminSubMenus[playerMenuId.. '-punish'].Add:Button('Kick '.. player.Name, {}, function()
--                             if not kickReason then kickReason = 'No Reason Provided' end
--                             TriggerServerEvent('Admin:Server:KickPlayer', player.Source, kickReason)
--                         end)

--                         adminSubMenus[playerMenuId.. '-punish'].Add:Text('Ban', { 'center', 'heading' })
--                         adminSubMenus[playerMenuId.. '-punish'].Add:Select('Ban Length', {
--                             disabled = false,
--                             current = banLength,
--                             list = {
--                                 { label = 'Permanent Ban', value = -1 },
--                                 { label = '1 Day', value = 1 },
--                                 { label = '2 Days', value = 2 },
--                                 { label = '3 Days', value = 3 },
--                                 { label = '1 Week', value = 7 },
--                                 { label = '2 Weeks', value = 14 },
--                                 { label = '1 Month', value = 30 },
--                             }
--                         }, function(data)
--                             banLength = data.data.value
--                         end)

--                         adminSubMenus[playerMenuId.. '-punish'].Add:Input('Ban Reason', {
--                             disabled = false,
--                             max = 255,
--                             current = '',
--                         }, function(data)
--                             banReason = data.data.value
--                         end)

--                         adminSubMenus[playerMenuId.. '-punish'].Add:Button('Ban '.. player.Name, {}, function()
--                             if not banReason then banReason = 'No Reason Provided' end
--                             TriggerServerEvent('Admin:Server:BanPlayer', player.Source, banLength, banReason)
--                         end)
--                         adminSubMenus[playerMenuId.. '-punish'].Add:SubMenuBack('Go Back', {})

--                         adminSubMenus[playerMenuId].Add:Text('Player Information', { 'center', 'heading' })
--                         adminSubMenus[playerMenuId].Add:Text(string.format(
--                             [[
--                                 Name: %s<br>
--                                 Server ID (Source): %s<br>
--                                 Account ID: %s<br>
--                                 Identifier: %s<br>
--                                 Staff: %s<br>
--                                 Admin: %s<br>
--                             ]],
--                             player.Name,
--                             player.Source,
--                             player.AccountID,
--                             player.Identifier,
--                             player.IsStaff and 'Yes' or 'No',
--                             player.IsAdmin and 'Yes' or 'No'
--                         ), {'pad', 'center', 'code'})

--                         adminSubMenus[playerMenuId].Add:SubMenu('Punishment', adminSubMenus[playerMenuId.. '-punish'], {})

--                         if player.Character then
--                             adminSubMenus[playerMenuId].Add:Text('Character Information', { 'center', 'heading' })
                            
--                             adminSubMenus[playerMenuId].Add:Text(string.format(
--                                 [[
--                                     Name: %s %s<br>
--                                     State ID: %s<br>
--                                     #: %s<br>
--                                 ]],
--                                 player.Character.First,
--                                 player.Character.Last,
--                                 player.Character.SID,
--                                 player.Character.Phone
--                             ), {'pad', 'center', 'code'})
--                         end
                        
--                         adminSubMenus[playerMenuId].Add:Button('Goto Player', { disabled = not player.Character, success = true }, function(data)
--                             Callbacks:ServerCallback('Admin:PlayerTeleportAction', {
--                                 action = 'GOTO',
--                                 target = player.Source,
--                             }, function(success)
--                                 if success then
--                                     Notification:Success('Successfully Teleported to '.. player.Name)
--                                 else
--                                     Notification:Error('Failed to Teleport to '.. player.Name)
--                                 end
--                             end)
--                         end)
                        
--                         adminSubMenus[playerMenuId].Add:Button('Bring Player', { disabled = not player.Character, success = true }, function(data)
--                             Callbacks:ServerCallback('Admin:PlayerTeleportAction', {
--                                 action = 'BRING',
--                                 target = player.Source,
--                             }, function(success)
--                                 if success then
--                                     Notification:Success('Successfully Brought '.. player.Name)
--                                 else
--                                     Notification:Error('Failed to Bring '.. player.Name)
--                                 end
--                             end)
--                         end)

--                         adminSubMenus[playerMenuId].Add:Button('Revive Player', { disabled = not player.Character }, function(data)
--                             ExecuteCommand('heal '.. player.Source)
--                         end)

--                         adminSubMenus[playerMenuId].Add:Button('Attach To (Spectate)', { disabled = not player.Character, success = _attached }, function(data)
--                             if _attached then
--                                 AdminStopAttach()
--                             else
--                                 Callbacks:ServerCallback('Admin:AttachToPlayer', player.Source, function(targetCoords)
--                                     if targetCoords then
--                                         AdminAttachToEntity(player.Source, targetCoords)
--                                     else
--                                         AdminStopAttach()
--                                     end
--                                 end)
--                             end
--                         end)
                        
--                         if player.Character then
--                             adminSubMenus[playerMenuId.. '-phone-perms'] = Menu:Create('adminPhonePerms-' .. player.Source, 'Update Phone Permissions')
--                             adminSubMenus[playerMenuId].Add:SubMenu('Phone Permissions', adminSubMenus[playerMenuId.. '-phone-perms'], {})

--                             for appKey, perms in pairs(player.Character.PhonePermissions) do
--                                 adminSubMenus[playerMenuId.. '-phone-perms'].Add:Text(appKey, { 'center', 'heading' })
--                                 for permKey, permState in pairs(perms) do
--                                     adminSubMenus[playerMenuId.. '-phone-perms'].Add:CheckBox(permKey, { selected = permState }, function(data)
--                                         Callbacks:ServerCallback('Admin:UpdatePhonePerms', {
--                                             target = player.Source,
--                                             app = appKey,
--                                             perm = permKey,
--                                             state = data.data.selected,
--                                         }, function(targetCoords)
    
--                                         end)
--                                     end)
--                                 end
--                             end
--                             adminSubMenus[playerMenuId.. '-phone-perms'].Add:SubMenuBack('Go Back', {})
    
--                         end
                        
--                         local playerString
--                         if player.Character then
--                             playerString = string.format('[%s] %s - %s %s', player.Source, player.Name, player.Character.First, player.Character.Last)
--                         else
--                             playerString = string.format('[%s] %s', player.Source, player.Name)
--                         end
                        
--                         if data.callingSource == player.Source then
--                             playerString = playerString .. ' (You)'
--                         end

--                         adminSubMenus[playerMenuId].Add:SubMenuBack('Go Back', {})
--                         adminSubMenus['activePlayers'].Add:SubMenu(playerString, adminSubMenus[playerMenuId], {})

--                         Wait(10)
--                     end
--                 else
--                     adminSubMenus['activePlayers'].Add:Button("No Active Players", { disabled = true }, function() end)
--                 end

--                 adminSubMenus['activePlayers'].Add:SubMenuBack('Go Back', {})

--                 adminMenu.Add:SubMenu('Player Management', adminSubMenus['activePlayers'], {})
--             end

--             adminSubMenus['recentDisconnects'] = Menu:Create('adminRecentDisconnects', 'Recent Disconnects')
--             if data.recentDisconnects then
--                 if #data.recentDisconnects > 0 then
--                     -- Highest Source should be at the top because it is the most recent disconnections
--                     table.sort(data.recentDisconnects, function(a, b)
--                         return a.Source > b.Source
--                     end)

--                     for _, player in ipairs(data.recentDisconnects) do
--                         local playerMenuId = 'adminRecentDisconnects-' .. player.Source
--                         adminSubMenus[playerMenuId] = Menu:Create(playerMenuId, string.format('Disconnected Player: [%s] %s', player.Source, player.Name))

--                         local hasReconnected = connectedIdentifiers[player.Identifier]

--                         adminSubMenus[playerMenuId].Add:Text('Player Information', { 'center', 'heading' })
--                         adminSubMenus[playerMenuId].Add:Text(string.format(
--                             [[
--                                 Name: %s<br>
--                                 Server ID (Source): %s<br>
--                                 Identifier: %s<br>
--                                 Staff: %s<br>
--                                 Admin: %s<br>
--                                 Disconnect Reason: %s<br>
--                                 Reconnected: %s<br>
--                             ]],
--                             player.Name,
--                             player.Source,
--                             player.Identifier,
--                             player.IsStaff and 'Yes' or 'No',
--                             player.IsAdmin and 'Yes' or 'No',
--                             player.Reason,
--                             hasReconnected and ('Yes, as ID '.. hasReconnected) or 'No'
--                         ), {'pad', 'center', 'code'})

--                         if player.Character then
--                             adminSubMenus[playerMenuId].Add:Text('Character Information', { 'center', 'heading' })
--                             adminSubMenus[playerMenuId].Add:Text(string.format(
--                                 [[
--                                     Name: %s %s<br>
--                                     State ID: %s<br>
--                                 ]],
--                                 player.Character.First,
--                                 player.Character.Last,
--                                 player.Character.SID
--                             ), {'pad', 'center', 'code'})
--                         end
--                         adminSubMenus[playerMenuId].Add:SubMenuBack('Go Back', {})

--                         local playerString
--                         if player.Character then
--                             playerString = string.format('[%s] %s - %s %s', player.Source, player.Name, player.Character.First, player.Character.Last)
--                         else
--                             playerString = string.format('[%s] %s', player.Source, player.Name)
--                         end

--                         if hasReconnected then
--                             playerString = playerString .. ' (Reconnected)'
--                         end

--                         adminSubMenus['recentDisconnects'].Add:SubMenu(playerString, adminSubMenus[playerMenuId], {})
--                     end
--                 else
--                     adminSubMenus['recentDisconnects'].Add:Button("No Recent Disconnects", { disabled = true }, function() end)
--                 end

--                 adminSubMenus['recentDisconnects'].Add:SubMenuBack('Go Back', {})
--                 adminMenu.Add:SubMenu('Recent Disconnects', adminSubMenus['recentDisconnects'], {})
--             end

--             -- Teleportation
--             adminSubMenus['teleportationUtils'] = Menu:Create('adminTeleportUtils', 'Teleport')
--             if data.spawnLocations then
--                 local spawnLocations = Menu:Create('adminSpawnLocations', 'Spawn Locations')
--                 for _, location in ipairs(data.spawnLocations) do
--                     if location.Name and location.Coords then
--                         spawnLocations.Add:Button(location.Name, { success = true }, function()
--                             SetEntityCoords(PlayerPedId(), location.Coords.x, location.Coords.y, location.Coords.z)
--                         end)
--                     end
--                 end
--                 spawnLocations.Add:SubMenuBack('Go Back', {})
--                 adminSubMenus['teleportationUtils'].Add:SubMenu('Location Teleports', spawnLocations, {})
--             end

--             adminSubMenus['teleportationUtils'].Add:Button('Teleport to Waypoint', { success = true }, function()
--                 TriggerEvent('Commands:Client:TeleportToMarker')
--             end)
            
--             local x, y, z = 0.0, 0.0, 0.0
            
--             adminSubMenus['teleportationUtils'].Add:Number('X', {
--                 disabled = false,
--                 current = 0,
--             }, function(data)
--                 x = tonumber(data.data.value) + 0.0
--             end)
            
--             adminSubMenus['teleportationUtils'].Add:Number('Y', {
--                 disabled = false,
--                 current = 0,
--             }, function(data)
--                 y = tonumber(data.data.value) + 0.0
--             end)
            
--             adminSubMenus['teleportationUtils'].Add:Number('Z', {
--                 disabled = false,
--                 current = 0,
--             }, function(data)
--                 z = tonumber(data.data.value) + 0.0
--             end)
            
--             adminSubMenus['teleportationUtils'].Add:Button('Manual Teleport', { success = true }, function()
--                 SetEntityCoords(PlayerPedId(), x, y, z)
--             end)
            
--             adminSubMenus['teleportationUtils'].Add:SubMenuBack('Go Back', {})
--             adminMenu.Add:SubMenu('Teleportation', adminSubMenus['teleportationUtils'], {})

--             adminSubMenus['developerUtilities'] = Menu:Create('adminDevUtils', 'Developer Utilities')

--             local playerPed = PlayerPedId()
--             local playerCoords = GetEntityCoords(playerPed)
--             local playerHeading = GetEntityHeading(playerPed)
            
--             adminSubMenus['developerUtilities'].Add:Text(string.format(
--                 [[
--                     Ped Coords: vector3(%.3f, %.3f, %.3f)<br>
--                     Ped Heading: %.3f<br>
--                     Current VOIP Grid: %s<br>
--                 ]],
--                 playerCoords.x,
--                 playerCoords.y,
--                 playerCoords.z,
--                 playerHeading,
--                 VOIP:GetGrid()
--             ), {'pad', 'center', 'code'})

--             adminSubMenus['developerUtilities'].Add:Button('Toggle Drawing Coords', { success = _drawingCoords }, function(data)
--                 if _drawingCoords then
--                     _drawingCoords = false
--                 else
--                     _drawingCoords = true
--                     local playerPed = PlayerPedId()
--                     CreateThread(function()
--                         while _drawingCoords do
--                             Wait(5)
--                             local playerCoords = GetEntityCoords(playerPed)
--                             local playerHeading = GetEntityHeading(playerPed)
--                             DrawShittyText(string.format('~r~X:~w~ %.3f ~r~Y:~w~ %.3f ~r~Z:~w~ %.3f ~b~H:~w~ %.3f', playerCoords.x, playerCoords.y, playerCoords.z, playerHeading))
--                         end
--                     end)
--                 end
--                 adminSubMenus['developerUtilities'].Update:Item(data.id, 'Toggle Drawing Coords', { success = _drawingCoords })
--             end)

--             adminSubMenus['developerUtilities'].Add:SubMenuBack('Go Back', {})
--             adminMenu.Add:SubMenu('Developer Utilities', adminSubMenus['developerUtilities'], {})

--             local insideVehicle = GetVehiclePedIsIn(playerPed, true)
--             if insideVehicle and insideVehicle > 0 and DoesEntityExist(insideVehicle) and NetworkHasControlOfEntity(insideVehicle) then
--                 adminSubMenus['vehicleUtilities'] = Menu:Create('adminVehUtils', 'Vehicle Utilities')

--                 local vehState = Entity(insideVehicle).state
--                 local vehicleCoords = GetEntityCoords(insideVehicle)
--                 local vehicleHeading = GetEntityHeading(insideVehicle)
--                 local currentSeat = 'Not In Vehicle'
--                 for i = -1, 14 do
--                     if GetPedInVehicleSeat(insideVehicle, i) == playerPed then
--                         currentSeat = i
--                         break
--                     end
--                 end

--                 adminSubMenus['vehicleUtilities'].Add:Text(string.format(
--                     [[
--                         Vehicle Coords: vector3(%.3f, %.3f, %.3f)<br>
--                         Vehicle Heading: %.3f<br>
--                         Vehicle Model: %s<br>
--                         Current Seat: %s<br>
--                     ]],
--                     vehicleCoords.x,
--                     vehicleCoords.y,
--                     vehicleCoords.z,
--                     vehicleHeading,
--                     GetEntityModel(insideVehicle),
--                     currentSeat
--                 ), {'pad', 'center', 'code'})

--                 local damage = vehState.Damage or {}
--                 adminSubMenus['vehicleUtilities'].Add:Text(string.format(
--                     [[
--                         Engine Damage: %.1f<br>
--                         Body Damage: %.1f<br><br>
--                         Fuel: %.3f<br>
--                     ]],
--                     damage.Engine or 1000.0,
--                     damage.Body or 1000.0,
--                     vehState.Fuel or 100.0
--                 ), {'pad', 'center', 'code'})

--                 local damagedParts = vehState.DamagedParts
--                 if damagedParts then
--                     adminSubMenus['vehicleUtilities'].Add:Text(string.format(
--                         [[
--                             <u>Part Damage</u><br>
--                             Axle: %.3f<br>
--                             Radiator: %.3f<br>
--                             Transmission: %.3f<br>
--                             Fuel Injectors: %.3f<br>
--                             Brakes: %.3f<br>
--                             Clutch: %.3f<br>
--                             Electronics: %.3f<br>
--                         ]],
--                         damagedParts.Axle,
--                         damagedParts.Radiator,
--                         damagedParts.Transmission,
--                         damagedParts.FuelInjectors,
--                         damagedParts.Brakes,
--                         damagedParts.Clutch,
--                         damagedParts.Electronics
--                     ), {'pad', 'center', 'code'})
--                 end

--                 adminSubMenus['vehicleUtilities'].Add:Button('Quick Repair', { success = true }, function()
--                     if Vehicles.Repair:Normal(insideVehicle) then
--                         Notification:Success('Repaired Vehicle')
--                     end
--                 end)

--                 adminSubMenus['vehicleUtilities'].Add:Button('Full Repair Inc. Degen Parts', { error = true }, function()
--                     if Vehicles.Repair:Full(insideVehicle) then
--                         Notification:Success('Repaired Vehicle Fully')
--                     end
--                 end)

--                 adminSubMenus['vehicleUtilities'].Add:Button('Explode 💣', { error = true }, function()
--                     NetworkExplodeVehicle(insideVehicle, true, false)
--                 end)

--                 adminSubMenus['vehicleUtilities'].Add:Button('Toggle Alarm', { error = true }, function()
--                     if IsVehicleAlarmSet(insideVehicle) then
--                         SetVehicleAlarm(insideVehicle, false)
--                     else
--                         SetVehicleAlarm(insideVehicle, true)
--                         SetVehicleAlarmTimeLeft(insideVehicle, 25000)
--                     end
--                 end)

--                 adminSubMenus['vehicleUtilities'].Add:SubMenuBack('Go Back', {})
--                 adminMenu.Add:SubMenu('Vehicle Utilities', adminSubMenus['vehicleUtilities'], {})
--             end

--             if _attached then
--                 adminMenu.Add:Button('Force Detach From All Players', { success = true }, function()
--                     AdminStopAttach()
--                 end)
--             end

--             adminMenu.Add:Button('Toggle NoClip', {}, function()
--                 Admin.NoClip:Toggle()
--             end)

--             adminMenu:Show()
--         else
--             _menuOpen = false
--         end
--     end)
-- end

-- RegisterNetEvent('Admin:Client:OpenAdminMenu', function()
--     OpenAdminMenu()
-- end)