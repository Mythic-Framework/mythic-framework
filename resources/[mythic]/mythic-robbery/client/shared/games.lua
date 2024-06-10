function RegisterGamesCallbacks()
	Callbacks:RegisterClientCallback("Robbery:Games:Progress", DoProgress)
	Callbacks:RegisterClientCallback("Robbery:Games:Lockpick", Lockpick)
	Callbacks:RegisterClientCallback("Robbery:Games:Thermite", Thermite)
	Callbacks:RegisterClientCallback("Robbery:Games:Laptop", Laptop)
	Callbacks:RegisterClientCallback("Robbery:Games:Captcha", Captcha)
	Callbacks:RegisterClientCallback("Robbery:Games:Tracking", Tracking)
	Callbacks:RegisterClientCallback("Robbery:Games:Aim", Aim)
	Callbacks:RegisterClientCallback("Robbery:Games:AimHack", AimHack)
	Callbacks:RegisterClientCallback("Robbery:Games:Hack", Hack)
	Callbacks:RegisterClientCallback("Robbery:Games:Drill", Drill)
	Callbacks:RegisterClientCallback("Robbery:Games:SafeCrack", SafeCrack)
end

function DoProgress(data, cb)
	Progress:Progress({
		name = "robbery_action",
		duration = math.random(45, 60) * 1000,
		label = data.config.label or "Doing A Thing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = data.config.anim,
	}, function(cancelled)
		cb(not cancelled, data.data)
	end)
end

function Lockpick(data, cb)
	DoLockpick(data.data, data.config, function(isSuccess, d)
		cb(isSuccess, d)
	end)
end

function Thermite(data, cb)
	_memPass = 1
	ThermiteShit({
		x = data.location.coords.x,
		y = data.location.coords.y,
		z = data.location.coords.z,
		h = data.location.heading,
	}, data, cb)
end

function Laptop(data, cb)
	LaptopShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess, data)
			cb(isSuccess, data)
		end
	)
end

function Captcha(data, cb)
	CaptchaShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess, data)
			cb(isSuccess, data)
		end
	)
end

function Tracking(data, cb)
	TrackingGameShit(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function Aim(data, cb)
	BombShit(
		{
			x = data.location.coords.x,
			y = data.location.coords.y,
			z = data.location.coords.z,
			h = data.location.heading,
		},
		data,
		function(isSuccess)
			if isSuccess then
				Callbacks:ServerCallback("Robbery:DoBombFx", {
					x = data.location.coords.x,
					y = data.location.coords.y,
					z = data.location.coords.z,
					h = data.location.heading,
				}, function() end)
			end

			cb(isSuccess)
		end
	)
end

function AimHack(data, cb)
	AimHackShit(data, function(isSuccess)
		cb(isSuccess, data)
	end)
end

function Hack(data, cb)
	HackShit(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function Drill(data, cb)
	DoDrill(data, function(isSuccess, data)
		cb(isSuccess, data)
	end)
end

function SafeCrack(data, cb)
	_memPass = 1
	DoMemory(data.passes, data.config, data.data, function(isSuccess, extra)
		cb(isSuccess, extra)
	end)
end
