_spawnedFurniture = nil

local _specCategories = {
    .storage,
    .beds,
}

function CreateFurniture(furniture)
    if _spawnedFurniture then
        DestroyFurniture()
    end

    _insideFurniture = furniture
    _spawnedFurniture = {}

    for k, v in ipairs(furniture) do
        PlaceFurniture(v)
    end
end

function PlaceFurniture(v)
    local model = GetHashKey(v.model)
    if LoadModel(model) then
        local obj = CreateObject(model, v.coords.x, v.coords.y, v.coords.z, false, true, false)
        SetEntityHeading(obj, v.heading + 0.0)
        FreezeEntityPosition(obj, true)
        while not DoesEntityExist(obj) do
            Wait(1)
        end

        local furnData = FurnitureConfig[v.model]
        local hasTargeting = false

        if furnData.placeGround then
            PlaceObjectOnGroundProperly(obj)
        end

        if furnData then
            if _specCategories[furnData.cat] then
                local icon = "square"
                local menu = {
                    {
                        icon = "arrows-up-down-left-right",
                        text = "Move",
                        event = "Furniture:Client:OnMove",
                        data = {
                            id = v.id,
                        },
                        isEnabled = function()
                            return LocalPlayer.state.furnitureEdit
                        end
                    },
                    {
                        icon = "trash",
                        text = "Delete",
                        event = "Furniture:Client:OnDelete",
                        data = {
                            id = v.id,
                        },
                        isEnabled = function()
                            return LocalPlayer.state.furnitureEdit
                        end
                    },
                    {
                        icon = "clone",
                        text = "Clone",
                        event = "Furniture:Client:OnClone",
                        data = {
                            id = v.id,
                            model = v.model,
                        },
                        isEnabled = function()
                            return LocalPlayer.state.furnitureEdit
                        end
                    },
                }

                if furnData.cat == "storage" then
                    icon = "boxes-packing"

                    table.insert(menu, {
                        icon = "boxes-packing",
                        text = "Access Storage",
                        event = "Properties:Client:Stash",
                        isEnabled = function(data)
                            if _insideProperty and _propertiesLoaded then
                                local property = _properties[_insideProperty.id]
                                return (property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) or LocalPlayer.state.onDuty == "police"
                            end
                        end,
                    })

                    table.insert(menu, {
                        icon = "shirt",
                        text = "Open Wardrobe",
                        event = "Properties:Client:Closet",
                    })
                elseif furnData.cat == "beds" then
                    icon = "bed"

                    table.insert(menu, {
                        icon = "bed",
                        text = "Logout",
                        event = "Properties:Client:Logout",
                        isEnabled = function(data)
                            if _insideProperty and _propertiesLoaded then
                                local property = _properties[_insideProperty.id]
                                return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
                            end
                        end,
                    })
                end

                hasTargeting = true

                Targeting:AddEntity(obj, icon, menu)
            end
        end

        table.insert(_spawnedFurniture, {
            id = v.id,
            entity = obj,
            model = v.model,
            targeting = hasTargeting,
        })

        Wait(1)
    else
        print("Failed to Load Model: " .. v.model)
    end
end

function DestroyFurniture(s)
    if _spawnedFurniture then
        for k, v in ipairs(_spawnedFurniture) do
            DeleteEntity(v.entity)
            if not s then
                Targeting:RemoveEntity(v.entity)
            end
        end

        _spawnedFurniture = nil
    end
end

function SetFurnitureEditMode(state)
    if _spawnedFurniture then
        if state then
            for k, v in ipairs(_spawnedFurniture) do
                if not v.targeting then
                    Targeting:AddEntity(v.entity, "square", {
                        {
                            icon = "arrows-up-down-left-right",
                            text = "Move",
                            event = "Furniture:Client:OnMove",
                            data = {
                                id = v.id,
                            },
                        },
                        {
                            icon = "trash",
                            text = "Delete",
                            event = "Furniture:Client:OnDelete",
                            data = {
                                id = v.id,
                            },
                        },
                        {
                            icon = "clone",
                            text = "Clone",
                            event = "Furniture:Client:OnClone",
                            data = {
                                id = v.id,
                                model = v.model,
                            },
                        },
                    })
                end
            end

            Notification.Persistent:Standard("furniture", "Furniture Edit Mode Enabled - Third Eye Objects to Move or Delete Them")
        else
            for k, v in ipairs(_spawnedFurniture) do
                if not v.targeting then
                    Targeting:RemoveEntity(v.entity)
                end
            end

            Notification.Persistent:Remove("furniture")
        end

        LocalPlayer.state.furnitureEdit = state
    end
end

function CycleFurniture(direction)
    if direction then
        if _furnitureCategoryCurrent < #_furnitureCategory then
            _furnitureCategoryCurrent += 1
        else
            return
        end
    else
        if _furnitureCategoryCurrent > 1 then
            _furnitureCategoryCurrent -= 1
        else
            return
        end
    end

    InfoOverlay:Close()
    ObjectPlacer:Cancel(true, true)
    Wait(200)
    local fKey = _furnitureCategory[_furnitureCategoryCurrent]
    local fData = FurnitureConfig[fKey]
    if fData then
        InfoOverlay:Show(fData.name, string.format("Category: %s | Model: %s", FurnitureCategories[fData.cat]?.name or "Unknown", fKey))
    end
    ObjectPlacer:Start(GetHashKey(fKey), "Furniture:Client:Place", {}, true, "Furniture:Client:Cancel", true, fData.placeGround)
end

AddEventHandler("Furniture:Client:Place", function(data, placement)
    if _placingFurniture then

        Callbacks:ServerCallback("Properties:PlaceFurniture", {
            model = _furnitureCategory[_furnitureCategoryCurrent],
            coords = {
                x = placement.coords.x,
                y = placement.coords.y,
                z = placement.coords.z,
            },
            heading = placement.rotation,
            data = data,
        }, function(success)
            if success then
                Notification:Success("Placed Item")
            else
                Notification:Error("Error")
            end

            _placingFurniture = false
            LocalPlayer.state.placingFurniture = false
            InfoOverlay:Close()

            if not _skipPhone then
                Phone:Open()
            end
        end)
    end
    DisablePauseMenu(false)
end)

AddEventHandler("Furniture:Client:Cancel", function()
    if _placingFurniture then
        _placingFurniture = false
        LocalPlayer.state.placingFurniture = false

        if not _skipPhone then
            Phone:Open()
        end

        Wait(200)
        DisablePauseMenu(false)
        InfoOverlay:Close()
    end
end)

AddEventHandler("Furniture:Client:Move", function(data, placement)
    if _placingFurniture and data.id then

        Callbacks:ServerCallback("Properties:MoveFurniture", {
            id = data.id,
            coords = {
                x = placement.coords.x,
                y = placement.coords.y,
                z = placement.coords.z,
            },
            heading = placement.rotation,
        }, function(success)
            if success then
                Notification:Success("Moved Item")
            else
                Notification:Error("Error")
            end

            _placingFurniture = false
            LocalPlayer.state.placingFurniture = false
            InfoOverlay:Close()

            if not _skipPhone then
                Phone:Open()
            end
        end)
    end
    DisablePauseMenu(false)
end)

AddEventHandler("Furniture:Client:CancelMove", function(data)
    if _placingFurniture and data.id then
        if _insideFurniture then
            for k, v in ipairs(_insideFurniture) do
                if v.id == data.id then
                    PlaceFurniture(v)
                end
            end
        end

        Notification:Error("Move Cancelled")
        _placingFurniture = false
        LocalPlayer.state.placingFurniture = false
        if not _skipPhone then
            Phone:Open()
        end

        Wait(200)
        DisablePauseMenu(false)
    end
end)

RegisterNetEvent("Furniture:Client:AddItem", function(property, index, item)
    if _insideProperty and _insideProperty.id == property and _spawnedFurniture then
        PlaceFurniture(item)
        table.insert(_insideFurniture, item)

        if LocalPlayer.state.furnitureEdit then
            SetFurnitureEditMode(false)
            Wait(100)
            SetFurnitureEditMode(true)
        end
    end
end)

RegisterNetEvent("Furniture:Client:MoveItem", function(property, id, item)
    if _insideProperty and _insideProperty.id == property and _spawnedFurniture then

        local ns = {}
        local shouldUpdate = false
        for k, v in ipairs(_spawnedFurniture) do
            if v.id == id then
                DeleteEntity(v.entity)
                Targeting:RemoveEntity(v.entity)
                shouldUpdate = true
            else
                table.insert(ns, v)
            end
        end
        if shouldUpdate then
            _spawnedFurniture = ns
        end

        PlaceFurniture(item)

        if LocalPlayer.state.furnitureEdit then
            SetFurnitureEditMode(false)
            Wait(100)
            SetFurnitureEditMode(true)
        end

        for k, v in ipairs(_insideFurniture) do
            if v.id == id then
                _insideFurniture[k] = item
                break
            end
        end
    end
end)

RegisterNetEvent("Furniture:Client:DeleteItem", function(property, id, furniture)
    if _insideProperty and _insideProperty.id == property and _spawnedFurniture then
        local ns = {}
        for k, v in ipairs(_spawnedFurniture) do
            if v.id == id then
                DeleteEntity(v.entity)
                Targeting:RemoveEntity(v.entity)
            else
                table.insert(ns, v)
            end
        end

        _spawnedFurniture = ns
        _insideFurniture = furniture
    end
end)

AddEventHandler("Furniture:Client:OnMove", function(entity, data)
    Properties.Furniture:Move(data.id, true)
end)

AddEventHandler("Furniture:Client:OnDelete", function(entity, data)
    Properties.Furniture:Delete(data.id)
end)

AddEventHandler("Furniture:Client:OnClone", function(entity, data)
    Properties.Furniture:Place(data.model, false, {}, false, true)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DestroyFurniture()
    end
end)

local _disablePause = false

function DisablePauseMenu(state)
    if _disablePause ~= state then
        _disablePause = state
        if _disablePause then
            CreateThread(function()
				while _disablePause do
					DisableControlAction(0, 200, true)
					Wait(1)
				end
			end)
        end
    end
end