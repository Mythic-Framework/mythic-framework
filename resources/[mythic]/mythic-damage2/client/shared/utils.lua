function cTable(table)
	local n = 0
	for k, v in pairs(table) do
		n = n + 1
	end
	return n
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end