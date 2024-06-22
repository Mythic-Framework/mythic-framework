function round(number, decimals) --Used to round distances. Was taken from stack overflow for ease.
	local power = 10 ^ decimals
	return math.floor(number * power) / power
end

function randomFloat(lower, greater) --Used to make float randoms. Was taken from stack overflow for ease.
	return lower + math.random() * (greater - lower)
end

function LoadAnimationDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(1)
	end
end

function DrawText3D(x, y, z, text) --Just a simple generic 3d text function. Copy pasted from my own core. Feel free to change the 3d text here. You got x,y,z and text.
	globalWait = 10
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
		local factor = (string.len(text)) / 370
		DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 100)
	end
end
