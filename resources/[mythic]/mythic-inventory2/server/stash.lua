function RegisterStashCallbacks()
	Callbacks:RegisterServerCallback("Stash:Server:Open", function(source, data, cb)
		if GlobalState[string.format("%s:Property", source)] ~= nil then
			local pid = GlobalState[string.format("%s:Property", source)]
			if not _openInvs[string.format("%s-%s", 13, pid)] then
				Inventory.Stash:Open(source, 13, pid)
				cb({ type = 13, owner = string.format("stash:%s", pid) })
			else
				cb(nil)
			end
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Shop:Server:Open", function(source, data, cb)
		local k = string.format("shop:%s", data.identifier)
		if shopLocations[k] ~= nil then
			local entId = shopLocations[k].entityId
			if not _openInvs[string.format("%s-%s", entId, data.identifier)] then
				Inventory:OpenSecondary(source, entId, ("shop:%s"):format(data.identifier))
				cb(entId)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:Server:Open", function(source, data, cb)
		if not _openInvs[string.format("%s-%s", data.invType, data.owner)] then
			if entityPermCheck(source, data.invType) then
				Inventory:OpenSecondary(source, data.invType, data.owner, data.class or false, data.model or false)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end
