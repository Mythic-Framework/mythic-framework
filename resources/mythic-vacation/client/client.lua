local inCayoPerico = false

AddEventHandler("Island:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
    Utils = exports["mythic-base"]:FetchComponent("Utils")
    Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
    Logger = exports["mythic-base"]:FetchComponent("Logger")
    Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
    Targeting = exports["mythic-base"]:FetchComponent("Targeting")
end

AddEventHandler("Core:Shared:Ready", function()
    exports["mythic-base"]:RequestDependencies("Island", {
        "Utils",
        "Callbacks",
        "Logger",
        "Polyzone",
        "Targeting",
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()

        Polyzone.Create:Circle('cayo_perico', vector3(4965.17, -5693.89, 200.86), 2500.0, {})

        Polyzone.Create:Poly(
            'cayo_perico_weather',
            {
                vector2(5553.9536132812, -3238.1625976562),
                vector2(5855.6381835938, -2362.1159667969),
                vector2(4317.2016601562, -1245.5816650391),
                vector2(3104.2312011719, -2695.8073730469),
                vector2(2460.2199707031, -3376.9597167969),
                vector2(2154.7917480469, -3681.4155273438),
                vector2(1554.6015625, -4674.4560546875),
                vector2(960.73480224609, -6455.1254882812),
                vector2(1246.1354980469, -7609.275390625),
                vector2(4273.4833984375, -10113.00390625),
                vector2(4648.6708984375, -8210.5888671875),
                vector2(4025.1157226562, -8052.54296875),
                vector2(3346.2822265625, -7672.6015625),
                vector2(3192.26171875, -7530.2250976562),
                vector2(2960.181640625, -7260.701171875),
                vector2(2699.8044433594, -6850.193359375),
                vector2(2549.1403808594, -6458.7514648438),
                vector2(2452.0122070312, -6017.6220703125),
                vector2(2425.0852050781, -5682.7514648438),
                vector2(2448.9787597656, -5392.9936523438),
                vector2(2491.3405761719, -5122.1108398438),
                vector2(2583.8132324219, -4842.8891601562),
                vector2(2705.4633789062, -4560.384765625),
                vector2(2790.7336425781, -4406.3862304688),
                vector2(3013.5832519531, -4066.4284667969),
                vector2(3222.1706542969, -3845.8833007812),
                vector2(3488.7822265625, -3605.1774902344),
                vector2(3742.1225585938, -3466.3317871094),
                vector2(4086.8933105469, -3304.8278808594),
                vector2(4275.13671875, -3246.171875),
                vector2(4636.5107421875, -3176.162109375),
                vector2(4818.166015625, -3159.6208496094),
                vector2(5143.3994140625, -3166.5712890625),
                vector2(5271.7734375, -3169.4792480469)
            },
            {},
            {}
        )
    end)
end)

local requestedIpl = {
    "h4_mph4_terrain_01_grass_0",
    "h4_mph4_terrain_01_grass_1",
    "h4_mph4_terrain_02_grass_0",
    "h4_mph4_terrain_02_grass_1",
    "h4_mph4_terrain_02_grass_2",
    "h4_mph4_terrain_02_grass_3",
    "h4_mph4_terrain_04_grass_0",
    "h4_mph4_terrain_04_grass_1",
    "h4_mph4_terrain_05_grass_0",
    "h4_mph4_terrain_06_grass_0",
    "h4_islandx_terrain_01",
    "h4_islandx_terrain_01_lod",
    "h4_islandx_terrain_01_slod",
    "h4_islandx_terrain_02",
    "h4_islandx_terrain_02_lod",
    "h4_islandx_terrain_02_slod",
    "h4_islandx_terrain_03",
    "h4_islandx_terrain_03_lod",
    "h4_islandx_terrain_04",
    "h4_islandx_terrain_04_lod",
    "h4_islandx_terrain_04_slod",
    "h4_islandx_terrain_05",
    "h4_islandx_terrain_05_lod",
    "h4_islandx_terrain_05_slod",
    "h4_islandx_terrain_06",
    "h4_islandx_terrain_06_lod",
    "h4_islandx_terrain_06_slod",
    "h4_islandx_terrain_props_05_a",
    "h4_islandx_terrain_props_05_a_lod",
    "h4_islandx_terrain_props_05_b",
    "h4_islandx_terrain_props_05_b_lod",
    "h4_islandx_terrain_props_05_c",
    "h4_islandx_terrain_props_05_c_lod",
    "h4_islandx_terrain_props_05_d",
    "h4_islandx_terrain_props_05_d_lod",
    "h4_islandx_terrain_props_05_d_slod",
    "h4_islandx_terrain_props_05_e",
    "h4_islandx_terrain_props_05_e_lod",
    "h4_islandx_terrain_props_05_e_slod",
    "h4_islandx_terrain_props_05_f",
    "h4_islandx_terrain_props_05_f_lod",
    "h4_islandx_terrain_props_05_f_slod",
    "h4_islandx_terrain_props_06_a",
    "h4_islandx_terrain_props_06_a_lod",
    "h4_islandx_terrain_props_06_a_slod",
    "h4_islandx_terrain_props_06_b",
    "h4_islandx_terrain_props_06_b_lod",
    "h4_islandx_terrain_props_06_b_slod",
    "h4_islandx_terrain_props_06_c",
    "h4_islandx_terrain_props_06_c_lod",
    "h4_islandx_terrain_props_06_c_slod",
    "h4_mph4_terrain_01",
    "h4_mph4_terrain_01_long_0",
    "h4_mph4_terrain_02",
    "h4_mph4_terrain_03",
    "h4_mph4_terrain_04",
    "h4_mph4_terrain_05",
    "h4_mph4_terrain_06",
    "h4_mph4_terrain_06_strm_0",
    "h4_mph4_terrain_lod",
    "h4_mph4_terrain_occ_00",
    "h4_mph4_terrain_occ_01",
    "h4_mph4_terrain_occ_02",
    "h4_mph4_terrain_occ_03",
    "h4_mph4_terrain_occ_04",
    "h4_mph4_terrain_occ_05",
    "h4_mph4_terrain_occ_06",
    "h4_mph4_terrain_occ_07",
    "h4_mph4_terrain_occ_08",
    "h4_mph4_terrain_occ_09",
    "h4_boatblockers",
    "h4_islandx",
    "h4_islandx_disc_strandedshark",
    "h4_islandx_disc_strandedshark_lod",
    "h4_islandx_disc_strandedwhale",
    "h4_islandx_disc_strandedwhale_lod",
    "h4_islandx_props",
    "h4_islandx_props_lod",
    "h4_islandx_sea_mines",
    "h4_mph4_island",
    "h4_mph4_island_long_0",
    "h4_mph4_island_strm_0",
    "h4_aa_guns",
    "h4_aa_guns_lod",
    "h4_beach",
    "h4_beach_bar_props",
    "h4_beach_lod",
    "h4_beach_party",
    "h4_beach_party_lod",
    "h4_beach_props",
    "h4_beach_props_lod",
    "h4_beach_props_party",
    "h4_beach_props_slod",
    "h4_beach_slod",
    "h4_islandairstrip",
    "h4_islandairstrip_doorsclosed",
    "h4_islandairstrip_doorsclosed_lod",
    "h4_islandairstrip_doorsopen",
    "h4_islandairstrip_doorsopen_lod",
    "h4_islandairstrip_hangar_props",
    "h4_islandairstrip_hangar_props_lod",
    "h4_islandairstrip_hangar_props_slod",
    "h4_islandairstrip_lod",
    "h4_islandairstrip_props",
    "h4_islandairstrip_propsb",
    "h4_islandairstrip_propsb_lod",
    "h4_islandairstrip_propsb_slod",
    "h4_islandairstrip_props_lod",
    "h4_islandairstrip_props_slod",
    "h4_islandairstrip_slod",
    "h4_islandxcanal_props",
    "h4_islandxcanal_props_lod",
    "h4_islandxcanal_props_slod",
    "h4_islandxdock",
    "h4_islandxdock_lod",
    "h4_islandxdock_props",
    "h4_islandxdock_props_2",
    "h4_islandxdock_props_2_lod",
    "h4_islandxdock_props_2_slod",
    "h4_islandxdock_props_lod",
    "h4_islandxdock_props_slod",
    "h4_islandxdock_slod",
    "h4_islandxdock_water_hatch",
    "h4_islandxtower",
    "h4_islandxtower_lod",
    "h4_islandxtower_slod",
    "h4_islandxtower_veg",
    "h4_islandxtower_veg_lod",
    "h4_islandxtower_veg_slod",
    "h4_islandx_barrack_hatch",
    "h4_islandx_barrack_props",
    "h4_islandx_barrack_props_lod",
    "h4_islandx_barrack_props_slod",
    "h4_islandx_checkpoint",
    "h4_islandx_checkpoint_lod",
    "h4_islandx_checkpoint_props",
    "h4_islandx_checkpoint_props_lod",
    "h4_islandx_checkpoint_props_slod",
    "h4_islandx_maindock",
    "h4_islandx_maindock_lod",
    "h4_islandx_maindock_props",
    "h4_islandx_maindock_props_2",
    "h4_islandx_maindock_props_2_lod",
    "h4_islandx_maindock_props_2_slod",
    "h4_islandx_maindock_props_lod",
    "h4_islandx_maindock_props_slod",
    "h4_islandx_maindock_slod",
    "h4_islandx_mansion",
    "h4_islandx_mansion_b",
    "h4_islandx_mansion_b_lod",
    "h4_islandx_mansion_b_side_fence",
    "h4_islandx_mansion_b_slod",
    "h4_islandx_mansion_entrance_fence",
    "h4_islandx_mansion_guardfence",
    "h4_islandx_mansion_lights",
    "h4_islandx_mansion_lockup_01",
    "h4_islandx_mansion_lockup_01_lod",
    "h4_islandx_mansion_lockup_02",
    "h4_islandx_mansion_lockup_02_lod",
    "h4_islandx_mansion_lockup_03",
    "h4_islandx_mansion_lockup_03_lod",
    "h4_islandx_mansion_lod",
    "h4_islandx_mansion_office",
    "h4_islandx_mansion_office_lod",
    "h4_islandx_mansion_props",
    "h4_islandx_mansion_props_lod",
    "h4_islandx_mansion_props_slod",
    "h4_islandx_mansion_slod",
    "h4_islandx_mansion_vault",
    "h4_islandx_mansion_vault_lod",
    "h4_island_padlock_props",
    -- "h4_mansion_gate_broken",
    "h4_mansion_gate_closed",
    "h4_mansion_remains_cage",
    "h4_mph4_airstrip",
    "h4_mph4_airstrip_interior_0_airstrip_hanger",
    "h4_mph4_beach",
    "h4_mph4_dock",
    "h4_mph4_island_lod",
    "h4_mph4_island_ne_placement",
    "h4_mph4_island_nw_placement",
    "h4_mph4_island_se_placement",
    "h4_mph4_island_sw_placement",
    "h4_mph4_mansion",
    "h4_mph4_mansion_b",
    "h4_mph4_mansion_b_strm_0",
    "h4_mph4_mansion_strm_0",
    "h4_mph4_wtowers",
    "h4_ne_ipl_00",
    "h4_ne_ipl_00_lod",
    "h4_ne_ipl_00_slod",
    "h4_ne_ipl_01",
    "h4_ne_ipl_01_lod",
    "h4_ne_ipl_01_slod",
    "h4_ne_ipl_02",
    "h4_ne_ipl_02_lod",
    "h4_ne_ipl_02_slod",
    "h4_ne_ipl_03",
    "h4_ne_ipl_03_lod",
    "h4_ne_ipl_03_slod",
    "h4_ne_ipl_04",
    "h4_ne_ipl_04_lod",
    "h4_ne_ipl_04_slod",
    "h4_ne_ipl_05",
    "h4_ne_ipl_05_lod",
    "h4_ne_ipl_05_slod",
    "h4_ne_ipl_06",
    "h4_ne_ipl_06_lod",
    "h4_ne_ipl_06_slod",
    "h4_ne_ipl_07",
    "h4_ne_ipl_07_lod",
    "h4_ne_ipl_07_slod",
    "h4_ne_ipl_08",
    "h4_ne_ipl_08_lod",
    "h4_ne_ipl_08_slod",
    "h4_ne_ipl_09",
    "h4_ne_ipl_09_lod",
    "h4_ne_ipl_09_slod",
    "h4_nw_ipl_00",
    "h4_nw_ipl_00_lod",
    "h4_nw_ipl_00_slod",
    "h4_nw_ipl_01",
    "h4_nw_ipl_01_lod",
    "h4_nw_ipl_01_slod",
    "h4_nw_ipl_02",
    "h4_nw_ipl_02_lod",
    "h4_nw_ipl_02_slod",
    "h4_nw_ipl_03",
    "h4_nw_ipl_03_lod",
    "h4_nw_ipl_03_slod",
    "h4_nw_ipl_04",
    "h4_nw_ipl_04_lod",
    "h4_nw_ipl_04_slod",
    "h4_nw_ipl_05",
    "h4_nw_ipl_05_lod",
    "h4_nw_ipl_05_slod",
    "h4_nw_ipl_06",
    "h4_nw_ipl_06_lod",
    "h4_nw_ipl_06_slod",
    "h4_nw_ipl_07",
    "h4_nw_ipl_07_lod",
    "h4_nw_ipl_07_slod",
    "h4_nw_ipl_08",
    "h4_nw_ipl_08_lod",
    "h4_nw_ipl_08_slod",
    "h4_nw_ipl_09",
    "h4_nw_ipl_09_lod",
    "h4_nw_ipl_09_slod",
    "h4_se_ipl_00",
    "h4_se_ipl_00_lod",
    "h4_se_ipl_00_slod",
    "h4_se_ipl_01",
    "h4_se_ipl_01_lod",
    "h4_se_ipl_01_slod",
    "h4_se_ipl_02",
    "h4_se_ipl_02_lod",
    "h4_se_ipl_02_slod",
    "h4_se_ipl_03",
    "h4_se_ipl_03_lod",
    "h4_se_ipl_03_slod",
    "h4_se_ipl_04",
    "h4_se_ipl_04_lod",
    "h4_se_ipl_04_slod",
    "h4_se_ipl_05",
    "h4_se_ipl_05_lod",
    "h4_se_ipl_05_slod",
    "h4_se_ipl_06",
    "h4_se_ipl_06_lod",
    "h4_se_ipl_06_slod",
    "h4_se_ipl_07",
    "h4_se_ipl_07_lod",
    "h4_se_ipl_07_slod",
    "h4_se_ipl_08",
    "h4_se_ipl_08_lod",
    "h4_se_ipl_08_slod",
    "h4_se_ipl_09",
    "h4_se_ipl_09_lod",
    "h4_se_ipl_09_slod",
    "h4_sw_ipl_00",
    "h4_sw_ipl_00_lod",
    "h4_sw_ipl_00_slod",
    "h4_sw_ipl_01",
    "h4_sw_ipl_01_lod",
    "h4_sw_ipl_01_slod",
    "h4_sw_ipl_02",
    "h4_sw_ipl_02_lod",
    "h4_sw_ipl_02_slod",
    "h4_sw_ipl_03",
    "h4_sw_ipl_03_lod",
    "h4_sw_ipl_03_slod",
    "h4_sw_ipl_04",
    "h4_sw_ipl_04_lod",
    "h4_sw_ipl_04_slod",
    "h4_sw_ipl_05",
    "h4_sw_ipl_05_lod",
    "h4_sw_ipl_05_slod",
    "h4_sw_ipl_06",
    "h4_sw_ipl_06_lod",
    "h4_sw_ipl_06_slod",
    "h4_sw_ipl_07",
    "h4_sw_ipl_07_lod",
    "h4_sw_ipl_07_slod",
    "h4_sw_ipl_08",
    "h4_sw_ipl_08_lod",
    "h4_sw_ipl_08_slod",
    "h4_sw_ipl_09",
    "h4_sw_ipl_09_lod",
    "h4_sw_ipl_09_slod",
    "h4_underwater_gate_closed",
    "h4_islandx_placement_01",
    "h4_islandx_placement_02",
    "h4_islandx_placement_03",
    "h4_islandx_placement_04",
    "h4_islandx_placement_05",
    "h4_islandx_placement_06",
    "h4_islandx_placement_07",
    "h4_islandx_placement_08",
    "h4_islandx_placement_09",
    "h4_islandx_placement_10",
    "h4_mph4_island_placement"
}


-- CreateThread(function()
--     Citizen.Wait(0)
--     for k, v in ipairs(requestedIpl) do
--         RequestIpl(v)
--     end
-- end)

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
    if id == 'cayo_perico' and not inCayoPerico then
        -- set island hopper config
        SetIslandHopperEnabled('HeistIsland', true)

        -- switch radar interior
        SetToggleMinimapHeistIsland(true)

        -- misc natives
        SetAiGlobalPathNodesType(true)
        Citizen.InvokeNative(0x53797676AD34A9AA, false)
        SetScenarioGroupEnabled('Heist_Island_Peds', true)

        -- audio stuff
        SetAudioFlag('PlayerOnDLCHeist4Island', true)
        SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
        SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
        inCayoPerico = true

        for k, v in ipairs(requestedIpl) do
            RequestIpl(v)
        end

        Logger:Trace('Island', 'Entering Island Zone')
    end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
    if id == 'cayo_perico' and inCayoPerico then
        -- set island hopper config
        SetIslandHopperEnabled('HeistIsland', false)

        -- switch radar interior
        SetToggleMinimapHeistIsland(false)

        -- misc natives
        SetAiGlobalPathNodesType(0)
        Citizen.InvokeNative(0x53797676AD34A9AA, true)
        SetScenarioGroupEnabled('Heist_Island_Peds', false)

        -- audio stuff
        SetAudioFlag('PlayerOnDLCHeist4Island', false)
        SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
        SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, false)
        inCayoPerico = false
        Logger:Trace('Island', 'Leaving Island Zone')

        Citizen.Wait(50)
        for k, v in ipairs(requestedIpl) do
            RemoveIpl(v)
        end
    end
end)