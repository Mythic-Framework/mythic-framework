function MazeBankThreads()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			local myCoords = GetEntityCoords(LocalPlayer.state.ped)
			for k, v in ipairs(_mbHacks) do
				if
					#(myCoords - v.coords) <= 200
					and GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)] ~= nil
					and GlobalState[string.format("MazeBank:ManualDoor:%s", v.doorId)].state == 3
				then
					OpenDoor(v.coords, v.doorConfig)
				end
			end
			Wait(1000)
		end
	end)
end
