_tabletProp = nil

LAPTOP = {
	Open = function(self)
		Inventory.Close:All()
		Interaction:Hide()
		LocalPlayer.state.laptopOpen = true
		DisplayRadar(true)
		Hud:ShiftLocation(true)
		SendNUIMessage({ type = "LAPTOP_VISIBLE" })
		SetNuiFocus(true, true)

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			LoadAnim('amb@code_human_in_bus_passenger_idles@female@tablet@base')
			LoadModel(`prop_cs_tablet`)

			_tabletProp = CreateObject(`prop_cs_tablet`, GetEntityCoords(playerPed), 1, 1, 0)
			AttachEntityToEntity(_tabletProp, playerPed, GetPedBoneIndex(playerPed, 60309), 0.02, -0.01, -0.03, 0.0, 0.0, -10.0, 1, 0, 0, 0, 2, 1)

			while LocalPlayer.state.tabletOpen and _loggedIn do
				if not IsEntityPlayingAnim(playerPed, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3) then
					TaskPlayAnim(playerPed, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3.0, 3.0, -1, 49, 0, false, false, false)
				end
				Citizen.Wait(250)
			end

			StopAnimTask(playerPed, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3.0)
			DeleteEntity(_tabletProp)
		end)
	end,
	Close = function(self)
		LocalPlayer.state.laptopOpen = false
		Laptop:ResetRoute()
		SendNUIMessage({ type = "ALERTS_RESET" })
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			DisplayRadar(false)
		end
		Hud:ShiftLocation(false)
		SetNuiFocus(false, false)
		TriggerEvent("UI:Client:Close", "laptop")
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
			return appdata ~= nil
				and hasValue(LocalPlayer.state.Character:GetData("Apps").installed, app)
				and (
					not appdata.restricted
					or (
						(
							appdata.restricted.job
							and Jobs.Permissions:HasJob(
								appdata.restricted.job,
								appdata.restricted.workplace,
								appdata.restricted.grade
							)
						)
						or (appdata.restricted.state and hasValue(
							LocalPlayer.state.Character:GetData("States"),
							appdata.restricted.state
						))
						or (appData.restricted.jobPermission and Jobs.Permissions:HasJob(
							appdata.restricted.job,
							appdata.restricted.workplace,
							appdata.restricted.grade,
							nil,
							false,
							appdata.restricted.jobPermission
						))
						or (appdata.restricted.laptopPermission and Laptop.Permissions:HasPermission(
							appdata.restricted.laptopPermission.app,
							appdata.restricted.laptopPermission.permission
						))
						or (
							appdata.restricted.repuation
							and Reputation:HasLevel(
								appdata.restricted.repuation,
								appdata.restricted.repuationAmount or 0
							)
						)
					)
				)
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

				if not LocalPlayer.state.laptopOpen and (Laptop:IsAppUsable(app)) then
					Sounds.Play:One(_settings.texttone, 0.1 * (_settings.volume / 100))
				end
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
		end,
		Update = function(self, id, title, description)
			SendNUIMessage({
				type = "NOTIF_UPDATE",
				data = {
					id = id,
					title = title,
					description = description,
				},
			})
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

RegisterNetEvent("Laptop:Client:Notifications:Add", function(title, description, time, duration, app, actions, notifData)
	Laptop.Notification:Add(title, description, time, duration, app, actions, notifData)
end)

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
