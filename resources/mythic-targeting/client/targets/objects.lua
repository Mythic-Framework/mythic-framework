TARGETING.AddObject = function(self, modelHash, icon, menuArray, proximity)
    if not modelHash then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end
    
    if targetableObjectModels[modelHash] then -- The object has already been added, so add these new menu items to the current menu
        local currentMenu = targetableObjectModels[modelHash].menu
        for k, v in ipairs(menuArray) do
            table.insert(currentMenu, v)
        end

        targetableObjectModels[modelHash].menu = currentMenu
    else
        targetableObjectModels[modelHash] = {
            type = 'model',
            model = modelHash,
            icon = icon,
            menu = menuArray,
            proximity = proximity,
        }
    end
    
end

TARGETING.RemoveObject = function(self, modelHash)
    targetableObjectModels[modelHash] = nil
end

-- For adding specific entities, probably won't get used much but it is here incase we do
TARGETING.AddEntity = function(self, entityId, icon, menuArray, proximity)
    if not entityId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end

    if targetableEntities[entityId] then -- The object has already been added, so add these new menu items to the current menu
        local currentMenu = targetableEntities[entityId].menu
        for k, v in ipairs(menuArray) do
            table.insert(currentMenu, v)
        end

        targetableEntities[entityId].menu = currentMenu
    else
        targetableEntities[entityId] = {
            type = 'entity',
            entity = entityId,
            icon = icon,
            menu = menuArray,
            proximity = proximity,
        }
    end
end

TARGETING.RemoveEntity = function(self, entityId)
    targetableEntities[entityId] = nil
end


function IsEntityInteractable(entity)
    local entityModel = GetEntityModel(entity)
    if targetableEntities[entity] then -- Do entities first because they are higher priority
        return targetableEntities[entity]
    elseif targetableObjectModels[entityModel] then
        return targetableObjectModels[entityModel]
    end
    return false
end