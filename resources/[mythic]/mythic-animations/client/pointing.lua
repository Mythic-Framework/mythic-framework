function StartPointing()
    if not LocalPlayer.state.loggedIn or _isPointing or IsPedArmed(LocalPlayer.state.ped, 7) or GLOBAL_VEH then return end
    _isPointing = true

    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(100)
    end

    SetPedConfigFlag(LocalPlayer.state.ped, 36, 1)
    TaskMoveNetworkByName(LocalPlayer.state.ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")

    CreateThread(function()
        while _isPointing do
            if GLOBAL_VEH or IsPedArmed(LocalPlayer.state.ped, 7) then
                return StopPointing()
            end
            if IsTaskMoveNetworkActive(LocalPlayer.state.ped) then
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = math.cos(camHeading)
                local sinCamHeading = math.sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local nn, blocked = GetRaycastResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, LocalPlayer.state.ped, 7))

                SetTaskMoveNetworkSignalFloat(LocalPlayer.state.ped, "Pitch", camPitch)
                SetTaskMoveNetworkSignalFloat(LocalPlayer.state.ped, "Heading", camHeading * -1.0 + 1.0)
                SetTaskMoveNetworkSignalBool(LocalPlayer.state.ped, "isBlocked", blocked)
                SetTaskMoveNetworkSignalBool(LocalPlayer.state.ped, "isFirstPerson", N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
            end
            Wait(5)
        end
    end)
end

function StopPointing()
    if not _isPointing then return end
    _isPointing = false
    
    RequestTaskMoveNetworkStateTransition(LocalPlayer.state.ped, "Stop")
    if not IsPedInjured(LocalPlayer.state.ped) then
        ClearPedSecondaryTask(LocalPlayer.state.ped)
    end

    SetPedConfigFlag(LocalPlayer.state.ped, 36, 0)
    ClearPedSecondaryTask(LocalPlayer.state.ped)
end
