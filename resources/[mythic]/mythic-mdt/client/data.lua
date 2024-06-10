RegisterNetEvent("MDT:Client:SetData")
AddEventHandler("MDT:Client:SetData", function(type, data, options)
	MDT.Data:Set(type, data)
end)

RegisterNetEvent("MDT:Client:AddData")
AddEventHandler("MDT:Client:AddData", function(type, data, id)
	MDT.Data:Add(type, data, id)
end)

RegisterNetEvent("MDT:Client:UpdateData")
AddEventHandler("MDT:Client:UpdateData", function(type, id, data)
	MDT.Data:Update(type, id, data)
end)

RegisterNetEvent("MDT:Client:RemoveData")
AddEventHandler("MDT:Client:RemoveData", function(type, id)
	MDT.Data:Remove(type, id)
end)

RegisterNetEvent("MDT:Client:ResetData")
AddEventHandler("MDT:Client:ResetData", function()
	Phone.Data:Reset()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	MDT.Data:Reset()
end)
