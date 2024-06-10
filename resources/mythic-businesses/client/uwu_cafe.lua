local catAnims = {
    sleep = {
        animDict = 'creatures@cat@amb@world_cat_sleeping_ground@enter',
        anim = 'enter',
        blendIn = 1.0,
        blendOut = -1,
        duration = -1,
        flag = 2,
    },
    sit = {
        animDict = 'creatures@cat@amb@world_cat_sleeping_ledge@idle_a',
        anim = 'idle_a',
        blendIn = 1.0,
        blendOut = -1,
        duration = -1,
        flag = 2,
    }
}

local cats = {
    {
        name = 'Colin',
        coords = vector3(-582.193, -1054.765, 21.2),
        heading = 271.607,
        anim = catAnims.sit,
        texture = 1,
    },
    {
        name = 'Dave',
        coords = vector3(-575.49, -1049.231, 22.5),
        heading = 178.0,
        --anim = catAnims.sit,
        texture = 2,
    },
    {
        name = 'Cat Helman',
        coords = vector3(-575.418, -1068.439, 25.667),
        heading = 1.0,
        anim = catAnims.sit,
        texture = 0,
    },
    {
        name = 'Velma',
        coords = vector3(-574.051, -1056.300, 21.2),
        heading = 64.0,
        anim = catAnims.sit,
        texture = 0,
    },
    {
        name = 'Judy',
        coords = vector3(-576.401, -1054.913, 21.2),
        heading = 64.0,
        anim = catAnims.sit,
        texture = 1,
    },
}

AddEventHandler('Businesses:Client:Startup', function()
    for k, v in ipairs(cats) do
        PedInteraction:Add('uwu-cat-'..k, `a_c_cat_01`, v.coords, v.heading, 25.0, {
            { icon = 'cat', text = 'Name: ' .. v.name, event = 'F', data = {}, minDist = 2.0, jobs = false },
        }, 'cat', false, true, v.anim, {
            texture = v.texture,
        })
    end

    Polyzone.Create:Box('uwu_cafe_door', vector3(-581.05, -1068.09, 22.34), 3.0, 1.6, {
        heading = 0,
        --debugPoly=true,
        minZ = 21.34,
        maxZ = 24.54
    }, {})
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == 'uwu_cafe_door' then
        local h = GetEntityHeading(LocalPlayer.state.ped)
        if h > 310 or h < 50 then
            Sounds.Play:Distance(15, "bell.ogg", 0.3)
        end
    end
end)