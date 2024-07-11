RegisterNetEvent("HUD:Client:Debug", function()
	_debugging = not _debugging
end)

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

function DrawText3Ds(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end

            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
	    	end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

local startTime = 0
local lastScore60 = "None"
local lastScore90 = "None"
local lastScore120 = "None"
local isRecording = false
local speedThread = false

local function SpeedThread()
    if speedThread then return end
    speedThread = true
    CreateThread(function()
        while _debugging do
            Wait(0)
            if IsControlJustPressed(0, 38) then
                lastScore60 = "None"
                lastScore90 = "None"
                lastScore120 = "None"
                isRecording = false
                startTime = 0
            end
            local currentSpeed = GetEntitySpeed(PlayerPedId()) * 2.236936 -- Convert from m/s to mph
            if currentSpeed > 1 and not isRecording then
                startTime = GetGameTimer()
                isRecording = true
            elseif currentSpeed <= 1 and isRecording then
                isRecording = false
            end

            local currentTime = GetGameTimer()
            local elapsedTime = (currentTime - startTime) / 1000 -- Convert to seconds

            if currentSpeed >= 60 and lastScore60 == "None" then
                lastScore60 = string.format("%.2f seconds", elapsedTime)
            elseif currentSpeed >= 90 and lastScore90 == "None" then
                lastScore90 = string.format("%.2f seconds", elapsedTime)
            elseif currentSpeed >= 120 and lastScore120 == "None" then
                lastScore120 = string.format("%.2f seconds", elapsedTime)
            end
        end
        speedThread = false
    end)
end

CreateThread(function()
	while true do
		Wait(1)

		if _debugging then
			local pos = GetEntityCoords(PlayerPedId())

			local ped = PlayerPedId()
			local veh = GetVehiclePedIsIn(ped,false)
			local forPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0.0)
			local backPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -1.0, 0.0)
			local LPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 0.0, 0.0)
			local RPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.0, 0.0, 0.0)

			local forPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0.0)
			local backPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -2.0, 0.0)
			local LPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 2.0, 0.0, 0.0)
			local RPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -2.0, 0.0, 0.0)

			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
			local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
			currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

			drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
			drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(PlayerPedId()), 55, 155, 55, 255)
			drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
			drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)

			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				local netID = VehToNet(vehicle)
				local hash = GetEntityModel(vehicle)
				local modelName = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				local eHealth = GetVehicleEngineHealth(vehicle)
				local bHealth = GetVehicleBodyHealth(vehicle)
				SpeedThread()
				drawTxt(0.6, 0.50, 0.4,0.4,0.30, "Vehicle: " .. modelName, 55, 155, 55, 255)
				drawTxt(0.6, 0.52, 0.4,0.4,0.30, "Vehicle Hash: " .. hash, 55, 155, 55, 255)
				drawTxt(0.6, 0.54, 0.4,0.4,0.30, "Vehicle NetID: " .. netID, 55, 155, 55, 255)
				drawTxt(0.6, 0.56, 0.4,0.4,0.30, "Vehicle Health: " .. bHealth, 55, 155, 55, 255)
				drawTxt(0.6, 0.58, 0.4,0.4,0.30, "Vehicle Engine Health: " .. eHealth, 55, 155, 55, 255)
				drawTxt(0.6, 0.60, 0.4,0.4,0.30, "0 to 60: " .. lastScore60, 55, 155, 55, 255)
				drawTxt(0.6, 0.62, 0.4,0.4,0.30, "0 to 90: " .. lastScore90, 55, 155, 55, 255)
				drawTxt(0.6, 0.64, 0.4,0.4,0.30, "0 to 120: " .. lastScore120, 55, 155, 55, 255)
				drawTxt(0.6, 0.66, 0.4,0.4,0.30, "Press E to Reset", 55, 155, 55, 255)
			else
				startTime = 0
				isRecording = false
				lastScore60 = "None"
				lastScore90 = "None"
				lastScore120 = "None"
			end

			DrawLine(pos,forPos, 255,0,0,115)
			DrawLine(pos,backPos, 255,0,0,115)

			DrawLine(pos,LPos, 255,255,0,115)
			DrawLine(pos,RPos, 255,255,0,115)

			DrawLine(forPos,forPos2, 255,0,255,115)
			DrawLine(backPos,backPos2, 255,0,255,115)

			DrawLine(LPos,LPos2, 255,255,255,115)
			DrawLine(RPos,RPos2, 255,255,255,115)

			local nearped = getNPC()

			local veh = GetVehicle()

			local nearobj = GetObject()

		end
	end
end)
