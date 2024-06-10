local _inVeh = nil

AddEventHandler("Vehicles:Client:EnterVehicle", function(currentVehicle, currentSeat)
	if currentSeat == -1 and _models[GetEntityModel(currentVehicle)] then
		Taxi.Hud:Show()
	end
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
	_inVeh = nil
	Taxi.Hud:Hide()
end)

RegisterNetEvent("UI:Client:Reset", function(force)
	_inVeh = nil
	Taxi.Hud:Reset()
end)
