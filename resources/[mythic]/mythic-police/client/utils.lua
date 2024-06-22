function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function loadModel(model)
	if IsModelInCdimage(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(5)
		end
	end
end