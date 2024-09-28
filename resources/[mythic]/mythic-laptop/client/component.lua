_tabletProp = nil

LAPTOP = {
	Open = function(self)
		Inventory.Close:All()
		Animations.Emotes:ForceCancel()
		Interaction:Hide()
		LocalPlayer.state.laptopOpen = true
		DisplayRadar(true)
		Hud:ShiftLocation(true)
		SendNUIMessage({ type = "LAPTOP_VISIBLE" })
		SetNuiFocus(true, true)

		CreateThread(function()
			local playerPed = PlayerPedId()
			LoadAnim("amb@code_human_in_bus_passenger_idles@female@tablet@base")
			LoadModel(`prop_cs_tablet`)

			local _tabletProp = CreateObject(`prop_cs_tablet`, GetEntityCoords(playerPed), 1, 1, 0)
			AttachEntityToEntity(
				_tabletProp,
				playerPed,
				GetPedBoneIndex(playerPed, 60309),
				0.02,
				-0.01,
				-0.03,
				0.0,
				0.0,
				-10.0,
				1,
				0,
				0,
				0,
				2,
				1
			)

			while LocalPlayer.state.laptopOpen and _loggedIn do
				if
					not IsEntityPlayingAnim(
						playerPed,
						"amb@code_human_in_bus_passenger_idles@female@tablet@base",
						"base",
						3
					)
				then
					TaskPlayAnim(
						playerPed,
						"amb@code_human_in_bus_passenger_idles@female@tablet@base",
						"base",
						3.0,
						3.0,
						-1,
						49,
						0,
						false,
						false,
						false
					)
				end
				Wait(250)
			end

			StopAnimTask(playerPed, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0)
			DeleteEntity(_tabletProp)
		end)
	end,
	Close = function(self, forced)
		LocalPlayer.state.laptopOpen = false
		Laptop:ResetRoute()

		if forced then
			SendNUIMessage({ type = "LAPTOP_NOT_VISIBLE_FORCED" })
		end

		SendNUIMessage({ type = "ALERTS_RESET" })

		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			DisplayRadar(LocalPlayer.state.Character and hasValue(LocalPlayer.state.Character:GetData("States"), "GPS"))
		end

		Hud:ShiftLocation(LocalPlayer.state.Character and hasValue(LocalPlayer.state.Character:GetData("States"), "GPS"))
		SetNuiFocus(false, false)
		--TriggerEvent("UI:Client:Close", "laptop")
	end,
	IsOpen = function(self)
		return LocalPlayer.state.laptopOpen
	end,
	ResetRoute = function(self)
		SendNUIMessage({ type = "CLEAR_HISTORY" })
	end,
	Permissions = {
		Load = function(self, p)
			SendNUIMessage({
				type = "LOAD_PERMS",
				data = p,
			})
		end,
	},
	IsAppUsable = function(self, app)
		if type(app) == "table" then
			return true
		else
			local appdata = LAPTOP_APPS[app]

			if appdata and hasValue(LocalPlayer.state.Character:GetData("LaptopApps").installed, app) then
				if appdata.restricted then
					for k, v in pairs(appdata.restricted) do
						if v then
							if k == "state" then
								if type(v) == "string" then
									if not hasValue(LocalPlayer.state.Character:GetData("States"), v) then
										return false
									end
								else
									for j, b in ipairs(v) do
										if not hasValue(LocalPlayer.state.Character:GetData("States"), b) then
											return false
										end
									end
								end
							elseif k == "job" then
								if not Jobs.Permissions:HasJob(v) then
									return false
								end
							elseif k == "laptopPermission" then
								if not Laptop.Permissions:HasPermission(v.app, v.permission) then
									return false
								end
							elseif k == "reputation" then
								if not Reputation:HasLevel(v.repuation, appdata.restricted.repuationAmount or 0) then
									return false
								end
							end
						end
					end
					return true
				else
					return true
				end
			end
			return false
		end
	end,
	Data = {
		Set = function(self, key, data)
			SendNUIMessage({ type = "SET_DATA", data = { type = key, data = data } })
		end,
		Add = function(self, type, data, key)
			SendNUIMessage({ type = "ADD_DATA", data = { type = type, data = data, key = key } })
		end,
		Update = function(self, type, id, data)
			SendNUIMessage({ type = "UPDATE_DATA", data = { type = type, id = id, data = data } })
		end,
		Remove = function(self, key, id)
			SendNUIMessage({ type = "REMOVE_DATA", data = { type = key, id = id } })
		end,
		Reset = function(self)
			SendNUIMessage({ type = "RESET_DATA" })
		end,
	},
	Notification = {
		Add = function(self, title, description, time, duration, app, actions, notifData)
			if
				not LocalPlayer.state.loggedIn or not hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP")
			then
				return
			end

			local appUsable = Laptop:IsAppUsable(app)
			if
				_settings.notifications
				and (type(app) == "table" or (appUsable and not _settings.appNotifications[app]))
				and not Jail:IsJailed()
			then
				SendNUIMessage({
					type = "NOTIF_ADD",
					data = {
						notification = {
							title = title,
							description = description,
							time = (time - 1000),
							duration = duration,
							app = app,
							action = actions,
							data = notifData,
							show = true,
						},
					},
				})

				Sounds.Play:One("notification1.ogg", 0.1 * (_settings.volume / 100))
			end
		end,
		AddWithId = function(self, id, title, description, time, duration, app, actions, notifData)
			SendNUIMessage({
				type = "NOTIF_ADD",
				data = {
					notification = {
						_id = id,
						title = title,
						description = description,
						time = (time - 1000),
						duration = duration,
						app = app,
						action = actions,
						data = notifData,
						show = true,
					},
				},
			})

			if not LocalPlayer.state.laptopOpen then
				Sounds.Play:One("notification1.ogg", 0.1 * (_settings.volume / 100))
			end
		end,
		Update = function(self, id, title, description, skipSound)
			SendNUIMessage({
				type = "NOTIF_UPDATE",
				data = {
					id = id,
					title = title,
					description = description,
				},
			})

			if not skipSound and not LocalPlayer.state.laptopOpen then
				Sounds.Play:One("notification1.ogg", 0.1 * (_settings.volume / 100))
			end
		end,
		Remove = function(self, id)
			SendNUIMessage({
				type = "NOTIF_HIDE",
				data = {
					id = id,
				},
			})
		end,
		Reset = function(self)
			SendNUIMessage({ type = "NOTIF_DISMISS_ALL" })
		end,
	},
	Permissions = {
		HasPermission = function(self, app, permission)
			local myPerms = LocalPlayer.state.Character:GetData("LaptopPermissions")
			if not app or not permission then
				return false
			else
				return LaptopPermissions[app][permission]
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Laptop", LAPTOP)
end)

RegisterNetEvent("Laptop:Client:Close", function()
	Laptop:Close()
end)

RegisterNUICallback("CloseLaptop", function(data, cb)
	cb("OK")
	Laptop:Close()
end)

RegisterNetEvent(
	"Laptop:Client:Notifications:Add",
	function(title, description, time, duration, app, actions, notifData)
		Laptop.Notification:Add(title, description, time, duration, app, actions, notifData)
	end
)

RegisterNetEvent(
	"Laptop:Client:Notifications:AddWithId",
	function(id, title, description, time, duration, app, actions, notifData)
		Laptop.Notification:AddWithId(id, title, description, time, duration, app, actions, notifData)
	end
)

RegisterNetEvent("Laptop:Client:Notifications:Update", function(id, title, description)
	Laptop.Notification:Update(id, title, description)
end)

RegisterNetEvent("Laptop:Client:Notifications:Remove", function(id)
	Laptop.Notification:Remove(id)
end)

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end

function LoadModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(10)
	end
end
