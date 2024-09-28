CRAFTING = {
	Benches = {
		Open = function(self, bench)
			Callbacks:ServerCallback("Crafting:GetBenchDetails", bench, function(results)
				if results == nil then
					return
				else
					LocalPlayer.state.craftingOpen = true
					SendNUIMessage({
						type = "SET_BENCH",
						data = {
							benchName = "Workbench",
							bench = bench,
							cooldowns = results.cooldowns,
							actionString = results.string,
							recipes = results.recipes,
							myCounts = results.myCounts,
						},
					})
					SendNUIMessage({
						type = "SET_MODE",
						data = {
							mode = "crafting",
						},
					})
					SetNuiFocus(true, true)
					SendNUIMessage({
						type = "APP_SHOW",
					})
				end
			end)
		end,
		Cleanup = function(self)
			for k, v in ipairs(_benchObjs) do
				Targeting:RemoveEntity(v)
				DeleteEntity(v)
			end
			_benchObjs = {}
		end,
		Refresh = function(self, interior)
			self:Cleanup()

			for k, v in ipairs(_benches) do
				if v.targeting and not v.targeting.manual then
					if
						v.restrictions.interior == nil
						or v.restrictions.interior
							== GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
					then
						local obj = nil
						if v.targeting.model ~= nil then
							obj = CreateObject(
								GetHashKey(v.targeting.model),
								v.location.x,
								v.location.y,
								v.location.z,
								false,
								true,
								false
							)
							FreezeEntityPosition(obj, true)
							table.insert(_benchObjs, obj)
							SetEntityHeading(obj, v.location.h)
						end

						if
							v.restrictions.shared
							or (v.restrictions.char ~= nil and v.restrictions.char == LocalPlayer.state.Character:GetData(
								"SID"
							))
							or (v.restrictions.job ~= nil and Jobs.Permissions:HasJob(
								v.restrictions.job.id,
								v.restrictions.job.workplace,
								v.restrictions.job.grade,
								false,
								false,
								v.restrictions.job.permissionKey or "JOB_CRAFTING"
							))
							or (
								v.restrictions.rep ~= nil
								and Reputation:GetLevel(v.restrictions.rep.id) >= v.restrictions.rep.level
							)
						then
							local menu = {
								{
									icon = v.targeting.icon,
									text = v.label,
									event = "Crafting:Client:OpenCrafting",
									data = v,
								},
							}

							if v.canUseSchematics then
								table.insert(menu, {
									icon = "clipboard-list",
									text = "Add Schematic To Bench",
									event = "Crafting:Client:AddSchematic",
									data = v,
									isEnabled = function(data, entityData)
										return Inventory.Items:HasType(17, 1)
									end,
								})
							end

							if v.restrictions.job ~= nil then
								menu.jobPerms = {
									{
										job = v.restrictions.job.id,
										workplace = v.restrictions.job.workplace,
										reqDuty = v.restrictions.job.onDuty,
									},
								}
							end

							if obj ~= nil then
								Targeting:AddEntity(obj, v.targeting.icon, menu)
							elseif v.targeting.ped ~= nil then
								PedInteraction:Add(
									v.id,
									GetHashKey(v.targeting.ped.model),
									vector3(v.location.x, v.location.y, v.location.z),
									v.location.h,
									25.0,
									menu,
									v.targeting.icon,
									v.targeting.ped.task
								)
							elseif v.targeting.poly ~= nil then
								Targeting.Zones:AddBox(
									v.id,
									v.targeting.icon,
									v.targeting.poly.coords,
									v.targeting.poly.w,
									v.targeting.poly.l,
									v.targeting.poly.options,
									menu,
									2.0,
									true
								)
							end
						end
					end
				end
			end
		end,
	},
}

_benchObjs = {}
_benches = nil
RegisterNetEvent("Crafting:Client:CreateBenches", function(benches)
	_benches = benches
	Crafting.Benches:Refresh(nil)
end)

RegisterNetEvent("Crafting:Client:ForceBenchRefresh", function()
	Crafting.Benches:Refresh(nil)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	Crafting.Benches:Cleanup()
end)

AddEventHandler("Crafting:Client:OpenCrafting", function(ent, data)
	Crafting.Benches:Open(data.id)
end)

AddEventHandler("Crafting:Client:AddSchematic", function(ent, data)
	Callbacks:ServerCallback("Crafting:GetSchematics", data, function(schematics)

		if #schematics > 0 then
			for k, v in ipairs(schematics) do
				schematics[k].data = {
					bench = data.id,
					schematic = schematics[k].data,
				}
			end
	
			ListMenu:Show({
				main = {
					label = "Crafting Schematics",
					items = schematics,
				},
			})
		else
			Notification:Error("You Have No Schematics")
		end

	end)
end)

AddEventHandler("Crafting:Client:UseSchematic", function(data)
	Progress:Progress({
		name = "schematic_action",
		duration = 8000,
		label = "Using Schematic",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("Crafting:UseSchematic", data, function(s)
		
			end)
		end
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Crafting", CRAFTING)
end)

RegisterNUICallback("Crafting:Craft", function(data, cb)
	Callbacks:ServerCallback("Crafting:Craft", data, function(state)
		if not state.error then
			if state.data.time > 0 then
				LocalPlayer.state.crafting = true
				Progress:Progress({
					name = "crafting_action",
					duration = state.data.time - 1000,
					label = string.format("%s: %s", state.string or "Crafting", _items[state.data.result.name].label),
					useWhileDead = false,
					canCancel = false,
					ignoreModifier = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(cancelled)
					if cancelled then
						Callbacks:ServerCallback("Crafting:Cancel", {}, function(s)
							if s then
								SendNUIMessage({
									type = "END_CRAFTING",
								})
							end
							LocalPlayer.state.crafting = false
						end)
					end
				end)
				if state.data ~= nil then
					Animations.Emotes:Play(state.data.animation, true, state.data.time, true)
				end
			end
			cb(true)
		else
			Notification:Error(string.format("Error - %s", state.message or "Something Is Broken, Report This"))
			cb(false)
		end
	end)
end)

RegisterNUICallback("Crafting:End", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Crafting:End", {}, function(state)
		SendNUIMessage({
			type = "END_CRAFTING",
		})
		Animations.Emotes:ForceCancel()
		if state ~= nil then
			if LocalPlayer.state.craftingOpen then
				Crafting.Benches:Open(state) -- Refresh bench bcuz item counts
			end
		end
		LocalPlayer.state.crafting = false
	end)
end)

RegisterNUICallback("Crafting:Cancel", function(data, cb)
	Callbacks:ServerCallback("Crafting:Cancel", {}, function(state)
		cb(state)
		if state then
			Progress:Cancel(true)
			Animations.Emotes:ForceCancel()
		end
		LocalPlayer.state.crafting = false
	end)
end)

function RegisterBenches() end
