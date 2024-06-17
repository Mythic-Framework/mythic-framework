InteractablePeds = {}
InteractableModels = {}

TARGETING.AddPed = function(self, entityId, icon, menuArray, proximity)
    if not entityId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end

    InteractablePeds[entityId] = {
        type = 'ped',
        ped = entityId,
        icon = icon,
        menu = menuArray,
        proximity = proximity,
    }
end

TARGETING.RemovePed = function(self, entityId)
    InteractablePeds[entityId] = nil
end

TARGETING.AddPedModel = function(self, modelId, icon, menuArray, proximity)
    if not modelId then return end
    if not proximity then proximity = 3 end
    if type(menuArray) ~= 'table' then menuArray = {} end

    InteractableModels[modelId] = {
        type = 'ped',
        ped = modelId,
        icon = icon,
        menu = menuArray,
        proximity = proximity,
    }
end

TARGETING.RemovePedModel = function(self, modelId)
    InteractableModels[modelId] = nil
end

function IsPedInteractable(entity)
    if InteractablePeds[entity] then -- Do entities first because they are higher priority
        return InteractablePeds[entity]
    end

    local model = GetEntityModel(entity)
    if InteractableModels[model] then
        return InteractableModels[model]
    end
    return false
end
