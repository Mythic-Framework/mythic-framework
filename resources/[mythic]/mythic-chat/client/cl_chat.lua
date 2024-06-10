local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false

RegisterNetEvent("chatMessage")
RegisterNetEvent("chat:addTemplate")
RegisterNetEvent("chat:addMessage")
RegisterNetEvent("chat:addSuggestion")
RegisterNetEvent("chat:addSuggestions")
RegisterNetEvent("chat:removeSuggestion")
RegisterNetEvent("chat:clearChat")

-- internal events
RegisterNetEvent("__cfx_internal:serverPrint")

RegisterNetEvent("_chat:messageEntered")

AddEventHandler("CarPark:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Chat.Refresh:Commands()
	Chat.Refresh:Themes()
end

AddEventHandler("Characters:Client:Spawn", function()
	Citizen.CreateThread(function()
		SetTextChatEnabled(false)
		SetNuiFocus(false)

		while LocalPlayer.state.loggedIn do
			Citizen.Wait(1)

			if not chatInputActive then
				if IsControlPressed(0, 245) then
					chatInputActive = true
					chatInputActivating = true
					SendNUIMessage({
						type = "ON_OPEN",
					})
				end
			end

			if chatInputActivating then
				if not IsControlPressed(0, 245) then
					SetNuiFocus(true)
					chatInputActivating = false
				end
			end
		end
	end)
end)

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("CarPark", {
		"Chat",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	SendNUIMessage({
		type = "ON_SCREEN_STATE_CHANGE",
		data = {
			shouldHide = true,
			inputting = false,
		},
	})
end)

RegisterNetEvent("UI:Client:Reset", function(apps)
	SendNUIMessage({
		type = "ON_SCREEN_STATE_CHANGE",
		data = {
			shouldHide = true,
			inputting = false,
		},
	})
	SendNUIMessage({
		type = "ON_CLEAR",
	})
end)

CHAT = {
	Open = function(self) end,
	Close = function(self) end,
	Refresh = {
		Commands = function(self)
			if GetRegisteredCommands then
				local registeredCommands = GetRegisteredCommands()

				local suggestions = {}

				for _, command in ipairs(registeredCommands) do
					if IsAceAllowed(("command.%s"):format(command.name)) then
						table.insert(suggestions, {
							name = "/" .. command.name,
							help = "",
						})
					end
				end

				TriggerEvent("chat:addSuggestions", suggestions)
			end
		end,
		Themes = function(self)
			local themes = {}

			for resIdx = 0, GetNumResources() - 1 do
				local resource = GetResourceByFindIndex(resIdx)

				if GetResourceState(resource) == "started" then
					local numThemes = GetNumResourceMetadata(resource, "chat_theme")

					if numThemes > 0 then
						local themeName = GetResourceMetadata(resource, "chat_theme")
						local themeData = json.decode(GetResourceMetadata(resource, "chat_theme_extra") or "null")

						if themeName and themeData then
							themeData.baseUrl = "nui://" .. resource .. "/"
							themes[themeName] = themeData
						end
					end
				end
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Chat", CHAT)
end)

--deprecated, use chat:addMessage
AddEventHandler("chatMessage", function(author, color, text)
	local args = { text }
	if author ~= "" then
		table.insert(args, 1, author)
	end
	SendNUIMessage({
		type = "ON_MESSAGE",
		data = {
			message = {
				color = color,
				args = args,
			},
		},
	})
end)

AddEventHandler("__cfx_internal:serverPrint", function(msg)
	if msg == "" then
		return
	end
	SendNUIMessage({
		type = "ON_MESSAGE",
		data = {
			message = {
				args = { msg },
			},
		},
	})
end)

AddEventHandler("chat:addMessage", function(message)
	SendNUIMessage({
		type = "ON_MESSAGE",
		data = {
			message = message,
		},
	})
end)

AddEventHandler("chat:addSuggestion", function(name, help, params)
	SendNUIMessage({
		type = "ON_SUGGESTION_ADD",
		data = {
			suggestion = {
				name = name,
				help = help,
				params = params or nil,
			},
		},
	})
end)

AddEventHandler("chat:addSuggestions", function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = "ON_SUGGESTION_ADD",
			data = {
				suggestion = suggestion,
			},
		})
	end
end)

AddEventHandler("chat:removeSuggestion", function(name)
	SendNUIMessage({
		type = "ON_SUGGESTION_REMOVE",
		data = {
			name = name,
		},
	})
end)

RegisterNetEvent("chat:resetSuggestions")
AddEventHandler("chat:resetSuggestions", function()
	SendNUIMessage({
		type = "ON_COMMANDS_RESET",
	})
end)

AddEventHandler("chat:addTemplate", function(id, html)
	SendNUIMessage({
		type = "ON_TEMPLATE_ADD",
		data = {
			template = {
				id = id,
				html = html,
			},
		},
	})
end)

AddEventHandler("chat:clearChat", function()
	SendNUIMessage({
		type = "ON_CLEAR",
	})
end)

RegisterNUICallback("chatResult", function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)
	
	if not data.cancelled then
		local id = PlayerId()

		--deprecated
		local r, g, b = 0, 0x99, 255

		if data.message:sub(1, 1) == "/" then
			ExecuteCommand(data.message:sub(2))
		else
			TriggerServerEvent("_chat:messageEntered", GetPlayerName(id), { r, g, b }, data.message)
		end
	end

	cb("ok")
end)

AddEventHandler("onClientResourceStart", function(resName)
	Wait(500)

	if Chat ~= nil then
		Chat.Refresh:Commands()
		Chat.Refresh:Themes()
	end
end)

AddEventHandler("onClientResourceStop", function(resName)
	Wait(500)

	if Chat ~= nil then
		Chat.Refresh:Commands()
		Chat.Refresh:Themes()
	end
end)

RegisterNUICallback("loaded", function(data, cb)
	TriggerServerEvent("chat:init")

	if Chat ~= nil then
		Chat.Refresh:Commands()
		Chat.Refresh:Themes()
	end

	cb("ok")

	Citizen.SetTimeout(5000, function()
		chatLoaded = true
	end)
end)
