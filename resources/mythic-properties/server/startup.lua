local _ran = false

function doPropertyThings(property)
	property.id = property._id
	property.interior = property.interior
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

_props = {}
_tierProps = {}


function SetupHouseData()
	local interiorZones = {}

	for k, v in pairs(PropertyConfig) do
		if v then
			GlobalState[string.format("Properties:Interior:%s", k)] = v
	
			if v.zone then
				table.insert(interiorZones, v.zone)
			end
		end
	end

	GlobalState["Properties:InteriorZones"] = interiorZones
end

function Startup()
	if _ran then
		return
	end

	SetupHouseData()
	
	Database.Game:find({
		collection = "properties",
	}, function(success, results)
		if not success then
			return
		end
		Logger:Trace("Properties", "Loaded ^2" .. #results .. "^7 Properties", { console = true })

		for k, v in ipairs(results) do
			local p = doPropertyThings(v)
			table.insert(_props, p.id)

			if _tierProps[p.interior] == nil then
				_tierProps[p.interior] = {}
			end
			table.insert(_tierProps[p.interior], p.id)

			GlobalState[string.format("Property:%s", v.id)] = p
		end

		GlobalState["Properties"] = _props
	end)

	_ran = true
end
