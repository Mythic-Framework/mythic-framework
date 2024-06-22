COMPONENTS.Discord = {
	_required = { "Enabled", "GetMember" },
	_name = "base",
	Enabled = true,
	Request = function(self, method, endpoint, jsondata)
		local data = nil
		PerformHttpRequest(
			"https://discordapp.com/api/" .. endpoint,
			function(errorCode, resultData, resultHeaders)
				data = {
					data = resultData,
					code = errorCode,
					headers = resultHeaders,
				}

				if data.code ~= nil and data.code ~= 200 then
					COMPONENTS.Logger:Error("Discord", "Error: " .. data.code, { console = true })
				end

				if data.data ~= nil then
					data.data = json.decode(data.data)
				end
			end,
			method,
			#jsondata > 0 and json.encode(jsondata) or "",
			{
				["Content-Type"] = "application/json",
				["Authorization"] = "Bot " .. COMPONENTS.Convar.BOT_TOKEN.value,
			}
		)

		while data == nil do
			Wait(0)
		end

		return data
	end,
    GetMember = function(self, discord)
        local endpoint = ("guilds/%s/members/%s"):format(COMPONENTS.Config.Groups.Server, discord)
        return self:Request('GET', endpoint, {})
    end
}

CreateThread(function()
	while true do
		GlobalState["PlayerCount"] = COMPONENTS.Fetch:Count()
		Wait(30000)
	end
end)
