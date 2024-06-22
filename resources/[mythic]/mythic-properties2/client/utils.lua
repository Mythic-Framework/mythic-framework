function LoadModel(model)
	RequestModel(model)
	local attempts = 0
	while not HasModelLoaded(model) and attempts < 100 do
		RequestModel(model)
		Wait(10)
		attempts += 1
	end

    return HasModelLoaded(model)
end