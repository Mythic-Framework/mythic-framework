TARGETING.AddObject = function(self, modelHash, icon, menuArray, proximity)
    if not modelHash then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end

    if TargetableObjectModels[modelHash] then -- The object has already been added, so add these new menu items to the current menu
        local currentMenu = TargetableObjectModels[modelHash].menu
        for k, v in ipairs(menuArray) do
            table.insert(currentMenu, v)
        end

        TargetableObjectModels[modelHash].menu = currentMenu
    else
        TargetableObjectModels[modelHash] = {
            type = 'model',
            model = modelHash,
            icon = icon,
            menu = menuArray,
            proximity = proximity,
        }
    end
end

TARGETING.RemoveObject = function(self, modelHash)
    TargetableObjectModels[modelHash] = nil
end

-- For adding specific entities, probably won't get used much but it is here incase we do
TARGETING.AddEntity = function(self, entityId, icon, menuArray, proximity)
    if not entityId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end

    if TargetableEntities[entityId] then -- The object has already been added, so add these new menu items to the current menu
        local currentMenu = TargetableEntities[entityId].menu
        for k, v in ipairs(menuArray) do
            table.insert(currentMenu, v)
        end

        TargetableEntities[entityId].menu = currentMenu
    else
        TargetableEntities[entityId] = {
            type = 'entity',
            entity = entityId,
            icon = icon,
            menu = menuArray,
            proximity = proximity,
        }
    end
end

TARGETING.RemoveEntity = function(self, entityId)
    TargetableEntities[entityId] = nil
end


function IsEntityInteractable(entity)
    local entityModel = GetEntityModel(entity)
    if TargetableEntities[entity] then -- Do entities first because they are higher priority
        return TargetableEntities[entity]
    elseif TargetableObjectModels[entityModel] then
        return TargetableObjectModels[entityModel]
    end
    return false
end
