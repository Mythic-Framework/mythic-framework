_methTables = {}
local _tableModels = {
    `bkr_prop_meth_table01a`
}

AddEventHandler("Drugs:Client:Startup", function()
    for k, v in ipairs(_tableModels) do
        Targeting:AddObject(v, "minus", {
            {
                text = "Pickup Table",
                icon = "hand", 
                event = "Drugs:Client:Meth:PickupTable",
                minDist = 3.0,
                isEnabled = function(data, entity)
                    local entState = Entity(entity.entity).state
                    return entState?.isMethTable and not _methTables[entState?.methTable]?.activeCook
                end,
            },
            {
                text = "Table Info",
                icon = "table", 
                event = "Drugs:Client:Meth:TableDetails",
                minDist = 3.0,
                isEnabled = function(data, entity)
                    return Entity(entity.entity).state?.isMethTable
                end,
            },
            {
                text = "Start Batch",
                icon = "clock", 
                event = "Drugs:Client:Meth:StartCook",
                minDist = 3.0,
                isEnabled = function(data, entity)
                    local entState = Entity(entity.entity).state
                    return entState?.isMethTable and (not _methTables[entState.methTable]?.cooldown or GetCloudTimeAsInt() > _methTables[entState.methTable]?.cooldown) and (_methTables[entState.methTable].owner == nil or _methTables[entState.methTable].owner == LocalPlayer.state.Character:GetData("SID"))
                end,
            },
            {
                text = "Collect Batch",
                icon = "table", 
                event = "Drugs:Client:Meth:PickupCook",
                minDist = 3.0,
                isEnabled = function(data, entity)
                    local entState = Entity(entity.entity).state
                    return entState?.isMethTable and _methTables[entState?.methTable]?.activeCook and _methTables[entState?.methTable]?.pickupReady and (_methTables[entState.methTable].owner == nil or _methTables[entState.methTable].owner == LocalPlayer.state.Character:GetData("SID"))
                end,
            },
        }, 3.0)
    end

    Callbacks:RegisterClientCallback("Drugs:Meth:PlaceTable", function(data, cb)
        ObjectPlacer:Start(`bkr_prop_meth_table01a`, "Drugs:Client:Meth:FinishPlacement", data, false)
        cb()
    end)

    Callbacks:RegisterClientCallback("Drugs:Meth:Use", function(data, cb)
        Wait(400)
        Minigame.Play:RoundSkillbar(1.0, 6, {
            onSuccess = function()
                cb(true)
            end,
            onFail = function()
                cb(false)
            end,
        }, {
            useWhileDead = false,
            vehicle = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "switch@trevor@trev_smoking_meth",
                anim = "trev_smoking_meth_loop",
                flags = 48,
            },
        })
    end)
end)

RegisterNetEvent("Drugs:Client:Meth:SetupTables", function(tables)
    loadModel(`bkr_prop_meth_table01a`)
    for k, v in pairs(tables) do
        _methTables[k] = v
        local obj = CreateObject(`bkr_prop_meth_table01a`, v.coords.x, v.coords.y, v.coords.z, false, true, false)
        SetEntityHeading(obj, v.heading)
        while not DoesEntityExist(obj) do
            Wait(1)
        end
        _methTables[k].entity = obj
        Entity(obj).state.isMethTable = true
        Entity(obj).state.methTable = v.id
    end
end)

RegisterNetEvent("Characters:Client:Logout", function()
    for k, v in pairs(_methTables) do
        if v?.entity ~= nil and DoesEntityExist(v?.entity) then
            DeleteEntity(v?.entity)
            _methTables[k] = nil
        end 
    end
end)

RegisterNetEvent("Drugs:Client:Meth:CreateTable", function(table)
    loadModel(`bkr_prop_meth_table01a`)
    _methTables[table.id] = table
    local obj = CreateObject(`bkr_prop_meth_table01a`, table.coords.x, table.coords.y, table.coords.z, false, true, false)
    SetEntityHeading(obj, table.heading)
    while not DoesEntityExist(obj) do
        Wait(1)
    end

    _methTables[table.id].entity = obj

    Entity(obj).state.isMethTable = true
    Entity(obj).state.methTable = table.id
end)

RegisterNetEvent("Drugs:Client:Meth:RemoveTable", function(tableId)
    local objs = GetGamePool("CObject")
    for k, v in ipairs(objs) do
        local entState = Entity(v).state
        if entState.isMethTable and entState.methTable == tableId then
            DeleteEntity(v)
        end
    end
    _methTables[tableId] = nil
end)

RegisterNetEvent("Drugs:Client:Meth:UpdateTableData", function(tableId, data)
    _methTables[tableId] = data
end)

AddEventHandler("Drugs:Client:Meth:FinishPlacement", function(data, endCoords)
    TaskTurnPedToFaceCoord(LocalPlayer.state.ped, endCoords.coords.x, endCoords.coords.y, endCoords.coords.z, 0.0)
    Wait(1000)
    Progress:Progress({
        name = "meth_pickup",
        duration = (math.random(5) + 10) * 1000,
        label = "Placing Table",
        useWhileDead = false,
        canCancel = true,
        ignoreModifier = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            task = "CODE_HUMAN_MEDIC_KNEEL",
        },
    }, function(status)
        if not status then
            Callbacks:ServerCallback("Drugs:Meth:FinishTablePlacement", {
                data = data,
                endCoords = endCoords
            }, function(s)
                -- if s then
                --     local obj = CreateObject(`bkr_prop_meth_table01a`, endCoords.coords.x, endCoords.coords.y, endCoords.coords.z, true, true, false)
                --     SetEntityHeading(obj, endCoords.rotation)
                --     Entity(obj).state:set("isMethTable", true, true)
                -- end
            end)
        end
    end)
end)

AddEventHandler("Drugs:Client:Meth:PickupTable", function(entity, data)
    if Entity(entity.entity).state?.isMethTable then
        Progress:Progress({
            name = "meth_pickup",
            duration = (math.random(5) + 15) * 1000,
            label = "Picking Up Table",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                task = "CODE_HUMAN_MEDIC_KNEEL",
            },
        }, function(status)
            if not status then
                Callbacks:ServerCallback("Drugs:Meth:PickupTable", Entity(entity.entity).state.methTable, function(s)
                    -- if s then
                    --     DeleteObject(entity.entity)
                    -- end
                end)
            end
        end)
    end
end)

AddEventHandler("Drugs:Client:Meth:StartCook", function(entity, data)
    local entState = Entity(entity.entity).state
    if entState.isMethTable and entState.methTable then
        Callbacks:ServerCallback("Drugs:Meth:CheckTable", entState.methTable, function(s)
            if s then
                Progress:Progress({
                    name = "meth_pickup",
                    duration = 5 * 1000,
                    label = "Preparing Table",
                    useWhileDead = false,
                    canCancel = true,
                    ignoreModifier = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        anim = "dj",
                    },
                }, function(status)
                    if not status then
                        local c = table.copy(_tableTiers[_methTables[entState.methTable].tier])
                        c.tableId = entState.methTable
                        Hud.Meth:Open(c)
                    end
                end)
            else
                Notification:Error("Table Is Not Ready")
            end
        end)
    end
end)

AddEventHandler("Drugs:Client:Meth:ConfirmCook", function(data)
    if data ~= nil and _methTables[data.tableId] ~= nil and (not _methTables[data.tableId]?.cooldown or GetCloudTimeAsInt() > _methTables[data.tableId]?.cooldown) then
        Progress:Progress({
            name = "meth_pickup",
            duration = 20 * 1000,
            label = "Readying Ingredients",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                anim = "dj",
            },
        }, function(status)
            if not status then
                Progress:Progress({
                    name = "meth_pickup",
                    duration = 20 * 1000,
                    label = "Mixing Ingredients",
                    useWhileDead = false,
                    canCancel = true,
                    ignoreModifier = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        anim = "dj",
                    },
                }, function(status)
                    if not status then
                        Progress:Progress({
                            name = "meth_pickup",
                            duration = 20 * 1000,
                            label = "Starting Cooking Process",
                            useWhileDead = false,
                            canCancel = true,
                            ignoreModifier = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                anim = "dj",
                            },
                        }, function(status)
                            if not status then
                                Callbacks:ServerCallback("Drugs:Meth:StartCooking", data, function(s)
                
                                end)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end)

AddEventHandler("Drugs:Client:Meth:PickupCook", function(entity, data)
    local entState = Entity(entity.entity).state
    if entState.isMethTable and entState.methTable then
        Progress:Progress({
            name = "meth_pickup",
            duration = 5 * 1000,
            label = "Gathering Goods",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                anim = "dj",
            },
        }, function(status)
            if not status then
                Callbacks:ServerCallback("Drugs:Meth:PickupCook", entState.methTable, function(s)
                    if s then
                    else
                        Notification:Error("Table Is Not Ready")
                    end
                end)
            end
        end)
    end
end)

AddEventHandler("Drugs:Client:Meth:TableDetails", function(entity, data)
    local entState = Entity(entity.entity).state
    if entState.isMethTable and entState.methTable then
        Callbacks:ServerCallback("Drugs:Meth:GetTableDetails", entState.methTable, function(s)

        end)
    end
end)

AddEventHandler("Drugs:Client:Meth:ViewItems", function(entity, data)
    Callbacks:ServerCallback("Drugs:Meth:GetItems", {}, function(items)
		local itemList = {}

        if #items > 0 then
            for k, v in ipairs(items) do
                local itemData = Inventory.Items:GetData(v.item)
                if v.qty > 0 then
                    table.insert(itemList, {
                        label = itemData.label,
                        description = string.format("Stock: 1 Per Tsunami | %s $%s", v.price, v.coin),
                        event = "Drugs:Client:Meth:BuyItem",
                        data = v.id,
                    })
                else
                    table.insert(itemList, {
                        label = itemData.label,
                        description = "Sold Out",
                    })
                end
            end
        else
            table.insert(itemList, {
                label = "No Items Available",
                description = "Come Back Later",
            })
        end

		ListMenu:Show({
			main = {
				label = "Offers",
				items = itemList,
			},
		})
	end)
end)

AddEventHandler("Drugs:Client:Meth:BuyItem", function(data)
	Callbacks:ServerCallback("Drugs:Meth:BuyItem", data)
end)