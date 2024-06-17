local Enabled = false -- Change this to enable client mod menu checks!
function CheckVariables()
	for i, v in ipairs(GlobalState["BlacklistedVars"]) do
		if _G[v] ~= nil then
			local reason = Config.Messages.ProhibitedVariables:gsub("{VARIABLE}", v)
			Callbacks:ServerCallback("Pwnzor:Trigger", {
				check = "var",
				match = v,
			}, function(s)
				_G[v] = nil
				return
			end)
		end
	end
end

if Enabled then
	CreateThread(function()
		while GlobalState["BlacklistedVars"] == nil do
			Wait(1000)
		end

		while true do
			Wait(30000)
			CheckVariables()
		end
	end)
else
	return "Nil"
end
