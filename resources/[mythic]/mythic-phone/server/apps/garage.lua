AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		TriggerClientEvent("Phone:Client:SetData", source, "garages", Vehicles.Garages:GetAll())
	end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Garage:GetCars", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")
		Vehicles.Owned:GetAll(nil, 0, char:GetData("SID"), cb)
	end)

	Callbacks:RegisterServerCallback("Phone:Garage:TrackVehicle", function(source, data, cb)
		local src = source
		local char = Fetch:Source(src):GetData("Character")

		local active = Vehicles.Owned:GetActive(data)
		if active then
			cb(GetEntityCoords(active:GetData("EntityId")))
		else
			Vehicles.Owned:GetVIN(data, function(c)
                if c.Storage.Type == 0 then
                    cb(Vehicles.Garages:Impound().coords)
				elseif c.Storage.Type == 1 then
                    cb(Vehicles.Garages:Get(c.Storage.Id).coords)
				elseif c.Storage.Type == 2 then
					local prop = Properties:Get(c.Storage.Id)
					if prop?.location?.garage then
						cb(vector3(prop?.location?.garage?.x, prop?.location?.garage?.y, prop?.location?.garage?.z))
					else
						cb(false)
					end
                end
            end)
		end
	end)
end)
