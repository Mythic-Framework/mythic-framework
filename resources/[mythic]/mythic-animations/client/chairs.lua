local enterChairPosition = false
local isSitting = false


function RegisterChairTargets()
    for k, v in ipairs(_sittableChairs) do
        v.id = k
        if v.prop then
            Targeting:AddObject(v.prop, "chair", {
                {
                    text = "Sit",
                    icon = 'chair', 
                    event = "Animations:Client:Chair",
                    data = v,
                    minDist = 2.0,
                },
            }, 1.8)
        elseif v.polyzone then
            Targeting.Zones:AddBox(
                string.format("chair-%s", v.id),
                "chair",
                v.polyzone.center,
                v.polyzone.length,
                v.polyzone.width,
                v.polyzone.options,
                {
                    {
                        text = "Sit",
                        icon = 'chair', 
                        event = "Animations:Client:Chair",
                        data = v,
                        minDist = 2.0,
                    }
                },
                2.0,
                true
            )
        end
    end

    Interaction:RegisterMenu('chairs-stand-up', 'Stand Up', 'chair', function(data)
        Interaction:Hide()
        StandTheFuckUp()
    end, function()
        return isSitting
    end)
end

AddEventHandler('Animations:Client:Chair', function(entityData, data)
    if not isSitting and not IsInEmoteName and not LocalPlayer.state.myEscorter then
        enterChairPosition = GetEntityCoords(LocalPlayer.state.ped)

        local positioning = GetOffsetFromEntityInWorldCoords(entityData.entity, data.xOff + 0.0, data.yOff + 0.0, data.zOff + 1.0)
        local heading = GetEntityHeading(entityData.entity) or 0.0

        if data.polyzone then
            positioning = vector3(data.polyzone.center.x + data.xOff, data.polyzone.center.y + data.yOff, data.polyzone.center.z + data.zOff)
            heading = data.polyzone.options.heading or 0.0
        end

        if data.hOff then
            heading += data.hOff
        else
            heading += 180.0
        end

        if positioning then
            TaskStartScenarioAtPosition(
                LocalPlayer.state.ped,
                'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',
                positioning,
                heading + 0.0,
                0,
                true,
                true
            )
            isSitting = true

            LocalPlayer.state:set('sitting', true, true)
        end
    end
end)

function StandTheFuckUp(forced, cry)
    if isSitting then
        ClearPedTasks(LocalPlayer.state.ped)
        isSitting = false

        LocalPlayer.state:set('sitting', false, true)

        if not forced then
            Wait(1000)
        end

        if not cry and #(GetEntityCoords(LocalPlayer.state.ped) - enterChairPosition) <= 5.0 then
            SetEntityCoords(LocalPlayer.state.ped, enterChairPosition)
        end
    end
end

RegisterNetEvent('Animations:Client:StandUp', function(forced, cry)
    StandTheFuckUp(forced, cry)
end)

_sittableChairs = {
    {
        prop = `v_res_fa_chair01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_picnictable_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_picnictable_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_m_dinechair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_club_stagechair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_01a`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
    },
    {
        prop = `prop_bench_01b`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_01c`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_04`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_05`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_06`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_05`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_08`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_09`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_10`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_bench_11`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_fib_3b_bench`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_ld_bench01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_wait_bench_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_serv_ct_chair02`,
        zOff = -1.0,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `hei_prop_heist_off_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `hei_prop_hei_skid_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_01a`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_01b`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_04a`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_04b`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_05`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_06`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_05`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_08`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_09`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chair_10`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_chateau_chair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_clown_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_cs_office_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_direct_chair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_direct_chair_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_gc_chair02`,
        zOff = -1.0,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_04`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_04b`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_04_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_off_chair_05`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_old_deck_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_old_wood_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_rock_chair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_skid_chair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_skid_chair_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_skid_chair_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_sol_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_wheelchair_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_wheelchair_01_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_armchair_01_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_clb_officechair_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_dinechair_01_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_ilev_p_easychair_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_soloffchair_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_yacht_chair_01_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_club_officechair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_corp_bk_chair3`,
        zOff = -0.5,
        yOff = -0.1,
        xOff = 0.0
    },
    {
        prop = `v_corp_cd_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_corp_offchair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_chair02_ped`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_hd_chair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_p_easychair`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ret_gc_chair03`,
        zOff = -1.25,
        yOff = -0.05,
        xOff = 0.0
    },
    {
        prop = `prop_ld_farm_chair01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_04_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_05_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_06_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_leath_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_01_chr_a`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_01_chr_b`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_02_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_03b_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_table_03_chr`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_torture_ch_01`,
        zOff = -0.9,
        yOff = -0.05,
        xOff = 0.0
    },
    {
        prop = `v_ilev_fh_dineeamesa`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_tort_stool`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_fh_kitchenstool`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `hei_prop_yah_seat_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `hei_prop_yah_seat_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `hei_prop_yah_seat_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_waiting_seat_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_yacht_seat_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_yacht_seat_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_yacht_seat_03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_hobo_seat_01`,
        zOff = -0.65,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_rub_couch01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `miss_rub_couch_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_ld_farm_couch01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_ld_farm_couch02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_rub_couch02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_rub_couch03`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_rub_couch04`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_lev_sofa_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_res_sofa_l_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_v_med_p_sofa_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `p_yacht_sofa_01_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_ilev_m_sofa`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_res_tre_sofa_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_tre_sofa_mess_a_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_tre_sofa_mess_b_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `v_tre_sofa_mess_c_s`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_roller_car_01`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `prop_roller_car_02`,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `ex_prop_offchair_exec_04`,
        zOff = -1.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = `V_Res_MBchair`,
        zOff = -0.5,
        yOff = -0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = `V_Res_M_ArmChair`,
        zOff = -0.5,
        yOff = -0.05,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -105886377,
        zOff = -0.3,
        yOff = 0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 757888276,
        zOff = -0.5,
        yOff = 0.1,
        xOff = 0.0,
        hOff = 0.0
    },
    {
        prop = -425962029,
        zOff = -0.5,
        yOff = -0.25,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1630899471,
        zOff = -0.5,
        yOff = 0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -523951410,
        zOff = -0.5,
        yOff = 0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1786424499,
        zOff = -1.0,
        yOff = -0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -2065455377,
        zOff = -1.0,
        yOff = 1.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -992735415,
        zOff = -1.2,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1120527678,
        zOff = -0.2,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        prop = `v_serv_ct_chair01`,
        zOff = -1.0,
        yOff = 0.325,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1195678770,
        zOff = -0.2,
        yOff = -0.1,
        xOff = 0.0,
        hOff = 0.0
    },
    {
        prop = 1127420746,
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        polyzone = {
            center = vector3(750.86, -779.28, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.68, -779.75, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 302,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.8, -780.29, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 272,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.8, -781.24, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 272,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(750.87, -782.27, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 182,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.55, -781.97, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 227,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },

    {
        polyzone = {
            center = vector3(750.86, -779.28 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.68, -779.75 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 302,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.8, -780.29 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 272,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.8, -781.24 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 272,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(750.87, -782.27 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 182,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(751.55, -781.97 + 8.32, 26.34),
            length = 0.6,
            width = 0.6,
            options = {
                heading = 227,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 26.14
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        prop = 652816835,
        zOff = -0.2,
        yOff = 0.18,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        polyzone = {
            center = vector3(139.47, -3007.29, 7.04),
            length = 1.0,
            width = 1.2,
            options = {
                heading = 359,
                --debugPoly=true,
                minZ = 6.04,
                maxZ = 6.84
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(137.51, -3007.36, 7.04),
            length = 1.0,
            width = 1.2,
            options = {
                heading = 359,
                --debugPoly=true,
                minZ = 6.04,
                maxZ = 6.84
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(135.38, -3014.16, 7.04),
            length = 1.0,
            width = 1.2,
            options = {
                heading = 300,
                --debugPoly=true,
                minZ = 6.04,
                maxZ = 6.84
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(133.68, -3007.29, 7.04),
            length = 1.0,
            width = 1.2,
            options = {
                heading = 359,
                --debugPoly=true,
                minZ = 6.04,
                maxZ = 6.84
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0
    },
    {
        polyzone = {
            center = vector3(1072.91, -2401.26, 25.9),
            length = 0.8,
            width = 0.8,
            options = {
                heading = 315,
                --debugPoly=true,
                minZ = 24.9,
                maxZ = 26.5
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-585.53, -207.03, 38.23),
            length = 1.0,
            width = 1.0,
            options = {
                heading = 310,
                --debugPoly=true,
                minZ = 37.23,
                maxZ = 38.23
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-586.8, -207.74, 38.23),
            length = 1.0,
            width = 1.0,
            options = {
                heading = 291,
                --debugPoly=true,
                minZ = 37.23,
                maxZ = 38.23
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-530.44, -188.85, 43.37),
            length = 1.0,
            width = 1.0,
            options = {
                heading = 291,
                --debugPoly=true,
                minZ = 42.37,
                maxZ = 43.37
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 360.0
    },
    {
        polyzone = {
            center = vector3(-529.52, -190.45, 43.37),
            length = 1.0,
            width = 1.0,
            options = {
                heading = 311,
                --debugPoly=true,
                minZ = 42.37,
                maxZ = 43.37
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 360.0
    },
    {
        polyzone = {
            center = vector3(-373.12, 271.76, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        polyzone = {
            center = vector3(-372.41, 272.22, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 360.0
    },
    {
        polyzone = {
            center = vector3(-371.51, 272.89, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        polyzone = {
            center = vector3(-370.8, 273.4, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 360.0
    },
    {
        polyzone = {
            center = vector3(-369.9, 274.05, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        polyzone = {
            center = vector3(-369.16, 274.51, 86.46),
            length = 0.6,
            width = 0.8,
            options = {
                heading = 305,
                --debugPoly=true,
                minZ = 85.66,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = -0.1,
        hOff = 360.0
    },
    {
        polyzone = {
            center = vector3(-377.84, 266.11, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-376.89, 266.82, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-376.24, 267.26, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-375.29, 267.98, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-374.59, 268.37, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-373.61, 269.08, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-372.97, 269.53, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-372.01, 270.21, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-371.34, 270.67, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-370.39, 271.38, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-369.77, 271.84, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-368.77, 272.48, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        polyzone = {
            center = vector3(-368.09, 272.93, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = -90.0
    },
    {
        polyzone = {
            center = vector3(-367.13, 273.62, 86.46),
            length = 0.8,
            width = 0.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 85.86,
                maxZ = 87.06
            }
        },
        zOff = -0.5,
        yOff = 0.0,
        xOff = 0.0,
        hOff = 90.0
    },
    {
        prop = -853526657,
        zOff = -1.1,
        yOff = 0.18,
        xOff = 0.0,
        hOff = 180.0
    },

    {
        prop = -125562459,
        zOff = -0.45,
        yOff = 0.12,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -603563862,
        zOff = -0.45,
        yOff = 0.12,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -606800174,
        zOff = -0.45,
        yOff = 0.12,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -470815620,
        zOff = -1.1,
        yOff = 0.12,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1840174940,
        zOff = -0.3,
        yOff = 0.12,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1202648266,
        zOff = -0.95,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 538002882,
        zOff = -1.1,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1279242633,
        zOff = -0.55,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1737090544,
        zOff = -1.1,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1889748069,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -212710979,
        zOff = -0.5,
        yOff = -0.1,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1577885496,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 1816935351,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = 2129125614,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -1692811878,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
    {
        prop = -729914417,
        zOff = -0.5,
        yOff = 0.04,
        xOff = 0.0,
        hOff = 180.0
    },
}