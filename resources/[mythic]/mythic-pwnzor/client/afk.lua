-- CreateThread(function()
-- 	local time = 0
-- 	local prevPos = nil
-- 	local currentPos = nil

-- 	Wait(30000)

-- 	while GlobalState['AFKTimer'] == nil do
-- 		Wait(1000)
-- 	end

-- 	local AFKTimer = GlobalState['AFKTimer']

-- 	while true do
-- 		Wait(1000)
-- 		--TriggerServerEvent('mythic_pwnzor:server:PingCheck', securityToken, isLoggedIn)
-- 		local playerPed = PlayerPedId()
-- 		if playerPed then
-- 			currentPos = GetEntityCoords(playerPed)
-- 			if prevPos ~= nil then
-- 				if #(vector3(currentPos.x, currentPos.y, currentPos.z) - vector3(prevPos.x, prevPos.y, prevPos.z)) < 1.5 then
-- 					if time > (AFKTimer * 2) then
-- 						Callbacks:ServerCallback('Pwnzor:AFK')
-- 					elseif time > AFKTimer then
-- 						Notification.Persistent:Error('pwnzor-afk', 'You Will Be Kicked In ' .. ((AFKTimer * 2) - time) .. ' Seconds For Being AFK')
-- 					end

-- 					time = time + 1
-- 				else
-- 					Notification.Persistent:Remove('pwnzor-afk')
-- 					time = 0
-- 				end
-- 			end

-- 			prevPos = currentPos
-- 		end
-- 	end
-- end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	if LocalPlayer.state.isDev then return end

    CreateThread(function()
		local time = 0
		local prevPos = nil
		local currentPos = nil

		Wait(30000)

		while GlobalState['AFKTimer'] == nil do
			Wait(1000)
		end

		local AFKTimer = GlobalState['AFKTimer']

		while LocalPlayer.state.inCreator do
			Wait(30000)
		end

		while LocalPlayer.state.loggedIn do
			Wait(1000)
			--TriggerServerEvent('mythic_pwnzor:server:PingCheck', securityToken, isLoggedIn)
			local playerPed = PlayerPedId()
			if playerPed then
				currentPos = GetEntityCoords(playerPed)
				if prevPos ~= nil then
					if #(vector3(currentPos.x, currentPos.y, currentPos.z) - vector3(prevPos.x, prevPos.y, prevPos.z)) < 1.5 then
						if time > (AFKTimer * 2) then
							Callbacks:ServerCallback('Pwnzor:AFK')
						elseif time > AFKTimer then
							Notification.Persistent:Error('pwnzor-afk', 'You Will Be Kicked In ' .. ((AFKTimer * 2) - time) .. ' Seconds For Being AFK')
						end

						time = time + 1
					else
						Notification.Persistent:Remove('pwnzor-afk')
						time = 0
					end
				end

				prevPos = currentPos
			end
		end
	end)
end)