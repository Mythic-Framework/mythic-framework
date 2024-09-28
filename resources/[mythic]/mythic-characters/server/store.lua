local _noUpdate = { 'Source', 'User', '_id', 'ID', 'First', 'Last', 'Phone', 'DOB', 'Gender', 'TempJob', 'Ped', 'MDTHistory', 'Parole', 'Preview', 'Team', 'LSUNDGBan' }

local _saving = {}

function StoreData(source)
	if _saving[source] then
		return
	end
	_saving[source] = true
	local plyr = Fetch:Source(source)
	local char = plyr:GetData('Character')
	local data = char:GetData()
	local cId = data.ID
	for k, v in ipairs(_noUpdate) do
		data[v] = nil
	end

	local ped = GetPlayerPed(source)
	if ped > 0 then
		data.HP = GetEntityHealth(ped)
		data.Armor = GetPedArmour(ped)
	end

	if data.States then
		local s = {}
		for _, v in ipairs(data.States) do
			if string.sub(v, 1, string.len('SCRIPT')) ~= 'SCRIPT' then
				table.insert(s, v)
			end
		end
		data.States = s
	end

	data.LastPlayed = os.time() * 1000

	Logger:Trace('Characters', string.format('Saving Character %s', cId), { console = true })
	Database.Game:updateOne({
		collection = 'characters',
		query = {
			User = plyr:GetData('AccountID'),
			_id = cId,
		},
		update = {
			['$set'] = data,
		},
	}, function()
		_saving[source] = false
	end)
end

local _prevSaved = 0
CreateThread(function()
	while Fetch == nil or Database == nil do
		Wait(1000)
	end

	Wait(120000)

	while true do
		local v = Fetch:Next(_prevSaved)
		Logger:Trace(
			'Characters',
			string.format('BEFORE SAVE, _prevSaved: %s, v ~= nil: %s', _prevSaved, tostring(v ~= nil)),
			{ console = true }
		)
		if v ~= nil then
			local s = v:GetData('Source')
			if v:GetData('Character') ~= nil then
				StoreData(s)
			end
			_prevSaved = s
		else
			_prevSaved = 0
		end

		local c = Fetch:CountCharacters() or 1
		Logger:Trace(
			'Characters',
			string.format('AFTER SAVE, _prevSaved: %s, c: %s', _prevSaved, c),
			{ console = true }
		)

		Wait(600000 / math.max(1, c))
	end
end)