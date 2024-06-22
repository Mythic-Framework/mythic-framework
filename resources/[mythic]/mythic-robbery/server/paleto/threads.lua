local _threading = false

function StartPaletoThreads()
    if _threading then return end
    _threading = true

	CreateThread(function()
		while _threading do
			if _pbGlobalReset ~= nil then
				if os.time() > _pbGlobalReset then
					Logger:Info("Robbery", "Paleto Bank Heist Has Been Reset")
					ResetPaleto()
				end
			end
			Wait(30000)
		end
	end)
end