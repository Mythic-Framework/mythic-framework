AddEventHandler("Businesses:Client:Startup", function()
    Interaction:RegisterMenu("storage-units", "Storage Unit", "warehouse", function(data)
        Interaction:ShowMenu({
            {
                icon = "warehouse",
                label = "Access Storage",
                action = function()
                    Interaction:Hide()
                    StorageUnits:Access()
                end,
                shouldShow = function()
                    return true
                end,
            },
            {
                icon = "bomb",
                label = "Raid Storage",
                action = function()
                    Interaction:Hide()
                    local nearUnit = StorageUnits:GetNearUnit()
                    if nearUnit and nearUnit?.unitId then
                        local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]

                        Callbacks:ServerCallback("StorageUnits:PoliceRaid", {
                            unit = nearUnit.unitId
                        }, function(success)
                            if not success then
                                Notification:Error("Error!")
                            else
                                Sounds.Play:Location(LocalPlayer.state.myPos, 10, "breach.ogg", 0.15)
                            end
                        end)
                    end
                end,
                shouldShow = function()
                    return LocalPlayer.state.onDuty == "police"
                end,
            },
            {
                icon = "gear",
                label = "Manage",
                action = function()
                    Interaction:Hide()
                    StorageUnits:Manage()
                end,
                shouldShow = function()
                    local nearUnit = StorageUnits:GetNearUnit()
                    if nearUnit and nearUnit?.unitId then
                        local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]

                        return (unit.owner and unit.owner.SID == LocalPlayer.state.Character:GetData("SID")) or Jobs.Permissions:HasJob(unit.managedBy)
                    end
                end,
            },
            {
                icon = "gears",
                label = "Manage All",
                action = function()
                    Interaction:Hide()
                    local nearUnit = StorageUnits:GetNearUnit()
                    if nearUnit and nearUnit?.unitId then
                        local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]

                        StorageUnits:ManageAll(unit.managedBy)
                    end
                end,
                shouldShow = function()
                    local nearUnit = StorageUnits:GetNearUnit()
                    if nearUnit and nearUnit?.unitId then
                        local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]

                        return Jobs.Permissions:HasJob(unit.managedBy)
                    end
                end,
            },
        })
    end, function()
        return StorageUnits:GetNearUnit() and LocalPlayer.state.Character
    end)

    Callbacks:RegisterClientCallback("StorageUnits:Passcode", function(code, cb)
        Minigame.Play:Keypad(code, false, 10000, true, {
            onSuccess = function(data)
                Citizen.Wait(2000)
                cb(true, data)
            end,
            onFail = function(data)
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
				animDict = "amb@prop_human_atm@male@idle_a",
				anim = "idle_b",
				flags = 49,
			},
        })
    end)
end)

_STORAGEUNITS = {
    Access = function(self)
        local nearUnit = StorageUnits:GetNearUnit()
        if nearUnit and nearUnit?.unitId then
            Callbacks:ServerCallback("StorageUnits:Access", nearUnit?.unitId)
        end
    end,
    Manage = function(self, specificUnit)
        local nearUnit = StorageUnits:GetNearUnit()

        if specificUnit then
            nearUnit = { unitId = specificUnit }
        end

        if nearUnit and nearUnit?.unitId then
            local unit = GlobalState[string.format("StorageUnit:%s", nearUnit.unitId)]
            if unit then
                local menu = {
                    main = {
                        label = "Manage " .. unit.label,
                        items = {
                            {
                                label = "Storage Last Accessed",
                                description = unit.lastAccessed and string.format("Unit Last Accessed %s ago.", GetFormattedTimeFromSeconds(GlobalState["OS:Time"] - unit.lastAccessed)) or "Never",
                            },
                        }
                    },
                }

                if unit.owner and LocalPlayer.state.Character and LocalPlayer.state.Character:GetData("SID") == unit.owner.SID then
                    table.insert(menu.main.items, {
                        label = "Set Passcode",
                        description = "Change the passcode for your storage unit",
                        data = { unit = nearUnit.unitId },
                        event = "StorageUnits:ChangePasscode",
                    })
                end

                if Jobs.Permissions:HasJob(unit.managedBy) then
                    if unit.owner then
                        table.insert(menu.main.items, {
                            label = "Current Unit Owner",
                            description = string.format("Owned By %s %s (State ID: %s)", unit.owner.First, unit.owner.Last, unit.owner.SID),
                        })

                        table.insert(menu.main.items, {
                            label = "Unit Sold By",
                            description = string.format("Sold By %s %s (State ID: %s) %s ago.", unit.soldBy.First, unit.soldBy.Last, unit.soldBy.SID, GetFormattedTimeFromSeconds(GlobalState["OS:Time"] - unit.soldAt)),
                        })
                    end
                end

                if Jobs.Permissions:HasJob(unit.managedBy, false, false, false, false, "UNIT_SELL") then
                    table.insert(menu.main.items, {
                        label = "Sell Storage Unit",
                        description = "Set the new owner of the storage unit",
                        data = { unit = nearUnit.unitId },
                        event = "StorageUnits:StartSell",
                    })
                end

                ListMenu:Show(menu)
            end
        end
    end,
    ManageAll = function(self, managedBy)
        local menu = {
            main = {
                label = "Manage All Storage Units",
                items = {}
            },
        }

        if GlobalState["StorageUnits"] then
            for k, v in ipairs(GlobalState["StorageUnits"]) do
                local unit = GlobalState[string.format("StorageUnit:%s", v)]
                if unit and unit.managedBy == managedBy then
                    table.insert(menu.main.items, {
                        label = unit.label,
                        description = unit.owner and string.format("Owned By %s %s", unit.owner.First, unit.owner.Last) or "Not Owned",
                        data = { unit = unit.id },
                        event = "StorageUnits:Manage",
                    })
                end
            end
        end

        ListMenu:Show(menu)
    end,
    GetNearUnit = function(self)
        if LocalPlayer.state.currentRoute ~= 0 then
			return false
		end

		local myCoords = GetEntityCoords(LocalPlayer.state.ped)

		if GlobalState["StorageUnits"] == nil then
			return false
		else
			local closest = nil
			for k, v in ipairs(GlobalState["StorageUnits"]) do
				local unit = GlobalState[string.format("StorageUnit:%s", v)]
                if unit then
                    local dist = #(myCoords - unit.location)
                    if dist < 3.0 and (not closest or dist < closest.dist) then
                        closest = {
                            dist = dist,
                            unitId = unit.id,
                        }
                    end
                end
			end
			return closest
		end
    end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("StorageUnits", _STORAGEUNITS)
end)

AddEventHandler("StorageUnits:ChangePasscode", function(data)
    Input:Show("Change Unit Passcode", "New Passcode", {
		{
			id = "passcode",
			type = "text",
			options = {
                helperText = "Numbers Only - Minimum Length of 4 and a Maximum Length of 8",
				inputProps = {
                    pattern = "[0-9]+",
                    minlength = 4,
                    maxlength = 8,
                },
			},
		},
	}, "StorageUnits:Client:NewPasscode", data)
end)

AddEventHandler("StorageUnits:Client:NewPasscode", function(values, data)
    if values and values.passcode and #values.passcode >= 4 then
        Callbacks:ServerCallback("StorageUnits:ChangePasscode", {
            unit = data.unit,
            passcode = values.passcode,
        }, function(success)
            if success then
                Notification:Success("Updated Passcode")
            else
                Notification:Error("Failed to Update Passcode")
            end
        end)
    end
end)

AddEventHandler("StorageUnits:StartSell", function(data)
    Input:Show("Set Storage Unit Owner", "State ID", {
		{
			id = "SID",
			type = "number",
			options = {
                --helperText = "Numbers Only - Minimum Length of 4 and a Maximum Length of 8",
				inputProps = {},
			},
		},
	}, "StorageUnits:Client:SellUnit", data)
end)

AddEventHandler("StorageUnits:Client:SellUnit", function(values, data)
    if values and values.SID then
        local stateId = tonumber(values.SID)
        if stateId and stateId > 0 then
            Callbacks:ServerCallback("StorageUnits:SellUnit", {
                unit = data.unit,
                SID = stateId,
            }, function(success)
                if success then
                    Notification:Success("Storage Unit Sold")
                else
                    Notification:Error("Failed to Sell Storage Unit")
                end
            end)
        else
            Notification:Error("Invalid State ID")
        end
    end
end)

AddEventHandler("StorageUnits:Manage", function(data)
    if data?.unit then
        StorageUnits:Manage(data.unit)
    end
end)