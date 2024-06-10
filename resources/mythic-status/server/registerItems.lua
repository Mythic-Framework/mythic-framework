local alcoholItems = {
    wine_glass = 'wine',
    beer = 'beer',
    whiskey = 'whiskey',
    vodka = 'vodka',
    tequila = 'tequila',
    rum = 'rum',
    whiskey_glass = 'whiskey_glass',
    vodka_shot = 'vodka_shot',
    tequila_shot = 'tequila_shot',
    tequila_sunrise = 'tequila_sunrise',
    pina_colada = 'cocktail',
    raspberry_mimosa = 'cocktail',
    bloody_mary = 'cocktail',
    jaeger_bomb = 'jaeger_bomb',
    diamond_drink = 'diamond_drink',
    pint_mcdougles = 'pint_mcdougles',
}

function registerUsables()
    Inventory.Items:RegisterUse("wine_bottle", "Status", function(source, itemData)
		local currentMeta = itemData.MetaData or {}
        if not currentMeta.GlassesRemaining then
            currentMeta.GlassesRemaining = 4
        end

        if currentMeta.GlassesRemaining >= 1 then
            currentMeta.GlassesRemaining -= 1
            currentMeta = Inventory:UpdateMetaData(itemData.id, currentMeta)
            Inventory:AddItem(itemData.Owner, "wine_glass", 1, {}, 1)
        else
            Execute:Client(source, "Notification", "Error", "Bottle is Empty!")
        end
	end)

    for k, v in pairs(alcoholItems) do
        Inventory.Items:RegisterUse(k, "Status", function(source, itemData)
            Callbacks:ClientCallback(source, "Status:DrinkAlcohol", v, function(success)
                if success then
                    Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)
                end
            end)
        end)
    end

    Inventory.Items:RegisterUse("scuba_gear", "Status", function(source, slot, itemData)
        Callbacks:ClientCallback(source, "Status:UseScubaGear", {}, function(success)
            if success then
                local newValue = slot.CreateDate - (60 * 60 * 24 * 20)
                if (os.time() - itemData.durability >= newValue) then
                    Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
                else
                    Inventory:SetItemCreateDate(
                        slot.id,
                        newValue
                    )
                end
            end
        end)
	end)
end

