COMPONENTS.Fetch = {
    _required = { 'Player' },
    _name = 'base',
}

function COMPONENTS.Fetch.Player(self)
    return COMPONENTS.Player.LocalPlayer
end

function COMPONENTS.Fetch.Character(self)
    return COMPONENTS.Player.LocalPlayer:GetData('Character')
end