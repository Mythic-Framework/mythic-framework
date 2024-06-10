camMoveUp, camMoveDown, camMoveLeft, camMoveRight = false, false, false, false

function RegisterKeyBinds()
	Keybinds:Add("cctv_disconnect", "ESCAPE", "keyboard", "CCTV - Close Camera", function()
		if LocalPlayer.state.inCCTVCam then
			CCTV:Close()
		end
	end)

	Keybinds:Add("cctv_previous", "LEFT", "keyboard", "CCTV - Previous Camera", function()
		if LocalPlayer.state.inCCTVCam then
            if GlobalState[LocalPlayer.state.inCCTVCam.camKey]?.group ~= nil then
				Callbacks:ServerCallback("CCTV:PreviousInGroup", {})
            end
		end
	end)

	Keybinds:Add("cctv_next", "RIGHT", "keyboard", "CCTV - Next Camera", function()
		if LocalPlayer.state.inCCTVCam then
            if GlobalState[LocalPlayer.state.inCCTVCam.camKey]?.group ~= nil then
				Callbacks:ServerCallback("CCTV:NextInGroup", {})
            end
		end
	end)

	Keybinds:Add("cctv_up", "W", "keyboard", "CCTV - Rotate Up", function()
		if LocalPlayer.state.inCCTVCam then
			camMoveUp = true
		end
	end, function()
		if camMoveUp then
			camMoveUp = false
		end
	end)

	Keybinds:Add("cctv_down", "S", "keyboard", "CCTV - Rotate Down", function()
		if LocalPlayer.state.inCCTVCam then
			camMoveDown = true
		end
	end, function()
		if camMoveDown then
			camMoveDown = false
		end
	end)

	Keybinds:Add("cctv_left", "A", "keyboard", "CCTV - Rotate Left", function()
		if LocalPlayer.state.inCCTVCam then
			camMoveLeft = true
		end
	end, function()
		if camMoveLeft then
			camMoveLeft = false
		end
	end)

	Keybinds:Add("cctv_right", "D", "keyboard", "CCTV - Rotate Right", function()
		if LocalPlayer.state.inCCTVCam then
			camMoveRight = true
		end
	end, function()
		if camMoveRight then
			camMoveRight = false
		end
	end)
end
