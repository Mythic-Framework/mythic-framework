local customsMenu = false
local customsMenuSubs = nil

local costElementId = nil

local isSaving = false

function CalculateCustomsCost(changingData, costMultiplier)
    local cost = 0
    local addedPaintCosts = {}
    for k, v in pairs(changingData) do
        if k == 'mods' then
            for j, b in pairs(v) do
                local price = _customsConfig.cost.mods[j]
                if price then
                    if type(price) == 'table' then
                        local priceLevel = b + 1
                        if priceLevel > #price or not price[priceLevel] then
                            cost = cost + price[#price]
                        else
                            cost = cost + price[priceLevel]
                        end
                    else
                        cost = cost + price
                    end
                end
            end
        elseif (k == 'color1' and v ~= nil) or (k == 'paintType' and v and v[1] ~= nil) and not addedPaintCosts[1] then
            addedPaintCosts[1] = true
            cost = cost + _customsConfig.paintCost
        elseif (k == 'color2' and v ~= nil) or (k == 'paintType' and v and v[2] ~= nil) and not addedPaintCosts[2] then
            addedPaintCosts[2] = true
            cost = cost + _customsConfig.paintCost
        elseif _customsConfig.cost[k] and v ~= nil then
            cost = cost + _customsConfig.cost[k]
        end
    end

    return math.ceil(cost * costMultiplier)
end

function OpenVehicleCustoms(canInstallPerformance, costMultiplier, settings)
    if CUSTOMS_OPEN then return end

    if not costMultiplier then
        costMultiplier = 1.0
    end

    if not settings then
        settings = {}
    end

    CUSTOMS_OPEN = true
    customsMenuSubs = {}

    local CUST_VEH = GetVehiclePedIsIn(PlayerPedId(), false)

    isSaving = false

    local originalData = Vehicles.Properties:Get(CUST_VEH)
    local changingData = {
        mods = {}
    }

    customsMenu = Menu:Create('vehicle_customs', 'Vehicle Customs', function()
        CUSTOMS_OPEN = true
    end, function()
        Wait(100)
        customsMenu = false
        customsMenuSubs = nil
        collectgarbage()
        
        Notification.Persistent:Remove('veh_customs')

        if not isSaving then
            Logger:Trace('VehicleCustoms', 'Not Saving - Reset Mods')
            Vehicles.Properties:Set(CUST_VEH, originalData)
            Notification:Error('Changes Discarded - You Weren\'t Charged')
        end
        CUSTOMS_OPEN = false
    end, true)

    customsMenu.Add:Text('Press SHIFT to Toggle Control of the Camera', { 'pad', 'code', 'center', 'textLarge' })
    costElementId = customsMenu.Add:Text('Current Total: $0', { 'pad', 'center', 'code', 'textLarge', 'colorSuccess', 'bold' })
    
    SetVehicleModKit(CUST_VEH, 0)
    Notification.Persistent:Standard('veh_customs', 'Current Total: $'.. 0)

    local function updateVehiclePropertyState()
        Vehicles.Properties:Set(CUST_VEH, originalData)
        Vehicles.Properties:Set(CUST_VEH, changingData)

        local newCost = CalculateCustomsCost(changingData, costMultiplier)
        Notification.Persistent:Standard('veh_customs', 'Current Total: $'.. newCost)
        customsMenu.Update:Item(costElementId, 'Current Total: $'.. newCost, {}, true)
    end

    -- PAINT STUFF

    customsMenuSubs['paint'] = Menu:Create('vehicle_customs_paint', 'Paint')

    if not settings.GOVERNMENT_PAINT then
        customsMenuSubs['paint'].Add:Text('Primary Paint Color', { 'heading' })
        customsMenuSubs['paint'].Add:Text('Changing Either Primary Paint Option Costs $'..math.ceil(_customsConfig.paintCost * costMultiplier), { 'pad', 'code', 'center', 'textLarge' })
    
        customsMenuSubs['paint'].Add:Select('Primary Paint Type', {
            disabled = false,
            current = originalData.paintType[1] or 0,
            list = {
                { label = 'Normal', value = 0 },
                { label = 'Metallic', value = 1 },
                { label = 'Pearl', value = 2 },
                { label = 'Matte', value = 3 },
                { label = 'Metal', value = 4 },
                { label = 'Chrome', value = 5 },
            }
        }, function(data)
            if not changingData.paintType then
                changingData.paintType = {}
            end
    
            if originalData.paintType and data.data.value == originalData.paintType[1] then
                changingData.paintType[1] = nil
            else
                changingData.paintType[1] = data.data.value
            end
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['paint'].Add:ColorPicker({
            current = originalData.color1
        }, function(data)
            changingData.color1 = {
                r = data.data.color.r,
                g = data.data.color.g,
                b = data.data.color.b,
            }
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['paint'].Add:Text('Secondary Paint Color', { 'heading' })
        customsMenuSubs['paint'].Add:Text('Changing Either Secondary Paint Option Costs $'..math.ceil(_customsConfig.paintCost * costMultiplier), { 'pad', 'code', 'center', 'textLarge' })
    
        customsMenuSubs['paint'].Add:Select('Secondary Paint Type', {
            disabled = false,
            current = originalData.paintType[2] or 0,
            list = {
                { label = 'Normal', value = 0 },
                { label = 'Metallic', value = 1 },
                { label = 'Pearl', value = 2 },
                { label = 'Matte', value = 3 },
                { label = 'Metal', value = 4 },
                { label = 'Chrome', value = 5 },
            }
        }, function(data)
            if not changingData.paintType then
                changingData.paintType = {}
            end
    
            if originalData.paintType and data.data.value == originalData.paintType[2] then
                changingData.paintType[2] = nil
            else
                changingData.paintType[2] = data.data.value
            end
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['paint'].Add:ColorPicker({
            current = ((changingData.color2 ~= nil and changingData.color2) or originalData.color2)
        }, function(data)
            changingData.color2 = {
                r = data.data.color.r,
                g = data.data.color.g,
                b = data.data.color.b,
            }
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['paint'].Add:Text('Extra Paint Colors', { 'heading' })
    
        customsMenuSubs['paint'].Add:Select('Pearlescent Color - $'.. math.ceil(_customsConfig.cost.pearlescentColor * costMultiplier), {
            disabled = false,
            current = ((changingData.pearlescentColor ~= nil) and changingData.pearlescentColor or (originalData.pearlescentColor or 0)),
            list = _customsConfig.pearlescents,
        }, function(data)
            if data.data.value == originalData.pearlescentColor then
                changingData.pearlescentColor = nil
            else
                changingData.pearlescentColor = data.data.value
            end
    
            updateVehiclePropertyState()
        end)

        customsMenuSubs['paint'].Add:Select('Interior Color - $'.. math.ceil(_customsConfig.cost.interiorColor * costMultiplier), {
            disabled = false,
            current = ((changingData.interiorColor ~= nil) and changingData.interiorColor or (originalData.interiorColor or 0)),
            list = _customsConfig.pearlescents,
        }, function(data)
            if data.data.value == originalData.interiorColor then
                changingData.interiorColor = nil
            else
                changingData.interiorColor = data.data.value
            end
    
            updateVehiclePropertyState()
        end)
    else
        customsMenuSubs['paint'].Add:Select('Paint Presets - $'.. math.ceil(_customsConfig.paintCost * costMultiplier), {
            disabled = false,
            current = false,
            list = {
                { label = 'No Change', value = false },
                { label = 'White', value = { r = 255, g = 255, b = 255 } },
                { label = 'Black', value = { r = 0, g = 0, b = 0 } },
                { label = 'Dark Grey', value = { r = 25, g = 25, b = 25 } },
                { label = 'Grey', value = { r = 60, g = 60, b = 60 } },
                { label = 'Dark Blue', value = { r = 0, g = 16, b = 41 } },
                { label = 'Silver', value = { r = 192, g = 192, b = 192 } },
            }
        }, function(data)
            if data.data.value then
                changingData.color1 = data.data.value
            else
                changingData.color1 = nil
            end

            updateVehiclePropertyState()
        end)
    end

    customsMenuSubs['paint'].Add:SubMenuBack('Go Back', {})

    customsMenu.Add:SubMenu('Paint Respray', customsMenuSubs['paint'], {})



    -- LIVERIES

    customsMenuSubs['livery'] = Menu:Create('vehicle_customs_livery', 'Liveries')

    local hasLiveries = false
    local liveryCount = GetVehicleLiveryCount(CUST_VEH)
    local liveryModCount = GetNumVehicleMods(CUST_VEH, 48)

    if liveryCount > -1 or liveryModCount > 0 then
        hasLiveries = true
        local currentLivery = originalData.livery

        local aLiveryCount = 0
        if liveryModCount > liveryCount then
            aLiveryCount = liveryModCount
        else
            aLiveryCount = liveryCount - 1
        end

        -- local list = {}

        -- table.insert(list, {
        --     label = 'No Change', 
        --     value = -1
        -- })

        -- for i = 0, aLiveryCount do
        --     local liveryName = GetLiveryName(CUST_VEH, i)
        --     if liveryName then
        --         liveryName = GetLabelText(liveryName)
        --     end

        --     table.insert(list, {
        --         label = (liveryName and liveryName or 'Livery #'.. i + 1), 
        --         value = i
        --     })
        -- end

        -- customsMenuSubs['livery'].Add:Select('Liveries - $'.. math.ceil(_customsConfig.cost.livery * costMultiplier), {
        --     disabled = false,
        --     current = originalData.livery or -1,
        --     list = list,
        -- }, function(data)
        --     if (data.data.value == -1) or (data.data.value == originalData.livery) then
        --         changingData.livery = nil
        --     else
        --         changingData.livery = data.data.value
        --     end
        --     updateVehiclePropertyState()
        -- end)

        customsMenuSubs['livery'].Add:Ticker('Liveries - $'.. math.ceil(_customsConfig.cost.livery * costMultiplier), {
            disabled = false,
            current = originalData.livery or -1,
            min = -1,
            max = aLiveryCount
        }, function(data)
            if (data.data.value == -1) or (data.data.value == originalData.livery) then
                changingData.livery = nil
            else
                changingData.livery = data.data.value
            end
            
            updateVehiclePropertyState()
        end)
    end
    
    customsMenuSubs['livery'].Add:SubMenuBack('Go Back', {})
    customsMenu.Add:SubMenu('Livery', customsMenuSubs['livery'], { disabled = not hasLiveries })







    




    -- EXTRAS
    customsMenuSubs['extras'] = Menu:Create('vehicle_customs_extras', 'Extras')
    local hasExtras = false

    local extraItemIds = {}

    customsMenuSubs['extras'].Add:Text('All Changes to Extras Cost $'.. math.ceil(_customsConfig.cost.extras * costMultiplier), { 'pad', 'code', 'center', 'textLarge' })

    for i = 0, 12 do
        if DoesExtraExist(CUST_VEH, i) then
            hasExtras = true
            local extraString = tostring(i)
            extraItemIds[extraString] = customsMenuSubs['extras'].Add:Button('Extra #'..extraString, { success = originalData.extras[extraString] }, function(data)
                if not changingData.extras then changingData.extras = {} end

                extraState = not IsVehicleExtraTurnedOn(CUST_VEH, i)

                if originalData.extras[extraString] == nil or (extraState ~= originalData.extras[extraString]) then
                    changingData.extras[extraString] = extraState
                else
                    changingData.extras[extraString] = nil

                    local anyChanging = false
                    for k, v in pairs(changingData.extras) do
                        if v ~= nil then
                            anyChanging = true
                        end
                    end

                    if not anyChanging then
                        changingData.extras = nil
                    end
                end

                updateVehiclePropertyState()

                customsMenuSubs['extras'].Update:Item(data.id, 'Extra #'..i, {
                    success = IsVehicleExtraTurnedOn(CUST_VEH, i)
                })
            end)
        end
    end

    customsMenuSubs['extras'].Add:Button('Discard Changes', { error = true }, function()
        changingData.extras = nil
        updateVehiclePropertyState()

        for k, v in pairs(extraItemIds) do
            customsMenuSubs['extras'].Update:Item(v, 'Extra #'..k, {
                success = originalData.extras[k]
            })
        end
    end)

    customsMenuSubs['extras'].Add:SubMenuBack('Go Back', {})

    customsMenu.Add:SubMenu('Extras', customsMenuSubs['extras'], { disabled = not hasExtras })









    -- Lighting
    customsMenuSubs['lighting'] = Menu:Create('vehicle_customs_lighting', 'Lighting')

    customsMenuSubs['lighting'].Add:Text('Xenon Lights', { 'heading' })
    customsMenuSubs['lighting'].Add:CheckBox('Xenon Lights - $'.. math.ceil(_customsConfig.cost.mods.xenon * costMultiplier), {
        selected = originalData.mods.xenon
    }, function(data)
        if data.data.selected == originalData.mods.xenon then
            changingData.mods.xenon = nil
        else
            changingData.mods.xenon = data.data.selected
        end

        updateVehiclePropertyState()
    end)

    customsMenuSubs['lighting'].Add:Select('Xenon Lights Color - $'.. math.ceil(_customsConfig.cost.mods.xenonColor * costMultiplier), {
        disabled = false,
        current = originalData.mods.xenonColor or -1,
        list = {
            { label = 'Default', value = 255 },
            { label = 'White', value = 0 },
            { label = 'Blue', value = 1 },
            { label = 'Electric Blue', value = 2 },
            { label = 'Mint Green', value = 3 },
            { label = 'Lime Green', value = 4 },
            { label = 'Yellow', value = 5 },
            { label = 'Golden Shower', value = 6 },
            { label = 'Orange', value = 7 },
            { label = 'Red', value = 8 },
            { label = 'Pony Pink', value = 9 },
            { label = 'Hot Pink', value = 10 },
            { label = 'Purple', value = 11 },
            { label = 'Blacklight', value = 12 },
        },
    }, function(data)
        if data.data.value == originalData.mods.xenonColor then
            changingData.mods.xenonColor = nil
        else
            changingData.mods.xenonColor = data.data.value
        end

        updateVehiclePropertyState()
    end)

    customsMenuSubs['lighting'].Add:Text('Neons/Underglow', { 'heading' })

    customsMenuSubs['lighting'].Add:Select('Neons/Underglow - $'.. math.ceil(_customsConfig.cost.neonEnabled * costMultiplier), {
        disabled = false,
        current = 0,
        list = _customsConfig.neonPresetsNamed,
    }, function(data)
        if data.data.value == 0 then
            changingData.neonEnabled = nil
        elseif _customsConfig.neonPresets[data.data.value] then
            changingData.neonEnabled = _customsConfig.neonPresets[data.data.value]
        end

        updateVehiclePropertyState()
    end)

    customsMenuSubs['lighting'].Add:ColorPicker({
        current = originalData.neonColor
    }, function(data)
        changingData.neonColor = {
            r = data.data.color.r,
            g = data.data.color.g,
            b = data.data.color.b,
        }

        updateVehiclePropertyState()
    end)
    
    customsMenuSubs['lighting'].Add:SubMenuBack('Go Back', {})

    if not settings.BLOCK_LIGHTING then
        customsMenu.Add:SubMenu('Lighting', customsMenuSubs['lighting'], { })
    end


    -- Wheels & Tires

    customsMenuSubs['wheels'] = Menu:Create('vehicle_customs_wheels', 'Wheels')

    local wheelTypeList = {}
    for k, v in pairs(_customsConfig.wheelTypes) do
        if v.value ~= 6 or (v.value == 6 and VEHICLE_CLASS == 8) then
            table.insert(wheelTypeList, v)
        end
    end

    customsMenuSubs['wheels'].Add:Select('Wheel Type', {
        disabled = false,
        current = originalData.wheels or 0,
        list = wheelTypeList,
    }, function(data)
        if data.data.value == originalData.wheels then
            changingData.wheels = nil
        else
            changingData.wheels = data.data.value
        end

        if originalData.mods.frontWheels == -1 then
            changingData.mods.frontWheels = nil
        else
            changingData.mods.frontWheels = -1
        end

        updateVehiclePropertyState()

        customsMenuSubs['wheels'].Update:Item('vehicle_customs_wheels-item1', 'Wheels', {
            current = -1,
            max = GetNumVehicleMods(CUST_VEH, 23) - 1,
        })

        if VEHICLE_CLASS == 8 then
            customsMenuSubs['wheels'].Update:Item('vehicle_customs_wheels-item2', 'Rear Wheels', {
                current = -1,
                max = GetNumVehicleMods(CUST_VEH, 23) - 1,
            })
        end
    end)

    customsMenuSubs['wheels'].Add:Ticker('Wheels - $'.. math.ceil(_customsConfig.cost.mods.frontWheels and (_customsConfig.cost.mods.frontWheels * costMultiplier) or 0), {
        disabled = false,
        current = originalData.mods.frontWheels or -1,
        min = -1,
        max = GetNumVehicleMods(CUST_VEH, 23) - 1
    }, function(data)
        if data.data.value == originalData.mods.frontWheels then
            changingData.mods.frontWheels = nil
        else
            changingData.mods.frontWheels = data.data.value
        end
        
        updateVehiclePropertyState()
    end)

    if VEHICLE_CLASS == 8 then
        customsMenuSubs['wheels'].Add:Ticker('Rear Wheels - $'.. math.ceil(_customsConfig.cost.mods.backWheels and (_customsConfig.cost.mods.backWheels * costMultiplier) or 0), {
            disabled = false,
            current = originalData.mods.backWheels or -1,
            min = -1,
            max = GetNumVehicleMods(CUST_VEH, 23) - 1
        }, function(data)
            if data.data.value == originalData.mods.backWheels then
                changingData.mods.backWheels = nil
            else
                changingData.mods.backWheels = data.data.value
            end
        
            updateVehiclePropertyState()
        end)
    end

    customsMenuSubs['wheels'].Add:Select('Wheel Color', {
        disabled = false,
        current = originalData.wheelColor,
        list = _customsConfig.allColors
    }, function(data)
        if data.data.value == originalData.wheelColor then
            changingData.wheelColor = nil
        else
            changingData.wheelColor = data.data.value
        end
    
        updateVehiclePropertyState()
    end)

    if not settings.BLOCK_TIRESMOKE then
        customsMenuSubs['wheels'].Add:Text('Tire Smoke', { 'heading' })
        customsMenuSubs['wheels'].Add:CheckBox('Custom Tire Smoke - $'.. math.ceil(_customsConfig.cost.tyreSmoke * costMultiplier), {
            selected = originalData.tyreSmoke
        }, function(data)
            if data.data.selected == originalData.tyreSmoke then
                changingData.tyreSmoke = nil
            else
                changingData.tyreSmoke = data.data.selected
            end
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['wheels'].Add:Text('Tire Smoke Color - $'.. math.ceil(_customsConfig.cost.tyreSmokeColor * costMultiplier), { 'pad', 'code', 'center', 'textLarge' })
        customsMenuSubs['wheels'].Add:ColorPicker({
            current = originalData.tyreSmokeColor
        }, function(data)
            changingData.tyreSmokeColor = {
                r = data.data.color.r,
                g = data.data.color.g,
                b = data.data.color.b,
            }
    
            updateVehiclePropertyState()
        end)
    end

    customsMenuSubs['wheels'].Add:SubMenuBack('Go Back', {})
    customsMenu.Add:SubMenu('Wheels & Tires', customsMenuSubs['wheels'], { })









    -- Body Parts

    customsMenuSubs['body_parts'] = Menu:Create('vehicle_customs_body_parts', 'Body Parts')

    for k, v in ipairs(_customsConfig.bodyParts) do
        if v.mod == 'horns' then
            customsMenuSubs['body_parts'].Add:Select(v.name .. ' - $' .. math.ceil(_customsConfig.cost.mods[v.mod] and (_customsConfig.cost.mods[v.mod] * costMultiplier) or 0), {
                disabled = false,
                current = originalData.mods[v.mod] or -1,
                list = _customsConfig.hornList,
            }, function(data)
                if data.data.value == originalData.mods[v.mod] then
                    changingData.mods[v.mod] = nil
                else
                    changingData.mods[v.mod] = data.data.value
                end
                updateVehiclePropertyState()
            end)
        else
            local levelList = {
                { label = 'Stock', value = -1 },
            }
    
            SetVehicleModKit(CUST_VEH, 0)
            local amount = GetNumVehicleMods(CUST_VEH, v.id)
            for i = 0, amount do
                local modName = GetModTextLabel(CUST_VEH, v.id, i)
                if modName then
                    local label = GetLabelText(modName)
                    if not label or label == "NULL" then
                        label = modName
                    end
                    table.insert(levelList, { label = label, value = i })
                end
            end

            if amount > 0 and #levelList > 1 then
                customsMenuSubs['body_parts'].Add:Select(v.name .. ' - $'.. math.ceil(_customsConfig.cost.mods[v.mod] and (_customsConfig.cost.mods[v.mod] * costMultiplier) or 0), {
                    disabled = false,
                    current = originalData.mods[v.mod] or -1,
                    list = levelList,
                }, function(data)
                    if data.data.value == originalData.mods[v.mod] then
                        changingData.mods[v.mod] = nil
                    else
                        changingData.mods[v.mod] = data.data.value
                    end
                    updateVehiclePropertyState()
                end)
            end
        end
    end

    customsMenuSubs['body_parts'].Add:Select('Window Tints - $'.. math.ceil(_customsConfig.cost.windowTint and (_customsConfig.cost.windowTint * costMultiplier) or 0), {
        disabled = false,
        current = originalData.windowTint or -1,
        list = _customsConfig.windowTints,
    }, function(data)
        if data.data.value == originalData.windowTint then
            changingData.windowTint = nil
        else
            changingData.windowTint = data.data.value
        end
        updateVehiclePropertyState()
    end)

    local platesList = {}
    for k, v in ipairs(_customsConfig.plateIndexes) do
        table.insert(platesList, v)
    end

    local onDuty = LocalPlayer.state.onDuty
    if originalData.plateIndex == 4 or onDuty == 'police' or onDuty == 'government' then
        table.insert(platesList, { label = 'Exempt', value = 4 })
    end

    customsMenuSubs['body_parts'].Add:Select('Plate Type - $'.. math.ceil(_customsConfig.cost.plateIndex and (_customsConfig.cost.plateIndex * costMultiplier) or 0), {
        disabled = originalData.plateIndex == 4,
        current = originalData.plateIndex or 0,
        list = platesList,
    }, function(data)
        if data.data.value == originalData.plateIndex then
            changingData.plateIndex = nil
        else
            changingData.plateIndex = data.data.value
        end
        updateVehiclePropertyState()
    end)

    customsMenuSubs['body_parts'].Add:SubMenuBack('Go Back', {})
    customsMenu.Add:SubMenu('Body Parts & Cosmetics', customsMenuSubs['body_parts'], { })






    -- Performance Parts

    if canInstallPerformance then
        customsMenuSubs['performance'] = Menu:Create('vehicle_customs_performance', 'Performance')
    
        for k, v in ipairs(_customsConfig.performanceMods) do
            local levelList = {
                { label = 'Stock', value = -1 },
            }
    
            local amount = GetNumVehicleMods(CUST_VEH, v.id) - 1
            for i = 0, amount do
                local modName = GetModTextLabel(CUST_VEH, v.id, i)
                local label = GetLabelText(modName)
    
                local price = math.ceil((_customsConfig.cost.mods[v.mod][i + 1] or _customsConfig.cost.mods[v.mod][#_customsConfig.cost.mods[v.mod]]) * costMultiplier)
                table.insert(levelList, { label = (modName and label or (v.name .. ' Level '.. i + 1)) .. ' - $'.. price, value = i })
            end
    
            customsMenuSubs['performance'].Add:Select(v.name, {
                disabled = false,
                current = originalData.mods[v.mod] or -1,
                list = levelList,
            }, function(data)
                if data.data.value == originalData.mods[v.mod] then
                    changingData.mods[v.mod] = nil
                else
                    changingData.mods[v.mod] = data.data.value
                end
                updateVehiclePropertyState()
            end)
        end
    
        customsMenuSubs['performance'].Add:CheckBox('Turbo - $'.. math.ceil(_customsConfig.cost.mods.turbo * costMultiplier), {
            selected = originalData.mods.turbo
        }, function(data)
            if data.data.selected == originalData.mods.turbo then
                changingData.mods.turbo = nil
            else
                changingData.mods.turbo = data.data.selected
            end
    
            updateVehiclePropertyState()
        end)
    
        customsMenuSubs['performance'].Add:SubMenuBack('Go Back', {})
        customsMenu.Add:SubMenu('Performance', customsMenuSubs['performance'], { })
    end

    customsMenu.Add:Button('Pay and Save Changes', { success = true }, function()
        local currentCost = CalculateCustomsCost(changingData, costMultiplier)
        if LocalPlayer.state.Character:GetData('Cash') >= currentCost then
            isSaving = true
            Logger:Trace('VehicleCustoms', 'Attept Mods Save')
            customsMenu:Close()

            Callbacks:ServerCallback('Vehicles:CompleteCustoms', {
                vNet = VehToNet(CUST_VEH),
                changes = changingData,
                cost = currentCost,
                new = Vehicles.Properties:Get(CUST_VEH),
            }, function(success, newNewData)
                if success then
                    UISounds.Play:FrontEnd(-1, "PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET")
                    Notification:Success('New Modifications Saved & Paid For')
                    if newNewData then
                        Vehicles.Properties:Set(CUST_VEH, newNewData)
                    end
                else
                    Notification:Error('Error Saving Vehicle Modifications - Not Enough Money?')
                    Vehicles.Properties:Set(CUST_VEH, originalData)
                end
            end)
        else
            Notification:Error('Not Enough Cash')
        end
    end)

    customsMenu.Add:Button('Discard & Exit', { error = true }, function()
        customsMenu:Close()
    end)


    customsMenu:Show()
end

function ForceCloseVehicleCustoms()
    if customsMenu then
        customsMenu:Close()
    end
end

AddEventHandler('VehicleCustoms:Client:Admin', OpenVehicleCustoms)

AddEventHandler('Vehicles:Client:ExitVehicle', function()
    ForceCloseVehicleCustoms()
end)