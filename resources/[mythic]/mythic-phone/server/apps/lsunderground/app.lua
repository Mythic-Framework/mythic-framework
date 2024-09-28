local _lsuReps = { Racing = true, Chopping = true }
local _boostingReps = { Boosting = true }

PHONE.LSUnderground = PHONE.LSUnderground or {}

local marketItems = {
	{ item = "racing_crappy", coin = "VRM", price = 3, vpn = false },
	{ item = "racedongle", coin = "VRM", rep = "Racing", repLvl = 3, price = 15, vpn = false },
	{ item = "harness", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = false },
	{ item = "choplist", coin = "VRM", rep = "Chopping", repLvl = 3, price = 25, vpn = true },
	{ item = "fakeplates", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = true },
	{ item = "nitrous", coin = "VRM", price = 10, vpn = true },
}

local _blacklistedJobs = {
	police = true,
	ems = true,
	government = true,
}

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:LSUnderground:GetDetails", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local chops = {
					Public = _publicChoplist,
					Private = _vipChopList,
				}

				for k, v in pairs(char:GetData("ChopLists") or {}) do
					chops[string.format("Chop List #%s", k)] = {
						id = k,
						list = v,
					}
				end

				local items = {}
				local hasVpn = hasValue(char:GetData("States"), "PHONE_VPN")
				for k, v in ipairs(marketItems) do
					if
						(v.rep == nil or Reputation:GetLevel(source, v.rep) and Reputation:GetLevel(source, v.rep) >= (v.repLvl or 1))
						and (not v.vpn or hasVpn)
						and (
							not v.requireCurrency
							or v.requireCurrency
								and ((v.coin ~= nil and Crypto:Has(source, v.coin, v.price)) or (v.coin == nil and Wallet:Has(
									source,
									v.price
								)))
						)
					then
						v.itemData = Inventory.Items:GetData(v.item)
						table.insert(items, v)
					end
				end

				cb({
					chopList = chops,
					reputations = Reputation:ViewList(source, _lsuReps),
					items = items,
				})
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Inventory.Items:RegisterUse("lsundg_invite", "LSUNDG", function(source, item, itemData)
		local plyr = Fetch:Source(source)
		local pState = Player(source).state
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if not pState.onDuty or not _blacklistedJobs[pState.onDuty] then
					if not hasValue(char:GetData("States") or {}, "ACCESS_LSUNDERGROUND") then
						if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
							local states = char:GetData("States") or {}
							table.insert(states, "ACCESS_LSUNDERGROUND")
							char:SetData("States", states)

							char:SetData("Apps", Phone.Store.Install:Do("lsunderground", char:GetData("Apps"), "force"))

							Phone.Email:Send(
								source,
								"shadow@ls.undg",
								os.time() * 1000,
								"Welcome To LS Underground",
								string.format(
									[[
									Hello %s<br /><br />
									Welcome to the future of the Los Santos racing scene. Someone you know closely has entrusted you enough to vouch for you and provide you an exclusive invite to be part of our mission.<br /><br/>
									Our goal is to build a scene that is comprised of individuals who respect each other and are there to race, and nothing more. We're here to be the enforcers for those who choose to disobey this very basic goal, and reward those who participate cleanly and in good faith.<br /><br />
									A key part of this will also be to deal with Los Santos' "greatest", and ensure they know there are lines that should not be crossed or else dire consequences will come.<br /><br />
									This should be rather apparent, but it will be said regardless, being part of this group must be kept a complete secret from everyone you know. At all times you should operate as if you're being listened in on.
									Our mission relies on remaining in the shadows until the time is right. This mission is bigger than you, if you jeopardize us, you will be eliminated. We are always watching.<br /><br />
									You will be contacted soon, in the meantime check the new app on your phone.<br />
									- Shadow
								]],
									char:GetData("First")
								)
							)

							SetTimeout(5000, function()
								Phone.Notification:Add(
									source,
									"App Installed",
									nil,
									os.time() * 1000,
									6000,
									"lsunderground",
									{
										view = "",
									},
									nil
								)
							end)
						end
					else
						Execute:Client(source, "Notification", "Error", "Already A Member Of LS Underground")
					end
				else
					Execute:Client(source, "Notification", "Error", "You Can't Use This Item")
				end
			end
		end
	end)
end)

PHONE.LSU = {}
