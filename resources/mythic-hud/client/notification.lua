Notification = {
	Clear = function(self)
		SendNUIMessage({
			type = "CLEAR_ALERTS",
		})
	end,
	Success = function(self, message, duration, icon)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "success",
					message = message,
					duration = duration,
					icon = icon,
				},
			},
		})
	end,
	Warn = function(self, message, duration, icon)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "warning",
					message = message,
					duration = duration,
					icon = icon,
				},
			},
		})
	end,
	Error = function(self, message, duration, icon)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "error",
					message = message,
					duration = duration,
					icon = icon,
				},
			},
		})
	end,
	Info = function(self, message, duration, icon)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "info",
					message = message,
					duration = duration,
					icon = icon,
				},
			},
		})
	end,
	Standard = function(self, message, duration, icon)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "standard",
					message = message,
					duration = duration,
					icon = icon,
				},
			},
		})
	end,
	Custom = function(self, message, duration, icon, style)
		if duration == nil then
			duration = 2500
		end

		SendNUIMessage({
			type = "ADD_ALERT",
			data = {
				notification = {
					type = "custom",
					message = message,
					duration = duration,
					icon = icon,
					style = style,
				},
			},
		})
	end,
	Persistent = {
		Success = function(self, id, message, icon)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "success",
						message = message,
						duration = -1,
						icon = icon,
					},
				},
			})
		end,
		Warn = function(self, id, message, icon)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "warning",
						message = message,
						duration = -1,
						icon = icon,
					},
				},
			})
		end,
		Error = function(self, id, message, icon)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "error",
						message = message,
						duration = -1,
						icon = icon,
					},
				},
			})
		end,
		Info = function(self, id, message, icon)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "info",
						message = message,
						duration = -1,
						icon = icon,
					},
				},
			})
		end,
		Standard = function(self, id, message, icon)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "standard",
						message = message,
						duration = -1,
						icon = icon,
					},
				},
			})
		end,
		Custom = function(self, id, message, icon, style)
			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					notification = {
						_id = id,
						type = "custom",
						message = message,
						duration = -1,
						icon = icon,
						style = style,
					},
				},
			})
		end,
		Remove = function(self, id)
			SendNUIMessage({
				type = "HIDE_ALERT",
				data = {
					id = id,
				},
			})
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Notification", Notification)
end)
