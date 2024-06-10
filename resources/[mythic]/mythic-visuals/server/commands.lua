AddEventHandler("Visuals:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Visuals = exports["mythic-base"]:FetchComponent("Visuals")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Visuals", {
		"Chat",
        "Visuals",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
	end)
end)

VISUALS = {
    Toggle = function(self, source)
        TriggerClientEvent("Visuals:Client:Toggle", source)
    end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Visuals", VISUALS)
end)

function RegisterChatCommands()
	Chat:RegisterCommand("visuals", function(source, args, rawCommand)
        Visuals:Toggle(source)
	end, {
		help = "THIS WILL CAUSE FRAME LAG FOR A FEW SECONDS.\n\nToggle Brighter Emergency Lights. NOTE: This will also make some other lights brighter, IE: interior dash lights, taxi roof advert lights, etc.",
	}, -1)
end

function ParseCommandData(cmd)
	if cmd:lower() == "true" then
		return true
	elseif cmd:lower() == "false" then
		return false
	elseif tonumber(cmd) then
		return tonumber(cmd)
	else
		return cmd
	end
end
