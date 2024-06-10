function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Apartment:Validate", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		local isMyApartment = data.id == GlobalState[string.format("%s:Apartment", source)]

		if data.id then
			if data.type == "wardrobe" and isMyApartment then
				cb(char:GetData("SID") == GlobalState[string.format("%s:Apartment", source)])
			elseif data.type == "logout" and isMyApartment then
				cb(char:GetData("SID") == GlobalState[string.format("%s:Apartment", source)])
			elseif data.type == "stash" and isMyApartment or Police:IsInBreach(source, "apartment", data.id, true) then
				local invType = _aptData[char:GetData("Apartment") or 1].invEntity or 13
				local isRaid = false
				local invOwner = char:GetData("SID")

				if Police:IsInBreach(source, "apartment", data.id, true) then
					invOwner = pState.inApartment.id
					isRaid = true
				elseif pState.inApartment ~= nil and pState.inApartment.id ~= char:GetData("SID") then
					return cb(false)
				end

				Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
					invType = invType,
					owner = invOwner,
				}, function()
					Inventory:OpenSecondary(source, invType, invOwner, false, false, isRaid)
				end)

				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Apartment:SpawnInside", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(Apartment:Enter(source, char:GetData("Apartment"), -1, true))
	end)

	Callbacks:RegisterServerCallback("Apartment:Enter", function(source, data, cb)
		cb(Apartment:Enter(source, data.tier, data.id))
	end)

	Callbacks:RegisterServerCallback("Apartment:Exit", function(source, data, cb)
		cb(Apartment:Exit(source))
	end)

	Callbacks:RegisterServerCallback("Apartment:GetVisitRequests", function(source, data, cb)
		cb(Apartment.Reqeusts:Get(source))
	end)

	Callbacks:RegisterServerCallback("Apartment:Visit", function(source, data, cb)
		cb(Apartment:Enter(source, data.tier, data.id))
	end)
end
