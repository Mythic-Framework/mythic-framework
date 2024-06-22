local myFeatures = {}
local crouchAnimSet = "move_ped_crouched"
local crouchStrafeAnimSet = "move_ped_crouched_strafing"

function RequestAndLoadAnimSet(animSet)
    RequestAnimSet(crouchAnimSet)
    while not HasAnimSetLoaded(crouchAnimSet) do
        Wait(10)
    end
end

ANIMATIONS.PedFeatures = {
    ToggleCrouch = function(self, toggle)
        if toggle == nil then
            toggle = not _isCrouched
        end

        if toggle then
            if IsPedOnFoot(LocalPlayer.state.ped) and not LocalPlayer.state.placingFurniture then
                if not LocalPlayer.state.isLimping then
                    RequestAndLoadAnimSet(crouchAnimSet)
                    --RequestAndLoadAnimSet(crouchStrafeAnimSet)

                    SetPedMovementClipset(LocalPlayer.state.ped, crouchAnimSet, 1.0)
                    --SetPedWeaponMovementClipset(LocalPlayer.state.ped, crouchAnimSet, 1.0)
                    --SetPedStrafeClipset(LocalPlayer.state.ped, crouchStrafeAnimSet, 1.0)

                    _isCrouched = true
                else
                    SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
                end
            end
        else
            ResetPedMovementClipset(LocalPlayer.state.ped, 0)

            ResetPedWeaponMovementClipset(LocalPlayer.state.ped)
            ResetPedStrafeClipset(LocalPlayer.state.ped)

            if not LocalPlayer.state.drunkMovement then
                Animations.PedFeatures:RequestFeaturesUpdate()
            end
            _isCrouched = false
        end
    end,
    SetWalk = function(self, walk, label)
        if LocalPlayer.state.isLimping then
            RequestAnimSet("move_m@injured")
            SetPedMovementClipset(LocalPlayer.state.ped, "move_m@injured", 0.2)
            RemoveAnimSet("move_m@injured")
            if walk == 'reset' then
                walkStyle = walk
                Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = 'default'}, function(success)
                    if success then
                        Notification:Info('Reset Walking Style', 5000)
                    end
                end)
            else
                walkStyle = walk
                Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = walk}, function(success)
                    if success then
                        Notification:Success('Saved Walking Style: ' .. label, 5000)
                    end
                end)
            end
        else
            if walk == 'reset' then
                ResetPedMovementClipset(LocalPlayer.state.ped, 0.0)
                walkStyle = walk
                Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = 'default'}, function(success)
                    if success then
                        Notification:Info('Reset Walking Style', 5000)
                    end
                end)
            else
                ReqAnimSet(walk)
                SetPedMovementClipset(LocalPlayer.state.ped, walk, 0.2)
                RemoveAnimSet(walk)
                walkStyle = walk
                Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'walk', data = walk}, function(success)
                    if success then
                        Notification:Success('Saved Walking Style: ' .. label, 5000)
                    end
                end)
            end
        end
    end,
    SetExpression = function(self, expression, label)
        if expression == 'reset' then
            ClearFacialIdleAnimOverride(LocalPlayer.state.ped)
            facialExpression = expression
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'expression', data = 'default'}, function(success)
                if success then
                    Notification:Info('Expression Reset', 5000)
                end
            end)
        else
            SetFacialIdleAnimOverride(LocalPlayer.state.ped, expression, 0)
            facialExpression = expression
            Callbacks:ServerCallback('Animations:UpdatePedFeatures', { type = 'expression', data = expression}, function(success)
                if success then
                    Notification:Success('Saved Expression: ' .. label, 5000)
                end
            end)
        end
    end,
    RequestFeaturesUpdate = function(self, feats)
        if LocalPlayer.state.isLimping then
            RequestAnimSet("move_m@injured")
            SetPedMovementClipset(LocalPlayer.state.ped, "move_m@injured", 0.2)
            RemoveAnimSet("move_m@injured")
        else
            if walkStyle ~= 'default' then
                ReqAnimSet(walkStyle)
                SetPedMovementClipset(LocalPlayer.state.ped, walkStyle, 0.6)
                RemoveAnimSet(walkStyle)
            else
                ResetPedMovementClipset(LocalPlayer.state.ped, 0.0)
            end
        end
        if facialExpression ~= 'default' then
            SetFacialIdleAnimOverride(LocalPlayer.state.ped, facialExpression, 0)
        end
    end,
}