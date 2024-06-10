AddEventHandler("Sounds:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Sounds", {
		"Fetch",
		"Callbacks",
		"Logger",
		"Sounds",
		"Middleware",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()

		Middleware:Add("Characters:Logout", function(source)
			TriggerClientEvent("Sounds:Client:Stop:All", -1, source)
		end, 2)

		Middleware:Add("playerDropped", function(source)
			TriggerClientEvent("Sounds:Client:Stop:All", -1, source)
		end, 2)
	end)
end)

SOUNDS = {
	Play = {
		One = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:One", clientNetId, soundFile, soundVolume)
		end,
		Distance = function(self, clientNetId, maxDistance, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:Distance", -1, clientNetId, maxDistance, soundFile, soundVolume)
		end,
		Location = function(self, clientNetId, Location, maxDistance, soundFile, soundVolume)
			TriggerClientEvent(
				"Sounds:Client:Play:Location",
				-1,
				clientNetId,
				Location,
				maxDistance,
				soundFile,
				soundVolume
			)
		end,
		All = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Play:One", -1, clientNetId, soundFile, soundVolume)
		end,
		Job = function(self, clientNetId, soundFile, job, soundVolume)
			local players = Fetch:All()
			for k, v in pairs(players) do
				local char = v:GetData("Character")
				if char ~= nil then
					local myDuty = Player(v:GetData('Source')).state.onDuty
					if myDuty and job[myDuty] then
						TriggerClientEvent(
							"Sounds:Client:Play:One",
							v:GetData("Source"),
							clientNetId,
							soundFile,
							soundVolume
						)
					end
				end
			end
		end,
	},
	Loop = {
		One = function(self, clientNetId, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Loop:One", clientNetId, soundFile, soundVolume)
		end,
		Distance = function(self, clientNetId, maxDistance, soundFile, soundVolume)
			TriggerClientEvent("Sounds:Client:Loop:Distance", -1, clientNetId, maxDistance, soundFile, soundVolume)
		end,
		Location = function(self, clientNetId, Location, maxDistance, soundFile, soundVolume)
			TriggerClientEvent(
				"Sounds:Client:Loop:Location",
				-1,
				clientNetId,
				Location,
				maxDistance,
				soundFile,
				soundVolume
			)
		end,
	},
	Stop = {
		One = function(self, clientNetId, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:One", clientNetId, soundFile)
		end,
		Distance = function(self, clientNetId, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:Distance", -1, clientNetId, soundFile)
		end,
		Location = function(self, clientNetId, location, soundFile)
			TriggerClientEvent("Sounds:Client:Stop:Distance", -1, clientNetId, soundFile)
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Sounds", SOUNDS)
end)

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Sounds:Play:Distance", function(source, data, cb)
		Sounds.Play:Distance(source, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	Callbacks:RegisterServerCallback("Sounds:Play:Location", function(source, data, cb)
		Sounds.Play:Location(source, data.location, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	Callbacks:RegisterServerCallback("Sounds:Loop:Distance", function(source, data, cb)
		Sounds.Loop:Distance(source, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	Callbacks:RegisterServerCallback("Sounds:Loop:Location", function(source, data, cb)
		Sounds.Loop:Location(source, data.location, data.maxDistance, data.soundFile, data.soundVolume)
	end)

	Callbacks:RegisterServerCallback("Sounds:Stop:Distance", function(source, data, cb)
		Sounds.Stop:Distance(source, data.soundFile)
	end)
end

AddEventHandler("Sounds:Server:Play:One", function(soundFile, soundVolume)
	Sounds.Play:One(soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	Sounds.Play:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:All", function(playerNetId, soundFile, soundVolume)
	Sounds.Play:All(playerNetId, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Play:Job", function(playerNetId, soundFile, job, soundVolume)
	Sounds.Play:Job(playerNetId, soundFile, job, soundVolume)
end)

AddEventHandler("Sounds:Server:Loop:One", function(soundFile, soundVolume)
	Sounds.Loop:One(soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Loop:Distance", function(playerNetId, maxDistance, soundFile, soundVolume)
	Sounds.Loop:Distance(playerNetId, maxDistance, soundFile, soundVolume)
end)

AddEventHandler("Sounds:Server:Stop:One", function(soundFile)
	Sounds.Stop:One(soundFile)
end)

AddEventHandler("Sounds:Server:Stop:Distance", function(playerNetId, soundFile)
	Sounds.Stop:Distance(playerNetId, soundFile)
end)
