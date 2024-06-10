AddEventHandler("Finance:Server:Startup", function()
	Middleware:Add("Characters:Creating", function(source, cData)
		return { {
			Crypto = {},
		} }
	end)

	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char and not char:GetData("CryptoWallet") then
			local stateId = char:GetData("SID")
			local generatedWallet = GenerateUniqueCrytoWallet()
			if generatedWallet then
				Logger:Trace(
					"Banking",
					string.format("Crypto Wallet (%s) Created for Character: %s", generatedWallet, stateId)
				)
				char:SetData("CryptoWallet", generatedWallet)
			end
		end
	end, 3)

	Callbacks:RegisterServerCallback("Crypto:GetAll", function(source, data, cb)
		cb(_cryptoCoins)
	end)

	Inventory.Items:RegisterUse("crypto_voucher", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		if item.MetaData.CryptoCoin and ((item.MetaData.Quantity and tonumber(item.MetaData.Quantity) or 0) > 0) then
			local data = Crypto.Coin:Get(item.MetaData.CryptoCoin)
			Crypto.Exchange:Add(item.MetaData.CryptoCoin, char:GetData("CryptoWallet"), item.MetaData.Quantity)
			Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
		else
			Execute:Client(source, "Notification", "Error", "Invalid Voucher")
		end
	end)

	TriggerEvent("Crypto:Server:Startup")
end)

local _todaysGenerated = {}
local _charSet = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
}

function RandomCharOrNumber(amount)
	if amount == nil then
		amount = 1
	end
	local value = ""
	for i = 1, amount do
		if math.random(0, 6) <= 4 then -- More chance of letter
			value = value .. _charSet[math.random(1, #_charSet)]
		else
			value = value .. tostring(math.random(1, 9))
		end
	end
	return value
end

function GenerateCryptoWallet()
	return RandomCharOrNumber(5)
end

function GenerateUniqueCrytoWallet()
	local generated = GenerateCryptoWallet()
	while DoesCryptoWalletExist(generated) do
		generated = GenerateCryptoWallet()
	end

	_todaysGenerated[generated] = true

	return generated
end

function DoesCryptoWalletExist(wallet)
	if _todaysGenerated[wallet] then
		return false
	end

	local p = promise.new()
	Database.Game:find({
		collection = "characters",
		query = {
			CryptoWallet = wallet,
		},
	}, function(success, results)
		if success and #results > 0 then
			p:resolve(true)
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end
