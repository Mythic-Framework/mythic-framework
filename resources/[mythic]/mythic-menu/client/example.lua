local cam = nil
local oPos = nil
local oPosH = 0

AddEventHandler('MenuExample:Shared:DependencyUpdate', RetrieveComponentsExample)
function RetrieveComponentsExample()
    Menu = exports['mythic-base']:FetchComponent('Menu')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('MenuExample', {
        'Menu',
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponentsExample()
    end)
end)

RegisterNetEvent('Menu:Client:Test') 
AddEventHandler('Menu:Client:Test', function()
    local menu = Menu:Create('menu1', 'Menu 1')
    menu.Add:ColorPicker({ disabled = false, current = { r = 0, g = 255, b = 0 }}, function(data)
        print(json.encode(data.data.color))
    end)
    menu.Add:ColorList({ disabled = false, current = 1, colors = {
        { label = 'White', hex = '#fff' },
        { label = 'Black', rgb = { r = 0, g = 0, b = 0 }, hex = '#000' },
        { label = 'Red', rgb = { r = 255, g = 0, b = 0 }},
        { label = 'Green', rgb = { r = 0, g = 255, b = 0 }},
        { label = 'Blue', rgb = { r = 0, g = 0, b = 255 }}
    }}, function(data)
        print(data.data.color)
    end)
    menu.Add:SubMenuBack('Back')

    local root = Menu:Create('root', 'Root Menu', function(id, back)
        oPos = GetEntityCoords(PlayerPedId())
        oPosH = GetEntityHeading(PlayerPedId())

        SetEntityCoords(PlayerPedId(), -1037.7409667969, -2737.6828613281, 19.169267654419 )
        SetEntityHeading(PlayerPedId(), 315.10974121094)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        AttachCamToPedBone(cam, PlayerPedId(), 31085, 0.5, 1.0, 1.0 , 0.0)
        SetCamRot(cam, -20.0, 0.0, 150.0, 0)
        SetCamFov(cam, 60.0)
    end, function()
        SetEntityCoords(PlayerPedId(), oPos)
        SetEntityHeading(PlayerPedId(), oPosH)
        RenderScriptCams(false, true, 500, true, true)
        cam = nil
    end)
    root.Add:Select('Select', {
        disabled = false,
        current = 1,
        list = {
            { label = 'One', value = 1 },
            { label = 'Two', value = 2 },
            { label = 'Three', value = 3 },
            { label = 'Four', value = 4 },
        }
    }, function(data)
        print(data.data.value)
    end)
    root.Add:Button('Button', { disabled = true }, function(data)
        print(data.id .. ' Pressed')
    end)
    root.Add:Button('Button', { success = true }, function(data)
        print(data.id .. ' Pressed')
    end)
    root.Add:AdvButton('Button', { disabled = true, secondaryLabel = '$100' }, function(data)
        print(data.id .. ' Pressed')
    end)
    root.Add:Text('Heading', { 'heading' })
    root.Add:Text('Text', { 'pad', 'textLarge', 'center' })
    root.Add:AdvButton('Button', { disabled = true, secondaryLabel = '$100' }, function(data)
        print(data.id .. ' Pressed')
    end)
    root.Add:CheckBox('Checkbox', { checked = false }, function(data)
        print(data.data.selected)
    end)
    root.Add:Ticker('Ticker', {
        disabled = false,
        min = 12,
        max = 166,
        current = 76
    }, function(data)
        print(data.data.value)
    end)
    root.Add:Slider('Slider', {
        disabled = false,
        min = 0,
        max = 100,
        current = 50
    }, function(data)
        print(data.data.value)
    end)
    root.Add:Ticker('Ticker', {
        disabled = false,
        min = 2,
        options = {
            { label = 'Option 1', value = 0 },
            { label = 'Option 2', value = 1 },
            { label = 'Option 3', value = 2 },
            { label = 'Option 4', value = 3 },
            { label = 'Option 5', value = 4 },
            { label = 'Option 6', value = 5 },
            { label = 'Option 7', value = 6 },
        }
    }, function(data)
        print(data.data.value)
    end)
    root.Add:Input('Input', {
        disabled = false,
        max = 10,
        current = nil,
    }, function(data)
        print(data.data.value)
    end)
    root.Add:Select('Select', {
        disabled = false,
        current = 1,
        list = {
            { label = 'One', value = 1 },
            { label = 'Two', value = 2 },
            { label = 'Three', value = 3 },
            { label = 'Four', value = 4 },
        }
    }, function(data)
        print(data.data.value)
    end)
    root.Add:SubMenu('Sub Menu', menu)
    root.Add:SubMenuBack('Back')
    root:Show()
end)