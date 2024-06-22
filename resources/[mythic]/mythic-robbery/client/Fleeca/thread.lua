function FleecaThreads()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if GlobalState["FleecaRobberies"] ~= nil then
				local myCoords = GetEntityCoords(LocalPlayer.state.ped)
				for k, v in ipairs(GlobalState["FleecaRobberies"]) do
					local bankData = GlobalState[string.format("FleecaRobberies:%s", v)]
					if
						#(myCoords - bankData.coords) <= 200
						and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)] ~= nil
						and GlobalState[string.format("Fleeca:%s:VaultDoor", bankData.id)].state == 3
					then
						OpenDoor(bankData.points.vaultPC.coords, bankData.doors.vaultDoor)
					end
				end
				Wait(1000)
			else
				Wait(3000)
			end
		end
	end)
end
