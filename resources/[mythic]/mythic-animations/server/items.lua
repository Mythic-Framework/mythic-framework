function RegisterItems()
    Inventory.Items:RegisterUse('camping_chair', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:CampChair', source)
    end)

    Inventory.Items:RegisterUse('beanbag', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:BeanBag', source)
    end)

    Inventory.Items:RegisterUse('binoculars', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:Binoculars', source)
    end)

    Inventory.Items:RegisterUse('camera', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:Camera', source)
    end)
end