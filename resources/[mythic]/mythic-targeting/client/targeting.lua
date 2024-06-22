local holdingTargeting = false
local lastSentIcon = false
local hittingTarget = false
local hittingTargetData
local SetDrawOrigin = SetDrawOrigin
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin
InTargetingMenu = false
DrawPoints = {}

local function updateTargetingIcon(icon)
    if lastSentIcon ~= icon then
        lastSentIcon = icon
        TriggerEvent("Targeting:Client:UpdateState", holdingTargeting, lastSentIcon)
    end
end

local function doesCharacterhaveTemp(tempJob)
    local _tempJob = LocalPlayer.state.Character:GetData("TempJob")
    return _tempJob and _tempJob == tempJob or false
end

local function doesCharacterhaveState(state)
    local states = LocalPlayer.state.Character:GetData("States") or {}
    for _, v in ipairs(states) do
        if v == state then
            return true
        end
    end
    return false
end

local function doesCharacterPassJobPermissions(jobPermissions)
    if type(jobPermissions) ~= "table" then
        return true
    end

    for _, v in ipairs(jobPermissions) do
        if v.job then
            if not v.reqOffDuty or (v.reqOffDuty and (not Jobs.Duty:Get(v.job))) then
                if Jobs.Permissions:HasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.permissionKey) then
                    return true
                end
            end
        elseif v.permissionKey then
            if Jobs.Permissions:HasPermission(v.permissionKey) then
                return true
            end
        end
    end
    return false
end

local function openTargetingMenu(entityData, menu)
    local distance = #(entityData.endCoords - GetEntityCoords(LocalPlayer.state.ped))
    local currentMenu = {}
    for _, v in ipairs(menu) do
        if
            (v.isEnabled == nil or (v.isEnabled ~= nil and v.isEnabled(v.data, entityData)))
            and (not v.minDist or (v.minDist and distance <= v.minDist))
            and (v.tempjob == nil or (v.tempjob ~= nil and doesCharacterhaveTemp(v.tempjob)))
            and (v.jobPerms == nil or (v.jobPerms ~= nil and doesCharacterPassJobPermissions(v.jobPerms)))
            and (v.state == nil or (v.state ~= nil and doesCharacterhaveState(v.state)))
            and (entityData.type ~= "vehicle" or (entityData.type == "vehicle" and v.model == nil) or (entityData.type == "vehicle" and GetEntityModel(
                entityData.entity
            ) == v.model))
            and (v.item == nil or v.item ~= nil and Inventory.Check.Player:HasItem(v.item, v.itemCount or 1))
            and (v.items == nil or v.items ~= nil and Inventory.Check.Player:HasItems(v.items))
            and (v.anyItems == nil or v.anyItems ~= nil and Inventory.Check.Player:HasAnyItems(v.anyItems))
            and (v.rep == nil or v.rep.level <= Reputation:GetLevel(v.rep.id))
        then
            local menuItem = table.copy(v)
            if v.textFunc then
                menuItem.text = v.textFunc(v.data, entityData)
                menuItem.textFunc = nil
            end
            table.insert(currentMenu, menuItem)
        end
    end

    if #currentMenu <= 0 then
        return
    end

    InTargetingMenu = true
    TriggerEvent("Targeting:Client:OpenMenu", currentMenu)
end

local function loadSpriteTexture()
    while not HasStreamedTextureDictLoaded("shared") do 
        Wait(10)
        RequestStreamedTextureDict("shared", true)
    end

    return HasStreamedTextureDictLoaded("shared")
end

local function getEntityMiddle(entity)
    local entityModel = GetEntityModel(entity)
    local min, max = GetModelDimensions(entityModel)
    local points = {
        GetOffsetFromEntityInWorldCoords(entity, min.x, min.y, min.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, min.x, min.y, max.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, min.x, max.y, max.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, min.x, max.y, min.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, max.x, min.y, min.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, max.x, min.y, max.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, max.x, max.y, max.z).xy,
        GetOffsetFromEntityInWorldCoords(entity, max.x, max.y, min.z).xy
    }

    local centroid = vec2(0, 0)

    for i = 1, 8 do
        centroid += points[i]
    end

    centroid = centroid / 8

    local z = GetOffsetFromEntityInWorldCoords(entity, 0, 0, (min.z + max.z) / 2).z

    centroid = vec3(centroid.x, centroid.y, z)

    return centroid
end

function DrawSprites()
    if not Config.Sprite.active then return end
    if not loadSpriteTexture() then
        return
    end

    local dict, texture = "shared", "emptydot_32"

    for i = 1, #DrawPoints do
        local point = DrawPoints[i]
        SetDrawOrigin(point.x, point.y, point.z)
        DrawSprite(dict, texture, 0, 0, 0.02, 0.035, 0, Config.Sprite.color.r, Config.Sprite.color.g, Config.Sprite.color.b, Config.Sprite.color.a)
        ClearDrawOrigin()
    end

    ClearDrawOrigin()
end

function StartTargeting()
    if
        not holdingTargeting
        and not InTargetingMenu
        and not LocalPlayer.state.doingAction
        and not LocalPlayer.state.inTrunk
    then

        holdingTargeting = true
        hittingTargetData = nil
        TriggerEvent("Targeting:Client:UpdateState", true, false)
        CreateThread(function()
            while holdingTargeting do
                if
                    IsPauseMenuActive()
                    or IsPedInAnyVehicle(LocalPlayer.state.ped, false)
                    or IsPedFatallyInjured(LocalPlayer.state.ped)
                    or not LocalPlayer.state.loggedIn
                then
                    return StopTargeting()
                end

                local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, LocalPlayer.state.ped)
                local nowHitting = nil

                if hitting then
                    local entityType = GetEntityType(entity)
                    local entityCoords = GetEntityCoords(entity)
                    local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
                    if entityType == 1 then
                        -- is a ped, no point checking for polyzones
                        if IsPedAPlayer(entity) and (#(pedCoords - entityCoords) <= 3.0) then
                            local playerId = NetworkGetPlayerIndexFromPed(entity)
                            if NetworkIsPlayerActive(playerId) then
                                nowHitting = {
                                    type = "player",
                                    entity = entity,
                                    endCoords = endCoords,
                                    serverId = GetPlayerServerId(playerId),
                                }
                            end
                        else
                            local interactablePed = IsPedInteractable(entity)
                            if interactablePed then
                                if (#(pedCoords - entityCoords) <= interactablePed.proximity) then
                                    nowHitting = interactablePed
                                    nowHitting.entity = entity
                                    nowHitting.endCoords = endCoords
                                end
                            end
                        end

                    elseif entityType == 2 and NetworkGetEntityIsNetworked(entity) then
                        -- is a vehicle, no point checking for polyzones
                        nowHitting = {
                            type = "vehicle",
                            entity = entity,
                            endCoords = endCoords,
                        }
                    else
                        if entityType == 3 then
                            local interactableEntity = IsEntityInteractable(entity)
                            if interactableEntity then
                                if (#(entityCoords - pedCoords) <= interactableEntity.proximity) then
                                    nowHitting = interactableEntity
                                    nowHitting.entity = entity
                                    nowHitting.endCoords = endCoords
                                end
                            end
                        end

                        local withinZone = GetPZoneAtCoords(endCoords)

                        if withinZone then
                            nowHitting = withinZone
                            nowHitting.id = withinZone.name
                            nowHitting.endCoords = endCoords
                        end
                    end

                end

                if nowHitting then
                    hittingTarget = true
                    hittingTargetData = nowHitting

                    if hittingTargetData.icon then
                        updateTargetingIcon(hittingTargetData.icon)
                    elseif hittingTargetData.type == "vehicle" then
                        updateTargetingIcon(Config.VehicleIcons[GetVehicleClass(hittingTargetData.entity)])
                    elseif hittingTargetData.type and Config.DefaultIcons[hittingTargetData.type] then
                        updateTargetingIcon(Config.DefaultIcons[hittingTargetData.type])
                    else
                        updateTargetingIcon(Config.DefaultIcons.object)
                    end

                elseif hittingTarget then
                    hittingTarget = false
                    updateTargetingIcon(false)
                    if InTargetingMenu then
                        InTargetingMenu = false
                        TriggerEvent("Targeting:Client:CloseMenu")
                    end
                end

                Wait(250)
            end
        end)

        CreateThread(function ()
            while holdingTargeting do
                table.wipe(DrawPoints)

                --#TODO: Check all the targetable object models?
                --#TODO: Check all the targetable ped models?

                for _, v in pairs(InteractionZones) do
                    if v.enabled then
                        local center = v.zone.center
                        if #(LocalPlayer.state.position - center) <= (v?.proximity and v.proximity * 1.5 or 3.0)then
                            DrawPoints[#DrawPoints+1] = center
                        end
                    end
                end

                for _, v in pairs(TargetableEntities) do
                    local entity = v.entity
                    local entityCoords = getEntityMiddle(entity)
                    if entityCoords and #(LocalPlayer.state.position - entityCoords) <= (v?.proximity and v.proximity * 1.5 or 3.0) then
                        DrawPoints[#DrawPoints+1] = entityCoords
                    end
                end

                for _, v in pairs(InteractablePeds) do
                    local entity = v.ped
                    local entityCoords = getEntityMiddle(entity)
                    if entityCoords and #(LocalPlayer.state.position - entityCoords) <= (v?.proximity and v.proximity * 1.5 or 3.0) then
                        DrawPoints[#DrawPoints+1] = entityCoords
                    end
                end

                Wait(1000)
            end
        end)

        CreateThread(function()
            while holdingTargeting do
                DrawSprites()
                DisablePlayerFiring(LocalPlayer.state.ped, true)
                DisableControlAction(0, 25, true)
                Wait(0)
            end
        end)
    end
end

function StopTargeting()
    if holdingTargeting then
        hittingTarget = false
        hittingTargetData = nil
        holdingTargeting = false
        lastSentIcon = false
        if not InTargetingMenu then
            TriggerEvent("Targeting:Client:UpdateState", false, false)
        end
    end
end

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
    if not InTargetingMenu and hittingTarget and hittingTargetData and holdingTargeting then
        if hittingTargetData.type == "vehicle" then
            openTargetingMenu(hittingTargetData, Config.VehicleMenu)
        elseif hittingTargetData.type == "player" then
            openTargetingMenu(hittingTargetData, Config.PlayerMenu)
        elseif hittingTargetData.menu then
            -- model, entity, zone, ped
            openTargetingMenu(hittingTargetData, hittingTargetData.menu)
        end
    end
end)

AddEventHandler("Targeting:Client:MenuSelect", function(event, data)
    if not LocalPlayer.state.loggedIn then
        return
    end
    if event then
        TriggerEvent(event, hittingTargetData, data)
        UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end
    StopTargeting()
    hittingTargetData = nil
    InTargetingMenu = false
    TriggerEvent("Targeting:Client:UpdateState", false, false)
end)