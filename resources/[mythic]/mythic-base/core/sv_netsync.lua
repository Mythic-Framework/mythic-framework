RegisterNetEvent("NetSync:Server:Request", function(resource, owner, method, netId, ...)
	if resource == GetInvokingResource() then
		TriggerClientEvent("NetSync:Client:Execute", owner, method, netId, ...)
	end
end)
