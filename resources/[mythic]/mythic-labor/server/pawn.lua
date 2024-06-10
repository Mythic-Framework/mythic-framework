local _ran = false

local _pawnPricing = {
    [0] = 20,
    [1] = 30,
    [2] = 40,
    [3] = 50,
    [4] = 60,
    [5] = 70,
}

local _pawnItems = {
    ['jewelry'] = {
        {
            item = 'rolex',
            rep = 15,
        },
        {
            item = 'ring',
            rep = 10,
        },
        {
            item = 'chain',
            rep = 10,
        },
        {
            item = 'watch',
            rep = 10,
        },
        {
            item = 'earrings',
            rep = 10,
        },
        {
            item = 'goldcoins',
            rep = 5,
        },
    },
    ['valuegoods'] = {
        {
            item = 'valuegoods',
            rep = 30,
        }
    },
    ['electronics'] = {
        {
            item = 'tv',
            rep = 30,
        },
        {
            item = 'big_tv',
            rep = 80,
        },
        {
            item = 'boombox',
            rep = 20,
        },
        {
            item = 'pc',
            rep = 50,
        },
    },
    ['appliance'] = {
        {
            item = 'microwave',
            rep = 25,
        },
    },
    ['golf'] = {
        {
            item = 'golfclubs',
            rep = 40,
        },
    },
    ['art'] = {
        {
            item = 'house_art',
            rep = 50,
        },
    },
    ['raremetals'] = {
        {
            item = 'goldbar',
            rep = 25,
        },
        {
            item = 'silverbar',
            rep = 15,
        },
    }
}

AddEventHandler("Labor:Server:Startup", function()
	if _ran then
		return
	end
	_ran = true
	
    Reputation:Create("Pawn", "Pawn Shop", {
        { label = "Rank 1", value = 5000 },
        { label = "Rank 2", value = 10000 },
        { label = "Rank 3", value = 20000 },
        { label = "Rank 4", value = 30000 },
        { label = "Rank 5", value = 40000 },
    })

    Callbacks:RegisterServerCallback("Pawn:Sell", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
        if char then
            local pawning = _pawnItems[data]
            if pawning then
                local repLvl = Reputation:GetLevel(source, "Pawn")

                local money = 0
                local earntRep = 0

                for k, v in ipairs(pawning) do
                    local count = Inventory.Items:GetCount(char:GetData("SID"), 1, v.item) or 0
                    if count > 0 then
                        local itemData = Inventory.Items:GetData(v.item)

                        if itemData and Inventory.Items:Remove(char:GetData("SID"), 1, v.item, count) then
                            money += math.floor(((_pawnPricing[repLvl] / 100) * itemData.price) * count)
                            earntRep += v.rep * count
                        end
                    end
                end

                if money > 0 then
                    Wallet:Modify(source, money)
                    Reputation.Modify:Add(source, "Pawn", earntRep)
                else
                    Execute:Client(source, "Notification", "Error", "You Have Nothing To Sell")
                end
            end
        end
	end)
end)
