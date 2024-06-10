AddEventHandler("Escort:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Escort = exports["mythic-base"]:FetchComponent("Escort")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Escort", {
		"Database",
		"Logger",
		"Callbacks",
		"Middleware",
		"Execute",
		"Fetch",
		"Utils",
		"Jobs",
		"Chat",
		"Escort",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
	end)
end)

_ESCORT = {
	Do = function(self, source, data)
		local mPed = GetPlayerPed(source)
		local tPed = GetPlayerPed(data.target)

		local mPos = GetEntityCoords(mPed)
		local tPos = GetEntityCoords(tPed)

		local pState = Player(source).state
		local tState = Player(data.target).state

		if tState.myEscorter == nil and (pState.myDuty == "ems" or not tState.ICU) then
			local dist = #(vector3(mPos.x, mPos.y, mPos.z) - vector3(tPos.x, tPos.y, tPos.z))
			if dist <= 1.5 or data.inVeh and dist <= 5 then
				if data.inVeh then
					TaskLeaveAnyVehicle(tPed, 0, 16)
				end

				pState.isEscorting = data.target
				tState.myEscorter = source
				TriggerClientEvent("Escort:Client:Escorted", data.target)
				return true
			else
				return false
			end
		else
			return false
		end
	end,
	DoPutIn = function(self, source, data)
		local pState = Player(source).state
		if pState.isEscorting ~= nil then
			local tPed = GetPlayerPed(pState.isEscorting)
			local tState = Player(pState.isEscorting).state
			local veh = NetworkGetEntityFromNetworkId(data.veh)
			ClearPedTasksImmediately(tPed)

			if data.class == 18 then -- Emergency
				-- Favour Lowest Back Seat But Try Passenger Seat as Last Resort
				local maxSeats = data.seatCount - 1
				for i = 1, maxSeats do
					local seat = (i < maxSeats) and i or 0

					local ent = GetPedInVehicleSeat(veh, seat)
					if ent == 0 then
						TaskWarpPedIntoVehicle(tPed, veh, seat)
						break
					end
				end
			else
				-- Favour Highest Back Seats First
				for i = (data.seatCount - 2), 0, -1 do
					local ent = GetPedInVehicleSeat(veh, i)
					if ent == 0 then
						TaskWarpPedIntoVehicle(tPed, veh, i)
						break
					end
				end
			end

			tState.myEscorter = nil
			tState.isEscorting = nil
			pState.myEscorter = nil
			pState.isEscorting = nil
			return true
		else
			return false
		end
	end,
	Stop = function(self, source)
		local pState = Player(source).state
		if pState.isEscorting ~= nil then
			local tState = Player(pState.isEscorting).state

			local p = promise.new()
			Callbacks:ClientCallback(pState.isEscorting, "Escort:StopEscort", {}, function()
				p:resolve(true)
			end)
			Citizen.Await(p)

			tState.myEscorter = nil
			tState.isEscorting = nil
			pState.myEscorter = nil
			pState.isEscorting = nil
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Escort", _ESCORT)
end)

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Escort:DoEscort", function(source, data, cb)
		cb(Escort:Do(source, data))
	end)

	Callbacks:RegisterServerCallback("Escort:DoPutIn", function(source, data, cb)
		cb(Escort:DoPutIn(source, data))
	end)

	Callbacks:RegisterServerCallback("Escort:StopEscort", function(source, data, cb)
		Escort:Stop(source)
	end)
end

function RegisterMiddleware()
	Middleware:Add("Characters:Logout", function(source)
		local pState = Player(source).state

		if pState?.isEscorting ~= nil then
			local tState = Player(pState.isEscorting).state

			local p = promise.new()
			Callbacks:ClientCallback(pState.isEscorting, "Escort:StopEscort", {}, function()
				p:resolve(true)
			end)
			Citizen.Await(p)
			
			tState.myEscorter = nil
			tState.isEscorting = nil
			pState.myEscorter = nil
			pState.isEscorting = nil
		elseif pState?.myEscorter ~= nil then
			local tState = Player(pState.myEscorter).state

			tState.myEscorter = nil
			tState.isEscorting = nil
			pState.myEscorter = nil
			pState.isEscorting = nil

			local p = promise.new()
			Callbacks:ClientCallback(source, "Escort:StopEscort", {}, function()
				p:resolve(true)
			end)
			Citizen.Await(p)
		end
	end)

	Middleware:Add("playerDropped", function(source)
		local pState = Player(source).state

		if pState?.isEscorting ~= nil then
			local tState = Player(pState.isEscorting).state

			local p = promise.new()
			Callbacks:ClientCallback(pState.isEscorting, "Escort:StopEscort", {}, function()
				p:resolve(true)
			end)
			Citizen.Await(p)

			tState.myEscorter = nil
			tState.isEscorting = nil
			pState.myEscorter = nil
			pState.isEscorting = nil
		elseif pState?.myEscorter ~= nil then
			local tState = Player(pState.myEscorter)?.state
			if tState ~= nil then
				tState.myEscorter = nil
				tState.isEscorting = nil
			end

			pState.myEscorter = nil
			pState.isEscorting = nil
		end
	end)
end

RegisterNetEvent("Ped:Server:Died", function()
	local src = source
	local pState = Player(src).state
	if pState.isEscorting ~= nil then
		local tState = Player(pState.isEscorting).state
		tState.myEscorter = nil
		tState.isEscorting = nil
		pState.myEscorter = nil
		pState.isEscorting = nil
	elseif pState.myEscorter then
		local tState = Player(pState.myEscorter).state
		tState.myEscorter = nil
		tState.isEscorting = nil
		pState.myEscorter = nil
		pState.isEscorting = nil
	end
end)

RegisterNetEvent("Escort:Server:DoPutIn", function(veh)
	local src = source
	local pState = Player(src).state

	if pState.isEscorting ~= nil then
		Callbacks:ClientCallback(pState.isEscorting, "Escort:StopEscort", {}, function() end)
	end
end)
