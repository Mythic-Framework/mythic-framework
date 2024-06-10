AddEventHandler('Finance:Server:Startup', function()
    Chat:RegisterCommand('fine', function(src, args, raw)
        local player = Fetch:SID(tonumber(args[1]))
        if player ~= nil then
            local targetSource, fineAmount = table.unpack(args)
            local success = Billing:Fine(src, player:GetData("Source"), tonumber(fineAmount))
            if success then
                Chat.Send.System:Single(src, string.format("You Successfully Fined State ID %s For $%s. You earned $%s.", args[1], success.amount, success.cut))
            else
                Chat.Send.System:Single(src, "Fine Failed")
            end
        else
            Chat.Send.System:Single(src, "Invalid Target")
        end
    end, {
        help = '[Government] Fine Someone',
        params = {
            { name = 'State ID', help = 'The State ID of the person you want to fine.' },
            { name = 'Amount', help = 'The amount of money you are fining them.' },
        },
    }, 2, {
        { Id = 'police' },
    })

    Chat:RegisterAdminCommand('testbilling', function(source, args, rawCommand)
        Execute:Client(source, 'Notification', 'Info', 'Bill Created')
        Billing:Create(source, 'Some Random Fucking Business', 1500, 'This is a shitty description of a test bill.', function(wasPayed)
            if wasPayed then
                Execute:Client(source, 'Notification', 'Success', 'Bill Accepted')
            else
                Execute:Client(source, 'Notification', 'Error', 'Bill Declined')
            end
        end)
    end, {
        help = 'Test Billing'
    }, 0)
end)