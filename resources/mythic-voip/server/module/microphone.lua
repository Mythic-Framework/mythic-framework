RegisterServerEvent('VOIP:Server:Microphone:SetPlayerState', function(state)
    local src = source
    TriggerClientEvent('VOIP:Client:Microphone:SetPlayerState', -1, src, state)
end)