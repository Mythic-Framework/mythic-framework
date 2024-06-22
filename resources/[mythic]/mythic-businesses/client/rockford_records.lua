local spawnedDJ = false
local spawnedLaptop = false

AddEventHandler("Businesses:Client:Startup", function()
    Targeting.Zones:AddBox(
        "rockford-stage",
        "headphones",
        vector3(-1004.11, -249.95, 39.47),
        1.0,
        1.2,
        {
            heading = 325,
            --debugPoly=true,
            minZ = 38.47,
            maxZ = 40.27
        },
        {
            {
                icon = "headphones",
                text = "Toggle DJ Stand",
                event = "Businesses:Client:RockfordStage",
                jobPerms = {
                    {
                        job = "rockford_records",
                        reqDuty = true,
                    }
                },
            },
        },
        3.0,
        true
    )

    Polyzone.Create:Box("rockford-stage-area", vector3(-1002.26, -257.48, 39.04), 12.2, 16.8, {
        heading = 323,
        --debugPoly=true,
        minZ = 38.04,
        maxZ = 42.44
    }, {})
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if id == "rockford-stage-area" then
        if GlobalState["rockford_dj"] then
            CreateDJStuff()
        end
    end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == "rockford-stage-area" then
        DeleteDJStuff()
    end
end)

AddEventHandler("Businesses:Client:RockfordStage", function()
    Callbacks:ServerCallback("Businesses:ToggleRockfordStage", {}, function(state)
        if state then
            Notification:Success("DJ Stand Enabled", 5000, "speakers")
        else
            Notification:Error("DJ Stand Disabled", 5000, "speakers")
        end
    end)
end)

function CreateDJStuff()
    DeleteDJStuff()

    loadModel(`sf_prop_sf_dj_desk_02a`)
    spawnedDJ = CreateObject(`sf_prop_sf_dj_desk_02a`, vector3(-1004.811, -255.6505, 38.46912), false, false)
    SetEntityHeading(spawnedDJ, 233.111)
    FreezeEntityPosition(spawnedDJ, true)

    loadModel(`prop_laptop_01a`)
    spawnedLaptop = CreateObject(`prop_laptop_01a`, vector3(-1004.537, -255.8471, 39.52119), false, false)
    SetEntityHeading(spawnedLaptop, 233.111)
    FreezeEntityPosition(spawnedLaptop, true)
end

function DeleteDJStuff()
    if spawnedDJ then
        DeleteEntity(spawnedDJ)
        DeleteEntity(spawnedLaptop)
        spawnedDJ = nil
        spawnedLaptop = nil
    end
end

AddStateBagChangeHandler("rockford_dj", nil, function(bagName, key, value, _unused, replicated)
    if Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped), "rockford-stage-area") then
        if value then
            CreateDJStuff()
        else
            DeleteDJStuff()
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeleteDJStuff()
    end
end)

function loadModel(model)
	if IsModelInCdimage(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(5)
		end
	end
end