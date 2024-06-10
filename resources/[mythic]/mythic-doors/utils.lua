function addDoorsListToConfig(newDoors)
    for k, v in ipairs(newDoors) do
        table.insert(_doorConfig, v)
    end
end