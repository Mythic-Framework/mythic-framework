local catalogState = false
local catalogCam, catalogVeh, catalogMenu, catalogSubMenus, catalogSubMenusData
local catalogMenuOpen = false
local catalogData = {}
local catalogCurrent

local allSpawnedCatalogVehicles = {}

function SetupCatalogCams()
    catalogCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamFov(catalogCam, 60.0)

    local interior = GetInteriorAtCoords(_catalog.camera.coords)
    LoadInterior(interior)
    SetFocusArea(_catalog.camera.coords, 0.0, 0.0, 0.0)

    SetCamCoord(catalogCam, _catalog.camera.coords)
    SetCamRot(catalogCam, _catalog.camera.rotation, 2)
    SetCamActive(catalogCam, true)

    RenderScriptCams(true, false, 1, false, false)
    Wait(250)
    DoScreenFadeIn(500)
end

function DestroyCatalogCams()
    DoScreenFadeOut(500)
    Wait(250)

    RenderScriptCams(false, false, 0, false, false)
    ClearFocus()
    DestroyCam(catalogCam, false)

    Wait(250)
    DoScreenFadeIn(500)
end

function OpenCatalog(dealerId)
    if not catalogMenuOpen then
        Hud:Hide()

        DoScreenFadeOut(250)

        Callbacks:ServerCallback('Dealerships:GetDealerStock', dealerId, function(stocks)
            catalogData = FormatDealerStockToCategories(stocks)
    
            SetupCatalogCams()
            OpenCatalogMenu(_dealerships[dealerId].abbreviation)
        end)
    end
end

function ForceCloseCatalog()
    if catalogMenuOpen then
        catalogMenu:Close()
    end
end

function SetCatalogVehicle(veh)
    if not veh or (veh and GetEntityModel(catalogVeh) ~= GetHashKey(veh)) then -- Delete the vehicle
        if catalogVeh and DoesEntityExist(catalogVeh) then
            Game.Vehicles:Delete(catalogVeh)
            catalogVeh = false
        end

        if veh then
            
            Game.Vehicles:SpawnLocal(_catalog.vehicle.xyz, veh, _catalog.vehicle.w, function(veh)
                catalogVeh = veh

                table.insert(allSpawnedCatalogVehicles, veh)

                FreezeEntityPosition(catalogVeh, true)
                SetVehicleDoorsLocked(catalogVeh, 2)
                SetVehicleLights(catalogVeh, 2)
                SetVehicleNumberPlateText(catalogVeh, '')
                RollDownWindows(catalogVeh)
            end)
        end
    end
end

function GetVehicleDealerCarInformationText(vData)
    return (vData.make .. ' ' .. vData.model), string.format(
        [[
            Class: %s<br>
            Category: %s<br>
        ]], 
        vData.class and string.upper(vData.class) or 'Unknown',
        _catalogCategories[vData.category]
    )
end

function OpenCatalogMenu(catalogName)
    catalogMenu = Menu:Create('dealerCatalog', catalogName .. ' Vehicle Catalog', function()
        catalogMenuOpen = true
    end, function()
        DestroyCatalogCams()
        Wait(250)
        SetCatalogVehicle(false, false)

        for k, v in ipairs(allSpawnedCatalogVehicles) do
            if DoesEntityExist(v) then
                Game.Vehicles:Delete(v)
            end
        end

        allSpawnedCatalogVehicles = {}
        
        Hud:Show()
        Wait(250)
        catalogData = {}
        catalogMenu = nil
        catalogSubMenus = nil
        collectgarbage()

        catalogMenuOpen = false
    end)

    local orderedCategories = Utils:GetTableKeys(_catalogCategories)
    table.sort(orderedCategories, function(a, b)
        return _catalogCategories[a] < _catalogCategories[b]
    end)

    catalogSubMenus = {}
    catalogSubMenusData = {}

    local doneFirst = false
    for _, cat in ipairs(orderedCategories) do
        if catalogData.sorted[cat] and #catalogData.sorted[cat] > 0 then
            if not doneFirst then
                doneFirst = true
                catalogCurrent = cat
                SetCatalogVehicle(catalogData.sorted[catalogCurrent][1].vehicle)
            end

            catalogSubMenus[cat] = Menu:Create('dealerCatalogSub-'.. cat, catalogName .. ' Catalog - '.. _catalogCategories[cat] .. ' Vehicles')
            local name, informationData = GetVehicleDealerCarInformationText(catalogData.sorted[cat][1])

            local vehicleNameElement = catalogSubMenus[cat].Add:Text(name, { 'heading' })
            local vehicleInformationElement = catalogSubMenus[cat].Add:Text(informationData, { 'pad', 'center', 'textLarge' })
            catalogSubMenus[cat].Add:Ticker('Currently Stocked Vehicles', {
                disabled = false,
                min = 1,
                max = #catalogData.sorted[cat],
                current = 1,
            }, function(data)
                local vData = catalogData.sorted[cat][data.data.value]
                if vData then
                    SetCatalogVehicle(vData.vehicle)

                    local name, informationData = GetVehicleDealerCarInformationText(vData)
                    catalogSubMenus[cat].Update:Item(vehicleNameElement, name, {})
                    catalogSubMenus[cat].Update:Item(vehicleInformationElement, informationData, {})
                end
            end)

            catalogSubMenus[cat].Add:Button('Rotate Vehicle', {}, function()
                if catalogVeh and DoesEntityExist(catalogVeh) then
                    local newHeading = GetEntityHeading(catalogVeh) + 90.0
                    if newHeading >= 360.0 then
                        newHeading = math.abs(360.0 - newHeading)
                    end
                    SetEntityHeading(catalogVeh, newHeading)
                end
            end)

            catalogSubMenus[cat].Add:Button('Open Doors', {}, function()
                if catalogVeh and DoesEntityExist(catalogVeh) then
                    for i = 0, 10 do
                        SetVehicleDoorOpen(catalogVeh, i, true, true)
                    end
                end
            end)

            catalogSubMenus[cat].Add:Button('Close Doors', {}, function()
                if catalogVeh and DoesEntityExist(catalogVeh) then
                    SetVehicleDoorsShut(catalogVeh, true)
                end
            end)


            catalogSubMenus[cat].Add:SubMenuBack('Go Back', {})
            catalogMenu.Add:SubMenu(_catalogCategories[cat], catalogSubMenus[cat], {}, function()
                SetCatalogVehicle(catalogData.sorted[cat][1].vehicle)

                catalogMenu:SubMenu('dealerCatalogSub-'.. cat)
            end)
        end
    end

    catalogMenu:Show()
end