function scaleformShit(scaleform, obj, jailer, name, sid, duration, date)
	local position = GetOffsetFromEntityInWorldCoords(obj, -0.2, -0.0132 - (GetEntitySpeed(PlayerPedId()) / 50), 0.105)
	local scale = vector3(0.41, 0.23, 1.0)
	local push = GetEntityRotation(obj, 2)

	DrawScaleformMovie_3d(
		scaleform,
		position,
		180.0 + push.x,
		0.0 - GetEntityRoll(obj),
		GetEntityHeading(obj),
		1.0,
		0.8,
		4.0,
		scale,
		0
	)

	if not date then
		date = "Unknown Date"
	end

	if not duration then
		duration = 0
	end

	if not name then
		name = "No Name"
	end

	PushScaleformMovieFunction(scaleform, "SET_BOARD")
	PushScaleformMovieFunctionParameterString(jailer:upper())
	PushScaleformMovieFunctionParameterString(date)
	PushScaleformMovieFunctionParameterString(string.format("Sentenced to %s Months", duration))
	PushScaleformMovieFunctionParameterString(name)
	PushScaleformMovieFunctionParameterFloat(0.0)
	PushScaleformMovieFunctionParameterString(sid)
	PushScaleformMovieFunctionParameterFloat(0.0)
	PopScaleformMovieFunctionVoid()
end

function DoBoardShit(jailer, duration, date)
	local scf = RequestScaleformMovie("mugshot_board_01")
	while not HasScaleformMovieLoaded(scf) do
		Wait(1)
	end

	local myname = string.format(
		"%s %s",
		LocalPlayer.state.Character:GetData("First"),
		LocalPlayer.state.Character:GetData("Last")
	)
	local mysid = LocalPlayer.state.Character:GetData("SID")

	CreateThread(function()
		while LocalPlayer.state.loggedIn and _doingMugshot do
            local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, `prop_police_id_board`, 0, 0, 0)
			if obj then
				scaleformShit(scf, obj, jailer, myname, mysid, duration, date)
			end
			Wait(1)
		end
	end)
end
