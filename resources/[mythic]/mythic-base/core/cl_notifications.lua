COMPONENTS.Notifications = {
    _name = 'base',
    Hint = {
        ShowThisFrame = function(message)
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandDisplayHelp(0, false, true, -1)
        end
    }
}