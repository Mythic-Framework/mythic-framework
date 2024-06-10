AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Jobs', {
        'Callbacks',
        'Logger',
        'Utils',
        'Notification',
        'Jobs',
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)