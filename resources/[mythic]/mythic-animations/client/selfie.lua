
local _selfie = false

RegisterNetEvent('Animations:Client:Selfie', function(toggle)
    if toggle ~= nil then
        if toggle then
            StartSelfieMode()
        else
            StopSelfieMode()
        end
    else
        if _selfie then
            StopSelfieMode()
        else
            StartSelfieMode()
        end
    end
end)

local function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

function StartSelfieMode()
    if not _selfie and not LocalPlayer.state.doingAction then
		Notification.Persistent:Info(
			"camera-info-notif",
			string.format("Camera - Press Enter to take a Selfie")
				.. "<br/>"
				.. string.format("Camera - Press %s to flip the camera", Keybinds:GetKey("secondary_action"))
				.. "<br/>"
				.. string.format("Camera - Press %s to cancel", Keybinds:GetKey("emote_cancel")),
			"camera"
		)
		Hud:Hide()
        local frontCam = true
        _selfie = true

        DestroyMobilePhone()
        Citizen.Wait(10)
        CreateMobilePhone(0)
        CellCamActivate(true, true)
        CellCamDisableThisFrame(true)

        Citizen.CreateThread(function()
            while _selfie do
                if IsControlJustPressed(1, 27) then
                    frontCam = not frontCam
                    CellFrontCamActivate(frontCam)
                elseif IsControlJustPressed(1, 176) then
                    Notification:Success("Touching up picture", 2000)
                    Wait(200)
                    exports['screenshot-basic']:requestScreenshotUpload(tostring("WEBHOOKHERE"), "files[]", function(data)
                        local image = json.decode(data)
                        StopSelfieMode()
                        local attachmentUrl = image.attachments[1].proxy_url
                        local cdnUrl = attachmentUrl:gsub("media.discordapp.net", "cdn.discordapp.com"):gsub("/proxy", "")
                        Notification:Success("URL Copied to clipboard", 2000)
                        Admin:CopyClipboard(cdnUrl)
                    end)
                end
                Citizen.Wait(0)
            end 
        end)
    end
end

function StopSelfieMode()
    if _selfie then
        		Notification.Persistent:Remove("camera-info-notif")
        DestroyMobilePhone()
        Citizen.Wait(10)
        CellCamDisableThisFrame(false)
        CellCamActivate(false, false)
        Hud:Show()

        _selfie = false
    end
end

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _selfie then
		TriggerServerEvent("Selfie:CaptureSelfie")
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
	if _selfie then
		_frontie = not _frontie
		CellFrontCamActivate(_frontie)
		-- if _frontie == false then
		-- 	Animations.Emotes:Play("filmshocking", false, false, false)
		-- else
		-- 	Animations.Emotes:ForceCancel()
		-- end
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if _selfie then
		StopSelfieMode()
	end
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end