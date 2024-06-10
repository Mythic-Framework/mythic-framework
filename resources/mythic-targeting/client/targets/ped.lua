interactablePeds = {}
interactableModels = {}

TARGETING.AddPed = function(self, entityId, icon, menuArray, proximity)
    if not entityId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end
    
    interactablePeds[entityId] = {
        type = 'ped',
        ped = entityId,
        icon = icon,
        menu = menuArray,
        proximity = proximity,
    }
end

TARGETING.RemovePed = function(self, entityId)
    interactablePeds[entityId] = nil
end

TARGETING.AddPedModel = function(self, modelId, icon, menuArray, proximity)
    if not modelId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end
    
    interactableModels[modelId] = {
        type = 'ped',
        ped = entityId,
        icon = icon,
        menu = menuArray,
        proximity = proximity,
    }
end

TARGETING.RemovePedModel = function(self, modelId)
    interactableModels[modelId] = nil
end

function IsPedInteractable(entity)
    if interactablePeds[entity] then -- Do entities first because they are higher priority
        return interactablePeds[entity]
    end

    local model = GetEntityModel(entity)
    if interactableModels[model] then
        return interactableModels[model]
    end
    return false
end