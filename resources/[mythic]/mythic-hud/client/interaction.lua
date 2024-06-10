local menus = {}
local currentItems = {}
local stack = {}

INTERACTION = {
	Hide = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "SHOW_INTERACTION_MENU",
			data = {
				toggle = false,
			},
		})
	end,
	Show = function(self)
		if not Hud:IsDisabledAllowDead() then
			Phone:Close()
			Inventory.Close:All()

			SetNuiFocus(true, true)
			SetCursorLocation(0.5, 0.5)
			local is = Interaction:ItemsAsMenu(menus)
			stack = { is }
			SendNUIMessage({
				type = "SET_INTERACTION_LAYER",
				data = {
					layer = 0,
				},
			})
			SendNUIMessage({
				type = "SHOW_INTERACTION_MENU",
				data = {
					toggle = true,
				},
			})
			SendNUIMessage({
				type = "SET_INTERACTION_MENU_ITEMS",
				data = {
					items = is,
				},
			})
		end
	end,
	RegisterMenu = function(self, id, label, icon, action, shouldShow, labelFunc)
		if not action then
			action = function()
				
			end
		end
		menus[id] = {
			label = label,
			icon = icon,
			shouldShow = shouldShow,
			action = action,
			labelFunc = labelFunc,
		}
	end,
	ShowMenu = function(self, items)
		local is = Interaction:ItemsAsMenu(items)
		stack[#stack + 1] = is
		SendNUIMessage({
			type = "SET_INTERACTION_LAYER",
			data = {
				layer = #stack,
			},
		})
		SendNUIMessage({
			type = "SET_INTERACTION_MENU_ITEMS",
			data = {
				items = is,
			},
		})
	end,
	Back = function(self)
		stack[#stack] = nil
		SendNUIMessage({
			type = "SET_INTERACTION_LAYER",
			data = {
				layer = #stack - 1,
			},
		})
		SendNUIMessage({
			type = "SET_INTERACTION_MENU_ITEMS",
			data = {
				items = stack[#stack],
			},
		})
	end,
	ItemsAsMenu = function(self, items)
		local is = {}
		for k, v in pairs(items) do
			local show = true
			if v.shouldShow then
				show = v.shouldShow()
			end

			if v.labelFunc then
				v.label = v.labelFunc()
			end

			if show then
				table.insert(is, {
					id = k,
					label = v.label,
					icon = v.icon,
					action = v.action,
					data = show,
				})
			end
		end
		return is
	end,
}

RegisterNUICallback("Interaction:Trigger", function(data, cb)
	for k, v in ipairs(stack[#stack]) do
		if v.id == data.id then
			if v.action then
				v.action(v.data)
			end
			UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
			return cb(true)
		end
	end
	cb(true)
end)

RegisterNUICallback("Interaction:Hide", function(data, cb)
	Interaction:Hide()
	UISounds.Play:FrontEnd(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	cb(true)
end)

RegisterNUICallback("Interaction:Back", function(data, cb)
	Interaction:Back()
	UISounds.Play:FrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	cb(true)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Interaction", INTERACTION)
end)
