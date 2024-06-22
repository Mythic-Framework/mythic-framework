_loadedScenes = {}
_nearbyScenes = {}

_hiddenScenes = {}

AddEventHandler('Scenes:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Game = exports['mythic-base']:FetchComponent('Game')
    Targeting = exports['mythic-base']:FetchComponent('Targeting')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Animations = exports['mythic-base']:FetchComponent('Animations')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Polyzone = exports['mythic-base']:FetchComponent('Polyzone')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Weapons = exports['mythic-base']:FetchComponent('Weapons')
    Progress = exports['mythic-base']:FetchComponent('Progress')
    Vehicles = exports['mythic-base']:FetchComponent('Vehicles')
    Targeting = exports['mythic-base']:FetchComponent('Targeting')
    ListMenu = exports['mythic-base']:FetchComponent('ListMenu')
    Action = exports['mythic-base']:FetchComponent('Action')
    Sounds = exports['mythic-base']:FetchComponent('Sounds')
    Scenes = exports['mythic-base']:FetchComponent('Scenes')
    Menu = exports['mythic-base']:FetchComponent('Menu')
    Input = exports['mythic-base']:FetchComponent('Input')
    Keybinds = exports['mythic-base']:FetchComponent('Keybinds')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Scenes', {
        'Logger',
        'Fetch',
        'Callbacks',
        'Game',
        'Menu',
        'Targeting',
        'Notification',
        'Utils',
        'Animations',
        'Polyzone',
        'Jobs',
        'Weapons',
        'Progress',
        'Vehicles',
        'Targeting',
        'ListMenu',
        'Action',
        'Sounds',
        'Scenes',
        'Input',
        'Keybinds',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        Keybinds:Add('scene_create', '', 'keyboard', 'Scenes - Create Scene', function()
            Scenes:BeginCreation()
        end)
    end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            Wait(2000)
            local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
            _nearbyScenes = {}
            collectgarbage()

            for k, v in pairs(_loadedScenes) do
                if (#(playerCoords - v.coords) <= 75.0) and (v.route == LocalPlayer.state.currentRoute) then
                    table.insert(_nearbyScenes, v)
                end
            end
        end
    end)

    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            if #_nearbyScenes > 0 then
                local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
                for k, v in ipairs(_nearbyScenes) do
                    if #(playerCoords - v.coords) <= v.distance and not _hiddenScenes[v._id] then
                        DrawScene(v)
                    end
                end
            else
                Wait(250)
            end
            Wait(3)
        end
    end)
end)

RegisterNetEvent('Scenes:Client:RecieveScenes', function(scenes)
    for k,v in pairs(scenes) do
        if v and v.coords then
            v.coords = vector3(v.coords.x, v.coords.y, v.coords.z)
        end
    end

    _loadedScenes = scenes
end)

RegisterNetEvent('Scenes:Client:AddScene', function(id, scene)
    scene.coords = vector3(scene.coords.x, scene.coords.y, scene.coords.z)
    _loadedScenes[id] = scene
end)

RegisterNetEvent('Scenes:Client:RemoveScene', function(id)
    _loadedScenes[id] = nil
end)

RegisterNetEvent('Scenes:Client:RemoveScenes', function(ids)
    for k, v in ipairs(ids) do
        _loadedScenes[v] = nil
    end
end)

_creationOpen = false
_creationMenu = nil

_SCENES = {
    BeginCreation = function(self, text, staff)
        if _creationOpen then
            return
        end

        local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)

        if not hitting then
            return Notification:Error('Cannot Place Here')
        end

        if #(GetEntityCoords(LocalPlayer.state.ped) - endCoords) > 5.0 then
            return Notification:Error('Cannot Place That Far Away')
        end

        if IsEntityAVehicle(entity) or IsEntityAPed(entity) then
            return Notification:Error('Cannot Place On a Vehicle or Person')
        end

        Input:Show(
            'Scene Creation',
            'Scene Text. Use ~n~ For a Newline',
            {
                {
                    id = 'text',
                    type = 'multiline',
                    options = {
                        inputProps = {
                            value = text,
                            maxLength = 290,
                        },
                    },
                },
            },
            'Scenes:Client:OpenOptionsMenu',
            {
                staff = staff,
                coords = endCoords,
                entity = entity,
            }
        )
    end,
    Deletion = function(self)
        if _nearbyScenes and #_nearbyScenes > 0 then
            local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)
            if hitting and endCoords then
                local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
                local lastDist = nil
                local lastId = nil
                for k, v in pairs(_nearbyScenes) do
                    local dist = #(pedCoords - v.coords)
                    if (not lastDist) or (lastDist and dist < lastDist) then
                        lastDist = dist
                        lastId = v._id
                    end
                end

                Callbacks:ServerCallback('Scenes:Delete', lastId, function(success, invalidPermissions)
                    if success then
                        Notification:Success('Scene Deleted')
                    else
                        if invalidPermissions then
                            Notification:Error('Invalid Permissions to Delete This Scene')
                        else
                            Notification:Error('Failed to Delete Scene')
                        end
                    end
                end)
            end
        end
    end,
    Edit = function(self)
        if _nearbyScenes and #_nearbyScenes > 0 then
            local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(15.0, LocalPlayer.state.ped)
            if hitting and endCoords then
                local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
                local lastDist = nil
                local lastId = nil
                for k, v in pairs(_nearbyScenes) do
                    local dist = #(pedCoords - v.coords)
                    if (not lastDist) or (lastDist and dist < lastDist) then
                        lastDist = dist
                        lastId = v._id
                    end
                end

                Callbacks:ServerCallback('Scenes:CanEdit', lastId, function(success, isStaff)
                    if success then
                        EditScene(lastId, _loadedScenes[lastId], { staff = isStaff })
                    else
                        Notification:Error('Invalid Permissions to Edit This Scene')
                    end
                end)
            end
        end
    end,
}

_lastData = nil

AddEventHandler('Scenes:Client:OpenOptionsMenu', function(values, data)
    if _creationOpen then return; end
    local creatingSceneData = deepcopy(_defaultSceneData)

    if _lastData then
        creatingSceneData = _lastData
    end

    creatingSceneData.text.text = values.text
    creatingSceneData.coords = vector3(data.coords.x, data.coords.y, data.coords.z)
    creatingSceneData.route = LocalPlayer.state.currentRoute

    _creationMenu = Menu:Create('scenes', 'Scene Creation', function()
        _creationOpen = true
        CreateThread(function()
            while _creationOpen do
                DrawScene(creatingSceneData)
                Wait(2)
            end
        end)

        CreateThread(function()
            while _creationOpen do
                if (#(GetEntityCoords(LocalPlayer.state.ped) - creatingSceneData.coords) > 10.0) then
                    Notification:Error('Scene Creation Cancelled - Too Far Away')

                    _creationMenu:Close()
                    break
                end
                Wait(2500)
            end
        end)
    end, function()
        _creationMenu = nil
        _creationOpen = false
        collectgarbage()
    end, true)

    _creationMenu.Add:Text('The Scene Will Be Created Where Your Camera is Pointed<br>Press SHIFT to Toggle Control of the Camera', { 'pad', 'code', 'center', 'textLarge' })

    _creationMenu.Add:Input('Scene Text', {
        disabled = false,
        max = 290,
        current = creatingSceneData.text.text,
    }, function(data)
        creatingSceneData.text.text = data.data.value
    end)

    -- Text Font

    local fontMenuList = {}

    for k, v in ipairs(_sceneFonts) do
        table.insert(fontMenuList, {
            label = v.name,
            value = k,
        })
    end

    _creationMenu.Add:Select('Text Font', {
        disabled = false,
        current = creatingSceneData.text.font,
        list = fontMenuList,
    }, function(data)
        creatingSceneData.text.font = data.data.value
    end)

    _creationMenu.Add:Slider('Font Size', {
        current = creatingSceneData.text.size,
        min = 0.25,
        max = 0.7,
        step = 0.05,
    }, function(data)
        creatingSceneData.text.size = tonumber(data.data.value) or creatingSceneData.text.size
    end)

    _creationMenu.Add:ColorPicker({
        current = creatingSceneData.text.color
    }, function(data)
        creatingSceneData.text.color = data.data.color
    end)

    _creationMenu.Add:Select('Text Outline', {
        disabled = false,
        current = creatingSceneData.text.outline,
        list = {
            { label = 'None', value = false },
            { label = 'Outline', value = 'outline' },
            { label = 'Shadow', value = 'shadow' },
        },
    }, function(data)
        creatingSceneData.text.outline = data.data.value
    end)

    local backgroundMenuList = {
        { label = 'None', value = 0 }
    }

    for k, v in ipairs(_sceneBackgrounds) do
        table.insert(backgroundMenuList, {
            label = v.name,
            value = k,
        })
    end

    _creationMenu.Add:Select('Background', {
        disabled = false,
        current = creatingSceneData.background.type,
        list = backgroundMenuList,
    }, function(data)
        creatingSceneData.background.type = data.data.value
    end)

    _creationMenu.Add:ColorPicker({
        current = creatingSceneData.background.color
    }, function(data)
        creatingSceneData.background.color = data.data.color
    end)

    _creationMenu.Add:Slider('Adjust Background Height', {
        current = creatingSceneData.background.h,
        min = -0.05,
        max = 0.6,
        step = 0.01,
    }, function(data)
        creatingSceneData.background.h = tonumber(data.data.value) or creatingSceneData.background.h
    end)

    _creationMenu.Add:Slider('Adjust Background Width', {
        current = creatingSceneData.background.w,
        min = -0.05,
        max = 0.5,
        step = 0.01,
    }, function(data)
        creatingSceneData.background.w = tonumber(data.data.value) or creatingSceneData.background.w
    end)

    _creationMenu.Add:Slider('Adjust Background X', {
        current = creatingSceneData.background.x,
        min = -0.05,
        max = 0.05,
        step = 0.005,
    }, function(data)
        creatingSceneData.background.x = tonumber(data.data.value) or creatingSceneData.background.x
    end)

    _creationMenu.Add:Slider('Adjust Background Y', {
        current = creatingSceneData.background.y,
        min = -0.05,
        max = 0.05,
        step = 0.005,
    }, function(data)
        creatingSceneData.background.y = tonumber(data.data.value) or creatingSceneData.background.y
    end)

    _creationMenu.Add:Slider('Adjust Background Rotation', {
        current = creatingSceneData.background.rotation,
        min = 0,
        max = 180,
        step = 1,
    }, function(data)
        creatingSceneData.background.rotation = tonumber(data.data.value) or creatingSceneData.background.rotation
    end)

    _creationMenu.Add:Slider('Distance Visible', {
        current = creatingSceneData.distance,
        min = 1.0,
        max = 10.0,
        step = 0.5,
    }, function(data)
        creatingSceneData.distance = tonumber(data.data.value) or creatingSceneData.distance
    end)

    local timeList = {
        { label = '1 Hour', value = 1 },
        { label = '2 Hours', value = 2 },
        { label = '3 Hours', value = 3 },
        { label = '6 Hours', value = 6 },
        { label = '12 Hours', value = 12 },
        { label = '24 Hours', value = 24 },
    }

    if data.staff then
        table.insert(timeList, {
            label = 'Permanent (Staff)',
            value = false,
        })
    end

    _creationMenu.Add:Select('Time Length', {
        disabled = false,
        current = creatingSceneData.length,
        list = timeList,
    }, function(data)
        if data.data.value then
            creatingSceneData.length = tonumber(data.data.value) or creatingSceneData.length
        else
            creatingSceneData.length = false
        end
    end)

    _creationMenu.Add:Button('Create Scene', { success = true }, function()
        _lastData = creatingSceneData

        Callbacks:ServerCallback('Scenes:Create', {
            scene = creatingSceneData,
            data = data,
        }, function(success)
            if success then
                Notification:Success('Scene Placed')
            else
                Notification:Error('Failed to Place Scene')
            end
        end)

        _creationMenu:Close()
    end)

    _creationMenu:Show()
end)

function EditScene(id, fuckface, data)
    if _creationOpen then return; end
    local creatingSceneData = deepcopy(fuckface)

    _creationMenu = Menu:Create('scenes', 'Edit Scene', function()
        _creationOpen = true
        _hiddenScenes[fuckface._id] = true
        CreateThread(function()
            while _creationOpen do
                DrawScene(creatingSceneData)
                Wait(2)
            end

            _hiddenScenes[fuckface._id] = nil
        end)

        CreateThread(function()
            while _creationOpen do
                if (#(GetEntityCoords(LocalPlayer.state.ped) - creatingSceneData.coords) > 10.0) then
                    Notification:Error('Scene Edit Cancelled - Too Far Away')

                    _creationMenu:Close()
                    break
                end
                Wait(2500)
            end
        end)
    end, function()
        _creationMenu = nil
        _creationOpen = false
        collectgarbage()
    end, true)


    _creationMenu.Add:Input('Scene Text', {
        disabled = false,
        max = 290,
        current = creatingSceneData.text.text,
    }, function(data)
        creatingSceneData.text.text = data.data.value
    end)

    -- Text Font

    local fontMenuList = {}

    for k, v in ipairs(_sceneFonts) do
        table.insert(fontMenuList, {
            label = v.name,
            value = k,
        })
    end

    _creationMenu.Add:Select('Text Font', {
        disabled = false,
        current = creatingSceneData.text.font,
        list = fontMenuList,
    }, function(data)
        creatingSceneData.text.font = data.data.value
    end)

    _creationMenu.Add:Slider('Font Size', {
        current = creatingSceneData.text.size,
        min = 0.25,
        max = 0.7,
        step = 0.05,
    }, function(data)
        creatingSceneData.text.size = tonumber(data.data.value) or creatingSceneData.text.size
    end)

    _creationMenu.Add:ColorPicker({
        current = creatingSceneData.text.color
    }, function(data)
        creatingSceneData.text.color = data.data.color
    end)

    _creationMenu.Add:Select('Text Outline', {
        disabled = false,
        current = creatingSceneData.text.outline,
        list = {
            { label = 'None', value = false },
            { label = 'Outline', value = 'outline' },
            { label = 'Shadow', value = 'shadow' },
        },
    }, function(data)
        creatingSceneData.text.outline = data.data.value
    end)

    local backgroundMenuList = {
        { label = 'None', value = 0 }
    }

    for k, v in ipairs(_sceneBackgrounds) do
        table.insert(backgroundMenuList, {
            label = v.name,
            value = k,
        })
    end

    _creationMenu.Add:Select('Background', {
        disabled = false,
        current = creatingSceneData.background.type,
        list = backgroundMenuList,
    }, function(data)
        creatingSceneData.background.type = data.data.value
    end)

    _creationMenu.Add:ColorPicker({
        current = creatingSceneData.background.color
    }, function(data)
        creatingSceneData.background.color = data.data.color
    end)

    _creationMenu.Add:Slider('Adjust Background Height', {
        current = creatingSceneData.background.h,
        min = -0.05,
        max = 0.6,
        step = 0.01,
    }, function(data)
        creatingSceneData.background.h = tonumber(data.data.value) or creatingSceneData.background.h
    end)

    _creationMenu.Add:Slider('Adjust Background Width', {
        current = creatingSceneData.background.w,
        min = -0.05,
        max = 0.5,
        step = 0.01,
    }, function(data)
        creatingSceneData.background.w = tonumber(data.data.value) or creatingSceneData.background.w
    end)

    _creationMenu.Add:Slider('Adjust Background X', {
        current = creatingSceneData.background.x,
        min = -0.05,
        max = 0.05,
        step = 0.005,
    }, function(data)
        creatingSceneData.background.x = tonumber(data.data.value) or creatingSceneData.background.x
    end)

    _creationMenu.Add:Slider('Adjust Background Y', {
        current = creatingSceneData.background.y,
        min = -0.05,
        max = 0.05,
        step = 0.005,
    }, function(data)
        creatingSceneData.background.y = tonumber(data.data.value) or creatingSceneData.background.y
    end)

    _creationMenu.Add:Slider('Adjust Background Rotation', {
        current = creatingSceneData.background.rotation,
        min = 0,
        max = 180,
        step = 1,
    }, function(data)
        creatingSceneData.background.rotation = tonumber(data.data.value) or creatingSceneData.background.rotation
    end)

    _creationMenu.Add:Slider('Distance Visible', {
        current = creatingSceneData.distance,
        min = 1.0,
        max = 10.0,
        step = 0.5,
    }, function(data)
        creatingSceneData.distance = tonumber(data.data.value) or creatingSceneData.distance
    end)

    local timeList = {
        { label = '1 Hour', value = 1 },
        { label = '2 Hours', value = 2 },
        { label = '3 Hours', value = 3 },
        { label = '6 Hours', value = 6 },
        { label = '12 Hours', value = 12 },
        { label = '24 Hours', value = 24 },
    }

    if data.staff then
        table.insert(timeList, {
            label = 'Permanent (Staff)',
            value = false,
        })
    end

    _creationMenu.Add:Select('Time Length', {
        disabled = false,
        current = creatingSceneData.length,
        list = timeList,
    }, function(data)
        if data.data.value then
            creatingSceneData.length = tonumber(data.data.value) or creatingSceneData.length
        else
            creatingSceneData.length = false
        end
    end)

    _creationMenu.Add:Button('Edit Scene', { success = true }, function()
        Callbacks:ServerCallback('Scenes:Edit', {
            id = id,
            scene = creatingSceneData,
            data = data,
        }, function(success)
            if success then
                Notification:Success('Scene Edited')
            else
                Notification:Error('Failed to Edit Scene')
            end
        end)

        _creationMenu:Close()
    end)

    _creationMenu:Show()
end

AddEventHandler('Proxy:Shared:RegisterReady', function()
	exports["mythic-base"]:RegisterComponent('Scenes', _SCENES)
end)

RegisterNetEvent('Scenes:Client:Creation', function(args, asStaff)
    Scenes:BeginCreation(#args > 0 and table.concat(args, ' ') or nil, asStaff)
end)

RegisterNetEvent('Scenes:Client:Deletion', function()
    Scenes:Deletion()
end)

RegisterNetEvent('Scenes:Client:StartEdit', function()
    Scenes:Edit()
end)

CreateThread(function()
    while not HasStreamedTextureDictLoaded('arpscenes') do
        Wait(100) 
        RequestStreamedTextureDict('arpscenes', true)
    end
end)