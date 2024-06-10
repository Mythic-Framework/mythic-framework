local _wetWeather = {
	["RAIN"] = true,
	["THUNDER"] = true,
	["SNOW"] = true,
	["BLIZZARD"] = true,
	["SNOWLIGHT"] = true,
	["XMAS"] = true,
}

function IsWeatherTypeRain(weather)
    return _wetWeather[weather]
end