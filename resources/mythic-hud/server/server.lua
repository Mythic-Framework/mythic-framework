local _uircd = {}

AddEventHandler("Hud:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Hud", {
		"Fetch",
		"Logger",
		"Chat",
		"Callbacks",
		"Inventory",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Callbacks:RegisterServerCallback("HUD:RemoveBlindfold", function(source, data, cb)
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local tarState = Player(data).state
					if tarState.isBlindfolded then
						Callbacks:ClientCallback(source, "HUD:PutOnBlindfold", "Removing Blindfold", function(isSuccess)
							if isSuccess then
								if Inventory:AddItem(char:GetData("SID"), "blindfold", 1, {}, 1) then
									tarState.isBlindfolded = false
								else
									Execute:Client(source, "Notification", "Error", "Failed Adding Item")
									cb(false)
								end
							end
						end)
					else
						Execute:Client(source, "Notification", "Error", "Target Not Blindfolded")
						cb(false)
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		end)

		Inventory.Items:RegisterUse("blindfold", "HUD", function(source, item, itemData)
			Callbacks:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
				if target ~= nil then
					local tarState = Player(target).state
					if not tarState.isBlindfolded then
						Callbacks:ClientCallback(
							source,
							"HUD:PutOnBlindfold",
							"Blindfolding",
							function(isSuccess)
								if isSuccess then
									if tarState.isCuffed then
										if
											Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
										then
											tarState.isBlindfolded = true
										else
											Execute:Client(
												source,
												"Notification",
												"Error",
												"Failed Removing Item"
											)
										end
									else
										Execute:Client(source, "Notification", "Error", "Target Not Cuffed")
									end
								end
							end
						)
					else
						Execute:Client(source, "Notification", "Error", "Target Already Blindfolded")
					end
				else
					Execute:Client(source, "Notification", "Error", "Nobody Near To Blindfold")
				end
			end)
		end)
	end)
end)

function RegisterChatCommands()
	Chat:RegisterCommand("uir", function(source, args, rawCommand)
		if not _uircd[source] or os.time() > _uircd[source] then
			TriggerClientEvent("UI:Client:Reset", source, true)
			_uircd[source] = os.time() + (60 * 5)
		else
			Chat.Send.System:Single(source, "You're Trying To Do This Too Much, Stop.")
		end
	end, {
		help = "Resets UI",
	})

	Chat:RegisterAdminCommand("testblindfold", function(source, args, rawCommand)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Player(source).state.isBlindfolded = not Player(source).state.isBlindfolded
			end
		end
	end, {
		help = "Test Blindfold",
	})

	-- Chat:RegisterAdminCommand("notif", function(source, args, rawCommand)
	-- 	exports["mythic-base"]:FetchComponent("Execute"):Client(source, "Notification", "Success", "This is a test, lul")
	-- end, {
	-- 	help = "Test Notification",
	-- })

	-- Chat:RegisterAdminCommand("list", function(source, args, rawCommand)
	-- 	TriggerClientEvent("ListMenu:Client:Test", source)
	-- end, {
	-- 	help = "Test List Menu",
	-- })

	-- Chat:RegisterAdminCommand("input", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Input:Client:Test", source)
	-- end, {
	-- 	help = "Test Input",
	-- })

	-- Chat:RegisterAdminCommand("confirm", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Confirm:Client:Test", source)
	-- end, {
	-- 	help = "Test Confirm Dialog",
	-- })

	-- Chat:RegisterAdminCommand("skill", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Skillbar", source)
	-- end, {
	-- 	help = "Test Skill Bar",
	-- })

	-- Chat:RegisterAdminCommand("scan", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scanner", source)
	-- end, {
	-- 	help = "Test Scanner",
	-- })

	-- Chat:RegisterAdminCommand("sequencer", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Sequencer", source)
	-- end, {
	-- 	help = "Test Sequencer",
	-- })

	-- Chat:RegisterAdminCommand("keypad", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Keypad", source)
	-- end, {
	-- 	help = "Test Keypad",
	-- })

	-- Chat:RegisterAdminCommand("scrambler", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scrambler", source)
	-- end, {
	-- 	help = "Test Scrambler",
	-- })

	-- Chat:RegisterAdminCommand("memory", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Memory", source)
	-- end, {
	-- 	help = "Test Memory",
	-- })
end
