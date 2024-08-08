function CreatePropertyZones(propertyId, int)
    DestroyPropertyZones(propertyId)

    Wait(100)

    local interior = PropertyInteriors[int]
    if interior then
        Targeting.Zones:AddBox(
            string.format("property-%s-exit", propertyId),
            "door-open",
            interior.locations.front.polyzone.center,
            interior.locations.front.polyzone.length,
            interior.locations.front.polyzone.width,
            interior.locations.front.polyzone.options,
            {
                {
                    icon = "door-open",
                    text = "Exit",
                    event = "Properties:Client:Exit",
                    data = {
                        property = propertyId,
                        backdoor = false,
                    },
                },
            },
            2.0,
            true
        )

        if interior.locations.back then
            Targeting.Zones:AddBox(
                string.format("property-%s-exit-back", propertyId),
                "door-open",
                interior.locations.back.polyzone.center,
                interior.locations.back.polyzone.length,
                interior.locations.back.polyzone.width,
                interior.locations.back.polyzone.options,
                {
                    {
                        icon = "door-open",
                        text = "Exit",
                        event = "Properties:Client:Exit",
                        data = {
                            property = propertyId,
                            backdoor = true,
                        },
                    },
                },
                2.0,
                true
            )
        end

        if interior.locations.office then
            Targeting.Zones:AddBox(
                string.format("property-%s-office", propertyId),
                "phone-office",
                interior.locations.office.polyzone.center,
                interior.locations.office.polyzone.length,
                interior.locations.office.polyzone.width,
                interior.locations.office.polyzone.options,
                {
                    {
                        icon = "box-open-full",
                        text = "Access Storage",
                        event = "Properties:Client:Stash",
                        data = propertyId,
                        isEnabled = function(data)
                            if not _propertiesLoaded then
                                return false
                            end
                            local property = _properties[data]
                            return (property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) or LocalPlayer.state.onDuty == "police"
                        end,
                    },
                    {
                        icon = "clipboard",
                        text = "Go On/Off Duty",
                        event = "Properties:Client:Duty",
                        data = propertyId,
                        isEnabled = function(data)
                            if not _propertiesLoaded then
                                return false
                            end
                            local property = _properties[data]
                            return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil and property?.data?.jobDuty
                        end,
                    },
                },
                2.0,
                true
            )
        end

        if interior.locations.warehouse then
            Targeting.Zones:AddBox(
                string.format("property-%s-warehouse", propertyId),
                "warehouse-full",
                interior.locations.warehouse.polyzone.center,
                interior.locations.warehouse.polyzone.length,
                interior.locations.warehouse.polyzone.width,
                interior.locations.warehouse.polyzone.options,
                {
                    {
                        icon = "box-open-full",
                        text = "Access Storage",
                        event = "Properties:Client:Stash",
                        data = propertyId,
                        isEnabled = function(data)
                            if not _propertiesLoaded then
                                return false
                            end
                            local property = _properties[data]
                            return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
                        end,
                    },
                },
                2.0,
                true
            )
        end

        if interior.locations.crafting and GlobalState[string.format("Property:Crafting:%s", propertyId)] then
            local menu = {
                {
                    icon = "box-open-full",
                    text = "Access Storage",
                    event = "Properties:Client:Stash",
                    data = propertyId,
                    isEnabled = function(data)
                        if not _propertiesLoaded then
                            return false
                        end
                        local property = _properties[data]
                        return (property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) or LocalPlayer.state.onDuty == "police"
                    end,
                },
                {
                    icon = "screwdriver-wrench",
                    text = "Use Bench",
                    event = "Properties:Client:Crafting",
                    data = propertyId,
                    isEnabled = function(data)
                        if not _propertiesLoaded then
                            return false
                        end
                        local property = _properties[data]
                        return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
                    end,
                },
            }

            if GlobalState[string.format("Property:Crafting:%s", propertyId)].schematics then
                table.insert(menu, {
                    icon = "memo-circle-check",
                    text = "Add Schematic To Bench",
                    event = "Crafting:Client:AddSchematic",
                    data = {
                        id = string.format("property-%s", propertyId),
                    },
                    isEnabled = function(data, entityData)
                        if not _propertiesLoaded then
                            return false
                        end

                        return Inventory.Items:HasType(17, 1)
                    end,
                })
            end

            Targeting.Zones:AddBox(
                string.format("property-%s-crafting", propertyId),
                "screwdriver-wrench",
                interior.locations.crafting.polyzone.center,
                interior.locations.crafting.polyzone.length,
                interior.locations.crafting.polyzone.width,
                interior.locations.crafting.polyzone.options,
                menu,
                2.0,
                true
            )
        end

        Wait(1000)
        Targeting.Zones:Refresh()
    end
end

function DestroyPropertyZones(propertyId)
	Targeting.Zones:RemoveZone(string.format("property-%s-exit", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-warehouse", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-office", propertyId))
    Targeting.Zones:RemoveZone(string.format("property-%s-crafting", propertyId))
end