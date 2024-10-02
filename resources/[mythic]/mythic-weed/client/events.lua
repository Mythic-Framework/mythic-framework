local harvesting = false

RegisterNetEvent("Weed:Client:Login", function(l)
	PedInteraction:Add("weed-dealer", `s_m_y_dealer_01`, vector3(l.coords.x, l.coords.y, l.coords.z), l.heading, 50.0, {
		{
			icon = "cannabis",
			text = "Buy Package",
			event = "Weed:Client:Package",
		},
		-- {
		-- 	icon = "sack",
		-- 	text = "Sell Bricks",
		-- 	event = "Weed:Client:Brick",
		-- 	item = "weed_brick",
		-- 	rep = {
		-- 		id = 'weed',
		-- 		level = 3,
		-- 	},
		-- },
		{
			icon = "9",
			text = "Sign In",
			event = "WeedRun:Client:Enable",
            data = {},
            isEnabled = function()
                return not hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_WEED_RUN") and LocalPlayer.state.onDuty ~= "police"
            end,
		},
		{
			icon = "9",
			text = "Sign In",
			event = "WeedRun:Client:Disabled",
            data = {},
            isEnabled = function()
                return hasValue(LocalPlayer.state.Character:GetData("States") or {}, "SCRIPT_WEED_RUN") and LocalPlayer.state.onDuty ~= "police"
            end,
		},
	}, 'sack-dollar', 'WORLD_HUMAN_DRUG_DEALER', true)
end)

AddEventHandler("Weed:Client:Check", function(entity, data)
	Callbacks:ServerCallback("Weed:CheckPlant", GetWeedPlant(entity.entity), function(data)
		if data ~= nil then
			local stageId = getStageByPct(data.plant.growth)
			local stage = Plants[stageId]

			local type = "Female"
			if data.plant.isMale then
				type = "Male"
			end

			local items = {
				{
					label = "Plant Information",
					description = type,
				},
				{
					label = "Plant Growth",
					description = string.format("Growth: %.2f%%", data.plant.growth),
				},
				{
					label = "Soil Information",
					description = string.format(
						"<ul><li>Ground Type: %s</li><li>Water: %s</li><li>Nitrogen: %s</li><li>Phosphorus: %s</li><li>Potassium: %s</li></ul>",
						data.ground.label,
						data.ground.water,
						data.ground.nitrogen,
						data.ground.phosphorus,
						data.ground.potassium
					),
				},
			}

			if data.plant.growth < 100 then
				if data.plant.fertilizer ~= nil then
					table.insert(items, {
						label = "Fertilized",
						description = string.format(
							"Type: %s (+%s) Time Left: %s Minutes",
							data.plant.fertilizer.type,
							data.plant.fertilizer.value,
							data.plant.fertilizer.time
						),
					})
				else
					table.insert(items, {
						label = "Not Fertilized",
						description = "Click to fertilize plant",
						submenu = "fertilizer",
					})
				end

				if data.plant.water < 95 then
					table.insert(items, {
						label = string.format("Water: %.2f%%", data.plant.water),
						description = "Requires 1x Bottle of Water",
						event = "Weed:Client:Water",
						data = GetWeedPlant(entity.entity),
					})
				else
					table.insert(items, {
						label = string.format("Water: %.2f%%", data.plant.water),
						description = "Does Not Need Water",
					})
				end
			end

			if stage.harvestable then
				table.insert(items, {
					label = "Harvest Plant",
					event = "Weed:Client:Harvest2",
					data = GetWeedPlant(entity.entity),
				})
			end

			local fertilizers = {
				{
					label = "About Fertilizer",
					description = "Various fertilizers do different things.<br />Nitrogen: Increases possible output of plant.<br />Phosphorus: Increases Growth Per Tick.<br />Potassium: Increases Water Duration.",
				},
			}

			local hasNitro = Inventory.Items:Has("fertilizer_nitrogen", 1)
			local hasPhos = Inventory.Items:Has("fertilizer_phosphorus", 1)
			local hasPotas = Inventory.Items:Has("fertilizer_potassium", 1)

			if hasNitro or hasPhos or hasPotas then
				if hasNitro then
					table.insert(fertilizers, {
						label = "Fertilize Plant (Nitrogen)",
						description = "Requires 1x Fertilizer (Nitrogen)",
						event = "Weed:Client:Fertilize",
						data = { id = GetWeedPlant(entity.entity), type = "nitrogen" },
					})
				end

				if hasPhos then
					table.insert(fertilizers, {
						label = "Fertilize Plant (Phosphorus)",
						description = "Requires 1x Fertilizer (Phosphorus)",
						event = "Weed:Client:Fertilize",
						data = { id = GetWeedPlant(entity.entity), type = "phosphorus" },
					})
				end

				if hasPotas then
					table.insert(fertilizers, {
						label = "Fertilize Plant (Potassium)",
						description = "Requires 1x Fertilizer (Potassium)",
						event = "Weed:Client:Fertilize",
						data = { id = GetWeedPlant(entity.entity), type = "potassium" },
					})
				end
			else
				table.insert(fertilizers, {
					label = "You Don't Have Any Fertilizer",
				})
			end
			
			table.insert(items, {
				label = "Destroy Plant",
				description = "Destroy the plant, you will not receive anything from doing this",
				submenu = "deleteConfirm",
			})

			ListMenu:Show({
				main = {
					label = string.format("Weed Plant Stage: %s", stageId),
					items = items,
				},
				fertilizer = {
					label = "Fertilize Plant",
					items = fertilizers,
				},
				deleteConfirm = {
					label = "Destroy Plant?",
					items = {
						{
							label = "Are You Sure?",
							description = "Destroying this plant is irreversible and you will not receive anything from this plant. Are you absolutely sure you want to do this?",
						},
						{
							label = "Yes",
							description = "Destroy This Plant",
							event = "Weed:Client:Destroy",
							data = GetWeedPlant(entity.entity),
						},
						{
							label = "No",
							description = "Do Not Destroy This Plant",
							submenu = "main",
						},
					},
				}
			})
		else
		end
	end)
end)

AddEventHandler("Weed:Client:Fertilize", function(data)
	if Inventory.Items:Has(string.format("fertilizer_%s", data.type), 1) then
		ListMenu:Close()
		Progress:Progress({
			name = "fertilize_weed",
			duration = 15000,
			label = "Fertilizing",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
				anim = "machinic_loop_mechandplayer",
				flags = 49,
			},
		}, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("Weed:FertilizePlant", data, function(status) end)
			end
		end)
	else
		Notification:Error("You Don't Have Fertilizer")
	end
end)

AddEventHandler("Weed:Client:Water", function(pId)
	if Inventory.Items:Has("water", 1) then
		ListMenu:Close()
		Progress:Progress({
			name = "water_weed",
			duration = 6000,
			label = "Watering",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
				anim = "machinic_loop_mechandplayer",
				flags = 49,
			},
		}, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("Weed:WaterPlant", pId, function(status) end)
			end
		end)
	end
end)

AddEventHandler("Weed:Client:Harvest", function(entity, data)
	Progress:Progress({
		name = "harvest_weed",
		duration = 6000,
		label = "Harvesting",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Weed:HarvestPlant", GetWeedPlant(entity.entity), function(status) end)
		end
	end)
end)

AddEventHandler("Weed:Client:Harvest2", function(nId)
	ListMenu:Close()
	Progress:Progress({
		name = "harvest_weed",
		duration = 6000,
		label = "Harvesting",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Weed:HarvestPlant", nId, function(status) end)
		end
	end)
end)

AddEventHandler("Weed:Client:Package", function()
	Callbacks:ServerCallback("Weed:BuyPackage", {}, function(status) end)
end)

-- AddEventHandler("Weed:Client:Brick", function()
-- 	Callbacks:ServerCallback("Weed:SellBrick", {}, function(status) end)
-- end)

AddEventHandler("Weed:Client:Destroy", function(nId)
	Progress:Progress({
		name = "destroy_weed",
		duration = 8000,
		label = "Destroying",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Weed:DestroyPlant", nId, function(status) end)
		end
	end)
end)

AddEventHandler("Weed:Client:PDDestroy", function(entity)
	Progress:Progress({
		name = "harvest_weed",
		duration = 4000,
		label = "Destroying",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Weed:PDDestroyPlant", GetWeedPlant(entity.entity), function(status) end)
		end
	end)
end)
