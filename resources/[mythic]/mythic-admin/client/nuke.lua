_awaitingNuke = false

RegisterNetEvent("Admin:Client:NukeCountdown", function()
    if not LocalPlayer.state.loggedIn then
        return
    end

    _awaitingNuke = true

    ShowNukeSprite()
    Sounds.Play:One("nukeincome.ogg", 0.5)

    Wait(3000)

    for i = 1, 10 do
        Sounds.Play:One("countbeep.ogg", 0.5)
        Wait(2000)
    end
end)

RegisterNetEvent("Admin:Client:Nuke", function()
    if not LocalPlayer.state.loggedIn then
        return
    end

    Sounds.Play:One("nukeboom.ogg", 0.3)

    Wait(500)

    StartScreenEffect("PeyoteIn", 1000, false)

    SetCamEffect(1)
    StartEntityFire(LocalPlayer.state.ped)

    local veh = GetVehiclePedIsIn(LocalPlayer.state.ped, false)

    if IsPedOnFoot(LocalPlayer.state.ped) then
		SetPedToRagdoll(LocalPlayer.state.ped, 5000, 5000, 0, true, true, false)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(LocalPlayer.state.ped, 1, 0.00, 0.00, 5000.00, true, false, false, true)
	elseif IsPedInAnyVehicle(LocalPlayer.state.ped) then
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, 10000.00, 10000.00, true, true, true, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, 10000.00, 10000.00, true, true, true, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, 10000.00, 10000.00, true, true, true, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, 10000.00, 10000.00, true, true, true, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, 10000.00, 10000.00, true, true, true, true)
        Wait(250)
		ApplyForceToEntityCenterOfMass(veh, 1, 0.00, -10000.00, -10000.00, true, true, true, true)
	end

    StopScreenEffect("PeyoteIn")

	StartScreenEffect("Damage", 60000, false)
	StartScreenEffect("RaceTurbo", 60000, false)

    Wait(60000)

    SetCamEffect(0)
	StopAllScreenEffects()

    _awaitingNuke = false
end)

local alpha = 255

function ShowNukeSprite()
    CreateThread(function()
        RequestStreamedTextureDict("Biohazard", true)
		while not HasStreamedTextureDictLoaded("Biohazard") do
			RequestStreamedTextureDict("Biohazard", true)
		    Wait(10)
		end

        local dir = true

        while _awaitingNuke do
            if dir then
                if alpha > 0 then
                    alpha -= 10
                else
                    dir = not dir
                end
            else
                if alpha < 255 then
                    alpha += 10
                else
                    dir = not dir
                end
            end

            DrawSprite("Biohazard", "nukeilluminated", 0.80, 0.80, 0.1205, 0.20, 0.00, 255, 255, 255, alpha)
            Wait(1)
        end
    end)
end
