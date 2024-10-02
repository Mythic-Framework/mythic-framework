_placedTables = {}
_inProgCooks = {}

local bought = {}
local _toolsForSale = {
	{ id = 1, item = "meth_table", coin = "PLEB", price = 400, qty = 5, vpn = true },
}

_DRUGS = _DRUGS or {}
_DRUGS.Meth = {
    GenerateTable = function(self, tier)
        local recipe = {
            ingredients = {},
            cookTimeMax = math.random(_tableTiers[tier].cookTimeMax)
        }

        for i = 1, _tableTiers[tier].ingredients do
            table.insert(recipe.ingredients, math.random(100))
        end

        return MySQL.insert.await('INSERT INTO meth_tables (created, recipe, tier) VALUES(?, ?, ?)', { os.time(), json.encode(recipe), tier })
    end,
    GetTable = function(self, tableId)
        return MySQL.single.await('SELECT id, tier, created, cooldown, recipe, active_cook FROM meth_tables WHERE id = ?', { tableId })
    end,
    IsTablePlaced = function(self, tableId)
        return MySQL.single.await('SELECT COUNT(table_id) as Count FROM placed_meth_tables WHERE table_id = ?', { tableId })?.Count or 0 > 0
    end,
    CreatePlacedTable = function(self, tableId, owner, tier, coords, heading, created)
        local itemInfo = Inventory.Items:GetData("meth_table")
        local tableData = self:GetTable(tableId)

        MySQL.insert.await("INSERT INTO placed_meth_tables (table_id, owner, placed, expires, coords, heading) VALUES(?, ?, ?, ?, ?, ?)", {
            tableId,
            owner,
            os.time(),
            created + itemInfo.durability,
            json.encode(coords),
            heading,
        })

        local cookData = tableData.active_cook ~= nil and json.decode(tableData.active_cook) or {}

        _placedTables[tableId] = {
            id = tableId,
            owner = owner,
            tier = tier,
            placed = os.time(),
            expires = created + itemInfo.durability,
            cooldown = tableData.cooldown,
            activeCook = tableData.active_cook ~= nil,
            pickupReady = os.time() > (cookData?.end_time or 0),
            coords = coords,
            heading = heading,
        }

        TriggerClientEvent("Drugs:Client:Meth:CreateTable", -1, _placedTables[tableId])
    end,
    RemovePlacedTable = function(self, tableId)
        local s = MySQL.query.await('DELETE FROM placed_meth_tables WHERE table_id = ?', { tableId })
        if s.affectedRows > 0 then
            _placedTables[tableId] = nil
            TriggerClientEvent("Drugs:Client:Meth:RemoveTable", -1, tableId)
        end
        return s.affectedRows > 0
    end,
    StartTableCook = function(self, tableId, cooldown, recipe)
        MySQL.query.await('UPDATE meth_tables SET cooldown = ?, active_cook = ? WHERE id = ?', { cooldown, json.encode(recipe), tableId })
        _placedTables[tableId].cooldown = cooldown
        _placedTables[tableId].activeCook = true
        _placedTables[tableId].pickupReady = false
        _inProgCooks[tableId] = recipe

        TriggerClientEvent("Drugs:Client:Meth:UpdateTableData", -1, tableId, _placedTables[tableId])
    end,
    FinishTableCook = function(self, tableId)
        MySQL.query.await('UPDATE meth_tables SET active_cook = NULL WHERE id = ?', { tableId })
        _placedTables[tableId].activeCook = false
        _placedTables[tableId].pickupReady = false
        _inProgCooks[tableId] = nil
        TriggerClientEvent("Drugs:Client:Meth:UpdateTableData", -1, tableId, _placedTables[tableId])
    end
}

AddEventHandler("Drugs:Server:Startup", function()
    Vendor:Create("MethSeller", "ped", "Rob Tools", `A_M_M_RurMeth_01`, {
        coords = vector3(1532.717, 6331.944, 23.273),
        heading = 205.563,
        scenario = "WORLD_HUMAN_GARDENER_LEAF_BLOWER"
    }, _toolsForSale, "badge-sign", "View Offers")

    local tables = MySQL.query.await('SELECT * FROM placed_meth_tables WHERE expires > ?', { os.time() })
    for k, v in ipairs(tables) do
        if _placedTables[v.table_id] == nil or not DoesEntityExist(_placedTables[v.table_id]?.entity) then
            local tableData = Drugs.Meth:GetTable(v.table_id)
            local coords = json.decode(v.coords)
    
            local cookData = tableData.active_cook ~= nil and json.decode(tableData.active_cook) or {}
            _placedTables[v.table_id] = {
                id = v.table_id,
                owner = v.owner,
                tier = tableData.tier,
                placed = v.placed,
                expires = v.expires,
                cooldown = tableData.cooldown,
                activeCook = tableData.active_cook ~= nil,
                pickupReady = os.time() > (cookData?.end_time or 0),
                coords = coords,
                heading = v.heading,
            }

            if tableData.active_cook then
                local f = json.decode(tableData.active_cook)
                if f.end_time > os.time() then
                    _inProgCooks[v.table_id] = f
                end
            end
        end
    end

    Logger:Trace("Drugs:Meth", string.format("Restored ^2%s^7 Meth Tables", #tables))

    StartCookThread()

    Middleware:Add("Characters:Spawning", function(source)
        TriggerClientEvent("Drugs:Client:Meth:SetupTables", source, _placedTables)
    end, 1)

    Callbacks:RegisterServerCallback("Drugs:Meth:FinishTablePlacement", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                local table = Inventory:GetItem(data.data)
                if table.Owner == string.format("%s-1", char:GetData("SID")) then
                    local md = json.decode(table.MetaData)
                    local tableData = Drugs.Meth:GetTable(md.MethTable)
                    if Inventory.Items:RemoveId(char:GetData("SID"), 1, table) then
                        Drugs.Meth:CreatePlacedTable(md.MethTable, char:GetData("SID"), tableData.tier, data.endCoords.coords, data.endCoords.rotation, table.CreateDate)
                        cb(true)
                    else
                        cb(false)
                    end
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:PickupTable", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if data then
                    if Drugs.Meth:IsTablePlaced(data) then
                        local tableData = Drugs.Meth:GetTable(data)
                        if Drugs.Meth:RemovePlacedTable(data) then
                            if Inventory:AddItem(char:GetData("SID"), "meth_table", 1, { MethTable = data }, 1, false, false, false, false, false, tableData.created, false) then
                                cb(true)
                            else
                                cb(false)
                            end
                        else
                            cb(false)
                        end
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:CheckTable", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if data and _placedTables[data] ~= nil then
                    if _placedTables[data].cooldown == nil or os.time() > _placedTables[data].cooldown then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:StartCooking", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if data and _placedTables[data.tableId] ~= nil then
                    if _placedTables[data.tableId].cooldown == nil or os.time() > _placedTables[data.tableId].cooldown then
                        Drugs.Meth:StartTableCook(data.tableId, os.time() + (60 * 60 * 2), {
                            start_time = os.time(),
                            end_time = os.time() + (60 * data.cookTime),
                            ingredients = data.ingredients,
                            cookTime = data.cookTime,
                        })

                        Execute:Client(source, "Notification", "Success", string.format("Batch Started, Will Be Ready In %s Minutes", data.cookTime))
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:PickupCook", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if data and _placedTables[data] ~= nil then
                    local tableData = Drugs.Meth:GetTable(data)
                    local targetData = json.decode(tableData.recipe)
                    if tableData.active_cook ~= nil then
                        local cookData = json.decode(tableData.active_cook)
                        if os.time() > cookData.end_time then
                            local total = 0
                            for k, v in ipairs(cookData.ingredients) do
                                local diff = math.abs(v - targetData.ingredients[k])
                                local pct = diff / 100
                                local amt = (100 / #cookData.ingredients) * pct
                                total += amt
                            end

                            local cookPct = math.abs(cookData.cookTime - _tableTiers[tableData.tier].cookTimeMax) / _tableTiers[tableData.tier].cookTimeMax
                            local calc = total * cookPct

                            if Inventory:AddItem(char:GetData("SID"), "meth_brick", 1, {}, 1, false, false, false, false, false, false, math.floor(100 - total)) then
                                Drugs.Meth:FinishTableCook(data)
                            end
                        else
                            cb(false)
                        end
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:GetTableDetails", function(source, data, cb)
        local plyr = Fetch:Source(source)
        if plyr ~= nil then
            local char = plyr:GetData("Character")
            if char ~= nil then
                if data and _placedTables[data] ~= nil then
                    local tableData = Drugs.Meth:GetTable(data)

                    local str = string.format("Table %s:<ul>", data)
                    if tableData.cooldown ~= nil then
                        local timeUntil = tableData.cooldown - os.time()
                        if timeUntil > 0 then
                            str = str .. string.format("<li><b>Cooldown:</b> Available %s (in about %s)</li>", os.date("%m/%d/%Y %I:%M %p", tableData.cooldown), GetFormattedTimeFromSeconds(timeUntil))
                        else
                            str = str .. string.format("<li><b>Cooldown:</b> Available %s</li>", os.date("%m/%d/%Y %I:%M %p", tableData.cooldown))
                        end
                    else
                        str = str .. string.format("<li><b>Cooldown:</b> Not On Cooldown</li>")
                    end

                    if tableData.active_cook ~= nil then
                        local cook = json.decode(tableData.active_cook)

                        local timeUntil = cook.end_time - os.time()
                        if timeUntil > 0 then
                            str = str .. string.format("<li><b>Cook Status:</b> Finished At %s (in about %s)</li>", os.date("%m/%d/%Y %I:%M %p", cook.end_time), GetFormattedTimeFromSeconds(timeUntil))
                        else
                            str = str .. string.format("<li><b>Cook Status:</b> Finished At %s</li>", os.date("%m/%d/%Y %I:%M %p", cook.end_time))
                        end
                    else
                        str = str .. string.format("<li><b>Cook Status:</b> No Active Cook</li>")
                    end

                    str = str .. "</ul>"

                    Chat.Send.System:Single(source, str)

                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:GetItems", function(source, data, cb)
        local itms = {}

        local char = Fetch:Source(source):GetData("Character")
        local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")

        for k, v in ipairs(_toolsForSale) do
            _toolsForSale[v.item] = _toolsForSale[v.item] or {}
            if (not v.vpn or hasVpn) and not _toolsForSale[v.item][char:GetData("SID")] then
                table.insert(itms, v)
            end
        end

        cb(itms)
    end)

    Callbacks:RegisterServerCallback("Drugs:Meth:BuyItem", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")

        for k, v in ipairs(_toolsForSale) do
            if v.id == data then
                local coinData = Crypto.Coin:Get(v.coin)
                if Crypto.Exchange:Remove(v.coin, char:GetData("CryptoWallet"), v.price) then
                    Inventory:AddItem(char:GetData("SID"), v.item, 1, {}, 1)
                    _toolsForSale[v.item][char:GetData("SID")] = true
                else
                    Execute:Client(source, "Notification", "Error", string.format("Not Enough %s", coinData.Name), 6000)
                end
            end
        end
    end)
end)
