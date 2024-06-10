AddEventHandler("Confirm:Shared:DependencyUpdate", RetrieveInfoOverlayComponents)
function RetrieveInfoOverlayComponents()
	InfoOverlay = exports["mythic-base"]:FetchComponent("InfoOverlay")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("InfoOverlay", {
		"InfoOverlay",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveInfoOverlayComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("InfoOverlay", INFOOVERLAY)
end)

-- RegisterNetEvent("Confirm:Client:Test", function()
-- 	Confirm:Show(
-- 		"Test Input",
-- 		{
-- 			yes = "Confirm:Test:Yes",
-- 			no = "Confirm:Test:No",
-- 		},
-- 		"This is a test confirm dialog, neat",
-- 		{
-- 			test = "penis",
-- 		}
-- 	)
-- end)

local _isOpen = false

INFOOVERLAY = {
	Show = function(self, title, description)
        _isOpen = true

		SendNUIMessage({
			type = "SHOW_INFO_OVERLAY",
			data = {
				info = {
                    label = title,
                    description = description,
                },
			},
		})
	end,
	Close = function(self)
        _isOpen = false

		SendNUIMessage({
			type = "CLOSE_INFO_OVERLAY",
		})
	end,
    IsOpen = function(self)
        return _isOpen
    end
}
