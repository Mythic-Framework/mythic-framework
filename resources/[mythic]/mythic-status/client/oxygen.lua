local oxygenDepletionRate = 1.3
local oxygenLevel = 100

local oxygenTank = nil
local oxygenMask = nil

AddEventHandler("Characters:Client:Spawn", function()
    Hud:RegisterStatus("mask-ventilator", 100, 100, "lungs", "#457F88", true, false, {
        hideHigh = true,
    })

    local underWater = false

    oxygenLevel = 100
    oxygenDepletionRate = 1

	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if IsPedSwimmingUnderWater(LocalPlayer.state.ped) then
                underWater = true

                if oxygenLevel > 0 then
                    SetPedDiesInWater(LocalPlayer.state.ped, false)

                    oxygenLevel -= oxygenDepletionRate

                    if oxygenLevel > 100 then
                        oxygenLevel = 100
                    end
                else
                    SetPedDiesInWater(LocalPlayer.state.ped, true)
                    SetPedMaxTimeUnderwater(LocalPlayer.state.ped, 0.0)
                end
			else
                underWater = false

                if oxygenLevel < 100 then
                    if oxygenDepletionRate < 1 then -- Using Scuba Gear
                        if oxygenLevel < 12.5 then
                            oxygenLevel += oxygenDepletionRate
                        end
                    else
                        oxygenLevel += oxygenDepletionRate
                    end
                else
                    Wait(900)
                end
			end

			Wait(150)
		end
	end)

    CreateThread(function()
		while LocalPlayer.state.loggedIn do
            if oxygenLevel < 100 then
                local sendingLevel = math.floor(oxygenLevel)

                TriggerEvent("Status:Client:Update", "oxygen", sendingLevel)

                Wait(500)
            else
                Wait(2500)
            end
		end
	end)
end)

AddEventHandler('Ped:Client:Died', function()
    oxygenLevel = 100
end)

function RemoveScubaGear()
    if IsPedSwimming(LocalPlayer.state.ped) then
        Notification:Error("Can't Take Off Gear Whilst Swimming")
        return
    end

    Progress:Progress({
        name = 'scuba_gear',
        duration = 2500,
        label = "Removing Scuba Gear",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            anim = "adjust",
        }
    }, function(cancelled)
        if not cancelled then
            oxygenDepletionRate = 1.25
    
            Hud:RegisterStatus("oxygen", 100, 100, "lungs", "#457F88", true, true, {
                hideHigh = true,
            })

            DeleteScubaGear()
        end
    end)
end

function RegisterOxygenCallbacks()
    Callbacks:RegisterClientCallback("Status:UseScubaGear", function(data, cb)
        if IsPedSwimming(LocalPlayer.state.ped) then
            Notification:Error("Can't Put On Scuba Gear Whilst Swimming")
            return
        end

        if oxygenDepletionRate >= 1 then
            Progress:Progress({
                name = 'scuba_gear',
                duration = 5000,
                label = "Fitting Scuba Gear",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    anim = "adjust",
                }
            }, function(cancelled)
                cb(not cancelled)
                if not cancelled then
                    oxygenDepletionRate = 0.05

                    Hud:RegisterStatus("oxygen", 100, 100, "mask-ventilator", "#457F88", true, true, {
                        hideHigh = false,
                    })

                    WearScubaGear()

                    CreateThread(function()
                        Wait(5000)
                        while oxygenDepletionRate < 1 and LocalPlayer.state.loggedIn do
                            if (oxygenTank and not DoesEntityExist(oxygenTank)) or (oxygenMask and not DoesEntityExist(oxygenMask)) then
                                WearScubaGear()
                            end
                            Wait(2000)
                        end
                    end)
                end
            end)
        else -- Already Has Scuba Gear
            cb(false)
            RemoveScubaGear()
        end
    end)
end

function RegisterOxygenMenus()
    Interaction:RegisterMenu("scuba_gear", "Take Off Scuba Gear", "mask-snorkel", function()
        RemoveScubaGear()
        Interaction:Hide()
    end, function()
        return oxygenDepletionRate < 1
    end)
end

function WearScubaGear()
    DeleteScubaGear()

    LoadPropModel(`p_s_scuba_tank_s`)
    LoadPropModel(`p_s_scuba_mask_s`)

    oxygenTank = CreateObject(`p_s_scuba_tank_s`, 1.0, 1.0, 1.0, 1, 1, 0)
    local bone = GetPedBoneIndex(LocalPlayer.state.ped, 24818)
    AttachEntityToEntity(oxygenTank, LocalPlayer.state.ped, bone, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetEntityCollision(oxygenTank, false, true)
	SetEntityCompletelyDisableCollision(oxygenTank, false, true)

    oxygenMask = CreateObject(`p_s_scuba_mask_s`, 1.0, 1.0, 1.0, 1, 1, 0)
    local bone = GetPedBoneIndex(LocalPlayer.state.ped, 12844)
    AttachEntityToEntity(oxygenMask, LocalPlayer.state.ped, bone, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetEntityCollision(oxygenMask, false, true)
	SetEntityCompletelyDisableCollision(oxygenMask, false, true)
end

function DeleteScubaGear()
    if oxygenTank and DoesEntityExist(oxygenTank) then
        DeleteEntity(oxygenTank)
        oxygenTank = nil
    end

    if oxygenMask and DoesEntityExist(oxygenMask) then
        DeleteEntity(oxygenMask)
        oxygenMask = nil
    end
end
