_characterLoaded, GLOBAL_PED = false, nil

_interactionPeds = {}
_spawnedInteractionPeds = {}

AddEventHandler('PedInteraction:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Game = exports['mythic-base']:FetchComponent('Game')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Targeting = exports['mythic-base']:FetchComponent('Targeting')
    PedInteraction = exports['mythic-base']:FetchComponent('PedInteraction')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('PedInteraction', {
        'Callbacks',
        'Notification',
        'Game',
        'Utils',
        'Logger',
        'Targeting',
        'PedInteraction',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        -- PedInteraction:Add('fuck', `a_m_y_soucent_04`, vector3(-810.171, -1311.092, 4.000), 332.419, 50.0, {
        --     { icon = 'boxes-stacked', text = 'F', event = 'F', data = {}, minDist = 2.0, jobs = false },
        -- })
    end)
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
    _characterLoaded = true

    Citizen.CreateThread(function()
        while _characterLoaded do
            Citizen.Wait(1500)
            local pedCoords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(_interactionPeds) do
                if v.enabled then
                    local inRange = #(v.coords - pedCoords) <= v.range
                    if inRange and not _spawnedInteractionPeds[k] then
                        _spawnedInteractionPeds[k] = CreateDumbAssPed(v.model, v.coords, v.heading, v.menu, v.icon, v.scenario, v.anim, v.component)
                    elseif not inRange and _spawnedInteractionPeds[k] then
                        DeletePed(_spawnedInteractionPeds[k])
                        Targeting:RemovePed(_spawnedInteractionPeds[k])
                        _spawnedInteractionPeds[k] = nil
                    end
                elseif _spawnedInteractionPeds[k] then
                    DeletePed(_spawnedInteractionPeds[k])
                    Targeting:RemovePed(_spawnedInteractionPeds[k])
                    _spawnedInteractionPeds[k] = nil
                end
            end
        end
    end)
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _characterLoaded = false

    for k, v in pairs(_spawnedInteractionPeds) do
        DeleteEntity(v)
    end

    _spawnedInteractionPeds = {}
end)

_pedShit = {
    Add = function(self, id, model, coords, heading, range, menu, icon, scenario, enabled, anim, component)
        if id and model and type(coords) == 'vector3' and type(heading) == 'number' then
            if enabled == nil then
                enabled = true
            end
    
            if type(model) == 'string' then
                model = GetHashKey(model)
            end
    
            if not range then
                range = 50.0
            end
    
            if not IsModelValid(model) or not IsModelAPed(model) then
                Logger:Error('PedInteraction', 'Failed to Add Ped ID: '.. id .. ' - It\'s Model is Invalid')
                return
            end
    
            _interactionPeds[id] = {
                enabled = enabled,
                range = range,
                model = model,
                coords = coords,
                heading = heading,
                icon = icon,
                menu = menu,
                scenario = scenario,
                anim = anim,
                component = component,
            }
        end
    end,
    Toggle = function(self, id, enabled)
        if _interactionPeds[id] then

            _interactionPeds[id].enabled = enabled
        end
    end,
    Remove = function(self, id)
        if _interactionPeds[id] then
            _interactionPeds[id] = nil
            if _spawnedInteractionPeds[id] then
                DeleteEntity(_spawnedInteractionPeds[id])
                Targeting:RemovePed(_spawnedInteractionPeds[id])
                _spawnedInteractionPeds[id] = nil
            end
        end
    end,
    GetPed = function(self, id)
        if _spawnedInteractionPeds[id] then
            return _spawnedInteractionPeds[id]
        end
        return false
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('PedInteraction', _pedShit)
end)

function CreateDumbAssPed(model, coords, heading, menu, icon, scenario, anim, component)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end

    local ped = CreatePed(5, model, coords.x, coords.y, coords.z, heading, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetPedCanRagdoll(ped, false)
    TaskSetBlockingOfNonTemporaryEvents(ped, 1)
    SetBlockingOfNonTemporaryEvents(ped, 1)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetEntityInvincible(ped, true)
    SetPedSeeingRange(ped, 0)
    SetPedDefaultComponentVariation(ped)
    SetModelAsNoLongerNeeded(model)

    if component and type(component) == "table" then
        SetPedComponentVariation(ped, component.componentId or 0, component.drawableId or 0, component.texture or 0, component.textureId or 0, component.paletteId or 0)
    end

    if anim and type(anim) == "table" and anim.animDict and anim.anim then
        ClearPedTasks(ped)
        LoadAnim(anim.animDict)
        TaskPlayAnim(ped, anim.animDict, anim.anim, anim.blendIn or 8.0, anim.blendOut or 8.0, anim.duration or -1, anim.flag or 1, anim.playback or 0, anim.lockX or 0, anim.lockY or 0, anim.lockZ or 0)
    elseif scenario and type(scenario) == "string" then
        ClearPedTasks(ped)
        TaskStartScenarioInPlace(ped, scenario, 0, true)
    end

    if menu then
        if not icon then icon = 'person-sign' end
        Targeting:AddPed(ped, icon, menu)
    end

    return ped
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end