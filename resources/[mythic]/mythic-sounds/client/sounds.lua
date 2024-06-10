local _sounds = {}

AddEventHandler("Sounds:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Sounds", {
		"Callbacks",
		"Logger",
		"Sounds",
		"UISounds",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Sounds", SOUNDS)
end)

RegisterNUICallback("SoundEnd", function(data, cb)
	Logger:Trace("Sounds", ("^2Stopping Sound %s For ID %s^7"):format(data.file, data.source))
	if _sounds[data.source] ~= nil and _sounds[data.source][data.file] ~= nil then
		_sounds[data.source][data.file] = nil
	end
end)

SOUNDS = {}
SOUNDS.Do = {
	Loop = {
		One = function(self, soundFile, soundVolume)
			Logger:Trace("Sounds", ("^2Looping Sound %s On Client Only^7"):format(soundFile))
			_sounds[LocalPlayer.state.ID] = _sounds[LocalPlayer.state.ID] or {}
			_sounds[LocalPlayer.state.ID][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = LocalPlayer.state.ID,
				file = soundFile,
				volume = soundVolume,
			})
		end,
		Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
			Logger:Trace(
				"Sounds",
				("^2Looping Sound %s Per Request From %s For Distance %s^7"):format(soundFile, playerNetId, maxDistance)
			)

			local isFromMe = false
			local pPed = PlayerPedId()

			local tPlayer = GetPlayerFromServerId(playerNetId)
			local tPed = GetPlayerPed(tPlayer)

			if playerNetId == LocalPlayer.state.ID then
				isFromMe = true
				tPed = LocalPlayer.state.ped
			end

			local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if isFromMe then
				vol = soundVolume
			elseif
				(tPed ~= 0 and distIs > maxDistance)
				or tPed == 0
				or not LocalPlayer.state.loggedIn
				or (tPlayer == -1)
			then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			Citizen.CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					tPlayer = GetPlayerFromServerId(playerNetId)
					tPed = GetPlayerPed(tPlayer)

					local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
					vol = soundVolume * (1.0 - (distIs / maxDistance))

					if isFromMe then
						vol = soundVolume
					elseif
						(tPed ~= 0 and distIs > maxDistance)
						or tPed == 0
						or not LocalPlayer.state.loggedIn
						or (tPlayer == -1)
					then
						vol = 0
					end

					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Citizen.Wait(100)
				end
			end)
		end,
		Location = function(self, playerNetId, location, maxDistance, soundFile, soundVolume)
			Logger:Trace(
				"Sounds",
				("^2Looping Sound %s Per Request From %s at location %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					json.encode(location),
					maxDistance
				)
			)
			local distIs = #(GetEntityCoords(LocalPlayer.state.ped) - location)
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if distIs > maxDistance then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "loopSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			Citizen.CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					local distIs = #(GetEntityCoords(LocalPlayer.state.ped) - location)
					vol = soundVolume * (1.0 - (distIs / maxDistance))
					if distIs > maxDistance or not LocalPlayer.state.loggedIn then
						vol = 0
					end
					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Citizen.Wait(100)
				end
			end)
		end,
	},
	Play = {
		One = function(self, soundFile, soundVolume)
			Logger:Trace("Sounds", ("^2Playing Sound %s On Client Only^7"):format(soundFile))
			_sounds[LocalPlayer.state.ID] = _sounds[LocalPlayer.state.ID] or {}
			_sounds[LocalPlayer.state.ID][soundFile] = {
				file = soundFile,
				volume = soundVolume,
			}
			SendNUIMessage({
				action = "playSound",
				source = LocalPlayer.state.ID,
				file = soundFile,
				volume = soundVolume,
			})
		end,
		Distance = function(self, playerNetId, maxDistance, soundFile, soundVolume)
			playerNetId = tonumber(playerNetId)
			Logger:Trace(
				"Sounds",
				("^2Playing Sound %s Once Per Request From %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					maxDistance
				)
			)

			local pPed = PlayerPedId()

			local isFromMe = false

			local tPlayer = GetPlayerFromServerId(playerNetId)
			local tPed = GetPlayerPed(tPlayer)

			if playerNetId == LocalPlayer.state.ID then
				isFromMe = true
				tPed = LocalPlayer.state.ped
			end

			local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if isFromMe then
				vol = soundVolume
			elseif
				(tPed ~= 0 and distIs > maxDistance)
				or (tPed == 0)
				or not LocalPlayer.state.loggedIn
				or (tPlayer == -1)
			then
				vol = 0
			end

			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "playSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			Citizen.CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					tPlayer = GetPlayerFromServerId(playerNetId)
					tPed = GetPlayerPed(tPlayer)

					local distIs = #(GetEntityCoords(pPed) - GetEntityCoords(tPed))
					vol = soundVolume * (1.0 - (distIs / maxDistance))

					if isFromMe then
						vol = soundVolume
					elseif
						(tPed ~= 0 and distIs > maxDistance)
						or (tPed == 0)
						or not LocalPlayer.state.loggedIn
						or (tPlayer == -1)
					then
						vol = 0
					end

					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Citizen.Wait(100)
				end
			end)
		end,
		Location = function(self, playerNetId, location, maxDistance, soundFile, soundVolume)
			Logger:Trace(
				"Sounds",
				("^2Playing Sound %s Once Per Request From %s at location %s For Distance %s^7"):format(
					soundFile,
					playerNetId,
					json.encode(location),
					maxDistance
				)
			)
			local distIs = #(
					vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
					- vector3(location.x, location.y, location.z)
				)
			local vol = soundVolume * (1.0 - (distIs / maxDistance))
			if distIs > maxDistance then
				vol = 0
			end
			_sounds[playerNetId] = _sounds[playerNetId] or {}
			_sounds[playerNetId][soundFile] = {
				file = soundFile,
				volume = soundVolume,
				distance = maxDistance,
			}
			SendNUIMessage({
				action = "playSound",
				source = playerNetId,
				file = soundFile,
				volume = vol,
			})

			Citizen.CreateThread(function()
				while _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil do
					local distIs = #(
							vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
							- vector3(location.x, location.y, location.z)
						)
					vol = soundVolume * (1.0 - (distIs / maxDistance))
					if distIs > maxDistance then
						vol = 0
					end
					SendNUIMessage({
						action = "updateVol",
						source = playerNetId,
						file = soundFile,
						volume = vol,
					})
					Citizen.Wait(100)
				end
			end)
		end,
	},
	Stop = {
		One = function(self, soundFile)
			Logger:Trace("Sounds", ("^2Stopping Sound %s On Client^7"):format(soundFile))
			if _sounds[LocalPlayer.state.ID] ~= nil and _sounds[LocalPlayer.state.ID][soundFile] ~= nil then
				_sounds[LocalPlayer.state.ID][soundFile] = nil
				SendNUIMessage({
					action = "stopSound",
					source = LocalPlayer.state.ID,
					file = soundFile,
				})
			end
		end,
		Distance = function(self, playerNetId, soundFile)
			Logger:Trace("Sounds", ("^2Stopping Sound %s Per Request From %s^7"):format(soundFile, playerNetId))
			if _sounds[playerNetId] ~= nil and _sounds[playerNetId][soundFile] ~= nil then
				_sounds[playerNetId][soundFile] = nil
				SendNUIMessage({
					action = "stopSound",
					source = playerNetId,
					file = soundFile,
				})
			end
		end,
	},
	Fade = {
		One = function(self, soundFile)
			Logger:Trace("Sounds", ("^2Stopping Sound %s On Client^7"):format(soundFile))
			if _sounds[LocalPlayer.state.ID] ~= nil and _sounds[LocalPlayer.state.ID][soundFile] ~= nil then
				_sounds[LocalPlayer.state.ID][soundFile] = nil
				SendNUIMessage({
					action = "fadeSound",
					source = LocalPlayer.state.ID,
					file = soundFile,
				})
			end
		end,
	}
}

SOUNDS.Play = {
	One = function(self, soundFile, soundVolume)
		Sounds.Do.Play:One(soundFile, soundVolume)
	end,
	Distance = function(self, maxDistance, soundFile, soundVolume)
		Callbacks:ServerCallback("Sounds:Play:Distance", {
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
	Location = function(self, location, maxDistance, soundFile, soundVolume)
		Callbacks:ServerCallback("Sounds:Play:Location", {
			location = location,
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
}

SOUNDS.Loop = {
	One = function(self, soundFile, soundVolume)
		Sounds.Do.Loop:One(soundFile, soundVolume)
	end,
	Distance = function(self, maxDistance, soundFile, soundVolume)
		Callbacks:ServerCallback("Sounds:Loop:Distance", {
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
	Location = function(self, location, maxDistance, soundFile, soundVolume)
		Callbacks:ServerCallback("Sounds:Loop:Location", {
			location = location,
			maxDistance = maxDistance,
			soundFile = soundFile,
			soundVolume = soundVolume,
		})
	end,
}

SOUNDS.Stop = {
	One = function(self, soundFile)
		Sounds.Do.Stop:One(soundFile)
	end,
	Distance = function(self, pNet, soundFile)
		Callbacks:ServerCallback("Sounds:Stop:Distance", {
			soundFile = soundFile,
		})
	end,
	Location = function(self, pNet, soundFile)
		Callbacks:ServerCallback("Sounds:Stop:Distance", {
			soundFile = soundFile,
		})
	end,
}

SOUNDS.Fade = {
	One = function(self, soundFile)
		Sounds.Do.Fade:One(soundFile)
	end,
}

RegisterNetEvent("Sounds:Client:Play:One", function(playetNedId, soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Play:One(playetNedId, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Play:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Play:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Play:Location", function(playerNetId, location, maxDistance, soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Play:Location(playerNetId, location, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:One", function(soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Loop:One(soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Loop:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Loop:Location", function(playerNetId, location, maxDistance, soundFile, soundVolume)
	if Sounds == nil then
		return
	end
	Sounds.Do.Loop:Location(playerNetId, location, maxDistance, soundFile, soundVolume)
end)

RegisterNetEvent("Sounds:Client:Stop:One", function(soundFile)
	if Sounds == nil then
		return
	end
	Sounds.Do.Stop:One(soundFile)
end)

RegisterNetEvent("Sounds:Client:Stop:Distance", function(playerNetId, soundFile)
	if Sounds == nil then
		return
	end
	Sounds.Do.Stop:Distance(playerNetId, soundFile)
end)

RegisterNetEvent("Sounds:Client:Stop:All", function(playerNetId, soundFile)
	if Sounds == nil then
		return
	end
	if _sounds[playerNetId] ~= nil then
		for k, v in pairs(_sounds[playerNetId]) do
			Sounds.Do.Stop:One(playerNetId, v)
		end
		_sounds[playerNetId] = nil
	end
end)
