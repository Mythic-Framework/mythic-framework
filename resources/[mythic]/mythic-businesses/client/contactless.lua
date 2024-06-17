local currentlyShowing = nil

AddEventHandler("Businesses:Client:PayContactlessPayment", function(_, data)
    if data and data.id then
        Callbacks:ServerCallback("Contactless:Pay", {
            terminalId = data.id,
        }, function(success)
            if success then
                Sounds.Play:Distance(4.0, 'payment_success.ogg', 0.2)
            end
        end)
    end
end)

AddEventHandler("Businesses:Client:CreateContactlessPayment", function(_, data)
    if data and data.job and data.id then
        local input = GetContactlessInput(data)

        if input?.amount and input?.description then
            local amount = tonumber(input.amount)
            if amount and amount > 0 and amount <= 10000 then
                Callbacks:ServerCallback("Contactless:Create", {
                    job = data.job,
                    terminalId = data.id,
                    payment = amount,
                    description = input.description
                }, function(success, res)
                    if success then
                        Notification:Success("Contactless Terminal Set, Now Get Them to Pay!")
                    else
                        Notification:Error(res or "Error")
                    end
                end)
            else
                Notification:Error("Maximum Contactless Amount is $10,000")
            end
        end
    end
end)

AddEventHandler("Businesses:Client:ClearContactlessPayment", function(_, data)
    if data and data.job and data.id then
        Callbacks:ServerCallback("Contactless:Clear", {
            job = data.job,
            terminalId = data.id,
        }, function(success, res)
            if success then
                Notification:Success("Contactless Terminal Cleared")
            else
                Notification:Error(res or "Error")
            end
        end)
    end
end)

local promptPromise
function GetContactlessInput(data)
    promptPromise = promise.new()
    currentlyShowing = GetGameTimer()
    local showingAtTime = GetGameTimer()
    Input:Show(string.format("Create Contactless Payment - %s Terminal #%s", data.jobName, data.num), "Amount", {
        {
			id = "amount",
			type = "number",
			options = {
				inputProps = {
                    defaultValue = "100",
                    min = 0,
                    max = 10000,
                },
                label = "Amount",
			},
		},
		{
			id = "description",
			type = "text",
			options = {
				inputProps = {
                    maxlength = 100,
                },
                label = "Description",
			},
		},
	}, "Contactless:Client:RecieveInput", {})

    SetTimeout(30000, function()
        if promptPromise and currentlyShowing == showingAtTime then
            Input:Close()
            promptPromise:resolve(false)
            promptPromise = nil
        end
    end)

    return Citizen.Await(promptPromise)
end

AddEventHandler("Contactless:Client:RecieveInput", function(values)
    if promptPromise then
        promptPromise:resolve(values)
        promptPromise = nil
    end
end)