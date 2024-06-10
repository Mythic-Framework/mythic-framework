_placing = false
_placeData = nil
placementCoords = nil
isValid = false

AddEventHandler("ObjectPlacer:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	ObjectPlacer = exports["mythic-base"]:FetchComponent("ObjectPlacer")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("ObjectPlacer", {
        "Notification",
        "Targeting",
        "ObjectPlacer",
	}, function(error)
		if #error > 0 then 
            exports["mythic-base"]:FetchComponent("Logger"):Critical("ObjectPlacer", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
    _placeData = nil
end)

_PLACER = {
    Start = function(self, model, finishEvent, data, allowedInterior, cancelEvent, isFurniture, stupidFlag)
        if _placing or IsPedInAnyVehicle(PlayerPedId()) then
            return
        end

        _placing = true
        _placeData = {
            finishEvent = finishEvent,
            cancelEvent = cancelEvent,
            data = data,
        }

        placementCoords = nil
        isValid = false

        RunPlacementThread(model, allowedInterior, isFurniture, stupidFlag)
    end,
    End = function(self)
        _placing = false
        if isValid then
            TriggerEvent(_placeData.finishEvent, _placeData.data, placementCoords)
        else
            if _placeData?.cancelEvent then
                TriggerEvent(_placeData.cancelEvent, _placeData.data, true)
            end
            Notification:Error("Invalid Object Placement")
        end

        placementCoords = nil
        isValid = false
        _placeData = nil
    end,
    Cancel = function(self, skipNotification, skipEvent)
        _placing = false
        if not skipEvent and _placeData?.cancelEvent then
            TriggerEvent(_placeData.cancelEvent, _placeData.data)
        end

        if not skipNotification then
            Notification:Error("Object Placement Cancelled")
        end

        placementCoords = nil
        isValid = false
        _placeData = nil
    end
}

AddEventHandler("Keybinds:Client:KeyDown:primary_action", function()
	if _placeData ~= nil then
        ObjectPlacer:End()
	end
end)

AddEventHandler("Keybinds:Client:KeyDown:cancel_action", function()
	if _placeData ~= nil then
        ObjectPlacer:Cancel()
	end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("ObjectPlacer", _PLACER)
end)