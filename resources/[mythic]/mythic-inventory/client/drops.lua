local closerDrops = {}
local closerDropsIds = {}

function runDropsUpdate(checkRemovals)
	if LocalPlayer.state.position ~= nil then
		closerDrops = {}
		closerDropsIds = {}
		local dropZones = GlobalState["Dropzones"]
		if #dropZones > 0 then
			for k, v in ipairs(dropZones) do
				local distance = #(LocalPlayer.state.position - vector3(v.coords.x, v.coords.y, v.coords.z))
				if distance <= 25.0 then
					if not closerDrops[k] then
						table.insert(
							closerDrops,
							{ coords = vector3(v.coords.x, v.coords.y, v.coords.z), route = v.route }
						)
						closerDropsIds[k] = #closerDrops
					end
				elseif closerDropsIds[k] then
					table.remove(closerDrops, closerDropsIds[k])
					closerDropsIds[k] = nil
				end
			end
		end
	end
end

function startDropsTick()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			runDropsUpdate()
			Wait(1000)
		end
	end)

	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if #closerDrops > 0 then
				for k, v in ipairs(closerDrops) do
					if v.route == LocalPlayer.state.currentRoute then
						DrawMarker(
							25,
							v.coords,
							0,
							0,
							0,
							0,
							0,
							0,
							0.4,
							0.4,
							1.0,
							139,
							16,
							20,
							250,
							false,
							false,
							2,
							false,
							false,
							false,
							false
						)
					end
				end
			else
				Wait(800)
			end
			Wait(3)
		end
	end)
end

RegisterNetEvent("Inventory:Client:DropzoneForceUpdate", function()
	Wait(100)
	runDropsUpdate(true)
end)
