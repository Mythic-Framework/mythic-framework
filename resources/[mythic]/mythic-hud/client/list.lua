AddEventHandler("ListMenu:Shared:DependencyUpdate", RetrieveListComponents)
function RetrieveListComponents()
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("ListMenu", {
		"Notification",
		"Utils",
		"UISounds",
		"ListMenu",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveListComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("ListMenu", LISTMENU)
end)

RegisterNetEvent("ListMenu:Client:Test", function()
    ListMenu:Show({
        main = {
            label = 'Test Menu',
            items = {
                {
                    label = 'Test Input',
                    description = 'Triggers input HUD option which lets us get input direct from user, NEAT!',
                    event = 'Input:Client:Test'
                },
                {
                    label = 'Test Item',
                    description = 'Test Item Description',
                    submenu = 'test'
                },
                {
                    label = 'Test Item Disabled',
                    description = 'Test Item Disabled Description',
                    disabled = true
                },
            }
        },
        test = {
            label = 'Test Sub Menu',
            items = {
                {
                    label = 'Test Sub Menu Item',
                    description = 'Test Sub Menu Item Description',
                    event = 'ListMenu:Client:MenuTest'
                },
            }
        },
    })
end)

RegisterNUICallback("ListMenu:Clicked", function(data, cb)
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    ListMenu:Close()
    TriggerEvent(data.event, data.data)
	cb("ok")
end)

RegisterNUICallback("ListMenu:Back", function(data, cb)
	UISounds.Play:FrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerEvent('ListMenu:GoBack')
	cb("ok")
end)

RegisterNUICallback("ListMenu:SubMenu", function(data, cb)
	UISounds.Play:FrontEnd(-1, "CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerEvent('ListMenu:EnterSubMenu', data.submenu)
	cb("ok")
end)

RegisterNUICallback("ListMenu:Close", function(data, cb)
	UISounds.Play:FrontEnd(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    ListMenu:Close()
    TriggerEvent('ListMenu:Close')
	cb("ok")
end)

LISTMENU = {
	Show = function(self, menus)
        SetNuiFocus(true, true)
		SendNUIMessage({
			type = "SET_LIST_MENU",
			data = {
                menus = menus
            },
		})
	end,
	Close = function(self)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "CLOSE_LIST_MENU",
        })
	end,
}
