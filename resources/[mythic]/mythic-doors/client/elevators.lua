AddEventHandler("Doors:Client:OpenElevator", function(hitEntity, data)
    if not ELEVATOR_STATE then
        return
    end

    local elevatorData = ELEVATOR_STATE[data.elevator]

    if elevatorData and LocalPlayer.state.loggedIn then
        local menu = {
            main = {
                label = elevatorData.name or "Elevator",
                items = {},
            },
        }

        local isAuthed = false
        if elevatorData.canLock and CheckElevatorPermissions(elevatorData.canLock) then
            isAuthed = true
        end

        for floorId, floorData in pairs(elevatorData.floors) do
            local isDisabled = false
            local description = nil

            if floorData.locked then
                if not floorData.bypassLock or not CheckElevatorPermissions(floorData.bypassLock) then
                    isDisabled = true
                end
                description = "Authorized Access Only (Locked)"
            end

            if data.floor == floorId then
                isDisabled = true
                description = "You are Currently on This Level"
            end

            if isAuthed then
                isDisabled = false
            end

            table.insert(menu.main.items, {
                level = floorId,
                label = floorData.name or "Level ".. floorId,
                disabled = isDisabled,
                description = description,
                event = "Doors:Client:UseElevator",
                data = { elevator = data.elevator, floor = floorId },
                submenu = isAuthed and string.format("auth-%s", floorId) or false
            })

            if isAuthed then
                if data.floor == floorId then
                    isDisabled = true
                end

                menu[string.format("auth-%s", floorId)] = {
                    label = (floorData.name or "Level ".. floorId),
                    items = {
                        {
                            level = floorId,
                            label = "Visit This Floor",
                            disabled = isDisabled,
                            description = description,
                            event = "Doors:Client:UseElevator",
                            data = { elevator = data.elevator, floor = floorId },
                            submenu = false
                        },
                        {
                            --level = -1000,
                            label = floorData.locked and "Unlock Floor" or "Lock Floor",
                            description = "Lock/Unlock this Floor",
                            event = "Doors:Client:LockElevator",
                            data = { elevator = data.elevator, floor = floorId },
                        }
                    }
                }
            end
        end

        table.sort(menu.main.items, function(a, b)
            return a.level < b.level
        end)

        ListMenu:Show(menu)
    end
end)

AddEventHandler("Doors:Client:LockElevator", function(data)
    if ELEVATOR_STATE[data.elevator] and LocalPlayer.state.loggedIn then
        Callbacks:ServerCallback("Doors:Elevators:ToggleLocks", data, function(success, newState)
            if success then
                if newState then
                    Notification:Error("Elevator Locked")
                else
                    Notification:Success("Elevator Unlocked")
                end
            end
        end)
    end
end)

AddEventHandler("Doors:Client:UseElevator", function(data)
    local elevatorData = ELEVATOR_STATE[data.elevator]

    if elevatorData and elevatorData.floors and LocalPlayer.state.loggedIn then
        local floorData = elevatorData.floors[data.floor]
        if floorData and floorData.coords then
            Callbacks:ServerCallback("Doors:Elevator:Validate", floorData, function()
                Progress:ProgressWithTickEvent({
                    name = "door_elevator",
                    duration = 2000,
                    label = "Awaiting Elevator",
                    useWhileDead = false,
                    canCancel = true,
                    ignoreModifier = true,
                    tickrate = 100,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function()
                    if LocalPlayer.state.isCuffed then
                        return Progress:Cancel()
                    end
                end, function(cancelled)
                    if not cancelled and not ELEVATOR_STATE[data.elevator].locked then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do Wait(10) end
            
                        SetEntityCoords(GLOBAL_PED, floorData.coords.x, floorData.coords.y, floorData.coords.z)
                        SetEntityHeading(GLOBAL_PED, floorData.coords.w)
                        Sounds.Play:Distance(5.0, "elevator-bell.ogg", 0.4)
                        Wait(250)
                        DoScreenFadeIn(500)
                    end
                end)
            end)
        end
    end
end)

function CheckElevatorPermissions(restricted)
    if LocalPlayer.state.Character then

        if type(restricted) ~= "table" then
            return true
        end

        local stateId = LocalPlayer.state.Character:GetData("SID")
        for k, v in ipairs(restricted) do
            if v.type == "character" then
                if stateId == v.SID then
                    return true
                end
            elseif v.type == "job" then
                if v.job then
                    if Jobs.Permissions:HasJob(v.job, v.workplace, v.grade, v.gradeLevel, v.reqDuty, v.jobPermission) then
                        return true
                    end
                elseif v.jobPermission then
                    if Jobs.Permissions:HasPermission(v.jobPermission) then
                        return true
                    end
                end
            end
        end
    end
    return false
end