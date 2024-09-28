local withinBranchZone = false
local showingAction = false

function RunBankingStartup()
	AddBankingATMs()

	for k, v in pairs(_bankBranches) do
		if v.interactZone then
			Polyzone.Create:Box("banking-" .. k, v.interactZone.center, v.interactZone.length, v.interactZone.width, {
				heading = v.interactZone.heading,
				minZ = v.interactZone.minZ,
				maxZ = v.interactZone.maxZ,
			}, {
				bank_branch = k,
			})
		end
	end
end

AddEventHandler("Characters:Client:Spawn", function()
	for k, v in pairs(_bankBranches) do
		if v.blip then
			if v.special then
				Blips:Add("bank_" .. k, "Pacific Bank", v.blip, 272, 15, 0.8)
			else
				Blips:Add("bank_" .. k, "Bank", v.blip, 272, 69, 0.6)
			end
		end
	end
end)

AddEventHandler("Polyzone:Enter", function(id, point, insideZone, data)
	if data.bank_branch then
		withinBranchZone = data.bank_branch

        if not GlobalState[string.format("Fleeca:Disable:%s", data.bank_branch)] then
            Action:Show("{keybind}primary_action{/keybind} Open Bank")
        else
            Action:Show("Bank Unavailable")
        end

		showingAction = true
	end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZone, data)
	if withinBranchZone and data and data.bank_branch then
		withinBranchZone = false
		if showingAction then
			Action:Hide()
			showingAction = false
		end
	end
end)

function getCurrentBranchId()
    for branchId in pairs(_bankBranches) do
        if withinBranchZone == branchId then
            return branchId
        end
    end
    return nil
end

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
    if withinBranchZone then
        local currentBranchId = getCurrentBranchId()
        if currentBranchId then
            TriggerEvent("Finance:Client:OpenUI", currentBranchId)
        end
    end
end)
