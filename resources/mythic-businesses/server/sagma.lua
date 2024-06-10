local _jobName = "sagma"

AddEventHandler("Businesses:Server:Startup", function()
    Callbacks:RegisterServerCallback("Businesses:SAGMA:OpenTable", function(source, data, cb)
        Inventory:OpenSecondary(source, 132, data)
    end)
    
    Callbacks:RegisterServerCallback("Businesses:SAGMA:Sell", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, _jobName, false, false, false, false, "JOB_SELL_GEMS") then
            local its = Inventory.Items:GetAllOfTypeNoStack(char:GetData("SID"), 1, 11)

            if #its > 0 then
                local totalSold = 0
                local totalPayout = 0
                for k, v in ipairs(its) do
                    local md = json.decode(v.MetaData)
                    local itemData = Inventory.Items:GetData(v.Name)
                    local gemWorth = (itemData.price * ((md.Quality or 1) / 100))

                    if Inventory.Items:RemoveId(char:GetData("SID"), 1, v) then
                        totalPayout += gemWorth
                        totalSold += 1
                    end
                end

                local f = Banking.Accounts:GetOrganization(_jobName)
                if f ~= nil then
                    Banking.Balance:Deposit(f.Account, math.ceil(math.abs(totalPayout) * 0.8), {
                        type = "deposit",
                        title = "Sold Goods",
                        description = string.format("Sold %s Gems", totalSold),
                        data = {},
                    })
                    Execute:Client(
                        source,
                        "Notification",
                        "Success",
                        string.format("Sold %s Gems For $%s (Deposited To Company Account)", totalSold, math.ceil(math.abs(totalPayout) * 0.8))
                    )
                else
                    Wallet:Modify(source, totalPayout)
                end

                
                f = Banking.Accounts:GetOrganization("government")
                Banking.Balance:Deposit(f.Account, math.ceil(math.abs(totalPayout) * 0.1), {
                    type = "deposit",
                    title = "Sold Goods Tax",
                    description = string.format("10%% Tax On %s Sold Gems", totalSold),
                    data = data,
                }, true)

                -- KEKW
                f = Banking.Accounts:GetOrganization("dgang")
                Banking.Balance:Deposit(f.Account, math.ceil(math.abs(totalPayout) * 0.1), {
                    type = "deposit",
                    title = "Sold Goods Tax",
                    description = string.format("10%% Tax On %s Sold Gems", totalSold),
                    data = data,
                }, true)
            else
                Execute:Client(
                    source,
                    "Notification",
                    "Error",
                    "You Don't Have Any Gems To Sell"
                )
			end
		end
    end)
end)

AddEventHandler("Businesses:Server:SAGMA:ViewGem", function(source, data)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		local char = plyr:GetData("Character")
		if char ~= nil then
            if Jobs.Permissions:HasJob(source, _jobName, false, false, false, true, "JOB_USE_GEM_TABLE") then
                local its = Inventory:GetInventory(source, data.owner, data.invType)
                if #its > 0 then
                    local md = json.decode(its[1].MetaData)
                    local itemData = Inventory.Items:GetData(its[1].Name)
                    if itemData ~= nil and itemData.type == 11 and itemData.gemProperties ~= nil then
                        TriggerClientEvent("Businesses:Client:SAGMA:ViewGem", source, data.owner, itemData.gemProperties, md.Quality, its[1])
                    end
                end
            end
		end
	end
end)