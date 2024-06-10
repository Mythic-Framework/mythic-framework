RegisterNetEvent("Laptop:Client:Spawn", function(data)

end)

LAPTOP.LSUnderground = {

}

RegisterNUICallback("GetLSUDetails", function(data, cb)
	Callbacks:ServerCallback("Phone:LSUnderground:GetDetails", {}, function(data)
        cb(data)
    end)
end)