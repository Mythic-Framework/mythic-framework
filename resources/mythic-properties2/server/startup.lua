local _ran = false

_properties = {}
_insideProperties = {}

function doPropertyThings(property)
	property.id = property._id
	property.locked = property.locked or true

	if property.location then
		for k, v in pairs(property.location) do
			if v then
				for k2, v2 in pairs(v) do
					property.location[k][k2] = property.location[k][k2] + 0.0
				end
			end
		end
	end

	return property
end

function Startup()
	if _ran then
		return
	end

	Database.Game:find({
		collection = "properties",
	}, function(success, results)
		if not success then
			return
		end
		Logger:Trace("Properties", "Loaded ^2" .. #results .. "^7 Properties", { console = true })

		for k, v in ipairs(results) do
			local p = doPropertyThings(v)

			_properties[v._id] = p
		end
	end)

	_ran = true
end
