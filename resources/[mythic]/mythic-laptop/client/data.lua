RegisterNetEvent("Laptop:Client:SetData", function(type, data, options)
	while Laptop == nil do
		Wait(10)
	end
	Laptop.Data:Set(type, data)
end)

RegisterNetEvent("Laptop:Client:AddData", function(type, data, id)
	Laptop.Data:Add(type, data, id)
end)

RegisterNetEvent("Laptop:Client:UpdateData", function(type, id, data)
	Laptop.Data:Update(type, id, data)
end)

RegisterNetEvent("Laptop:Client:RemoveData", function(type, id)
	Laptop.Data:Remove(type, id)
end)

RegisterNetEvent("Laptop:Client:ResetData", function()
	Laptop.Data:Reset()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	SendNUIMessage({ type = "LAPTOP_NOT_VISIBLE" })
	Laptop.Data:Reset()
	Laptop.Notification:Reset()
	Laptop:ResetRoute()
	SendNUIMessage({ type = "CLOSE_ALL_APPS" })
end)
