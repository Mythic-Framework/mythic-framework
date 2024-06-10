RegisterServerEvent('VOIP:Server:Megaphone:SetPlayerState', function(state)
    local src = source
    TriggerClientEvent('VOIP:Client:Megaphone:SetPlayerState', -1, src, state)
end)