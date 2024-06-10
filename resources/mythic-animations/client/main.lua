GLOBAL_VEH = nil

IsInAnimation = false

_isPointing = false
_isCrouched = false

walkStyle = 'default'
facialExpression = 'default'
emoteBinds = {}

_doingStateAnimation = false

AddEventHandler('Animations:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Menu = exports['mythic-base']:FetchComponent('Menu')
    Damage = exports['mythic-base']:FetchComponent('Damage')
    Keybinds = exports['mythic-base']:FetchComponent('Keybinds')
    Animations = exports['mythic-base']:FetchComponent('Animations')
    Targeting = exports['mythic-base']:FetchComponent('Targeting')
    Interaction = exports['mythic-base']:FetchComponent('Interaction')
    Hud = exports['mythic-base']:FetchComponent('Hud')
    Weapons = exports['mythic-base']:FetchComponent('Weapons')
    ListMenu = exports['mythic-base']:FetchComponent('ListMenu')
    Input = exports['mythic-base']:FetchComponent('Input')
    Sounds = exports['mythic-base']:FetchComponent('Sounds')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Animations', {
        'Callbacks',
        'Utils',
        'Notification',
        'Menu',
        'Damage',
        'Keybinds',
        'Animations',
        'Targeting',
        'Interaction',
        'Hud',
        'Weapons',
        'ListMenu',
        'Input',
        'Sounds',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveComponents()
        RegisterKeybinds()

        RegisterChairTargets()

        Interaction:RegisterMenu("expressions", 'Expressions', "face-confounded", function()
            Interaction:Hide()
            Animations:OpenExpressionsMenu()
        end)

        Interaction:RegisterMenu("walks", 'Walk Styles', "person-walking", function()
            Interaction:Hide()
            Animations:OpenWalksMenu()
        end)
    end)
end)

AddEventHandler('Characters:Client:Spawn', function()
    Animations.Emotes:Cancel()
    TriggerEvent('Animations:Client:StandUp', true, true)

    Citizen.CreateThread(function()
        while LocalPlayer.state.loggedIn do 
            Citizen.Wait(5000)
            if not _isCrouched and not LocalPlayer.state.drunkMovement then
                Animations.PedFeatures:RequestFeaturesUpdate()
            end
        end
    end)

    Citizen.CreateThread(function()
        while LocalPlayer.state.loggedIn do
            Citizen.Wait(5)
            DisableControlAction(0, 36, true)
            if IsDisabledControlJustPressed(0, 36) then 
                Animations.PedFeatures:ToggleCrouch()
            end
            if IsInAnimation and IsPedShooting(LocalPlayer.state.ped) then
                Animations.Emotes:ForceCancel()
            end
        end
    end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    Animations.Emotes:ForceCancel()
    Citizen.Wait(20)

    LocalPlayer.state:set('anim', false, true)
end)

RegisterNetEvent('Vehicles:Client:EnterVehicle')
AddEventHandler('Vehicles:Client:EnterVehicle', function(veh)
    GLOBAL_VEH = veh
end)

RegisterNetEvent('Vehicles:Client:ExitVehicle')
AddEventHandler('Vehicles:Client:ExitVehicle', function()
    GLOBAL_VEH = nil
end)

RegisterNetEvent('Animations:Client:RecieveStoredAnimSettings')
AddEventHandler('Animations:Client:RecieveStoredAnimSettings', function(data)
    if data then
        walkStyle, facialExpression, emoteBinds = data.walk, data.expression, data.emoteBinds
        Animations.PedFeatures:RequestFeaturesUpdate()
    else -- There is non stored and reset back to default
        walkStyle, facialExpression, emoteBinds =  Config.DefaultSettings.walk, Config.DefaultSettings.expression, Config.DefaultSettings.emoteBinds
        Animations.PedFeatures:RequestFeaturesUpdate()
    end
end)


function RegisterKeybinds()
    Keybinds:Add('pointing', 'b', 'keyboard', 'Pointing - Toggle', function()
        if _isPointing then
            StopPointing()
        else
            StartPointing()
        end
    end)

    Keybinds:Add('emote_cancel', 'x', 'keyboard', 'Emotes - Cancel Current', function()
        Animations.Emotes:Cancel()

        TriggerEvent('Animations:Client:StandUp')
        TriggerEvent('Animations:Client:Selfie', false)
    end)

    -- Don't specify and key so then players can set it themselves if they want to use...
    Keybinds:Add('emote_menu', '', 'keyboard', 'Emotes - Open Menu', function()
        Animations:OpenMainEmoteMenu()
    end)

    -- There are 5 emote binds and by default they use numbers 5, 6, 7, 8 and 9
    for bindNum = 1, 5 do
        Keybinds:Add('emote_bind_'.. bindNum, tostring(4 + bindNum), 'keyboard', 'Emotes - Bind #'.. bindNum, function()
            Animations.EmoteBinds:Use(bindNum)
        end)
    end
end