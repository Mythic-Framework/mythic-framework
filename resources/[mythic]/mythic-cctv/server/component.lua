AddEventHandler("Sync:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	CCTV = exports["mythic-base"]:FetchComponent("CCTV")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("CCTV", {
		"Callbacks",
		"Fetch",
		"Chat",
		"CCTV",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		SetupCameras()

		Callbacks:RegisterServerCallback("CCTV:PreviousInGroup", function(source, data, cb)
			local pState = Player(source).state
			if pState.inCCTVCam then
				for i = pState.inCCTVCam.camId - 1, 0, -1 do
					if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
						return CCTV:View(source, i)
					end
				end

				for i = #Config.Cameras, 0, -1 do
					if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
						return CCTV:View(source, i)
					end
				end
			end
		end)

		Callbacks:RegisterServerCallback("CCTV:NextInGroup", function(source, data, cb)
			local pState = Player(source).state
			if pState.inCCTVCam then
				for i = pState.inCCTVCam.camId + 1, #Config.Cameras do
					if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
						return CCTV:View(source, i)
					end
				end
				
				for i = 1, #Config.Cameras do
					if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
						return CCTV:View(source, i)
					end
				end
			end
		end)

		Callbacks:RegisterServerCallback("CCTV:ViewGroup", function(source, data, cb)
			CCTV:ViewGroup(source, data)
		end)
	end)
end)

_CCTV = {
    View = function(self, source, camId)
        local pState = Player(source).state
        if Config.AllowedJobs[pState.onDuty] or Fetch:Source(source).Permissions:IsAdmin() then
			TriggerClientEvent("CCTV:Client:View", source, camId)
		end
    end,
	ViewGroup = function(self, source, camGroup)
		for k, v in ipairs(Config.Cameras) do
			if v?.group == camGroup then
				return CCTV:View(source, k)
			end
		end

		return nil
	end,
	State = {
		Online = function(self, camId)
			local camKey = string.format("CCTV:Camera:%s", camId)
			if GlobalState[camKey] ~= nil then
				GlobalState[camKey].isOnline = true
			end
		end,
		Offline = function(self, camId)
			local camKey = string.format("CCTV:Camera:%s", camId)
			if GlobalState[camKey] ~= nil then
				GlobalState[camKey].isOnline = false
			end
		end,
		Group = {
			Online = function(self, groupId)
				for k, v in pairs(Config.Cameras) do
					if v.group == groupId then
						CCTV.State:Online(k)
					end
				end
			end,
			Offline = function(self, groupId)
				for k, v in pairs(Config.Cameras) do
					if v.group == groupId then
						CCTV.State:Offline(k)
					end
				end
			end,
		}
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["mythic-base"]:RegisterComponent("CCTV", _CCTV)
end)