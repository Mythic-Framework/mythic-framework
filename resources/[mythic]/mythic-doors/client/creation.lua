local creationHelper = false
local creationHelperEntity = false
local creationHelperEntityCoords = false

RegisterNetEvent('Doors:Client:DoorHelper', function()
    if creationHelper then
        creationHelper = false
    else
        creationHelper = true
        creationHelperEntity = false
        CreateThread(function()
            while creationHelper do
                if creationHelperEntity and creationHelperEntityCoords then
                    DrawMarker(28, creationHelperEntityCoords.x, creationHelperEntityCoords.y, creationHelperEntityCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.6, 0.6, 0.6, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                else
                    Wait(1000)
                end
                Wait(5)
            end
        end)
    end
end)

AddEventHandler('Targeting:Client:TargetChanged', function(entity)
    if creationHelper then
        if entity and IsEntityAnObject(entity) then
            creationHelperEntity = entity
            creationHelperEntityCoords = GetEntityCoords(creationHelperEntity)
        elseif creationHelperEntity then
            SetEntityAlpha(creationHelperEntity, 255)
            creationHelperEntity = false
        end
    end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if creationHelper and creationHelperEntity then
        local name = GetUserInput('Door Reference ID: ')
        if name == nil then
            name = "no_name"
        end

        local data = {
            name = name,
            entity = creationHelperEntity,
            model = GetEntityModel(creationHelperEntity),
            coords = GetEntityCoords(creationHelperEntity),
            heading = GetEntityHeading(creationHelperEntity),
        }

        Utils:Print(data)
        TriggerServerEvent('Doors:Server:PrintDoor', data)
        Notification:Success('Saved Door To File')
        creationHelper = false
    end
end)

-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
function GetUserInput(windowTitle, defaultText, maxInputLength)
    -- Create the window title string.
    local resourceName = string.upper(GetCurrentResourceName())
    local textEntry = resourceName .. "_WINDOW_TITLE"
    if windowTitle == nil then
        windowTitle = "Enter:"
    end
    AddTextEntry(textEntry, windowTitle)

    -- Display the input box.
    DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
    Wait(0)
    -- Wait for a result.
    while true do
        local keyboardStatus = UpdateOnscreenKeyboard();
        if keyboardStatus == 3 then -- not displaying input field anymore somehow
            return nil
        elseif keyboardStatus == 2 then -- cancelled
            return nil
        elseif keyboardStatus == 1 then -- finished editing
            return GetOnscreenKeyboardResult()
        else
            Wait(0)
        end
    end
end