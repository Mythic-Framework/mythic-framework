local _data = {}

COMPONENTS.Player = {
    _required = { 'LocalPlayer' },
    _name = 'base',
    LocalPlayer = nil,
}

RegisterNetEvent('Player:Client:SetData')
AddEventHandler('Player:Client:SetData', function(data)
    COMPONENTS.Player.LocalPlayer = COMPONENTS.DataStore:CreateStore(1, 'Player', data)
    TriggerEvent('Player:Client:Updated')
end)