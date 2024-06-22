local particleDict = "scr_indep_fireworks"
local AnimationDict = "anim@mp_fireworks"

local fireworkProps = {
    { prop = `ind_prop_firework_03`, anim = "place_firework_3_box" },
    { prop = `ind_prop_firework_04`, anim = "place_firework_4_cone"},
    { prop = `ind_prop_firework_02`, anim = "place_firework_2_cylinder"},
    { prop = `ind_prop_firework_01`, anim = "place_firework_1_rocket"},
    { prop = `ind_prop_firework_03`, anim = "place_firework_3_box" },
    { prop = `ind_prop_firework_03`, anim = "place_firework_3_box" },
}

AddEventHandler("Businesses:Client:Startup", function()
    Callbacks:RegisterClientCallback("Fireworks:Use", function(data, cb)
        local firework = fireworkProps[data]
        loadModel(firework.prop)

        RequestAnimDict("anim@mp_fireworks")
        while not HasAnimDictLoaded("anim@mp_fireworks") do
            Wait(1)
        end

        TaskPlayAnim(LocalPlayer.state.ped, "anim@mp_fireworks", firework.anim, 8.0, -1, -1, 0, 0, 0, 0, 0)

        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0.0, 0.5, -1.02))

        local prop = CreateObject(firework.prop, x, y, z, true, false, true)
        SetEntityHeading(prop, GetEntityHeading(LocalPlayer.state.ped))
        PlaceObjectOnGroundProperly(prop)

        Notification:Info("RUN AWAY!")

        Wait(9000)

        cb(x, y, z)

        Wait(8500)

        DeleteObject(prop)
    end)
end)

RegisterNetEvent("Fireworks:Client:Play", function(firework, x, y, z)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
    end

    RequestNamedPtfxAsset("proj_xmas_firework")
    while not HasNamedPtfxAssetLoaded("proj_xmas_firework") do
        Wait(1)
    end

    if firework == 1 then -- cl4
        for i = 1, 8 do
            UseParticleFxAssetNextCall(particleDict)
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
            Wait(1500)
        end

        Wait(2500)

        UseParticleFxAssetNextCall(particleDict)
        local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 1.8, false, false, false, false)
    elseif firework == 2 then
        for i = 1, 5 do
            UseParticleFxAssetNextCall(particleDict)
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
            Wait(1500)
        end

        Wait(1000)

        UseParticleFxAssetNextCall(particleDict)
        local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
    elseif firework == 3 then
        for i = 1, 5 do
            UseParticleFxAssetNextCall(particleDict)
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
            Wait(1500)
        end

        Wait(1000)

        for i = 1, 3 do
            UseParticleFxAssetNextCall(particleDict)
            local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)

            Wait(2500)
        end
    elseif firework == 4 then
        UseParticleFxAssetNextCall(particleDict)
        StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", x, y, z, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
    elseif firework == 5 then
        for i = 1, 5 do
            local randomNess = math.random() * 0.5 + 0.8
            UseParticleFxAssetNextCall(particleDict)
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z + 30.0, 0.0, 0.0, 0.0, randomNess, false, false, false, false)

            UseParticleFxAssetNextCall("proj_xmas_firework")
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_firework_xmas_ring_burst_rgw", x, y, z + 30.0, 0.0, 0.0, 0.0, randomNess, false, false, false, false)

            Wait(1500)
        end

        Wait(1000)

        for i = 1, 3 do
            local randomness = math.random() * 1.5 + 1.8

            UseParticleFxAssetNextCall(particleDict)
            local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z + 30.0, 0.0, 0.0, 0.0, randomness, false, false, false, false)

            UseParticleFxAssetNextCall("proj_xmas_firework")
            local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_firework_xmas_ring_burst_rgw", x, y, z + 30.0, 0.0, 0.0, 0.0, randomness - 1.8, false, false, false, false)

            Wait(2500)
        end
    end
end)