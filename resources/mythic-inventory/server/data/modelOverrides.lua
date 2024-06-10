_modelOverride = {
    [`taxi`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`moonbeam`] = {
        trunk = { slots = 36, capacity = 500 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`flatbed`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`rubble`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`mixer`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`mixer2`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`tiptruck`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`tiptruck2`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`mule`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },  
    [`mule2`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    }, 
    [`hauler`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`packer`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`phantom`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`biff`] = {
        trunk = { slots = 20, capacity = 300 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`trash`] = {
        trunk = { slots = 20, capacity = 100 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`stockade`] = {
        trunk = { slots = 20, capacity = 50 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`dubsta3`] = {
        trunk = { slots = 36, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`cararv`] = {
        trunk = { slots = 36, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`guardianrv`] = {
        trunk = { slots = 36, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`sandroamer`] = {
        trunk = { slots = 36, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`sandkingrv`] = {
        trunk = { slots = 36, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    },
    [`blazer`] = {
        trunk = { slots = 8, capacity = 40 },
        glovebox = { slots = 0, capacity = 5 },
    },
    [`blazer4`] = {
        trunk = { slots = 8, capacity = 40 },
        glovebox = { slots = 0, capacity = 5 },
    },
    [`caddy`] = {
        trunk = { slots = 12, capacity = 60 },
        glovebox = { slots = 0, capacity = 5 },
    },
}

local fullTrailers = {
    `trailers`,
    `trailers2`,
    `trailers3`,
    `tvtrailer`,
    `trailers4`,
    `trailerlarge`
}

for k, v in ipairs(fullTrailers) do
    _modelOverride[v] = {
        trunk = { slots = 64, capacity = 1200 },
        glovebox = { slots = 4, capacity = 50 },
    }
end