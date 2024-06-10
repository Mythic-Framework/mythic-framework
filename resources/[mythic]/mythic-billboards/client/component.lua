AddEventHandler("Billboards:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
    Logger = exports["mythic-base"]:FetchComponent("Logger")
    Fetch = exports["mythic-base"]:FetchComponent("Fetch")
    Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
    Game = exports["mythic-base"]:FetchComponent("Game")
    Targeting = exports["mythic-base"]:FetchComponent("Targeting")
    Utils = exports["mythic-base"]:FetchComponent("Utils")
    Animations = exports["mythic-base"]:FetchComponent("Animations")
    Notification = exports["mythic-base"]:FetchComponent("Notification")
    Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
    Jobs = exports["mythic-base"]:FetchComponent("Jobs")
    Weapons = exports["mythic-base"]:FetchComponent("Weapons")
    Progress = exports["mythic-base"]:FetchComponent("Progress")
    Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
    Targeting = exports["mythic-base"]:FetchComponent("Targeting")
    ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
    Action = exports["mythic-base"]:FetchComponent("Action")
    Sounds = exports["mythic-base"]:FetchComponent("Sounds")
    PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
    Blips = exports["mythic-base"]:FetchComponent("Blips")
    Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
    Minigame = exports["mythic-base"]:FetchComponent("Minigame")
    Input = exports["mythic-base"]:FetchComponent("Input")
    Interaction = exports["mythic-base"]:FetchComponent("Interaction")
    Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
    exports["mythic-base"]:RequestDependencies("Billboards", {
        "Logger",
        "Fetch",
        "Callbacks",
        "Game",
        "Menu",
        "Targeting",
        "Notification",
        "Utils",
        "Animations",
        "Polyzone",
        "Jobs",
        "Weapons",
        "Progress",
        "Vehicles",
        "Targeting",
        "ListMenu",
        "Action",
        "Sounds",
        "PedInteraction",
        "Blips",
        "Keybinds",
        "Minigame",
        "Input",
        "Interaction",
        "Inventory",
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        -- print('testing biatch')
        -- local dui = CreateBillboardDUI('https://i.imgur.com/Zlf40QZ.png', 1024, 512)
        -- AddReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown', dui.dictionary, dui.texture)

        -- Citizen.Wait(10000)

        -- print(dui.id)

        -- ReleaseBillboardDUI(dui.id)
        -- RemoveReplaceTexture('ch2_03b_cg2_03b_bb', 'ch2_03b_bb_lowdown')

        StartUp()
    end)
end)

local started = false
local _billboardDUIs = {}

function StartUp()
    if started then
        return
    end

    started = true

    for k,v in pairs(_billboardConfig) do
        v.url = GlobalState[string.format("Billboards:%s", k)]
    end
end

AddEventHandler('Characters:Client:Spawn', function()
    Citizen.CreateThread(function()
        while LocalPlayer.state.loggedIn do
            for k,v in pairs(_billboardConfig) do
                local dist = #(GetEntityCoords(LocalPlayer.state.ped) - v.coords)
                if dist <= v.range then
                    if not _billboardDUIs[k] and v.url then
                        local createdDui = CreateBillboardDUI(v.url, v.width, v.height)
                        AddReplaceTexture(v.originalDictionary, v.originalTexture, createdDui.dictionary, createdDui.texture)

                        _billboardDUIs[k] = createdDui
                    end
                elseif _billboardDUIs[k] then
                    ReleaseBillboardDUI(_billboardDUIs[k].id)
                    RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
                    _billboardDUIs[k] = nil
                end
            end
            Citizen.Wait(1500)
        end
    end)
end)


RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    for k,v in pairs(_billboardConfig) do
        if _billboardDUIs[k] then

            ReleaseBillboardDUI(_billboardDUIs[k].id)
            RemoveReplaceTexture(v.originalDictionary, v.originalTexture)
            _billboardDUIs[k] = nil
        end
    end
end)

RegisterNetEvent("Billboards:Client:UpdateBoardURL", function(id, url)
    if not _billboardConfig[id] then
        return
    end

    if _billboardDUIs[id] then
        if url then
            UpdateBillboardDUI(_billboardDUIs[id].id, url)
            AddReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture, _billboardDUIs[id].dictionary, _billboardDUIs[id].texture)
        else
            ReleaseBillboardDUI(_billboardDUIs[id].id)
            RemoveReplaceTexture(_billboardConfig[id].originalDictionary, _billboardConfig[id].originalTexture)
            _billboardDUIs[id] = nil
        end
    end

    _billboardConfig[id].url = url
end)