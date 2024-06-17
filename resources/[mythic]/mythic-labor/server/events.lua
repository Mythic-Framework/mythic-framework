local _houseLocs = {
	{
		coords = vector3(850.425, -2504.266, 39.686),
		heading = 88.629,
	},
}

local rando = _houseLocs[math.random(#_houseLocs)]
local _locations = {
	houseRobbery = rando,
	oxy = _oxyStarts[tostring(os.date("%w"))],
	corner = {
		coords = vector3(-25.504, -1291.002, 28.510),
		heading = 129.002,
	},
}

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		Wait(20)
		TriggerClientEvent("Labor:Client:GetLocs", -1, _locations)
	end
end)

AddEventHandler("Queue:Server:SessionActive", function(source, data)
	TriggerClientEvent("Labor:Client:GetLocs", source, _locations)
end)
