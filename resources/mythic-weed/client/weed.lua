AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Weed = exports["mythic-base"]:FetchComponent("Weed")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Weed", {
		"Logger",
		"Callbacks",
		"Game",
		"Weed",
		"Targeting",
		"Animations",
		"Progress",
		"Notification",
		"ListMenu",
		"Inventory",
		"PedInteraction",
		"Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterTargets()
		RegisterCallbacks()

		LoadWeedModels()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
	local stagePct = 100 / (#Plants - 1)
	return math.floor((pct / stagePct) + 1.5)
end

local _plants = {}
function RegisterCallbacks()
	Callbacks:RegisterClientCallback("Weed:PlantingAnim", function(data, cb)
		local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.3, 0))
		local foundGround, zPos = GetGroundZFor_3dCoord(x, y, z - 0.5, 0)
		if foundGround then
			z = zPos
		end

		local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(x, y, z + 4, x, y, z - 2, 1, 0, 4)
		local retval, hit, endCoords, _, materialHash, _ = GetShapeTestResultIncludingMaterial(rayHandle)
		
		if hit then
			if Materials[materialHash] ~= nil and not Polyzone:IsCoordsInZone(vector3(x, y, z), 'cayo_perico') then
				Progress:Progress({
					name = "plant_weed",
					duration = 15000,
					label = "Planting",
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						task = "WORLD_HUMAN_GARDENER_PLANT",
					},
				}, function(cancelled)
					if not cancelled then
						cb({
							coords = { x = x, y = y, z = z },
							material = materialHash,
						})
					else
						cb({ error = 3 })
					end
				end)
			else
				cb({ error = 2 })
			end
		else
			cb({ error = 1 })
		end
	end)

	Callbacks:RegisterClientCallback("Weed:RollingAnim", function(data, cb)
		Progress:Progress({
			name = "rolling_weed",
			duration = 3000,
			label = "Rolling Joints",
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@world_human_clipboard@male@idle_a",
				anim = "idle_c",
				flags = 49,
			},
		}, function(cancelled)
			cb(not cancelled)
		end)
	end)

	Callbacks:RegisterClientCallback("Weed:MakingBrick", function(data, cb)
		Progress:Progress({
			name = "making_brick",
			duration = data.time * 1000,
			label = data.label,
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@world_human_clipboard@male@idle_a",
				anim = "idle_c",
				flags = 49,
			},
		}, function(cancelled)
			cb(not cancelled)
		end)
	end)

	Callbacks:RegisterClientCallback("Weed:SmokingAnim", function(data, cb)
		local ticks = 1
        Progress:ProgressWithTickEvent({
			name = "smoking_weed",
			duration = 8000,
			tickrate = 1000,
			label = "Smoking",
			canCancel = true,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
			animation = not IsPedInAnyVehicle(LocalPlayer.state.ped, true) and {
				task = "WORLD_HUMAN_DRUG_DEALER" ,
			} or false,
        }, function()
			local armor = GetPedArmour(LocalPlayer.state.ped)
			if armor < 50 then
				SetPedArmour(LocalPlayer.state.ped, armor + 3)
			end
			ticks = ticks + 1
        end, function(cancelled)
			cb(not cancelled, ticks)
        end)
	end)
end

WEED = {}
