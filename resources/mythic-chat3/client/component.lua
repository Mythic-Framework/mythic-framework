function Print3DText(coords, text, isDice)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        if isDice then
            SetTextScale(0.4, 0.4)
            SetTextFont(1)
        end
        SetTextProportional(1)
        SetTextColour(250, 250, 250, 255)		-- You can change the text color here
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    TriggerEvent('chat:clearChat')
end)

local mes = {}
RegisterNetEvent('Chat:Client:ReceiveMe')
AddEventHandler('Chat:Client:ReceiveMe', function(sender, uid, message, isDice)
    if not LocalPlayer.state.loggedIn then return; end

    if mes[sender] then
        mes[sender] = nil
    end

    local senderClient = GetPlayerFromServerId(sender)

    local isMe = false
    if sender == LocalPlayer.state.ID then
        isMe = true
    end

    exports['mythic-base']:FetchComponent('Logger'):Trace('Me', string.format('Sender Source: %s; Sender Player: %s; My Source: %s; My Ped: %s', sender, senderClient, LocalPlayer.state.ID, LocalPlayer.state.ped))

    if senderClient < 0 and not isMe then
        return
    end

    if not senderClient then
        return
    end

    local myPed = LocalPlayer.state.ped
    local senderPed = GetPlayerPed(senderClient)

    if DoesEntityExist(senderPed) then
        local dist = #(GetEntityCoords(senderPed) - GetEntityCoords(myPed))

        if dist <= 15.0 and HasEntityClearLosToEntity(myPed, senderPed, 17) then
            local timer = 350
            mes[sender] = uid
            Citizen.CreateThread(function()
                while dist <= 25.0 and mes[sender] == uid and timer > 0 do
                    senderPos = GetPedBoneCoords(senderPed, 0)
                    Print3DText(senderPos, message, isDice)
                    dist = #(senderPos - GetEntityCoords(myPed))
                    timer = timer - 1
                    Citizen.Wait(5)
                end
            end)
        end
    end
end)