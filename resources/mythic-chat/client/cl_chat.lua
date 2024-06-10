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

CHAT = {
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
		message = {
			color = color,
			args = args,
		},
	})
end)

AddEventHandler("__cfx_internal:serverPrint", function(msg)
	if msg == "" then return end
	SendNUIMessage({
		type = "ON_MESSAGE",
		message = {
			args = { msg },
		},
	})
end)

AddEventHandler("chat:addMessage", function(message)
	SendNUIMessage({
		type = "ON_MESSAGE",
		message = message,
	})
end)

AddEventHandler("chat:addSuggestion", function(name, help, params)
	SendNUIMessage({
		type = "ON_SUGGESTION_ADD",
		suggestion = {
			name = name,
			help = help,
			params = params or nil,
		},
	})
end)

AddEventHandler("chat:addSuggestions", function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = "ON_SUGGESTION_ADD",
			suggestion = suggestion,
		})
	end
end)

AddEventHandler("chat:removeSuggestion", function(name)
	SendNUIMessage({
		type = "ON_SUGGESTION_REMOVE",
		name = name,
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
		template = {
			id = id,
			html = html,
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

	if not data.canceled then
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

	chatLoaded = true

	cb("ok")
end)

Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)

	while true do
		Wait(0)

		if not chatInputActive then
			if
				IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]]
			then
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

		if chatLoaded then
			local shouldBeHidden = false

			if IsScreenFadedOut() or IsPauseMenuActive() then
				shouldBeHidden = true
			end

			if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
				chatHidden = shouldBeHidden

				SendNUIMessage({
					type = "ON_SCREEN_STATE_CHANGE",
					shouldHide = shouldBeHidden,
				})
			end
		end
	end
end)
