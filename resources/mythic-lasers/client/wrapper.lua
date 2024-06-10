local _fookinLasers = {}

function InitWrapperLasers()
	for k, v in pairs(_fookinLasers) do
		v.laser = Laser.new(v.originPoint, v.targetPoints, v.options)
		v.laser.onPlayerHit(v.onHit)

		if v.startEnabled then
			v.laser.setActive(true)
		else
			v.laser.setActive(false)
		end
	end
end

function DeleteLasers()
	for k, v in pairs(_fookinLasers) do
		if v.laser ~= nil then
			v.laser.setActive(false)
			_fookinLasers[k] = nil
		end
	end
end

AddEventHandler("Lasers:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Lasers = exports["mythic-base"]:FetchComponent("Lasers")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Lasers", {
		"Logger",
		"Callbacks",
		"Game",
		"Utils",
		"Lasers",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Callbacks:RegisterClientCallback("Lasers:Create:Start", function()
			creationEnabled = true
			inOriginMode = true
			startCreation()
		end)

		Callbacks:RegisterClientCallback("Lasers:Create:End", function()
			creationEnabled = false
		end)

		Callbacks:RegisterClientCallback("Lasers:Create:Save", function()
			if not originPoints or not targetPoints then
				return
			end
			local name = GetUserInput("Enter name of laser:", "", 30)
			if name == nil then
				return
			end
			local laser = {
				name = name,
				originPoints = originPoints,
				targetPoints = targetPoints,
				travelTimeBetweenTargets = { 1.0, 1.0 },
				waitTimeAtTargets = { 0.0, 0.0 },
				randomTargetSelection = true,
			}
			TriggerServerEvent("Lasers:Server:Save", laser)
			creationEnabled = false
		end)
	end)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	InitWrapperLasers()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	DeleteLasers()
end)

_LASERS = {
	Create = function(self, id, originPoint, targetPoints, options, startEnabled, onHit)
		_fookinLasers[id] = {
			originPoint = originPoint,
			targetPoints = targetPoints,
			options = options,
			startEnabled = startEnabled,
			onHit = onHit,
		}
	end,
	GetLaser = function(self, id)
		return _fookinLasers[id].laser or nil
	end,
	GetActive = function(self, id)
		if _fookinLasers[id] ~= nil then
			return _fookinLasers[id].laser.getActive()
		else
			return false
		end
	end,
	GetVisible = function(self, id)
		if _fookinLasers[id] ~= nil then
			return _fookinLasers[id].laser.getVisible()
		else
			return false
		end
	end,
	GetMoving = function(self, id)
		if _fookinLasers[id] ~= nil then
			return _fookinLasers[id].laser.getMoving()
		else
			return false
		end
	end,
	GetColor = function(self, id)
		if _fookinLasers[id] ~= nil then
			return _fookinLasers[id].laser.getColor()
		else
			return false
		end
	end,
	Utils = {
		SetActive = function(self, id, state)
			if _fookinLasers[id] ~= nil and _fookinLasers[id].laser ~= nil then
				_fookinLasers[id].laser.setActive(state)
			end
		end,
		SetVisible = function(self, id, state)
			if _fookinLasers[id] ~= nil and _fookinLasers[id].laser ~= nil then
				_fookinLasers[id].laser.setVisible(state)
			end
		end,
		SetMoving = function(self, id, state)
			if _fookinLasers[id] ~= nil and _fookinLasers[id].laser ~= nil then
				_fookinLasers[id].laser.setMoving(state)
			end
		end,
		SetColor = function(self, id, r, g, b, a)
			if _fookinLasers[id] ~= nil and _fookinLasers[id].laser ~= nil then
				_fookinLasers[id].laser.setColor(r, g, b, a)
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Lasers", _LASERS)
end)
