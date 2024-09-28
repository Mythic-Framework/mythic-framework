_limited = false
_payphone = false

PHONE = {
	Open = function(self)
		_limited = false
		_payphone = false
		Inventory.Close:All()
		Interaction:Hide()
		LocalPlayer.state.phoneOpen = true
		DisplayRadar(true)
		Hud:ShiftLocation(true)
		PhonePlayIn()
		SendNUIMessage({ type = "PHONE_VISIBLE" })
		SetNuiFocus(true, true)
	end,
	OpenLimited = function(self)
		_limited = true
		_payphone = false
		Inventory.Close:All()
		Interaction:Hide()
		LocalPlayer.state.phoneOpen = true
		PhonePlayIn()
		SendNUIMessage({ type = "PHONE_VISIBLE_LIMITED" })
		SetNuiFocus(true, true)
	end,
	OpenPayphone = function(self)
		_limited = true
		_payphone = true
		Inventory.Close:All()
		Interaction:Hide()
		LocalPlayer.state.phoneOpen = true
		PhonePlayIn()
		SendNUIMessage({ type = "PHONE_VISIBLE_LIMITED" })
		SetNuiFocus(true, true)
	end,
	Close = function(self, forced, doJankyStuff)
		LocalPlayer.state.phoneOpen = false
		_openCd = true
		if not doJankyStuff then
			Phone:ResetRoute()
		end
		if forced then
			SendNUIMessage({ type = "PHONE_NOT_VISIBLE_FORCED" })
		end
		if _limited then
			Phone.Call:End()
		end
		SendNUIMessage({ type = "ALERTS_RESET" })
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			DisplayRadar(false)
		end
		Hud:ShiftLocation(false)
		if not Phone.Call:Status() or _limited then
			PhonePlayOut()
		end
		SetNuiFocus(false, false)
		TriggerEvent("UI:Client:Close", "phone")
		_limited = false
	end,
	IsOpen = function(self)
		return LocalPlayer.state.phoneOpen
	end,
	ResetRoute = function(self)
		SendNUIMessage({ type = "CLEAR_HISTORY" })
	end,
	-- InsertUSB = function(self, data)
	-- 	SendNUIMessage({ type = "INSTALL_USB", data = data })
	-- end,
	-- RemoveUSB = function(self)
	-- 	SendNUIMessage({ type = "REMOVE_USB" })
	-- end,
	ReceiveShare = function(self, data)
		SendNUIMessage({ type = "RECEIVE_SHARE", data = data })
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
			local appdata = PHONE_APPS[app]
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
						or (appdata.restricted.jobPermission and Jobs.Permissions:HasJob(
							appdata.restricted.job,
							appdata.restricted.workplace,
							appdata.restricted.grade,
							nil,
							false,
							appdata.restricted.jobPermission
						))
						or (appdata.restricted.phonePermission and Phone.Permissions:HasPermission(
							appdata.restricted.phonePermission.app,
							appdata.restricted.phonePermission.permission
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
				not LocalPlayer.state.loggedIn or not hasValue(LocalPlayer.state.Character:GetData("States"), "PHONE")
			then
				return
			end

			local appUsable = Phone:IsAppUsable(app)
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

				if not LocalPlayer.state.phoneOpen and (Phone:IsAppUsable(app)) then
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
	SetExpanded = function(self, state)
		SendNUIMessage({
			type = "SET_EXPANDED",
			data = {
				expanded = state,
			},
		})
	end,
	Permissions = {
		HasPermission = function(self, app, permission)
			local myPerms = LocalPlayer.state.Character:GetData("PhonePermissions")
			if not app or not permission then
				return false
			else
				return PhonePermissions[app][permission]
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Phone", PHONE)
end)

RegisterNetEvent("Phone:Client:Close", function()
	Phone:Close()
end)

RegisterNUICallback("OpenCamera", function(data, cb)
	Phone:Close(true)
	Wait(300)
	TriggerEvent("Animations:Client:Selfie", true)
end)

-- Register it above this
RegisterNUICallback("ClosePhone", function(data, cb)
	cb("OK")
	Phone:Close()
end)

RegisterNetEvent("Phone:Client:Notifications:Add", function(title, description, time, duration, app, actions, notifData)
	Phone.Notification:Add(title, description, time, duration, app, actions, notifData)
end)

RegisterNetEvent(
	"Phone:Client:Notifications:AddWithId",
	function(id, title, description, time, duration, app, actions, notifData)
		Phone.Notification:AddWithId(id, title, description, time, duration, app, actions, notifData)
	end
)

RegisterNetEvent("Phone:Client:Notifications:Update", function(id, title, description)
	Phone.Notification:Update(id, title, description)
end)

RegisterNetEvent("Phone:Client:Notifications:Remove", function(id)
	Phone.Notification:Remove(id)
end)
