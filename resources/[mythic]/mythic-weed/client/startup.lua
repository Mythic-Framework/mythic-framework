function RegisterTargets()
	for k, v in ipairs(Plants) do
		Targeting:AddObject(v.model, "cannabis", v.targeting, 3.0)
	end
end

function LoadWeedModels()
	CreateThread(function()
		for k, v in ipairs(Plants) do
			LoadModel(v.model)
		end
	end)
end

function LoadModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(10)
	end
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end