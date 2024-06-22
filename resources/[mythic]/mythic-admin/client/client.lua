
AddEventHandler('Admin:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Menu = exports['mythic-base']:FetchComponent('Menu')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Status = exports['mythic-base']:FetchComponent('Status')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Keybinds = exports['mythic-base']:FetchComponent('Keybinds')
    Vehicles = exports['mythic-base']:FetchComponent('Vehicles')
    VOIP = exports['mythic-base']:FetchComponent('VOIP')
    Admin = exports['mythic-base']:FetchComponent('Admin')
    NetSync = exports['mythic-base']:FetchComponent('NetSync')
    Sounds = exports['mythic-base']:FetchComponent('Sounds')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Admin', {
        'Callbacks',
        'Utils',
        'Logger',
        'Menu',
        'Notification',
        'Status',
        'Jobs',
        'Keybinds',
        'Vehicles',
        'VOIP',
        'Admin',
        'NetSync',
        'Sounds',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()

        Keybinds:Add('admin_menu', 'HOME', 'keyboard', '[Admin] Open Admin Menu', function()
            Admin:OpenMenu()
        end)

        Keybinds:Add('admin_noclip', 'END', 'keyboard', '[Admin] Toggle NoClip', function()
            Callbacks:ServerCallback('Admin:NoClip', {
                active = not Admin.NoClip:IsActive()
            }, function(isAdmin)
                if isAdmin then
                    Admin.NoClip:Toggle()
                end
            end)
        end)

        Keybinds:Add('admin_debug1', '', 'keyboard', '[Admin] Debug 1', function()
            DoAdminVehicleAction('repair_engine')
        end)

        Keybinds:Add('admin_debug2', '', 'keyboard', '[Admin] Debug 2', function()
            DoAdminVehicleAction('repair')
        end)

        Keybinds:Add('admin_debug3', '', 'keyboard', '[Admin] Debug IDs', function()
            if LocalPlayer.state.isDev then
                ToggleAdminPlayerIDs()
            end
        end)
    end)
end)

ADMIN = {
    OpenMenu = function(self)
        OpenMenu()
    end,
    CopyClipboard = function(self, txt)
        CopyClipboard(txt)
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Admin', ADMIN)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Admin.NoClip:Stop()
    _drawingCoords = false
end)

function DrawShittyText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(4)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

RegisterNetEvent('Admin:Client:Marker', function(x, y)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent('Admin:Client:CopyCoords', function(action)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local pedHeading = GetEntityHeading(ped)
    local petRotation = GetEntityRotation(ped)

    if action == 'vec4' then
        CopyClipboard(string.format('vector4(%.3f, %.3f, %.3f, %.3f)', pedCoords.x, pedCoords.y, pedCoords.z, pedHeading))
    elseif action == 'vec2' then
        CopyClipboard(string.format('vector2(%.3f, %.3f)', pedCoords.x, pedCoords.y))
    elseif action == 'z' then
        CopyClipboard(string.format('%.3f', pedCoords.z))
    elseif action == 'h' then
        CopyClipboard(string.format('%.3f', pedHeading))
    elseif action == 'table' then
        CopyClipboard(string.format([[
            x = %.3f,
            y = %.3f,
            z = %.3f,
            h = %.3f,]], pedCoords.x, pedCoords.y, pedCoords.z, pedHeading))
    elseif action == 'rot' then
        CopyClipboard(string.format('vector3(%.3f, %.3f, %.3f)', petRotation.x, petRotation.y, petRotation.z))
    elseif action == 'cctv' then
        CopyClipboard(string.format('x = %.3f, y = %.3f, z = %.3f, r = { x = %.3f, y = %.3f, z = %.3f }', pedCoords.x, pedCoords.y, pedCoords.z, petRotation.x, petRotation.y, petRotation.z))
    else
        CopyClipboard(string.format('vector3(%.3f, %.3f, %.3f)', pedCoords.x, pedCoords.y, pedCoords.z))
    end
end)

RegisterNetEvent('Admin:Client:Recording', function(action)
    if action == 'record' then
        StartRecording(1)
    elseif action == 'stop' then
        StopRecordingAndSaveClip()
    elseif action == 'delete' then
        StopRecordingAndDiscardClip()
    elseif action == 'editor' then
        NetworkSessionLeaveSinglePlayer()
        ActivateRockstarEditor()
    end
end)

RegisterNetEvent('Admin:Client:ChangePed', function(model)
    local hash = GetHashKey(model)
    if IsModelValid(hash) then
        if not HasModelLoaded(hash) then
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(100)
            end
        end

        SetPlayerModel(PlayerId(), hash)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(hash)
        TriggerEvent('Ped:Client:ChangedPed', model)
    end
end)

function DoAdminVehicleAction(action)
    local insideVehicle = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
    if LocalPlayer.state.isDev and insideVehicle and insideVehicle > 0 and DoesEntityExist(insideVehicle) and NetworkHasControlOfEntity(insideVehicle) then
        Callbacks:ServerCallback('Admin:CurrentVehicleAction', { action = action }, function(canDo)
            if canDo then
                if action == 'repair' then
                    if Vehicles.Repair:Normal(insideVehicle) then
                        
                    end
                elseif action == 'repair_full' then
                    if Vehicles.Repair:Full(insideVehicle) then

                    end
                elseif action == 'repair_engine' then
                    if Vehicles.Repair:Engine(insideVehicle) then
                        
                    end
                end
            end
        end)
    end
end