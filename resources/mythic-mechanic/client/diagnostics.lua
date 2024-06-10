local partNames = {
    Axle = 'Axle',
    Radiator = 'Radiator',
    Transmission = 'Transmission',
    FuelInjectors = 'Fuel Injectors',
    Brakes = 'Brakes',
    Clutch = 'Clutch',
    Electronics = 'Electronics',
}

AddEventHandler('Mechanic:Client:RunDiagnostics', function(entityData)
    if entityData and entityData.entity and DoesEntityExist(entityData.entity) then
        local vehEnt = Entity(entityData.entity)
        local vehDamage = vehEnt.state.DamagedParts

        local menu = {
            main = {
                label = 'Vehicle Diagnostics',
                items = {
                    {
                        label = 'Vehicle Class',
                        description = vehEnt.state.Class or 'Unknown',
                        event = false,
                    },
                    {
                        label = 'Vehicle Mileage',
                        description = (vehEnt.state.Mileage and Utils:Round(vehEnt.state.Mileage, 2) or 0) .. ' Miles',
                        event = false,
                    },
                },
            }
        }

        for k, v in pairs(partNames) do
            if vehDamage and vehDamage[k] then
                table.insert(menu.main.items, {
                    label = v,
                    description = Utils:Round(vehDamage[k], 2) .. '%',
                    event = false,
                })
            else
                table.insert(menu.main.items, {
                    label = v,
                    description = '100%',
                    event = false,
                })
            end
        end

        ListMenu:Show(menu)
    end
end)

function GetVehicleUpgradeLabel(level)
    if level == -1 then
        return 'Stock'
    end

    return 'Level ' .. (level + 1)
end

local modShit = {
    [11] = 'Engine',
    [13] = 'Transmission',
    [12] = 'Brakes',
    [15] = 'Suspension',
}

AddEventHandler('Mechanic:Client:RunPerformanceDiagnostics', function(entityData)
    if entityData and entityData.entity and DoesEntityExist(entityData.entity) then
        SetVehicleModKit(entityData.entity, 0)
        local vehEnt = Entity(entityData.entity)

        local menu = {
            main = {
                label = 'Vehicle Performance Parts',
                items = {},
            }
        }

        for k, v in pairs(modShit) do
            table.insert(menu.main.items, {
                label = v,
                description = GetVehicleUpgradeLabel(GetVehicleMod(entityData.entity, k)),
                event = false,
            })
        end

        table.insert(menu.main.items, {
            label = 'Turbo',
            description = IsToggleModOn(entityData.entity, 18) and 'Yes' or 'No',
            event = false,
        })

        ListMenu:Show(menu)
    end
end)