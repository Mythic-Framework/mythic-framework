AddEventHandler('Finance:Server:Startup', function()
    Callbacks:RegisterServerCallback('Billing:DismissBill', function(source, data, cb)
        if data and data.bill then
            local success = Billing:Dismiss(source, data.bill)
            cb(success)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Billing:AcceptBill', function(source, data, cb)
        if data and data.bill then
            local success = Billing:Accept(source, data.bill, data.account)
            cb(success)
            if data.notify then
                if success then
                    Phone.Notification:Add(source, "Bill Payment Successful", false, os.time() * 1000, 3000, "bank", {})
                else
                    Phone.Notification:Add(source, "Bill Payment Failed", false, os.time() * 1000, 3000, "bank", {})
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Billing:CreateBill', function(source, data, cb)
        if data and data.fromAccount and data.target and data.description and data.amount then
            local creationSuccess = Billing:PlayerCreateOrganizationBill(source, data.target, data.fromAccount, data.amount, data.description)
            cb(creationSuccess)
        end
    end)
end)