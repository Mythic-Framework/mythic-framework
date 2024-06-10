local _ran = false

function DefaultData()
    if _ran then return end

    _ran = true
    Default:Add('properties', 1590006209, {
        {
            interior = 1,
            price = 100000,
            location = {
                front = {
                    z = 26.679443359375,
                    x = -33.92966842651367,
                    y = -1847.235107421875
                },
                backdoor = {
                    x = -42.875373840332,
                    y = -1859.2385253906,
                    z = 26.197219848633,
                    h = 139.80822753906
                }
            },
            label = "1 Grove St",
            sold = false
        }
    })
end