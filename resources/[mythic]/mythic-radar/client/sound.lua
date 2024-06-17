function PlayFastAlert()
    CreateThread(function()
        UISounds.Play:FrontEnd(-1, 'BEEP_RED', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
        Wait(250)
        UISounds.Play:FrontEnd(-1, 'BEEP_RED', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
        Wait(250)
        UISounds.Play:FrontEnd(-1, 'BEEP_RED', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
    end)
end

function PlayFlaggedAlert()
    UISounds.Play:FrontEnd(-1, 'BEEP_GREEN', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
end

function PlayLockAlert()
    UISounds.Play:FrontEnd(-1, 'BEEP_RED', 'DLC_HEIST_HACKING_SNAKE_SOUNDS')
end

function PlayUnlockAlert()
    UISounds.Play:FrontEnd(-1, '5_SEC_WARNING', 'HUD_MINI_GAME_SOUNDSET')
end