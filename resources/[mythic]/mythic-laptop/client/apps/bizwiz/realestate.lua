local _drawingPropertyLocations = false
local locationTypes = {
    front = "Front Door",
    backdoor = "Back Door",
    garage = "Garage"
}

RegisterNUICallback("Dyn8SearchProperties", function(d, cb)
    local properties = Properties:GetProperties()

    local data = {}
    if properties then
        for k,v in pairs(properties) do
            table.insert(data, v)
        end
    end

    cb({
        properties = data,
        upgrades = Properties:GetUpgradesConfig(),
    })
end)

RegisterNUICallback("Dyn8MarkProperty", function(data, cb)
	local prop = Properties:Get(data)
	if prop ~= nil then
		ClearGpsPlayerWaypoint()
		SetNewWaypoint(prop.location.front.x, prop.location.front.y)
        cb(true)
	else
		cb(false)
	end
end)

RegisterNUICallback("Dyn8StartSale", function(data, cb)
	Callbacks:ServerCallback("Properties:Dyn8:Sell", {
        property = data.property,
        loan = data.type == 'loan',
        target = data.SID,
        deposit = data.downpayment,
        time = data.weeks,
    }, cb)
end)

RegisterNUICallback("Dyn8StartTransfer", function(data, cb)
	Callbacks:ServerCallback("Properties:Dyn8:Transfer", {
        property = data.property,
        target = data.SID,
    }, cb)
end)

RegisterNUICallback("Dyn8RunCredit", function(data, cb)
	Callbacks:ServerCallback(
        "Properties:Dyn8:CheckCredit", 
        {
            target = data.term,
        }, 
        cb
    )
end)

RegisterNUICallback("Dyn8ChangePropertyLocations", function(data, cb)
    Callbacks:ServerCallback("Properties:EditProperty", data, function(success)
        if success and _drawingPropertyLocations then
            _drawingPropertyLocations = false
        end

        cb(success)
    end)
end)

RegisterNUICallback("Dyn8ShowPropertyLocations", function(data, cb)
    local prop = Properties:Get(data.property)
    if prop and prop.location then
        cb(true)

        if _drawingPropertyLocations then
            _drawingPropertyLocations = false
            Wait(100)
        end

        _drawingPropertyLocations = true

        CreateThread(function()
            while LocalPlayer.state.loggedIn and _drawingPropertyLocations do
                for k, v in pairs(prop.location) do
                    Print3DText(vector3(v.x + 0.0, v.y + 0.0, v.z + 1.0), locationTypes[k])
                    DrawMarker(2, v.x + 0.0, v.y + 0.0, v.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 19, 98, 49, 200, 1, 1, 0, 0)
                end

                Wait(5)
            end
        end)

        Citizen.SetTimeout(30000, function()
            _drawingPropertyLocations = false
        end)
    else
        cb(false)
    end
end)

function Print3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(250, 250, 250, 255)		-- You can change the text color here
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

RegisterNUICallback("Dyn8CopyID", function(data, cb)
	Admin:CopyClipboard(data)

    cb(true)
end)

RegisterNUICallback("Dyn8ToggleBlips", function(data, cb)
	TriggerEvent("Properties:Client:ShowAllPropertyBlips")

    cb('ok')
end)