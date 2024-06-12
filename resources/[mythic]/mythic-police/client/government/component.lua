local govDutyPoints = {
    {
        center = vector3(-587.98, -206.59, 38.23),
        length = 0.8,
        width = 0.8,
        options = {
            heading = 30,
            --debugPoly=true,
            minZ = 37.23,
            maxZ = 38.83
        }
    },
}

AddEventHandler("Police:Shared:DependencyUpdate", GovComponents)
function GovComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
    Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Police", {
		"Callbacks",
		"Inventory",
		"Notification",
		"Blips",
		"Targeting",
		"Jobs",
        "PedInteraction",
        "ListMenu",
        "Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end
		GovComponents()

        local govServices = {
            {
				icon = "id-card",
				text = "Purchase ID ($500)",
				event = "Government:Client:BuyID",
			},
			{
				icon = "certificate",
				text = "License Services",
				event = "Government:Client:BuyLicense",
			},
            {
                icon = "gavel",
                text = "Public Records",
                event = "Government:Client:AccessPublicRecords",
            },
            {
                icon = "clipboard-check",
                text = "Go On Duty",
                event = "Government:Client:OnDuty",
                jobPerms = {
                    {
                        job = 'government',
                        reqOffDuty = true,
                    }
                },
            },
            {
                icon = "clipboard",
                text = "Go Off Duty",
                event = "Government:Client:OffDuty",
                jobPerms = {
                    {
                        job = 'government',
                        reqDuty = true,
                    }
                },
            },
            {
                icon = "shop-lock",
                text = "DOJ Shop",
                event = "Government:Client:DOJShop",
                jobPerms = {
                    {
                        job = 'government',
                        workplace = 'doj',
                        reqDuty = true,
                    }
                },
            },
        }

		PedInteraction:Add("govt-services", `a_f_m_eastsa_02`, vector3(-552.412, -202.760, 37.239), 337.363, 25.0, govServices, "bell-concierge")
        -- Targeting.Zones:AddBox("govt-services", "bell-concierge", vector3(-555.92, -186.01, 38.22), 2.0, 2.0, {
        --     heading = 28,
        --     --debugPoly=true,
        --     minZ = 37.22,
        --     maxZ = 39.62
        -- }, govServices, 3.0, true)

        for k, v in ipairs(govDutyPoints) do
            Targeting.Zones:AddBox("gov-info-" .. k, "gavel", v.center, v.length, v.width, v.options, {
                {
                    icon = "clipboard-check",
                    text = "Go On Duty",
                    event = "Government:Client:OnDuty",
                    jobPerms = {
                        {
                            job = 'government',
                            reqOffDuty = true,
                        }
                    },
                },
                {
                    icon = "clipboard",
                    text = "Go Off Duty",
                    event = "Government:Client:OffDuty",
                    jobPerms = {
                        {
                            job = 'government',
                            reqDuty = true,
                        }
                    },
                },
                {
                    icon = "gavel",
                    text = "Public Records",
                    event = "Government:Client:AccessPublicRecords",
                },
            }, 3.0, true)
        end

        Polyzone.Create:Box("courtroom", vector3(-571.17, -207.02, 38.77), 18.2, 19.6, {
            heading = 30,
            --debugPoly=true,
            minZ = 36.97,
            maxZ = 47.37
        }, {})

        Targeting.Zones:AddBox("court-gavel", "gavel", vector3(-575.8, -210.3, 38.77), 0.8, 0.8, {
            heading = 30,
            --debugPoly=true,
            minZ = 37.77,
            maxZ = 39.37
        }, {
            {
                icon = "gavel",
                text = "Use Gavel",
                event = "Government:Client:UseGavel",
                -- jobPerms = {
                --     {
                --         job = 'government',
                --         reqDuty = true,
                --     }
                -- },
            },
        }, 3.0, true)
	end)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	Blips:Add('courthouse', "Courthouse", vector3(-538.916, -214.852, 37.650), 419, 0, 0.9)
end)

AddEventHandler("Government:Client:UseGavel", function()
    TriggerServerEvent("Government:Server:Gavel")
end)

RegisterNetEvent("Government:Client:Gavel", function()
    if not LocalPlayer.state.loggedIn then return end
    local coords = GetEntityCoords(LocalPlayer.state.ped)
    if Polyzone:IsCoordsInZone(coords, "courtroom") then
        Sounds.Play:One("gavel.ogg", 0.6)
    end
end)

AddEventHandler('Government:Client:DOJShop', function()
    Inventory.Shop:Open("doj-shop")
end)