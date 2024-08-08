PropertyUpgrades = {
    house = {
        storage = {
            name = "Storage",
            levels = {}
        },
        interior = {
            name = "Interior",
            levels = {}
        },
        garage = {
            name = "Garage",
            levels = {}
        }
    },
    office = {
        storage = {
            name = "Storage",
            levels = {}
        },
        interior = {
            name = "Interior",
            levels = {}
        },
        garage = {
            name = "Garage",
            levels = {}
        }
    },
}

CreateThread(function()
    for k, v in pairs(PropertyInteriors) do
        if PropertyUpgrades[v.type] and PropertyUpgrades[v.type].interior then
            table.insert(PropertyUpgrades[v.type].interior.levels, {
                name = v.info?.name or k,
                info = v.info,
                id = k,
                price = v.price,
            })
        end
    end

    for k, v in pairs(PropertyStorage) do
        if PropertyUpgrades[k] then
            for k2, v2 in ipairs(v) do
                table.insert(PropertyUpgrades[k].storage.levels, {
                    name = "Storage Level " .. k2,
                    info = string.format("%s Slots | %s Capacity", v2.slots, v2.capacity),
                    storage = v2,
                    price = v2.price,
                })
            end
        end
    end

    for k, v in pairs(PropertyGarage) do
        if PropertyUpgrades[k] then
            for k2, v2 in ipairs(v) do
                table.insert(PropertyUpgrades[k].garage.levels, {
                    name = "Garage Level " .. k2,
                    info = string.format("%s Parking Spaces", v2.parking),
                    garage = v2,
                    price = v2.price,
                })
            end
        end
    end
end)