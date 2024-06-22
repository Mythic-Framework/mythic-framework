local _threading = false
function StartFleecaThreads()
	if _threading then
		return
	end
	_threading = true

	CreateThread(function()
		while _threading do
			for k, v in pairs(FLEECA_LOCATIONS) do
				if _fcGlobalReset[k] ~= nil and os.time() > _fcGlobalReset[k] then
					Logger:Info("Robbery", string.format("Fleeca - %s Heist Has Been Reset", v.label))
					ResetFleeca(k)
				end
			end
			Wait(30000)
		end
	end)

	CreateThread(function()
		while _threading do
			for k, v in pairs(FLEECA_LOCATIONS) do
				if
					GlobalState[string.format("Fleeca:%s:VaultDoor", v.id)] ~= nil
					and GlobalState[string.format("Fleeca:%s:VaultDoor", v.id)].state == 2
					and GlobalState[string.format("Fleeca:%s:VaultDoor", v.id)].expires < os.time()
				then
					Logger:Info("Robbery", string.format("Vault Door At %s Opening", v.label))
					GlobalState[string.format("Fleeca:%s:VaultDoor", v.id)] = {
						state = 3,
					}
					TriggerClientEvent("Robbery:Client:Fleeca:OpenVaultDoor", -1, v.id)
				end
			end

			Wait(30000)
		end
	end)
end
