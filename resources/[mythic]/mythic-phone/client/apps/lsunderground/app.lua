RegisterNetEvent("Phone:Client:Spawn", function(data)

end)

PHONE.LSUnderground = {

}

RegisterNUICallback("GetLSUDetails", function(data, cb)
	Callbacks:ServerCallback("Phone:LSUnderground:GetDetails", {}, function(data)
        cb(data)
    end)
end)