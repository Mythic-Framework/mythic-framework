_publicChoplist = {}
_vipChopList = {}

CreateThread(function()
	while not Phone do
		Wait(10)
	end

	
	_publicChoplist = {
		list = Phone.LSUnderground.Chopping:GenerateList(10, 2),
		public = true,
	}
	_vipChopList = {
		list = Phone.LSUnderground.Chopping:GenerateList(10, 4),
		public = true,
	}

	-- while true do
	-- 	if not _publicChoplist.expires or os.time() > _publicChoplist.expires then
	-- 		Logger:Trace("Chopping", "Generating New Public Chop List")
	-- 		_publicChoplist = {
	-- 			list = Phone.LSUnderground.Chopping:GenerateList(10, 2),
	-- 			expires = os.time() + (60 * 10),
	-- 		}

	-- 		for k, v in pairs(_inProgress) do
	-- 			if v.type == 1 then
	-- 				for k2, v2 in pairs(_pChopping) do
	-- 					if v2 == k then
	-- 						TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
	-- 						_pChopping[k2] = nil
	-- 					end
	-- 				end
	-- 				_inProgress[k] = nil
	-- 				_chopped[k] = nil
	-- 			end
	-- 		end
	-- 	end

	-- 	if not _vipChopList.expires or os.time() > _vipChopList.expires then
	-- 		Logger:Trace("Chopping", "Generating New VIP Chop List")
	-- 		_vipChopList = {
	-- 			list = Phone.LSUnderground.Chopping:GenerateList(10, 4),
	-- 			expires = os.time() + (60 * 10),
	-- 		}

	-- 		for k, v in pairs(_inProgress) do
	-- 			if v.type == 2 then
	-- 				for k2, v2 in pairs(_pChopping) do
	-- 					if v2 == k then
	-- 						TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
	-- 						_pChopping[k2] = nil
	-- 					end
	-- 				end
	-- 				_inProgress[k] = nil
	-- 				_chopped[k] = nil
	-- 			end
	-- 		end
	-- 	end

	-- 	Wait(60000)
	-- end
end)
