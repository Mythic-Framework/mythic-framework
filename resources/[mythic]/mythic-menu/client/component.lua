cbs = {}
menuItems = {}
submenus = {}

allowUnfocus = {}
stupidFocusLoss = false

MENU_OPEN = false

--RetrieveComponents
AddEventHandler('Menu:Shared:DependencyUpdate', SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH)
function SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH()
    UISounds = exports['mythic-base']:FetchComponent('UISounds')
end

AddEventHandler('Core:Shared:Ready', function(component)
    exports['mythic-base']:RequestDependencies('Menu', {
        'UISounds',
    }, function(error)  
        SomeBullshitNameThatIsntFuckingUsedFUCKYOUBITCH()
        if #error > 0 then return end
    end)
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Menu', MENU)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    SendNUIMessage({
        type = 'APP_HIDE'
    })
    SetNuiFocus(false, false)

    MENU_OPEN = false
    stupidFocusLoss = false

    for k, v in pairs(cbs) do
        if string.match(k, "-close") then
            v()
        end
    end

    cbs = {}

    collectgarbage()
end)

MENU = {
    Create = function(self, mId, mLabel, openCb, closeCb, canFocusBeLost)
        local menuId = mId
        local menuLabel = mLabel

        menuItems[menuId] = {}

        allowUnfocus[menuId] = canFocusBeLost

        local _data = {
            data = {
                id = menuId,
                label = menuLabel
            },
            Show = function(self, back)
                if not back and openCb ~= nil then
                    openCb()
                end

                self.data.items = menuItems[menuId]
                SendNUIMessage({
                    type = 'SETUP_MENU',
                    data = {
                        data = self.data
                    }
                })
                SendNUIMessage({
                    type = 'APP_SHOW'
                })
                SetNuiFocus(true, true)

                MENU_OPEN = menuId
            end,
            SubMenu = function(self, id, back)
                local data = submenus[id]
                data.items = menuItems[id]
                SendNUIMessage({
                    type = 'SUBMENU_OPEN',
                    data = {
                        data = data,
                        addHistroy = not back
                    }
                })
            end,
            Close = function(self)
                SendNUIMessage({
                    type = 'APP_HIDE'
                })
                SetNuiFocus(false, false)
                SendNUIMessage({
                    type = 'CLEAR_MENU'
                })
                if closeCb ~= nil then
                    closeCb()
                end
                menuItems = {}
                cbs = {}
                submenus = {}

                collectgarbage()

                MENU_OPEN = false
                stupidFocusLoss = false
            end,
            ValidateOptions = function(self, type, options)
                local reqAtts = {
                    ['BUTTON'] = {},
                    ['ADVANCED'] = { 'secondaryLabel' },
                    ['CHECKBOX'] = { 'selected' },
                    ['SLIDER'] = { 'min', 'max', 'current' },
                    ['TICKER'] = { 'min', 'max', 'current' },
                    ['COLORPICKER'] = { 'current' },
                    ['COLORLIST'] = { 'current', 'colors' },
                    ['INPUT'] = { 'max' },
                    ['NUMBER'] = {},
                    ['SELECT'] = { 'current', 'list' },
                    ['TEXT'] = {},
                    ['SUBMENU'] = {},
                    ['GOBACK'] = {},
                }

                if reqAtts[type] ~= nil then
                    for k, v in ipairs(reqAtts[type]) do
                        if options[v] == nil then
                            return false
                        end
                    end

                    return true
                else
                    return false
                end
            end,
            UpdateValue = function(self, itemId, dataKey, newVal)
                for k, v in pairs(menuItems[menuId]) do
                    if v.id == itemId and v.options then
                        menuItems[menuId][k].options[dataKey] = newVal
                    end
                end
            end
        }

        _data.Add = {
            Button = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('BUTTON', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'BUTTON',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            AdvButton = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('ADVANCED', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'ADVANCED',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            Slider = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SLIDER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.value)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'SLIDER',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            Ticker = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('TICKER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.value)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'TICKER',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            CheckBox = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('CHECKBOX', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'selected', data.data.selected)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'CHECKBOX',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            ColorPicker = function(self, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('COLORPICKER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.color)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'COLORPICKER',
                    id = id,
                    options = options
                })
                return id
            end,
            ColorList = function(self, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('COLORLIST', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.color)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'COLORLIST',
                    id = id,
                    options = options
                })
                return id
            end,
            Input = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('INPUT', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.value)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'INPUT',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            Number = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('NUMBER', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.value)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'NUMBER',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            Select = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SELECT', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = function(data)
                    _data:UpdateValue(data.id, 'current', data.data.value)
                    selectCb(data)
                end
                table.insert(menuItems[menuId], {
                    type = 'SELECT',
                    id = id,
                    label = label,
                    options = options
                })
                return id
            end,
            Text = function(self, text, classes)
                if not _data:ValidateOptions('TEXT', options) then
                    return
                end

                local id = menuId .. '-item' .. #menuItems[menuId]
                table.insert(menuItems[menuId], {
                    type = 'TEXT',
                    id = id,
                    label = text,
                    options = {
                        classes = classes
                    }
                })
                return id
            end,
            SubMenu = function(self, label, menu, options, openCb, closeCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('SUBMENU', options) then
                    return
                end
                if openCb == nil then
                    openCb = function(id, back)
                        _data:SubMenu(id, back)
                    end
                end
                cbs[menu.data.id .. '-open'] = openCb
                if closeCb ~= nil then
                    cbs[menu.data.id .. '-close'] = closeCb
                end

                table.insert(menuItems[menuId], {
                    type = 'SUBMENU',
                    id = menu.data.id,
                    label = label,
                    menu = menu.data.id,
                    options = options
                })
                submenus[menu.data.id] = menu.data
            end,
            SubMenuBack = function(self, label, options, selectCb)
                if options == nil then
                    options = { disabled = false }
                end
                if options.disabled == nil then
                    options.disabled = false
                end
                if not _data:ValidateOptions('GOBACK', options) then
                    return
                end
                local id = menuId .. '-item' .. #menuItems[menuId]
                cbs[id] = selectCb
                table.insert(menuItems[menuId], {
                    type = 'GOBACK',
                    id = id,
                    label = label,
                    options = options
                })
            end
        }
        
        _data.Remove = function(self, id)
            for k, v in ipairs(self.data.items) do
                if v.id == id then
                    table.remove(self.data.items, k)
                    cbs[id] = nil
                    return
                end
            end
        end

        _data.Update = {
            Item = function(self, id, label, data, dontPushUpdates)
                for k, v in ipairs(menuItems[menuId]) do
                    if v.id == id then
                        for k2, v2 in pairs(data) do
                            v.options[k2] = v2
                        end
                        v.label = label
                        _data.data.items = menuItems[menuId]
                        if not dontPushUpdates then
                            SendNUIMessage({
                                type = "UPDATE_MENU",
                                data = {
                                    data = _data.data
                                }
                            })
                        end
                        return
                    end
                end
            end,
            Submenu = function(self, id, data)
                submenus[id] = data
            end
        }

        cbs[menuId .. '-open'] = function(id, back)
            _data:Show(back)
        end
        if closeCb ~= nil then
            cbs[menuId .. '-close'] = closeCb
        end

        return _data
    end,
    IsOpen = function(self)
        if MENU_OPEN then
            return true
        end
        return false
    end
}