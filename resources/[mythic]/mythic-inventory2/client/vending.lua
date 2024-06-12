local vendingMachines = {
    { model = `prop_vend_coffe_01`, shop = "vending-coffee", icon = "mug-hot", text = "Use Coffee Machine" },
    { model = `prop_vend_water_01`, shop = "vending-water", icon = "droplet", text = "Use Water Machine"  },
    { model = `prop_watercooler`, shop = "vending-water", icon = "droplet", text = "Use Water Machine"  },
    { model = `prop_watercooler_dark`, shop = "vending-water", icon = "droplet", text = "Use Water Machine"  },
    { model = `prop_vend_soda_01`, shop = "vending-drinks", icon = "kitchen-set" },
    { model = `prop_vend_soda_02`, shop = "vending-drinks", icon = "kitchen-set" },
    { model = `v_68_broeknvend`, shop = "vending-drinks", icon = "kitchen-set" },
    { model = `prop_vend_snak_01`, shop = "vending-food", icon = "cookie-bite" },
    { model = `prop_gas_pump_1a`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_gas_pump_1b`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_gas_pump_1c`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_gas_pump_1d`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_vintage_pump`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_gas_pump_old2`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
    { model = `prop_gas_pump_old3`, shop = "fuel-pump", icon = "gas-pump", text = 'Buy Petrol Can' },
}

function CreateVendingMachines()
    for k, v in ipairs(vendingMachines) do
        Targeting:AddObject(v.model, v.icon, {
            {
                text = v.text or "Use Vending Machine",
                icon = v.icon, 
                event = "Shop:Client:OpenShop",
                data = v.shop,
                minDist = 3.0,
            },
        }, 3.0)
    end
end