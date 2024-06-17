local maxDistance = 50.0
local laserPointRadius = 0.1
local originPoints, targetPoints
local inOriginMode = false

creationEnabled = false

function startCreation()
	if not creationEnabled or not LocalPlayer.state.isAdmin then
		return
	end
	originPoints, targetPoints = {}, {}
	CreateThread(function()
		while creationEnabled do
			if IsControlJustReleased(0, 73) then
				inOriginMode = not inOriginMode
			end
			drawPoints()
			drawLines()
			if inOriginMode then
				handleLaserOriginPoint()
			else
				handleLaserTargetPoints()
			end
			Wait(0)
		end
	end)
end

function handleLaserOriginPoint()
	local point = handlePoint(0, 255, 0, 255)
	if point and originPoints then
		originPoints[#originPoints + 1] = point
		print("Add point to laser originPoints:", point)
	end
end

function handleLaserTargetPoints()
	local point = handlePoint(255, 0, 0, 255)
	if point then
		targetPoints[#targetPoints + 1] = point
		print("Add point to laser targetPoints:", point)
	end
end

function handlePoint(r, g, b, a)
	local hit, pos, _, _ = RayCastGamePlayCamera(maxDistance)
	if hit then
		DrawSphere(pos, laserPointRadius, r, g, b, a)
		if IsControlJustReleased(0, 51) then
			return pos
		end
	end
end

function drawPoints()
	if not originPoints then
		return
	end
	for _, originPoint in ipairs(originPoints) do
		DrawSphere(originPoint, laserPointRadius, 0, 255, 0, 255)
	end
	if not targetPoints then
		return
	end
	for _, targetPoint in ipairs(targetPoints) do
		DrawSphere(targetPoint, laserPointRadius, 255, 0, 0, 255)
	end
end

function drawLines()
	if not originPoints or #originPoints == 0 or not targetPoints or #targetPoints == 0 then
		return
	end
	if #originPoints == 1 then
		for _, targetPoint in ipairs(targetPoints) do
			DrawLine(originPoints[1], targetPoint, 255, 0, 0, 255)
		end
	else
		for i = 1, #originPoints do
			if i <= #targetPoints then
				DrawLine(originPoints[i], targetPoints[i], 255, 0, 0, 255)
			end
		end
	end
end
