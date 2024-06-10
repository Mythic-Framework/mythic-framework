function IsPaletoExploitInstalled()
	for k, v in ipairs(_pbPCHackAreas) do
		if not _bankStates.paleto.exploits[v.data.pcId] then
			return false
		end
	end
	return true
end

function CountPaletoExploits()
	local val = 0
	for k, v in ipairs(_pbPCHackAreas) do
		if _bankStates.paleto.exploits[v.data.pcId] ~= nil and _bankStates.paleto.exploits[v.data.pcId] > os.time() then
			val += 1
		end
	end
	return val
end

function IsPaletoPowerDisabled()
	if not IsPaletoExploitInstalled() then
		return false
	end

	for k, v in ipairs(_pbSubStationZones) do
		if not _bankStates.paleto.substations[v.data.subStationId] then
			return false
		end
	end

	for k, v in ipairs(_pbPowerHacks) do
		if not _bankStates.paleto.electricalBoxes[v.data.boxId] then
			return false
		end
	end

	return true
end
