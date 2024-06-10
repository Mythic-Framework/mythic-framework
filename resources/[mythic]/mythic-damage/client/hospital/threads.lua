_countdown = 0
_leavingBed = false

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _curBed ~= nil and LocalPlayer.state.isHospitalized and _countdown <= 0 and not _leavingBed then
		_leavingBed = true
		LeaveBed()
	end
end)

local _healThreading = false
local _healCounting = false
function StartHealThread()
	if _healThreading then
		return
	end
	_healThreading = true

	Citizen.CreateThread(function()
		local key = Keybinds:GetKey("primary_action")
		while LocalPlayer.state.loggedIn and LocalPlayer.state.isHospitalized do
			if _leavingBed then
				DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, 'Finishing Up...')
			else
				if _countdown > 0 then
					DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, string.format('You\'re Being Treated, %s Seconds Left', _countdown))
				else
					DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, string.format('Press ~r~(%s)~s~ To Get Out of Bed', key))
				end
			end
			Citizen.Wait(1)
		end
		_healThreading = false
	end)

	if not _healCounting then
		_healCounting = true
		Citizen.CreateThread(function()
			while LocalPlayer.state.loggedIn and _countdown >= 0 and LocalPlayer.state.isHospitalized do
				Citizen.Wait(1000)
				_countdown = _countdown - 1
			end
			Damage:Heal()
			_healCounting = false
		end)
	end
end

function StartRPThread()
	Citizen.CreateThread(function()
		local key = Keybinds:GetKey("primary_action")
		while LocalPlayer.state.loggedIn and LocalPlayer.state.isHospitalized do
			if _leavingBed then
				DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, 'Getting Up...')
			else
				DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, string.format('Press ~r~(%s)~s~ To Get Out of Bed', key))
			end
			Citizen.Wait(1)
		end
	end)
end