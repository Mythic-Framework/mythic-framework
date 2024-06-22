function beingCuffedAnim(cId)
	loadAnimDict("mp_arrest_paired")
	local cuffer = GetPlayerPed(GetPlayerFromServerId(cid))
	local dir = GetEntityHeading(cuffer)
	--SetEntityCoords(LocalPlayer.state.ped, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Wait(100)
	SetEntityHeading(LocalPlayer.state.ped, dir)
	TaskPlayAnim(LocalPlayer.state.ped, "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
end

function ResetTimer()
    cuffAttemptThreading = nil
    _attempts = 0
end

local cuffAttemptThreading = false
_attempts = 0
function CuffAttempt()
    _attempts = _attempts + 1
    if cuffAttemptThreading then 
        cuffAttemptThreading = (GetGameTimer() + 30000)
        return
    end
    cuffAttemptThreading = (GetGameTimer() + 30000)
    CreateThread(function()
        while GetGameTimer() < cuffAttemptThreading do
            Wait(10)
        end
        ResetTimer()
    end)
end