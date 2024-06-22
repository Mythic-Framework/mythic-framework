_disabled = false

function DisableControls()
    CreateThread(function()
		while LocalPlayer.state.loggedIn and _disabled do
			DisableControlAction(0, 0, true) -- INPUT_NEXT_CAMERA
			DisableControlAction(0, 21, true) -- INPUT_SPRINT
			DisableControlAction(0, 22, true) -- INPUT_JUMP
			DisableControlAction(0, 23, true) -- INPUT_ENTER
			DisableControlAction(0, 24, true) -- INPUT_ATTACK
			DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 26, true) -- INPUT_LOOK_BEHIND
			DisableControlAction(0, 30, true) -- INPUT_MOVE_LR
			DisableControlAction(0, 31, true) -- INPUT_MOVE_UD
			DisableControlAction(0, 36, true) -- INPUT_DUCK
			DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
			DisableControlAction(0, 44, true) -- INPUT_COVER
			DisableControlAction(0, 47, true) -- INPUT_DETONATE
			DisableControlAction(0, 58, true) -- INPUT_THROW_GRENADE
			DisableControlAction(0, 61, true) -- INPUT_VEH_MOVE_UP_ONLY
			DisableControlAction(0, 62, true) -- INPUT_VEH_MOVE_DOWN_ONLY
			DisableControlAction(0, 63, true) -- INPUT_VEH_MOVE_LEFT_ONLY
			DisableControlAction(0, 64, true) -- INPUT_VEH_MOVE_RIGHT_ONLY
			DisableControlAction(0, 71, true) -- INPUT_VEH_ACCELERATE
			DisableControlAction(0, 72, true) -- INPUT_VEH_BRAKE
			DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT
			DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
			DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
			DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
			DisableControlAction(0, 143, true) -- INPUT_MELEE_BLOCK
			DisableControlAction(0, 257, true) -- INPUT_ATTACK2
			DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
			DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
			DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
			Wait(1)
		end
    end)
end