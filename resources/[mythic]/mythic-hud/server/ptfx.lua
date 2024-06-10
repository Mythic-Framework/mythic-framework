local runningId = 0
RegisterNetEvent("Particles:Server:DoFx", function(coords, fx)
	runningId += 1
	TriggerClientEvent("Particles:Client:DoFx", -1, coords.x, coords.y, coords.z, fx, runningId, 0.0, 0.0, 0.0)
end)