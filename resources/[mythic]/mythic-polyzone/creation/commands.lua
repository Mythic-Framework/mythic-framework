RegisterNetEvent("polyzone:createcommand", function(args)
	local zoneType = args[1]
	if zoneType == nil then
		TriggerEvent("chat:addMessage", {
			template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
			args = { "Please add zone type to create (poly, circle, box)!" },
		})
		return
	end
	if zoneType ~= "poly" and zoneType ~= "circle" and zoneType ~= "box" then
		TriggerEvent("chat:addMessage", {
			template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
			args = { "Zone type must be one of: poly, circle, box" },
		})
		return
	end
	local name = nil
	if #args >= 2 then
		name = args[2]
	else
		name = GetUserInput("Enter name of zone:")
	end
	if name == nil or name == "" then
		TriggerEvent("chat:addMessage", {
			template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
			args = { "Please add a name!" },
		})
		return
	end
	TriggerEvent("polyzone:pzcreate", zoneType, name, args)
end)

RegisterNetEvent("polyzone:pzcomboinfo")
