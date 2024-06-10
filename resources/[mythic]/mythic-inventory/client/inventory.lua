SecondInventory = {}

_inUse = false
_disabled = false
local _openCd = false
local _hkCd = false
local _container = nil
local trunkOpen = false

AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Crafting = exports["mythic-base"]:FetchComponent("Crafting")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")

	--Weapons = exports['mythic-base']:FetchComponent('Weapons')
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	LoadItems()
end)

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Inventory", {
		"Callbacks",
		"Inventory",
		"Utils",
		"Notification",
		"Action",
		"Animations",
		"Progress",
		"Crafting",
		"Interaction",
		"Targeting",
		"UISounds",
		"Blips",
		"PedInteraction",
		"Polyzone",
		"Hud",
		"Phone",
		"Jobs",
		"Reputation",
		"Vehicles",
		"Sounds",
		"ListMenu",
		--'Weapons',
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterKeyBinds()
		RegisterRandomItems()

		Callbacks:RegisterClientCallback("Inventory:ForceClose", function(data, cb)
			Inventory.Close:All()
			cb(true)
		end)

		Callbacks:RegisterClientCallback("Inventory:Container:Open", function(data, cb)
			if SecondInventory.owner ~= nil then
				Callbacks:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
					_container = data.item
					SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
					cb(true)
				end)
			else
				_container = data.item
				SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
				cb(true)
			end
		end)

		Callbacks:RegisterClientCallback("Inventory:Compartment:Open", function(data, cb)
			if SecondInventory.owner ~= nil then
				Callbacks:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
					SecondInventory = data
					cb(true)
				end)
			else
				SecondInventory = data
				cb(true)
			end
		end)

		Callbacks:RegisterClientCallback("Inventory:ItemUse", function(item, cb)
			if item.anim and (not item.pbConfig or not item.pbConfig.animation) then
				Animations.Emotes:Play(item.anim, false, item.time, true)
			end

			if item.pbConfig ~= nil then
				Progress:Progress({
					name = item.pbConfig.name,
					duration = item.time,
					label = item.pbConfig.label,
					useWhileDead = item.pbConfig.useWhileDead,
					canCancel = item.pbConfig.canCancel,
					vehicle = item.pbConfig.vehicle,
					disarm = item.pbConfig.disarm,
					ignoreModifier = item.pbConfig.ignoreModifier or true,
					animation = item.pbConfig.animation or false,
					controlDisables = {
						disableMovement = item.pbConfig.disableMovement,
						disableCarMovement = item.pbConfig.disableCarMovement,
						disableMouse = item.pbConfig.disableMouse,
						disableCombat = item.pbConfig.disableCombat,
					},
				}, function(cancelled)
					Animations.Emotes:ForceCancel()
					cb(not cancelled)
				end)
			else
				cb(true)
			end
		end)

		CreateVendingMachines()
	end)
end)

local _openCd = false
function startCd()
	Citizen.CreateThread(function()
		_openCd = true
		Citizen.Wait(1000)
		_openCd = false
	end)
end

RegisterNetEvent("UI:Client:Reset", function(force)
	if force then
		_startup = false
		LoadItems()
	end
	Inventory.Close:All()
	Inventory:Enable()
end)

INVENTORY = {
	_required = { "IsEnabled", "Open", "Close", "Set", "Enable", "Disable", "Toggle", "Check" },
	IsEnabled = function(self)
		return _startup and not _disabled and not _openCd and not Hud:IsDisabled()
	end,
	Open = {
		Player = function(self)
			if Inventory:IsEnabled() then
				Phone:Close()
				Interaction:Hide()
				Callbacks:ServerCallback("Inventory:GetPlayerInventory", {}, function(inventory)
					if inventory ~= nil then
						LocalPlayer.state.inventoryOpen = true

						Citizen.CreateThread(function()
							TransitionToBlurred(50)
							while LocalPlayer.state.inventoryOpen do
								Citizen.Wait(50)
							end
							TriggerServerEvent("Inventory:server:closePlayerInventory", LocalPlayer.state.Char)
							TransitionFromBlurred(1000)
						end)

						Inventory.Set.Player:Inventory(inventory)
						Inventory.Set.Player.Data.Open = true

						SetNuiFocus(true, true)
						SendNUIMessage({
							type = "APP_SHOW",
						})
						SendNUIMessage({
							type = "SET_MODE",
							data = {
								mode = "inventory",
							},
						})
					end
				end)
			end
		end,
		Secondary = function(self)
			SendNUIMessage({
				type = "SHOW_SECONDARY_INVENTORY",
			})
		end,
	},
	Close = {
		All = function(self)
			SendNUIMessage({
				type = "APP_HIDE",
			})
			SetNuiFocus(false, false)

			LocalPlayer.state.inventoryOpen = false
			LocalPlayer.state.craftingOpen = false
			Inventory.Set.Player.Data.Open = false

			if trunkOpen and trunkOpen > 0 then
				Vehicles.Sync.Doors:Shut(trunkOpen, 5, false)
				trunkOpen = false
			end

			if Inventory.Set.Secondary.Data.Open then
				Inventory.Close:Secondary()
			end
		end,
		Secondary = function(self)
			SendNUIMessage({
				type = "HIDE_SECONDARY_INVENTORY",
			})
			if trunkOpen and trunkOpen > 0 then
				Vehicles.Sync.Doors:Shut(trunkOpen, 5, false)
				trunkOpen = false
			end

			if Inventory.Set.Secondary.Data.Open then
				Callbacks:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
					SecondInventory = {}
					_container = nil
					Inventory.Set.Secondary.Data.Open = false
				end)
			end
		end,
	},
	Set = {
		Player = {
			Data = {
				allowOpen = true,
				Open = false,
			},
			Inventory = function(self, data)
				if not data then
					SendNUIMessage({
						type = "APP_HIDE",
					})
					LocalPlayer.state.inventoryOpen = false
					LocalPlayer.state.craftingOpen = false
					Inventory.Set.Player.Data.Open = false
					return
				end
				SendNUIMessage({
					type = "SET_PLAYER_INVENTORY",
					data = data,
				})
			end,
			Equipment = function(self, data)
				SendNUIMessage({
					type = "SET_EQUIPMENT",
					data = data,
				})
			end,
			Refresh = function(self)
				Callbacks:ServerCallback("Inventory:GetPlayerInventory", {}, function(inventory)
					Inventory.Set.Player:Inventory(inventory)
				end)
			end,
			Slot = function(self, slot, slotData)
				SendNUIMessage({
					type = "SET_PLAYER_SLOT",
					data = {
						slot = slot,
						slotData = slotData,
					},
				})
			end,
		},
		Secondary = {
			Data = {
				Open = false,
			},
			Inventory = function(self, data)
				Inventory.Set.Secondary.Data.Open = true
				SendNUIMessage({
					type = "SET_SECONDARY_INVENTORY",
					data = data,
				})
			end,
			Refresh = function(self)
				Callbacks:ServerCallback("Inventory:GetSecondInventory", {}, function(inventory)
					Inventory.Set.Secondary:Inventory(inventory)
				end)
			end,
			Slot = function(self, slot, slotData)
				SendNUIMessage({
					type = "SET_SECONDARY_SLOT",
					data = {
						slot = slot,
						slotData = slotData,
					},
				})
			end,
		},
	},
	Used = {
		HotKey = function(self, control)
			if not _hkCd and not _inUse and not Hud:IsDisabled() then
				SendNUIMessage({
					type = "USE_ITEM_PLAYER",
					data = {
						originSlot = control,
					},
				})
				_hkCd = true
				Callbacks:ServerCallback("Inventory:UseSlot", { slot = control }, function(state)
					if not state then
						_hkCd = false
						SendNUIMessage({
							type = "SLOT_NOT_USED",
							data = {
								originSlot = control,
							},
						})
					end

					Citizen.SetTimeout(3000, function()
						_hkCd = false
					end)
				end)
			end
		end,
	},
	-- ALL OF THIS NEEDS TO BE VALIDATED SERVER SIDE
	-- THIS IS BEING ADDED TO SAVE A CLIENT > SERVER > CLIENT CALL
	Items = {
		GetCount = function(self, item, bundleWeapons)
			local counts = Inventory.Items:GetCounts(bundleWeapons)
			return counts[item] or 0
		end,
		GetCounts = function(self, bundleWeapons)
			local counts = {}

			if LocalPlayer.state.Character == nil then
				return counts
			end

			local cid = LocalPlayer.state.Character:GetData("ID")
			local slots = GlobalState[("inventory:%s:%s:slots"):format(cid, 1)]
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(cid, 1, slot)]
				if
					_items[slotData.Name].durability == nil
					or not _items[slotData.Name].isDestroyed
					or (((slotData.MetaData.CreateDate or 0) + _items[slotData.Name].durability) >= GlobalState["OS:Time"])
				then
					local itemData = Inventory.Items:GetData(slotData.Name)

					if bundleWeapons and itemData?.weapon then
						counts[itemData?.weapon] = (counts[itemData?.weapon] or 0) + slotData.Count
					end
					counts[slotData.Name] = (counts[slotData.Name] or 0) + slotData.Count
				end
				-- 	counts[slotData.Name] = (counts[slotData.Name] or 0) + slotData.Count
			end
			return counts
		end,
		GetTypeCounts = function(self)
			local counts = {}

			if LocalPlayer.state.Character == nil then
				return counts
			end

			local cid = LocalPlayer.state.Character:GetData("ID")
			local slots = GlobalState[("inventory:%s:%s:slots"):format(cid, 1)]
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(cid, 1, slot)]
				if
					_items[slotData.Name].durability == nil
					or ((slotData.MetaData.CreateDate or 0) + _items[slotData.Name].durability)
						>= GlobalState["OS:Time"]
				then
					local itemData = Inventory.Items:GetData(slotData.Name)

					counts[itemData.type] = (counts[itemData.type] or 0) + slotData.Count
				end
				-- 	counts[slotData.Name] = (counts[slotData.Name] or 0) + slotData.Count
			end
			return counts
		end,
		Has = function(self, item, count, bundleWeapons)
			return Inventory.Items:GetCount(item, bundleWeapons) >= count
		end,
		HasType = function(self, itemType, count)
			return (Inventory.Items:GetTypeCounts()[itemType] or 0) >= count
		end,
		GetData = function(self, name)
			if name ~= nil then
				return _items[name]
			else
				return _items
			end
		end,
		GetWithStaticMetadata = function(self, masterKey, mainIdName, textureIdName, gender, data)
			for k, v in pairs(_items) do
				if
					v.staticMetadata ~= nil
					and v.staticMetadata[masterKey] ~= nil
					and v.staticMetadata[masterKey][gender][mainIdName] == data[mainIdName]
					and v.staticMetadata[masterKey][gender][textureIdName] == data[textureIdName]
				then
					return k
				end
			end

			return nil
		end,
	},
	Check = {
		Player = {
			HasItem = function(self, item, count)
				return Inventory.Items:Has(item, count)
			end,
			HasItems = function(self, items)
				for k, v in ipairs(items) do
					if not Inventory.Items:Has(LocalPlayer.state.Char, 1, v.item, v.count) then
						return false
					end
				end
				return true
			end,
			HasAnyItems = function(self, items)
				for k, v in ipairs(items) do
					if Inventory.Items:Has(v.item, v.count) then
						return true
					end
				end

				return false
			end,
		},
		Functions = {
			Vehicle = function(self)
				local player = PlayerPedId()
				local startPos = GetOffsetFromEntityInWorldCoords(player, 0, 0.5, 0)
				local endPos = GetOffsetFromEntityInWorldCoords(player, 0, 5.0, 0)

				local rayHandle = StartShapeTestRay(
					startPos["x"],
					startPos["y"],
					startPos["z"],
					endPos["x"],
					endPos["y"],
					endPos["z"],
					10,
					player,
					0
				)
				local a, b, c, d, veh = GetShapeTestResult(rayHandle)

				if veh ~= 2 then
					local plyCoords = GetEntityCoords(player)
					local offCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.5, 1.0)
					local dist = #(vector3(offCoords.x, offCoords.y, offCoords.z) - plyCoords)

					if dist < 2.5 then
						return veh
					end
				else
					return nil
				end
			end,
		},
	},
	Enable = function(self)
		_disabled = false
	end,
	Disable = function(self)
		_disabled = true
	end,
	Toggle = function(self)
		_disabled = not _disabled
	end,
	Dumbfuck = {
		Open = function(self, data)
			Callbacks:ServerCallback("Inventory:Server:Open", data, function(state)
				if state then
					SecondInventory = { invType = data.invType, owner = data.owner }
				end
			end)
		end,
	},
	Stash = {
		Open = function(self, type, identifier)
			Callbacks:ServerCallback("Stash:Server:Open", {
				type = type,
				identifier = identifier,
			}, function(state)
				if state ~= nil then
					SecondInventory = state
				end
			end)
		end,
	},
	Shop = {
		Open = function(self, identifier)
			Callbacks:ServerCallback("Shop:Server:Open", {
				identifier = identifier,
			}, function(state)
				if state then
					SecondInventory = { invType = state, owner = string.format("shop:%s", identifier) }
				end
			end)
		end,
	},
	Search = {
		Character = function(self, serverId)
			Callbacks:ServerCallback("Inventory:Search", {
				serverId = serverId,
			}, function(owner)
				if owner then
					SecondInventory = { invType = 1, owner = owner }
				end
			end)
		end,
	},
}

RegisterNetEvent("Inventory:client:loadSecondary", function(data)
	Inventory.Set.Secondary:Inventory(data)
	if not Inventory.Set.Player.Data.Open then
		Inventory.Open:Player()
	end
	Inventory.Open:Secondary()
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Inventory", INVENTORY)
end)

local Sounds = {
	["SELECT"] = { id = -1, sound = "SELECT", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["BACK"] = { id = -1, sound = "CANCEL", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["UPDOWN"] = { id = -1, sound = "NAV_UP_DOWN", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["DISABLED"] = { id = -1, sound = "ERROR", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
}
RegisterNUICallback("FrontEndSound", function(data, cb)
	cb("ok")
	if Sounds[data] ~= nil then
		UISounds.Play:FrontEnd(Sounds[data].id, Sounds[data].sound, Sounds[data].library)
	end
end)

RegisterNUICallback("Close", function(data, cb)
	startCd()
	cb(true)
	Inventory.Close:All()
	Inventory:Enable()
end)

RegisterNUICallback("BrokeShit", function(data, cb)
	cb(true)
	startCd()
	Inventory.Close:All()
	Inventory:Enable()
	Notification:Error("Something Is Broken And Your Inventory Isn't Working, You May Need To Hard Nap To Fix")
end)

AddEventHandler("Ped:Client:Died", function()
	Inventory.Close:All()
end)

AddEventHandler("Inventory:Client:Trunk", function(entity, data)
	local vehClass = GetVehicleClass(entity.entity)
	local vehModel = GetEntityModel(entity.entity)

	Callbacks:ServerCallback("Inventory:OpenTrunk", {
		netId = VehToNet(entity.entity),
		class = vehClass,
		model = vehModel,
	}, function(s)
		if s then
			SecondInventory = {
				netId = VehToNet(entity.entity),
				invType = 4,
				owner = Entity(entity.entity).state.VIN,
				class = vehClass,
				model = vehModel,
			}
			trunkOpen = entity.entity
			SetVehicleHasBeenOwnedByPlayer(entity.entity, true)
			SetEntityAsMissionEntity(entity.entity, true, true)
			--SetVehicleDoorOpen(entity.entity, 5, true, false)
			Vehicles.Sync.Doors:Open(entity.entity, 5, false, false)
		end
	end)
end)

RegisterNetEvent("Inventory:Client:InUse", function(state)
	LocalPlayer.state.inUse = state
	SendNUIMessage({
		type = "USE_IN_PROGRESS",
		data = {
			state = state,
		},
	})
end)

RegisterNetEvent("Inventory:Container:Move", function(from, to)
	if _container ~= nil and _container.Slot == from then
		_container.Slot = to
	end
end)

RegisterNetEvent("Inventory:Container:Remove", function(data, from)
	if _container ~= nil and _container.Slot == from then
		Inventory.Close:All()
	end
end)

RegisterNetEvent("Inventory:Client:RefreshPlayer", function()
	Inventory.Set.Player:Refresh()
end)

RegisterNetEvent("Inventory:Client:SetSlot", function(owner, slot, slotData)
	if SecondInventory.owner == owner then
		Inventory.Set.Secondary:Slot(slot, slotData)
	else
		Inventory.Set.Player:Slot(slot, slotData)
	end
end)

RegisterNetEvent("Inventory:Client:RefreshSecondary", function()
	if Inventory.Set.Secondary.Data.Open then
		Inventory.Set.Secondary:Refresh()
	end
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	Callbacks:ServerCallback("Inventory:Server:retreiveStores", {}, function(shopsData)
		Shops = shopsData
		setupStores(shopsData)
		startDropsTick()
	end)

	WeaponsThread()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	Shops = {}
end)

local runningId = 0
RegisterNetEvent("Inventory:Client:Changed", function(type, item, count)
	runningId = runningId + 1
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			alert = {
				id = runningId,
				type = type,
				item = item,
				count = count,
			},
		},
	})
end)

function dropAnim(drop)
	if LocalPlayer.state.doingAction then
		return
	end
	if drop then
		loadAnimDict("pickup_object")
		TaskPlayAnim(PlayerPedId(), "pickup_object", "putdown_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	else
		loadAnimDict("pickup_object")
		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	end
end

function OpenInventory()
	if Inventory:IsEnabled() then
		local playerPed = PlayerPedId()
		local plate
		local requestSecondary = false
		local isPedInVehicle = IsPedInAnyVehicle(playerPed, true)

		-- do trunk check here as well maybe?
		if isPedInVehicle then
			local v = GetVehiclePedIsIn(playerPed)
			if v ~= nil and v > 0 then
				local vin = Entity(v).state.VIN
				if vin ~= nil then
					SecondInventory = {
						netId = VehToNet(v),
						invType = 5,
						owner = vin,
						class = GetVehicleClass(v),
						model = GetEntityModel(v),
					}
					requestSecondary = true
				end
			end
		elseif _inInvPoly ~= nil then
			SecondInventory = { invType = _inInvPoly.inventory.invType, owner = _inInvPoly.inventory.owner }
			requestSecondary = true
		elseif not IsPedFalling(playerPed) and not IsPedClimbing(playerPed) and not IsPedDiving(playerPed) and not LocalPlayer.state.playingCasino then
			local p = promise.new()

			while GetEntitySpeed(playerPed) > 2.5 do
				Citizen.Wait(1)
			end

			if Inventory:IsEnabled() then
				Callbacks:ServerCallback("Inventory:CheckIfNearDropZone", {}, function(dropzone)
					if dropzone ~= nil and not isPedInVehicle and not requestSecondary then
						p:resolve({ invType = 10, owner = dropzone.id, position = dropzone.position })
					else
						local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0, -0.99))
						local retval, groundZ = GetGroundZFor_3dCoord(x, y, z, 0)
						if retval then
							z = groundZ
						end

						p:resolve({
							invType = 10,
							owner = string.format("%s:%s", x, y),
							position = vector3(x, y, z),
						})
					end
				end)
				local s = Citizen.Await(p)
				if s ~= nil then
					SecondInventory = s
					requestSecondary = true
				end
			end
		end
		Inventory.Open:Player()
		if requestSecondary then
			TriggerServerEvent("Inventory:Server:requestSecondaryInventory", SecondInventory)
		end
	end
end

RegisterNUICallback("MoveSlot", function(data, cb)
	cb("OK")
	data.class = SecondInventory.class
	data.model = SecondInventory.model

	Callbacks:ServerCallback("Inventory:MoveItem", data, function(success)
		if success and success.success then
			if SecondInventory.netId then
				local veh = NetToVeh(SecondInventory.netId)
				if veh then
					local vEnt = Entity(veh)
					if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
						TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
					end
				end
			end
			if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
				dropAnim(data.invTypeTo == 10)
			end
		else
			if success and success.reason then
				Notification:Error(success.reason, 3600)
			end
		end
	end)
end)

RegisterNUICallback("SendNotify", function(data, cb)
	cb("OK")
	if data then
		if data.alert == "success" then
			Notification:Success(data.message, data.time)
		elseif data.alert == "warning" then
			Notification:Warning(data.message, data.time)
		elseif data.alert == "error" then
			Notification:Error(data.message, data.time)
		end
	end
end)

RegisterNUICallback("UseItem", function(data, cb)
	cb("OK")
	if LocalPlayer.state.doingAction then
		return
	end
	Callbacks:ServerCallback("Inventory:UseItem", {
		slot = data.slot,
		owner = data.owner,
		invType = data.invType,
	}, function(success) end)
end)

RegisterNetEvent("Inventory:CloseUI", function()
	startCd()
	Inventory.Close:All()
	Inventory:Enable()
end)
