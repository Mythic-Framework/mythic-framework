local _threading = false

function StartMazeBankThreads()
    if _threading then return end
    _threading = true


	CreateThread(function()
		while _threading do
			if _mbGlobalReset ~= nil then
				if os.time() > _mbGlobalReset then
					Logger:Info("Robbery", "Maze Bank Heist Has Been Reset")
					ResetMazeBank()
				end
			end
			Wait(30000)
		end
	end)

    CreateThread(function()
        while _threading do
            local powerDisabled = IsMBPowerDisabled()
            if not powerDisabled and not Doors:IsLocked("mazebank_offices") then
                Doors:SetLock("mazebank_offices", true)
				for k, v in ipairs(_mbOfficeDoors) do
					Doors:SetLock(v.door, true)
				end
            elseif powerDisabled and Doors:IsLocked("mazebank_offices") then
                Doors:SetLock("mazebank_offices", false)
            end
            Wait((1000 * 60) * 1)
        end
    end)

	CreateThread(function()
		while _threading do
			for k, v in pairs(_mbHacks) do
				if
					GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] ~= nil
					and GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)].state == 2
					and GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)].expires < os.time()
				then
					Logger:Info("Robbery", string.format("Maze Bank Door %s Opening", v.doorId))
					GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] = {
						state = 3,
					}
					TriggerClientEvent("Robbery:Client:MazeBank:OpenVaultDoor", -1, v)
				end
			end
	
			Wait(30000)
		end
	end)
end
