UISOUNDS = {
	Play = {
		Generic = function(self, id, sound, library)
			PlaySound(id, sound, library, false, false, true)
		end,
		Coords = function(self, id, sound, library, coords)
			PlaySoundFromCoord(id, sound, coords.x, coords.y, coords.z, library, false, false, true)
		end,
		Entity = function(self, id, sound, library, entity)
			PlaySoundFromCoord(id, sound, entity, library, false, false, true)
		end,
		FrontEnd = function(self, id, sound, library)
			PlaySoundFrontend(id, sound, library, true)
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("UISounds", UISOUNDS)
end)

RegisterNetEvent("UISounds:Client:Play:Generic")
AddEventHandler("UISounds:Client:Play:Generic", function(id, sound, library)
	UISounds.Play:Generic(id, sound, library)
end)

RegisterNetEvent("UISounds:Client:Play:Coords")
AddEventHandler("UISounds:Client:Play:Coords", function(id, sound, library, coords)
	UISounds.Play:Coords(id, sound, library, coords)
end)

RegisterNetEvent("UISounds:Client:Play:Entity")
AddEventHandler("UISounds:Client:Play:Entity", function(id, sound, library, entity)
	UISounds.Play:Entity(id, sound, library, entity)
end)

RegisterNetEvent("UISounds:Client:Play:FrontEnd")
AddEventHandler("UISounds:Client:Play:FrontEnd", function(id, sound, library)
	UISounds.Play:FrontEnd(id, sound, library)
end)
