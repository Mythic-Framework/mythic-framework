COMPONENTS.Game = {
	_protected = true,
	_name = "base",
}

COMPONENTS.Game = {
	Players = {
		GetPlayerPeds = function(self)
			local players = {}

			for _, player in ipairs(GetActivePlayers()) do
				local ped = GetPlayerPed(player)

				if DoesEntityExist(ped) then
					table.insert(players, { ["ped"] = ped, ["id"] = player })
				end
			end

			return players
		end,
		GetClosestPlayer = function(self, _coords)
			local players = self:GetPlayerPeds()
			local closestDistance = -1
			local closestPlayer = -1
			local coords = _coords
			local usePlayerPed = false
			local playerId = LocalPlayer.state.clientID
			if coords == nil then
				usePlayerPed = true
				coords = LocalPlayer.state.position
			end

			for i = 1, #players, 1 do
				local target = players[i].ped

				if not usePlayerPed or (usePlayerPed and players[i].id ~= playerId) then
					local targetCoords = GetEntityCoords(target)
					local distance = #(targetCoords - vector3(coords.x, coords.y, coords.z))

					if closestDistance == -1 or closestDistance > distance then
						closestPlayer = players[i].id
						closestDistance = distance
					end
				end
			end

			return closestPlayer, closestDistance
		end,
	},
	Objects = {
		GetAll = function(self)
			local objects = {}
			for obj in EnumerateObjects() do
				table.insert(objects, obj)
			end
			return objects
		end,
		GetInArea = function(self, coords, radius)
			local objects = {}
			for obj in EnumerateObjects() do
				local objectCoords = GetEntityCoords(obj)
				if #(objectCoords - vector3(coords.x, coords.y, coords.z)) <= radius then
					table.insert(objects, obj)
				end
			end
			return objects
		end,
		Spawn = function(self, coords, modelName, heading, cb)
			local model = (type(modelName) == "number" and modelName or joaat(modelName))
			CreateThread(function()
				COMPONENTS.Stream.RequestModel(model)
				local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
				SetEntityHeading(obj, heading)
				if cb ~= nil then
					cb(obj)
				end
			end)
		end,
		SpawnLocal = function(self, coords, modelName, heading, cb)
			local model = (type(modelName) == "number" and modelName or joaat(modelName))
			CreateThread(function()
				COMPONENTS.Stream.RequestModel(model)

				local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
				SetEntityHeading(obj, heading)
				if cb ~= nil then
					cb(obj)
				end
			end)
		end,
		SpawnLocalNoOffset = function(self, coords, modelName, heading, cb)
			local model = (type(modelName) == "number" and modelName or joaat(modelName))
			CreateThread(function()
				COMPONENTS.Stream.RequestModel(model)

				local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, true)
				SetEntityHeading(obj, heading)
				if cb ~= nil then
					cb(obj)
				end
			end)
		end,
		Delete = function(self, obj)
			SetEntityAsMissionEntity(obj, false, true)
			DeleteObject(obj)
		end,
	},
	Vehicles = {
		Spawn = function(self, coords, modelName, heading, cb)
			local model = (type(modelName) == "number" and modelName or GetHashKey(modelName))
			CreateThread(function()
				COMPONENTS.Stream.RequestModel(model)

				if HasModelLoaded((type(model) == "number" and model or GetHashKey(model))) then
					local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)

					local t = 0
					while not DoesEntityExist(vehicle) and t <= 10000 do
						Wait(1)
						t += 1
					end

					if not DoesEntityExist(vehicle) then
						COMPONENTS.Logger:Error(
							"Game",
							string.format(
								"Vehicle (%s) Didn't Spawn, Returning Nil And Aborting Remaining Spawn Behavior",
								model
							)
						)
						return cb(nil)
					end

					local id = NetworkGetNetworkIdFromEntity(vehicle)
					SetNetworkIdCanMigrate(id, true)
					SetEntityAsMissionEntity(vehicle, true, true)
					SetVehicleHasBeenOwnedByPlayer(vehicle, true)
					SetVehicleNeedsToBeHotwired(vehicle, false)
					RequestCollisionAtCoord(coords.x, coords.y, coords.z)
					SetVehRadioStation(vehicle, "OFF")
					SetModelAsNoLongerNeeded(model)
					while not HasCollisionLoadedAroundEntity(vehicle) do
						RequestCollisionAtCoord(coords.x, coords.y, coords.z)
						Wait(0)
					end

					if cb then
						cb(vehicle)
					end
				else
					COMPONENTS.Logger:Error(
						"Stream",
						string.format("failed to load model, please report this: %s", model)
					)
					return cb(nil)
				end
			end)
		end,
		SpawnLocal = function(self, coords, modelName, heading, cb)
			local model = (type(modelName) == "number" and modelName or GetHashKey(modelName))
			CreateThread(function()
				COMPONENTS.Stream.RequestModel(model)
				local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
				SetEntityAsMissionEntity(vehicle, true, false)
				SetVehicleHasBeenOwnedByPlayer(vehicle, true)
				SetVehicleNeedsToBeHotwired(vehicle, false)
				SetModelAsNoLongerNeeded(model)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
				while not HasCollisionLoadedAroundEntity(vehicle) do
					RequestCollisionAtCoord(coords.x, coords.y, coords.z)
					Wait(0)
				end
				SetVehRadioStation(vehicle, "OFF")
				if cb then
					cb(vehicle)
				end
			end)
		end,
		Delete = function(self, vehicle)
			SetEntityAsMissionEntity(vehicle, false, true)
			DeleteVehicle(vehicle)
		end,
	},
}
