local syncedScene = nil
local satOnSeat = nil

local dealerVoiceGroups = {
    `S_M_Y_Casino_01_WHITE_01`,
    `S_M_Y_Casino_01_WHITE_02`,
    `S_M_Y_Casino_01_ASIAN_01`,
    `S_M_Y_Casino_01_ASIAN_02`,
    `S_F_Y_Casino_01_ASIAN_01`,
    `S_F_Y_Casino_01_ASIAN_02`,
    `S_F_Y_Casino_01_LATINA_01`,
    `S_F_Y_Casino_01_LATINA_02`
}

function SetBlackjackDealerVariation(ped, number)
    if number == 0 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 3, 0, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[1])
    elseif number == 1 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 2, 2, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 4, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[1])
    elseif number == 2 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 2, 1, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 2, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[2])
    elseif number == 3 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 2, 0, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[2])
    elseif number == 4 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 4, 2, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[1])
    elseif number == 5 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 4, 0, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[2])
    elseif number == 6 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 4, 1, 0)
        SetPedComponentVariation(ped, 1, 1, 0, 0)
        SetPedComponentVariation(ped, 2, 4, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 1, 0, 0)
        SetPedComponentVariation(ped, 11, 1, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[2])
    elseif number == 7 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 1, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 1, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[1])
    elseif number == 8 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 1, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 1, 1, 0)
        SetPedComponentVariation(ped, 3, 1, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[5])
    elseif number == 9 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 2, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 2, 0, 0)
        SetPedComponentVariation(ped, 3, 2, 3, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[6])
    elseif number == 10 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 2, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 2, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 3, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[6])
    elseif number == 11 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 3, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)

        SetPedVoiceGroup(ped, dealerVoiceGroups[7])
    elseif number == 12 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 3, 1, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 3, 1, 0)
        SetPedComponentVariation(ped, 3, 1, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 2, 0, 0)
        SetPedComponentVariation(ped, 8, 1, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)

        SetPedVoiceGroup(ped, dealerVoiceGroups[7])
    elseif number == 13 then
        SetPedDefaultComponentVariation(ped)
        SetPedComponentVariation(ped, 0, 4, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 4, 0, 0)
        SetPedComponentVariation(ped, 3, 2, 1, 0)
        SetPedComponentVariation(ped, 4, 1, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 0, 0)
        SetPedComponentVariation(ped, 7, 1, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
        SetPedPropIndex(ped, 1, 0, 0, false)

        SetPedVoiceGroup(ped, dealerVoiceGroups[8])
	end
end

function getDealerAnimString(tableId)
    if _blackjackTablesConfig[tableId].dealerVariation >= 8 then
        return "female_"
    end
    return ""
end

function doStupidFuckingAnimation(dict, anim)
    local duration = GetAnimDuration(dict, anim)
    TaskPlayAnim(LocalPlayer.state.ped, dict, anim, 2.0, 0.0, duration, 48, 0.0, 0, 0, 0)

    return duration * 1000
end

function blackjack_func_398(iParam0)
	local vVar0 = vector3(0.0, 164.52, 11.5)
	return vector3(getTableHeading(iParam0), 0.0, 0.0) + vVar0;
end

function blackjack_func_399(iParam0) --iParam0 is table ID?
    local vVar0 = vector3(0.526, 0.571, 0.963)
    --print("func_399 iParam0",iParam0)
    local x,y,z = getTableCoords(iParam0)
    return GetObjectOffsetFromCoords(x, y, z, getTableHeading(iParam0), vVar0.x, vVar0.y, vVar0.z)
end

function blackjack_func_204(iParam0, iParam1, bParam2) --returns vector
    if bParam2 then 
        return vector3(getTableHeading(iParam1), 0.0, 0.0) + vector3(0, 0.061, -59.1316);
    else
        vVar0 = blackjack_func_215(iParam0)
        return vector3(vVar0.z, 0.0, 0.0) + vector3(-87.48, 0, -60.84);
    end
    return 0.0, 0.0, 0.0
end 

function blackjack_func_205(iParam0, iParam1, bParam2) --returns Vector
    if bParam2 then 
        --return OBJECT::_GET_OBJECT_OFFSET_FROM_COORDS(func_70(iParam1), func_69(iParam1), -0.0094f, -0.0611f, 1.5098f);
        return GetObjectOffsetFromCoords(getTableCoords(iParam1), getTableHeading(iParam1),-0.0094, -0.0611, 1.5098)
    else
        --vVar0 = { func_215(iParam0) };
        --return OBJECT::_GET_OBJECT_OFFSET_FROM_COORDS(func_348(iParam0), vVar0.z, 0.245f, 0f, 1.415f);
        vVar0 = blackjack_func_215(iParam0)
        return GetObjectOffsetFromCoords(blackjack_func_348(iParam0), vVar0.z,0.245, 0.0, 1.415)
    end
    return 0.0, 0.0, 0.0
end

function blackjack_func_216(iParam0, iParam1)
    local goToVector = blackjack_func_348(iParam0)
    local xRot,yRot,zRot = blackjack_func_215(iParam0)
    vVar0 = GetAnimInitialOffsetRotation("anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(iParam1), goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 0.01, 2)
    return vVar0.z
end

function blackjack_func_217(iParam0, vParam1, bParam2)
	local vVar0 = {}
    
    if not IsEntityDead(iParam0,0) then 
        vVar0 = GetEntityCoords(iParam0,1)
    else
        vVar0 = GetEntityCoords(iParam0,0)
    end
    return #(vVar0-vParam1)
end

function GetBlackjackAnimOffset(iParam0, iParam1) --//param0 is 0-3 && param1 is 0-15?
    local goToVector = blackjack_func_348(iParam0)
    local xRot,yRot,zRot = blackjack_func_215(iParam0)
    vVar0 = GetAnimInitialOffsetPosition("anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(iParam1), goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 0.01, 2)
    return vVar0
end

function blackjack_func_213(sitAnimID) 
    if sitAnimID == 0 then 
        return "sit_enter_left"
    elseif sitAnimID == 1 then
        return "sit_enter_left_side"
    elseif sitAnimID == 2 then
        return "sit_enter_right_side"
    end
    return "sit_enter_left"
end

function getInverseChairId(chairId)
    if chairId == 0 then return 3 end
    if chairId == 1 then return 2 end
    if chairId == 2 then return 1 end
    if chairId == 3 then return 0 end
end

function blackjack_func_348(iParam0) --GetVectorFromChairId
    if iParam0 < 0 then
        return vector3(0.0,0.0,0.0)
    end
    local blackjackTableObj
    local tableId = blackjack_func_368(iParam0)
    local x,y,z = getTableCoords(tableId)
    blackjackTableObj = GetClosestObjectOfType(x, y, z, 1.0, _blackjackTables[tableId].table.prop, 0, 0, 0)
    
    if DoesEntityExist(blackjackTableObj) and DoesEntityHaveDrawable(blackjackTableObj) then
        local localChairId = getLocalChairIndexFromGlobalChairId(iParam0)
        --print("localchairId was",localChairId)
        localChairId = getInverseChairId(localChairId) + 1
        --print("localchairId is now",localChairId)
        return GetWorldPositionOfEntityBone_2(blackjackTableObj,GetEntityBoneIndexByName(blackjackTableObj, "Chair_Base_0"..localChairId))
    end
    return vector3(0.0,0.0,0.0)
end

function blackjack_func_215(iParam0)
    if iParam0 == -1 then
        return vector3(0.0,0.0,0.0)
    end
    local blackjackTableObj
    local tableId = blackjack_func_368(iParam0)
    local x,y,z = getTableCoords(tableId)
    blackjackTableObj = GetClosestObjectOfType(x, y, z, 1.0, _blackjackTables[tableId].table.prop, 0, 0, 0)
    if DoesEntityExist(blackjackTableObj) and DoesEntityHaveDrawable(blackjackTableObj) then
        local localChairId = getLocalChairIndexFromGlobalChairId(iParam0)
        --print("localchairId was",localChairId)
        localChairId = getInverseChairId(localChairId) + 1
        --print("localchairId is now",localChairId)
        return GetWorldRotationOfEntityBone(blackjackTableObj,GetEntityBoneIndexByName(blackjackTableObj, "Chair_Base_0"..localChairId))
    else
        return vector3(0.0,0.0,0.0)
    end 
end 

function blackjack_func_368(chairId) --returns tableID based on chairID
    local tableId = -1
    for i=0,chairId,4 do
        tableId = tableId + 1
    end
    return tableId
end

function getCardFromNumber(iParam0, bParam1)
	if bParam1 then 
        if iParam0 == 1 then
            return "vw_prop_vw_club_char_a_a"
        elseif iParam0 == 2 then
            return "vw_prop_vw_club_char_02a"
        elseif iParam0 == 3 then
            return "vw_prop_vw_club_char_03a"
        elseif iParam0 == 4 then
            return "vw_prop_vw_club_char_04a"
        elseif iParam0 == 5 then
            return "vw_prop_vw_club_char_05a"
        elseif iParam0 == 6 then
            return "vw_prop_vw_club_char_06a"
        elseif iParam0 == 7 then
            return "vw_prop_vw_club_char_07a"
        elseif iParam0 == 8 then
            return "vw_prop_vw_club_char_08a"
        elseif iParam0 == 9 then
            return "vw_prop_vw_club_char_09a"
        elseif iParam0 == 10 then
            return "vw_prop_vw_club_char_10a"
        elseif iParam0 == 11 then
            return "vw_prop_vw_club_char_j_a"
        elseif iParam0 == 12 then
            return "vw_prop_vw_club_char_q_a"
        elseif iParam0 == 13 then
            return "vw_prop_vw_club_char_k_a"
        elseif iParam0 == 14 then
            return "vw_prop_vw_dia_char_a_a"
        elseif iParam0 == 15 then
            return "vw_prop_vw_dia_char_02a"
        elseif iParam0 == 16 then
            return "vw_prop_vw_dia_char_03a"
        elseif iParam0 == 17 then
            return "vw_prop_vw_dia_char_04a"
        elseif iParam0 == 18 then
            return "vw_prop_vw_dia_char_05a"
        elseif iParam0 == 19 then
            return "vw_prop_vw_dia_char_06a"
        elseif iParam0 == 20 then
            return "vw_prop_vw_dia_char_07a"
        elseif iParam0 == 21 then
            return "vw_prop_vw_dia_char_08a"
        elseif iParam0 == 22 then
            return "vw_prop_vw_dia_char_09a"
        elseif iParam0 == 23 then
            return "vw_prop_vw_dia_char_10a"
        elseif iParam0 == 24 then
            return "vw_prop_vw_dia_char_j_a"
        elseif iParam0 == 25 then
            return "vw_prop_vw_dia_char_q_a"
        elseif iParam0 == 26 then
            return "vw_prop_vw_dia_char_k_a"
        elseif iParam0 == 27 then
            return "vw_prop_vw_hrt_char_a_a"
        elseif iParam0 == 28 then
            return "vw_prop_vw_hrt_char_02a"
        elseif iParam0 == 29 then
            return "vw_prop_vw_hrt_char_03a"
        elseif iParam0 == 30 then
            return "vw_prop_vw_hrt_char_04a"
        elseif iParam0 == 31 then
            return "vw_prop_vw_hrt_char_05a"
        elseif iParam0 == 32 then
            return "vw_prop_vw_hrt_char_06a"
        elseif iParam0 == 33 then
            return "vw_prop_vw_hrt_char_07a"
        elseif iParam0 == 34 then
            return "vw_prop_vw_hrt_char_08a"
        elseif iParam0 == 35 then
            return "vw_prop_vw_hrt_char_09a"
        elseif iParam0 == 36 then
            return "vw_prop_vw_hrt_char_10a"
        elseif iParam0 == 37 then
            return "vw_prop_vw_hrt_char_j_a"
        elseif iParam0 == 38 then
            return "vw_prop_vw_hrt_char_q_a"
        elseif iParam0 == 39 then
            return "vw_prop_vw_hrt_char_k_a"
        elseif iParam0 == 40 then
            return "vw_prop_vw_spd_char_a_a"
        elseif iParam0 == 41 then
            return "vw_prop_vw_spd_char_02a"
        elseif iParam0 == 42 then
            return "vw_prop_vw_spd_char_03a"
        elseif iParam0 == 43 then
            return "vw_prop_vw_spd_char_04a"
        elseif iParam0 == 44 then
            return "vw_prop_vw_spd_char_05a"
        elseif iParam0 == 45 then
            return "vw_prop_vw_spd_char_06a"
        elseif iParam0 == 46 then
            return "vw_prop_vw_spd_char_07a"
        elseif iParam0 == 47 then
            return "vw_prop_vw_spd_char_08a"
        elseif iParam0 == 48 then
            return "vw_prop_vw_spd_char_09a"
        elseif iParam0 == 49 then
            return "vw_prop_vw_spd_char_10a"
        elseif iParam0 == 50 then
            return "vw_prop_vw_spd_char_j_a"
        elseif iParam0 == 51 then
            return "vw_prop_vw_spd_char_q_a"
        elseif iParam0 == 52 then
            return "vw_prop_vw_spd_char_k_a"
        end
	else
        if iParam0 == 1 then
            return "vw_prop_cas_card_club_ace"
        elseif iParam0 == 2 then
            return "vw_prop_cas_card_club_02"
        elseif iParam0 == 3 then
            return "vw_prop_cas_card_club_03"
        elseif iParam0 == 4 then
            return "vw_prop_cas_card_club_04"
        elseif iParam0 == 5 then
            return "vw_prop_cas_card_club_05"
        elseif iParam0 == 6 then
            return "vw_prop_cas_card_club_06"
        elseif iParam0 == 7 then
            return "vw_prop_cas_card_club_07"
        elseif iParam0 == 8 then
            return "vw_prop_cas_card_club_08"
        elseif iParam0 == 9 then
            return "vw_prop_cas_card_club_09"
        elseif iParam0 == 10 then
            return "vw_prop_cas_card_club_10"
        elseif iParam0 == 11 then
            return "vw_prop_cas_card_club_jack"
        elseif iParam0 == 12 then
            return "vw_prop_cas_card_club_queen"
        elseif iParam0 == 13 then
            return "vw_prop_cas_card_club_king"
        elseif iParam0 == 14 then
            return "vw_prop_cas_card_dia_ace"
        elseif iParam0 == 15 then
            return "vw_prop_cas_card_dia_02"
        elseif iParam0 == 16 then
            return "vw_prop_cas_card_dia_03"
        elseif iParam0 == 17 then
            return "vw_prop_cas_card_dia_04"        
        elseif iParam0 == 18 then
            return "vw_prop_cas_card_dia_05"
        elseif iParam0 == 19 then
            return "vw_prop_cas_card_dia_06"
        elseif iParam0 == 20  then
            return "vw_prop_cas_card_dia_07"
        elseif iParam0 == 21 then
            return "vw_prop_cas_card_dia_08"
        elseif iParam0 == 22 then
            return "vw_prop_cas_card_dia_09"
        elseif iParam0 == 23 then
            return "vw_prop_cas_card_dia_10"
        elseif iParam0 == 24 then
            return "vw_prop_cas_card_dia_jack"
        elseif iParam0 == 25 then
            return "vw_prop_cas_card_dia_queen"
        elseif iParam0 == 26 then
            return "vw_prop_cas_card_dia_king"
        elseif iParam0 == 27 then
            return "vw_prop_cas_card_hrt_ace"
        elseif iParam0 == 28 then
            return "vw_prop_cas_card_hrt_02"
        elseif iParam0 == 29 then
            return "vw_prop_cas_card_hrt_03"
        elseif iParam0 == 30 then
            return "vw_prop_cas_card_hrt_04"
        elseif iParam0 == 31 then
            return "vw_prop_cas_card_hrt_05"
        elseif iParam0 == 32 then
            return "vw_prop_cas_card_hrt_06"
        elseif iParam0 == 33 then
            return "vw_prop_cas_card_hrt_07"
        elseif iParam0 == 34 then
            return "vw_prop_cas_card_hrt_08"
        elseif iParam0 == 35 then
            return "vw_prop_cas_card_hrt_09"
        elseif iParam0 == 36 then
            return "vw_prop_cas_card_hrt_10"
        elseif iParam0 == 37 then
            return "vw_prop_cas_card_hrt_jack"
        elseif iParam0 == 38 then
            return "vw_prop_cas_card_hrt_queen"
        elseif iParam0 == 39 then
            return "vw_prop_cas_card_hrt_king"
        elseif iParam0 == 40 then
            return "vw_prop_cas_card_spd_ace"
        elseif iParam0 == 41 then
            return "vw_prop_cas_card_spd_02"
        elseif iParam0 == 42 then
            return "vw_prop_cas_card_spd_03"
        elseif iParam0 == 43 then
            return "vw_prop_cas_card_spd_04"
        elseif iParam0 == 44 then
            return "vw_prop_cas_card_spd_05"
        elseif iParam0 == 45 then
            return "vw_prop_cas_card_spd_06"
        elseif iParam0 == 46 then
            return "vw_prop_cas_card_spd_07"
        elseif iParam0 == 47 then
            return "vw_prop_cas_card_spd_08"
        elseif iParam0 == 48 then
            return "vw_prop_cas_card_spd_09"
        elseif iParam0 == 49 then
            return "vw_prop_cas_card_spd_10"
        elseif iParam0 == 50 then
            return "vw_prop_cas_card_spd_jack"
        elseif iParam0 == 51 then
            return "vw_prop_cas_card_spd_queen"
        elseif iParam0 == 52 then
            return "vw_prop_cas_card_spd_king"
        end
    end
	if bParam1 then
		return "vw_prop_vw_jo_char_01a"
    end
	return "vw_prop_casino_cards_single"
end

function getAnimNameFromBet(betAmount)
    --TODO sort this out once bet amounts decided
    -- return "place_bet_small";
    -- return "place_bet_small_alt1";
    -- return "place_bet_small_alt2";
    -- return "place_bet_small_alt3";
    -- return "place_bet_large";
    -- return "place_bet_double_down";
    -- return "place_bet_small_player_02";
    -- return "place_bet_large_player_02";
    -- return "place_bet_double_down_player_02";
    -- return "place_bet_small_split";
    -- return "place_bet_large_split";

    --default for now
    return "place_bet_small"
end 


function blackjack_func_377(iParam0, iParam1, bParam2) --iVar5, iVar9, 0
    --print("blackjack_func_377")
    --print("iParam0: " .. tostring(iParam0))
    --print("iParam1: " .. tostring(iParam1))
    --print("bParam2: " .. tostring(bParam2))
    if bParam2 == 0 then 
        --print("first check [OK]")
        --print("iParam1: " .. tostring(iParam1))
        --print("iParam0: " .. tostring(iParam0))
		if iParam1 == 0 then
            if iParam0 == 0 then
                return 0.5737, 0.2376, 0.948025
            elseif iParam0 == 1 then
                return 0.562975, 0.2523, 0.94875
            elseif iParam0 == 2 then
                return 0.553875, 0.266325, 0.94955
            elseif iParam0 == 3 then
                return 0.5459, 0.282075, 0.9501
            elseif iParam0 == 4 then
                return 0.536125, 0.29645, 0.95085
            elseif iParam0 == 5 then
                return 0.524975, 0.30975, 0.9516
            elseif iParam0 == 6 then
                return 0.515775, 0.325325, 0.95235
            end 
		elseif iParam1 == 1 then
            if iParam0 == 0 then
                return 0.2325, -0.1082, 0.94805
            elseif iParam0 == 1 then
                return 0.23645, -0.0918, 0.949
            elseif iParam0 == 2 then
                return 0.2401, -0.074475, 0.950225
            elseif iParam0 == 3 then
                return 0.244625, -0.057675, 0.951125
            elseif iParam0 == 4 then
                return 0.249675, -0.041475, 0.95205
            elseif iParam0 == 5 then
                return 0.257575, -0.0256, 0.9532
            elseif iParam0 == 6 then
                return 0.2601, -0.008175, 0.954375
            end 
        elseif iParam1 == 2 then
            if iParam0 == 0 then
                return -0.2359, -0.1091, 0.9483
            elseif iParam0 == 1 then
                return -0.221025, -0.100675, 0.949
            elseif iParam0 == 2 then
                return -0.20625, -0.092875, 0.949725
            elseif iParam0 == 3 then
                return -0.193225, -0.07985, 0.950325
            elseif iParam0 == 4 then
                return -0.1776, -0.072, 0.951025
            elseif iParam0 == 5 then
                return -0.165, -0.060025, 0.951825
            elseif iParam0 == 6 then
                return -0.14895, -0.05155, 0.95255
            end
		elseif iParam1 == 3 then
            if iParam0 == 0 then
                return -0.5765, 0.2229, 0.9482
            elseif iParam0 == 1 then
                return -0.558925, 0.2197, 0.949175
            elseif iParam0 == 2 then
                return -0.5425, 0.213025, 0.9499
            elseif iParam0 == 3 then
                return -0.525925, 0.21105, 0.95095
            elseif iParam0 == 4 then
                return -0.509475, 0.20535, 0.9519
            elseif iParam0 == 5 then
                return -0.491775, 0.204075, 0.952825
            elseif iParam0 == 6 then
                return -0.4752, 0.197525, 0.9543
            end
        end  
	else
		if iParam1 == 0 then 
            if iParam0 == 0 then
                return 0.6083, 0.3523, 0.94795
            elseif iParam0 == 1 then
                return 0.598475, 0.366475, 0.948925
            elseif iParam0 == 2 then
                return 0.589525, 0.3807, 0.94975
            elseif iParam0 == 3 then
                return 0.58045, 0.39435, 0.950375
            elseif iParam0 == 4 then
                return 0.571975, 0.4092, 0.951075
            elseif iParam0 == 5 then
                return 0.5614, 0.4237, 0.951775
            elseif iParam0 == 6 then
                return 0.554325, 0.4402, 0.952525
            end 
        elseif iParam1 == 1 then 
            if iParam0 == 0 then
				return 0.3431, -0.0527, 0.94855
            elseif iParam0 == 1 then
                return 0.348575, -0.0348, 0.949425
            elseif iParam0 == 2 then
                return 0.35465, -0.018825, 0.9502
            elseif iParam0 == 3 then
                return 0.3581, -0.001625, 0.95115
            elseif iParam0 == 4 then
                return 0.36515, 0.015275, 0.952075
            elseif iParam0 == 5 then
                return 0.368525, 0.032475, 0.95335
            elseif iParam0 == 6 then
                return 0.373275, 0.0506, 0.9543
            end 
        elseif iParam1 == 2 then 
            if iParam0 == 0 then
                return -0.116, -0.1501, 0.947875
            elseif iParam0 == 1 then
                return -0.102725, -0.13795, 0.948525
            elseif iParam0 == 2 then
                return -0.08975, -0.12665, 0.949175
            elseif iParam0 == 3 then
                return -0.075025, -0.1159, 0.949875
            elseif iParam0 == 4 then
                return -0.0614, -0.104775, 0.9507
            elseif iParam0 == 5 then
                return -0.046275, -0.095025, 0.9516
            elseif iParam0 == 6 then
                return -0.031425, -0.0846, 0.952675
            end 
        elseif iParam1 == 3 then 
            if iParam0 == 0 then
                return -0.5205, 0.1122, 0.9478
            elseif iParam0 == 1 then
                return -0.503175, 0.108525, 0.94865
            elseif iParam0 == 2 then
                return -0.485125, 0.10475, 0.949175
            elseif iParam0 == 3 then
                return -0.468275, 0.099175, 0.94995
            elseif iParam0 == 4 then
                return -0.45155, 0.09435, 0.95085
            elseif iParam0 == 5 then
                return -0.434475, 0.089725, 0.95145
            elseif iParam0 == 6 then
                return -0.415875, 0.0846, 0.9523
            end
        elseif iParam1 == 4 then --estimated
            if iParam0 == 0 then
                return -0.293,0.253,0.950025
            elseif iParam0 == 1 then
                return -0.093,0.253,0.950025
            elseif iParam0 == 2 then
                return 0.0293,0.253,0.950025
            elseif iParam0 == 3 then
                return 0.1516,0.253,0.950025
            elseif iParam0 == 4 then
                return 0.2739,0.253,0.950025
            elseif iParam0 == 5 then
                return 0.3962,0.253,0.950025
            elseif iParam0 == 6 then
                return 0.5185,0.253,0.950025
            end             
        end
    end  
	return 0.0, 0.0, 0.947875
end

function func_376(iParam0, iParam1, bParam2, bParam3)
	if not bParam2 then
		if iParam1 == 0 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 69.12)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 67.8)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 66.6)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 70.44)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 70.84)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 67.88)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 69.56)
            end
        elseif iParam0 == 1 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 22.11)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 22.32)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 20.8)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 19.8)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 19.44)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 26.28)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 22.68)
            end
        elseif iParam0 == 2 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -21.43)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -20.16)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -16.92)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -23.4)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -21.24)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -23.76)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -19.44)
            end
        elseif iParam0 == 3 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -67.03)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -69.12)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -64.44)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -67.68)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -63.72)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -68.4)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -64.44)
            end
        end      
	else
		if iParam1 == 0 then 
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 68.57)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 67.52)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 67.76)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 67.04)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 68.84)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 65.96)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 67.76)
            end
        elseif iParam1 == 1 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, 22.11)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, 22)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, 24.44)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, 21.08)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, 25.96)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, 26.16)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, 28.76)
            end
        elseif iParam1 == 2 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -14.04)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -15.48)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -16.56)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -15.84)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -16.92)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -14.4)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -14.28)
            end
        elseif iParam1 == 3 then
            if iParam0 == 0 then
                return vector3(0.0, 0.0, -67.03)
            elseif iParam0 == 1 then
                return vector3(0.0, 0.0, -67.6)
            elseif iParam0 == 2 then
                return vector3(0.0, 0.0, -69.4)
            elseif iParam0 == 3 then
                return vector3(0.0, 0.0, -69.04)
            elseif iParam0 == 4 then
                return vector3(0.0, 0.0, -68.68)
            elseif iParam0 == 5 then
                return vector3(0.0, 0.0, -66.16)
            elseif iParam0 == 6 then
                return vector3(0.0, 0.0, -63.28)
            end
        end
    end
	if bParam3 then 
        vVar0.z = (vVar0.z + 90.0)
    end
	return vVar0
end

function getChipPropFromAmount(amount)
    --? _x1 is 1 chip _st is stack of 10 chips
    --vw_prop_chip_10dollar_x1 --! £10
    --vw_prop_chip_50dollar_x1 --! £50
    --vw_prop_chip_100dollar_x1 --! £100
    --vw_prop_chip_50dollar_st --!  £50 stack
    --vw_prop_chip_100dollar_st --!  £100 stack
    --vw_prop_chip_500dollar_x1 --! £500 
    --vw_prop_chip_1kdollar_x1 --!  £1,000
    --vw_prop_chip_500dollar_st --! £500 stack
    --vw_prop_chip_5kdollar_x1 --!  £5,000
    --vw_prop_chip_1kdollar_st --!  £1,000 stack
    --vw_prop_chip_10kdollar_x1 --! £10,000 
    --vw_prop_chip_5kdollar_st --! £5,000 stack
    --vw_prop_chip_10kdollar_st --! £10,000 stack
    --vw_prop_plaq_5kdollar_x1 --! £5,000
    --vw_prop_plaq_5kdollar_st --! £5,000 stack
    --vw_prop_plaq_10kdollar_x1 --! £10,0000
    --vw_prop_plaq_10kdollar_st --! £10,0000 stack
    --* below not included in func in decompiled code
    --vw_prop_vw_chips_pile_01a.ydr
    --vw_prop_vw_chips_pile_02a.ydr
    --vw_prop_vw_chips_pile_03a.ydr
    --vw_prop_vw_coin_01a.ydr
    amount = tonumber(amount)
    if amount < 1000000 then 
        denominations = {10,50,100,500,1000,5000,10000}  
        chips = {} 
        local max = 7
        for k,v in ipairs(denominations) do 
            while amount >= denominations[max] do 
                table.insert(chips,denominations[max])
                amount = amount - denominations[max]
            end
            max = max - 1
        end
        for k,v in ipairs(chips) do 
            chips[k] = getChipFromAmount(v) 
        end
        return chips
    elseif amount < 5000000 then  
        return {"vw_prop_vw_chips_pile_01a"}
    elseif amount < 10000000 then  
        return {"vw_prop_vw_chips_pile_02a"}
    else
        return {"vw_prop_vw_chips_pile_03a"}
    end
    return {"vw_prop_chip_500dollar_st"}
end     

local chipsFromAmount = {
    [1] = "vw_prop_vw_coin_01a",
    [10] = "vw_prop_chip_10dollar_x1",
    [50] = "vw_prop_chip_50dollar_x1",
    [100] = "vw_prop_chip_100dollar_x1",
    [500] = "vw_prop_chip_500dollar_x1",
    [1000] = "vw_prop_chip_1kdollar_x1",
    [5000] = "vw_prop_chip_5kdollar_x1",
    [10000] = "vw_prop_chip_10kdollar_x1",
}

function getChipFromAmount(amount) 
    return chipsFromAmount[amount]
end 

function blackjack_func_374(betAmount, iParam1, chairId, bParam3) --returns vector3
    --betAmount, 0, chairID, someBool
    --print("blackjack_func_374 params:")
    --print("betAmount: " .. tostring(betAmount))
    --print("iParam1: " .. tostring(iParam1))
    --print("chairId: " .. tostring(chairId))
    --print("bParam3: " .. tostring(bParam3))
    fVar0 = 0.0
    vVar1 = vector3(0,0,0)
    if not bParam3 then 
        --print("now checking betAmount: " .. tostring(betAmount))
        if betAmount == 10 then 
            fVar0 = 0.95
        elseif betAmount == 20 then
            fVar0 = 0.896
        elseif betAmount == 30 then
            fVar0 = 0.901
        elseif betAmount == 40 then
            fVar0 = 0.907
        elseif betAmount == 50 then
            fVar0 = 0.95
        elseif betAmount == 60 then
            fVar0 = 0.917
        elseif betAmount == 70 then
            fVar0 = 0.922
        elseif betAmount == 80 then
            fVar0 = 0.927
        elseif betAmount == 90 then
            fVar0 = 0.932
        elseif betAmount == 100 then
            fVar0 = 0.95
        elseif betAmount == 150 then
            fVar0 = 0.904
        elseif betAmount == 200 then
            fVar0 = 0.899
        elseif betAmount == 250 then
            fVar0 = 0.914
        elseif betAmount == 300 then
            fVar0 = 0.904
        elseif betAmount == 350 then
            fVar0 = 0.924
        elseif betAmount == 400 then
            fVar0 = 0.91
        elseif betAmount == 450 then
            fVar0 = 0.935
        elseif betAmount == 500 then
            fVar0 = 0.95
        elseif betAmount == 1000 then
            fVar0 = 0.95
        elseif betAmount == 1500 then
            fVar0 = 0.904
        elseif betAmount == 2000 then
            fVar0 = 0.899
        elseif betAmount == 2500 then
            fVar0 = 0.915
        elseif betAmount == 3000 then
            fVar0 = 0.904
        elseif betAmount == 3500 then
            fVar0 = 0.925
        elseif betAmount == 4000 then
            fVar0 = 0.91
        elseif betAmount == 4500 then
            fVar0 = 0.935
        elseif betAmount == 5000 then
            fVar0 = 0.95
        elseif betAmount == 6000 then
            fVar0 = 0.919
        elseif betAmount == 7000 then
            fVar0 = 0.924
        elseif betAmount == 8000 then
            fVar0 = 0.93
        elseif betAmount == 9000 then
            fVar0 = 0.935
        elseif betAmount == 10000 then
            fVar0 = 0.95
        elseif betAmount == 15000 then
            fVar0 = 0.902
        elseif betAmount == 20000 then
            fVar0 = 0.897
        elseif betAmount == 25000 then
            fVar0 = 0.912
        elseif betAmount == 30000 then
            fVar0 = 0.902
        elseif betAmount == 35000 then
            fVar0 = 0.922
        elseif betAmount == 40000 then
            fVar0 = 0.907
        elseif betAmount == 45000 then
            fVar0 = 0.932
        elseif betAmount == 50000 then
            fVar0 = 0.912
        end
		if chairId == 0 then 
			if iParam1 == 0 then 
                vVar1 = vector3(0.712625, 0.170625, 0.0001)
            elseif iParam1 == 1 then
                vVar1 = vector3(0.6658, 0.218375, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(0.756775, 0.292775, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(0.701875, 0.3439, 0.0)
            end 
        elseif chairId == 1 then 
            if iParam1 == 0 then
                vVar1 = vector3(0.278125, -0.2571, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(0.280375, -0.190375, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(0.397775, -0.208525, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(0.39715, -0.1354, 0.0)
            end 
        elseif chairId == 2 then 
            if iParam1 == 0 then
                vVar1 = vector3(-0.30305, -0.2464, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(-0.257975, -0.19715, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(-0.186575, -0.2861, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(-0.141675, -0.237925, 0.0)
            end
        elseif chairId == 3 then 
            if iParam1 == 0 then
                vVar1 = vector3(-0.72855, 0.17345, 0.0)
            elseif iParam1 == 1 then
                vVar1 = vector3(-0.652825, 0.177525, 0.0)
            elseif iParam1 == 2 then
                vVar1 = vector3(-0.6783, 0.0744, 0.0)
            elseif iParam1 == 3 then
                vVar1 = vector3(-0.604425, 0.082575, 0.0)
            end
        end 
    else 
        if betAmount == 10 then
            fVar0 = 0.95
        elseif betAmount == 20 then
            fVar0 = 0.896
        elseif betAmount == 30 then
            fVar0 = 0.901
        elseif betAmount == 40 then
            fVar0 = 0.907
        elseif betAmount == 50 then
            fVar0 = 0.95
        elseif betAmount == 60 then
            fVar0 = 0.917
        elseif betAmount == 70 then
            fVar0 = 0.922
        elseif betAmount == 80 then
            fVar0 = 0.927
        elseif betAmount == 90 then
            fVar0 = 0.932
        elseif betAmount == 100 then
            fVar0 = 0.95
        elseif betAmount == 150 then
            fVar0 = 0.904
        elseif betAmount == 200 then
            fVar0 = 0.899
        elseif betAmount == 250 then
            fVar0 = 0.914
        elseif betAmount == 300 then
            fVar0 = 0.904
        elseif betAmount == 350 then
            fVar0 = 0.924
        elseif betAmount == 400 then
            fVar0 = 0.91
        elseif betAmount == 450 then
            fVar0 = 0.935
        elseif betAmount == 500 then
            fVar0 = 0.95
        elseif betAmount == 1000 then
            fVar0 = 0.95
        elseif betAmount == 1500 then
            fVar0 = 0.904
        elseif betAmount == 2000 then
            fVar0 = 0.899
        elseif betAmount == 2500 then
            fVar0 = 0.915
        elseif betAmount == 3000 then
            fVar0 = 0.904
        elseif betAmount == 3500 then
            fVar0 = 0.925
        elseif betAmount == 4000 then
            fVar0 = 0.91
        elseif betAmount == 4500 then
            fVar0 = 0.935
        elseif betAmount == 5000 then
            fVar0 = 0.953
        elseif betAmount == 6000 then
            fVar0 = 0.919
        elseif betAmount == 7000 then
            fVar0 = 0.924
        elseif betAmount == 8000 then
            fVar0 = 0.93
        elseif betAmount == 9000 then
            fVar0 = 0.935
        elseif betAmount == 10000 then
            fVar0 = 0.95
        elseif betAmount == 15000 then
            fVar0 = 0.902
        elseif betAmount == 20000 then
            fVar0 = 0.897
        elseif betAmount == 25000 then
            fVar0 = 0.912
        elseif betAmount == 30000 then
            fVar0 = 0.902
        elseif betAmount == 35000 then
            fVar0 = 0.922
        elseif betAmount == 40000 then
            fVar0 = 0.907
        elseif betAmount == 45000 then
            fVar0 = 0.932
        elseif betAmount == 50000 then
            fVar0 = 0.912
        end 
        -- case 5000:
        -- case 10000:
        -- case 15000:
        -- case 20000:
        -- case 25000:
        -- case 30000:
        -- case 35000:
        -- case 40000:
        -- case 45000:
        if betAmount ==  50000 then
            if chairId == 0 then
                if iParam1 == 0 then
                    vVar1 = vector3(0.6931, 0.1952, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.724925, 0.26955, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.7374, 0.349625, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.76415, 0.419225, 0.0)
                end
            elseif chairId == 1 then
                if iParam1 == 0 then
                    vVar1 = vector3(0.2827, -0.227825, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.3605, -0.1898, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(0.4309, -0.16365, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(0.49275, -0.111575, 0.0)
                end
            elseif chairId == 2 then    
                if iParam1 == 0 then
                    vVar1 = vector3(-0.279425, -0.2238, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.200775, -0.25855, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.125775, -0.26815, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.05615, -0.29435, 0.0)
                end 
            elseif chairId ==  3 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.685925, 0.173275, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.6568, 0.092525, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.612875, 0.033025, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.58465, -0.0374, 0.0)
                end 
            end 
        else 
            if chairId == 0 then 
                if iParam1 == 0 then
                    vVar1 = vector3(0.712625, 0.170625, 0.0)       
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.6658, 0.218375, 0.0)      
                elseif iParam1 ==  2 then
                    vVar1 = vector3(0.756775, 0.292775, 0.0)
                elseif iParam1 ==  3 then
                    vVar1 = vector3(0.701875, 0.3439, 0.0)
                end 
            elseif chairId == 1 then 
                if iParam1 == 0 then 
                    vVar1 = vector3(0.278125, -0.2571, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(0.280375, -0.190375, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(0.397775, -0.208525, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(0.39715, -0.1354, 0.0)
                end
            elseif chairId == 2 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.30305, -0.2464, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.257975, -0.19715, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.186575, -0.2861, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.141675, -0.237925, 0.0)
                end 
            elseif chairId == 3 then
                if iParam1 == 0 then
                    vVar1 = vector3(-0.72855, 0.17345, 0.0)
                elseif iParam1 == 1 then
                    vVar1 = vector3(-0.652825, 0.177525, 0.0)
                elseif iParam1 == 2 then
                    vVar1 = vector3(-0.6783, 0.0744, 0.0)
                elseif iParam1 == 3 then
                    vVar1 = vector3(-0.604425, 0.082575, 0.0)
                end 
            end 
        end
    end 
    -- print(vVar1) 
    -- print(vVar1.z) 
    -- print(fVar0) 
    --vVar1.z = fVar0
    vVar1 = vVar1 + vector3(0.0,0.0,fVar0)
    return vVar1
end 

function blackjack_func_373(iParam0, iParam1, iParam2, bParam3)
	if not bParam3 then 
		if iParam2 == 0 then 
            if iParam1 == 0 then
                return vector3(0.0, 0.0, 72)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, 64.8)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, 74.52)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, 72)
            end
        elseif iParam2 == 1 then 
            if iParam1 == 0 then
                return vector3(0.0, 0.0, 12.96)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, 29.16)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, 32.04)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, 32.04)
            end 
		elseif iParam2 == 2 then
            if iParam1 == 0 then
                return vector3(0.0, 0.0, -18.36)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, -18.72)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, -15.48)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, -18)
            end 
        elseif iParam2 == 3 then
            if iParam1 == 0 then
                return vector3(0.0, 0.0, -79.2)
            elseif iParam1 == 1 then
                return vector3(0.0, 0.0, -68.76)
            elseif iParam1 == 2 then
                return vector3(0.0, 0.0, -57.6)
            elseif iParam1 == 3 then
                return vector3(0.0, 0.0, -64.8)
            end
		end 
	else
        -- case 5000 then
        -- case 10000 then
        -- case 15000 then
        -- case 20000 then
        -- case 25000 then
        -- case 30000 then
        -- case 35000 then
        -- case 40000 then
        -- case 45000 then
        if iParam0 == 50000 then 
            if iParam2 == 0 then 
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -16.56)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -22.32)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -10.8)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -9.72)
                end
            elseif iParam2 == 1 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -69.12)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -64.8)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -58.68)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -51.12)
                end
            elseif iParam2 == 2 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -112.32)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -108.36)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -99.72)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -102.6)
                end
            elseif iParam2 == 3 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -155.88)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -151.92)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -147.24)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -146.52)
                end
            end 
        else
            if iParam2 == 0 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, 72)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, 64.8)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, 74.52)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, 72)
                end
            elseif iParam2 == 1 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, 12.96)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, 29.16)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, 32.04)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, 32.04)
                end 
            elseif iParam2 == 2 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -18.36)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -18.72)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -15.48)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -18)
                end 
            elseif iParam2 == 3 then
                if iParam1 == 0 then
                    return vector3(0.0, 0.0, -79.2)
                elseif iParam1 == 1 then
                    return vector3(0.0, 0.0, -68.76)
                elseif iParam1 == 2 then
                    return vector3(0.0, 0.0, -57.6)
                elseif iParam1 == 3 then
                    return vector3(0.0, 0.0, -64.8)
                end
            end
        end  
    end
    return vector3(0.0, 0.0, 0)
end

function getTableCoords(id) --previously blackjack_func_70
    if _blackjackTables[id] ~= nil then 
        return _blackjackTables[id].table.coords.x, _blackjackTables[id].table.coords.y, _blackjackTables[id].table.coords.z 
    else
        return 0.0,0.0,0.0 --(i.e for dealer)
    end
end

function getLocalChairIndexFromGlobalChairId(globalChairId) --returns tableID based on chairID
    if globalChairId ~= -1 then 
        return (globalChairId % 4)
    else 
        return 100
    end
end

function getLocalChairIdFromGlobalChairId(globalChairId) --returns tableID based on chairID
    if globalChairId ~= -1 then 
        return (globalChairId % 4) + 1
    else 
        return 100
    end
end

function getDealerFromTableId(tableId)
    return _BJdealerPeds[tableId]
end

function getDealerFromChairId(chairId)
    tableId = blackjack_func_368(chairId)
    return getDealerFromTableId(tableId)
end

function goToBlackjackSeat(seatId)
    sittingAtBlackjackTable = true
    waitingForSitDownState = true
    canExitBlackjack = true
    currentHand = 0
    dealersHand = 0
    --showHowToBlackjack(false)
    closestDealerPed = getDealerFromChairId(seatId)
    PlayAmbientSpeech1(closestDealerPed,"MINIGAME_DEALER_GREET","SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)

    loadAnim("anim_casino_b@amb@casino@games@blackjack@dealer")
    loadAnim("anim_casino_b@amb@casino@games@shared@dealer@")
    loadAnim("anim_casino_b@amb@casino@games@blackjack@player")
    loadAnim("anim_casino_b@amb@casino@games@shared@player@")

    satOnSeat = seatId
    --print("blackjackSeatID: " .. blackjackSeatID)
    fVar3 = blackjack_func_217(LocalPlayer.state.ped,GetBlackjackAnimOffset(satOnSeat, 0), 1)
    fVar4 = blackjack_func_217(LocalPlayer.state.ped,GetBlackjackAnimOffset(satOnSeat, 1), 1)
    fVar5 = blackjack_func_217(LocalPlayer.state.ped,GetBlackjackAnimOffset(satOnSeat, 2), 1)
    if (fVar4 < fVar5 and fVar4 < fVar3) then 
      Local_198f_251 = 1
    elseif (fVar5 < fVar4 and fVar5 < fVar3) then 
      Local_198f_251 = 2
    else
      Local_198f_251 = 0
    end
    --blackjack_func_218 is get_anim_offset
    --param0 is 0-3 && param1 is 0-15? (OF blackjack_func_218 GetBlackjackAnimOffset)
    local walkToVector = GetBlackjackAnimOffset(satOnSeat, Local_198f_251)
    local targetHeading = blackjack_func_216(satOnSeat, Local_198f_251)
    TaskGoStraightToCoord(LocalPlayer.state.ped, walkToVector.x, walkToVector.y, walkToVector.z, 1.0, 5000, targetHeading, 0.01)

    local goToVector = blackjack_func_348(satOnSeat)
    local xRot,yRot,zRot = blackjack_func_215(satOnSeat)
    syncedScene = NetworkCreateSynchronisedScene(goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 2, 1, 0, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(LocalPlayer.state.ped, syncedScene, "anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(Local_198f_251), 2.0, -2.0, 13, 16, 2.0, 0) -- 8.0, -1.5, 157, 16, 1148846080, 0) ?
    NetworkStartSynchronisedScene(syncedScene)
    --Local_198.f_255 = NETWORK::NETWORK_CREATE_SYNCHRONISED_SCENE(func_348(Local_198.f_247), func_215(Local_198.f_247), 2, 1, 0, 1065353216, 0, 1065353216)
    --NETWORK::NETWORK_ADD_PED_TO_SYNCHRONISED_SCENE(PLAYER::PLAYER_PED_ID(), Local_198.f_255, "anim_casino_b@amb@casino@games@shared@player@", blackjack_func_213(Local_198f_251), 2f, -2f, 13, 16, 2f, 0)
    --NETWORK::NETWORK_START_SYNCHRONISED_SCENE(Local_198.f_255)

    --NEXT --> Line 5552
    Citizen.InvokeNative(0x79C0E43EB9B944E2, -2124244681)
    Wait(3000)
    --print("STOP STITTING ")
    --Wait for sit down anim to end
    local sittingDown = NetworkCreateSynchronisedScene(goToVector.x, goToVector.y, goToVector.z, xRot, yRot, zRot, 2, 1, 1, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(LocalPlayer.state.ped, sittingDown, "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 2.0, -2.0, 13, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(sittingDown)
    StartAudioScene("DLC_VW_Casino_Table_Games") --need to stream this
    Citizen.InvokeNative(0x79C0E43EB9B944E2, -2124244681)
    waitingForSitDownState = false
    shouldForceIdleCardGames = true
end

function leaveBlackjackSeat()
    shouldForceIdleCardGames = false

    loadAnim("anim_casino_b@amb@casino@games@shared@player@")
    NetworkStopSynchronisedScene(syncedScene)

    ClearPedTasksImmediately(LocalPlayer.state.ped)
    TaskPlayAnim(LocalPlayer.state.ped, "anim_casino_b@amb@casino@games@shared@player@", "sit_exit_left", 1.0, 1.0, 2500, 0)              
    --SetPlayerControl(PlayerId(),1,256,0)

    PlayAmbientSpeech1(getDealerFromChairId(_BJclosestChair), "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME","SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
end

function leaveBlackjackSeatForced()
    shouldForceIdleCardGames = false

    NetworkStopSynchronisedScene(syncedScene)
    ClearPedTasksImmediately(LocalPlayer.state.ped)
end

function betBlackjack(amount,chairId)
    local chipsProp = getChipPropFromAmount(amount)
    --betChipsForNextHand(100,chipsProp,pos,chairId,false,stack/100) --false or true no clue
    -- for stack=1,10,1 do 
    --     for pos=0,1,1 do  --can be 0 to 3, however last 2 chip x/y positions are for a split I think
            
    --     end
    -- end
    for i,v in ipairs(chipsProp) do 
        betChipsForNextHand(100,v,0,chairId,false,(i-1)/200) --false or true no clue
    end
end

function betChipsForNextHand(chipsAmount,chipsProp,something,chairID,someBool,zOffset)
    -- Local_198.f_538[func_379(iVar2, iVar9, 0)] = OBJECT::CREATE_OBJECT_NO_OFFSET(func_375(iVar14, bVar4), OBJECT::_GET_OBJECT_OFFSET_FROM_COORDS(func_70(iVar2), vVar8.z, func_374(iVar14, 0, iVar9, bVar4)), 0, false, 1);
    -- ENTITY::SET_ENTITY_COORDS_NO_OFFSET(Local_198.f_538[func_379(iVar2, iVar9, 0)], 
    --^-> OBJECT::_GET_OBJECT_OFFSET_FROM_COORDS(func_70(iVar2), vVar8.z, func_374(iVar14, 0, iVar9, bVar4)), 0, 0, 1);
    -- ENTITY::SET_ENTITY_ROTATION(Local_198.f_538[func_379(iVar2, iVar9, 0)], vVar8 + func_373(iVar14, 0, iVar9, bVar4), 2, 1);
    -- if (!MISC::IS_STRING_NULL_OR_EMPTY(func_372(iVar14)))
    -- {
    --     AUDIO::PLAY_SOUND_FROM_ENTITY(-1, func_372(iVar14), Local_198.f_538[func_379(iVar2, iVar9, 0)], "dlc_vw_table_games_sounds", 0, 0);
    -- }
    --print("betChipsForNextHand",chairID)
    --print("betChipsForNextHand_local",getLocalChairIndexFromGlobalChairId(chairID))
    RequestModel(chipsProp)
    while not HasModelLoaded(chipsProp) do  
        Wait(0)
        RequestModel(chipsProp)
    end
    vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairID)))
    local tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairID))
    local chipsVector = blackjack_func_374(chipsAmount,something,getLocalChairIndexFromGlobalChairId(chairID),someBool)
    local chipsOffset = GetObjectOffsetFromCoords(tablePosX,tablePosY,tablePosZ, vVar8.z, chipsVector.x, chipsVector.y, chipsVector.z)
    
    local chipsObj = CreateObjectNoOffset(GetHashKey(chipsProp), chipsOffset.x,chipsOffset.y,chipsOffset.z, false, false, 1)
    if _BJcardObjects[tostring(chairID) .. "chips"] ~= nil then
        table.insert(_BJcardObjects[tostring(chairID) .. "chips"],chipsObj)
    else 
        _BJcardObjects[tostring(chairID) .. "chips"] = {}
        table.insert(_BJcardObjects[tostring(chairID) .. "chips"],chipsObj)
    end
    SetEntityCoordsNoOffset(chipsObj, chipsOffset.x, chipsOffset.y, chipsOffset.z+zOffset, 0, 0, 1)
    local chipOffsetRotation = blackjack_func_373(chipsAmount,0,getLocalChairIndexFromGlobalChairId(chairID),someBool)
    SetEntityRotation(chipsObj,vVar8 + chipOffsetRotation, 2, 1)

    --print("betChips DEBUG")
    --print("==============")
    --print("zOffset: " .. tostring(zOffset))
    --print("vVar8: " .. tostring(vVar8))
    --print("tablePosX: " .. tostring(tablePosX))
    --print("tablePosY: " .. tostring(tablePosY))
    --print("tablePosZ: " .. tostring(tablePosZ))
    --print("chipsVector: " .. tostring(chipsVector))
    --print("chipsOffset: " .. tostring(chipsOffset))
    --print("chipsObj: " .. tostring(chipsObj))
    --print("chipOffsetRotation: " .. tostring(chipOffsetRotation))
end

function getTableHeading(id) --previously blackjack_func_69
    if _blackjackTables[id] then 
        return _blackjackTables[id].table.heading
    else
        return 0.0 --(i.e for dealer)
    end
end

function DoBlackjackDeclineCardAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@blackjack@player", "decline_card_001")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end

function DoBlackjackRequestCardAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@blackjack@player", "request_card")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function DoBlackjackPlaceBetAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@blackjack@player", getAnimNameFromBet(100))

    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function DoBlackjackBustAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_terrible_var_01")
    SetTimeout(duration, function()
        shouldForceIdleCardGames = true
    end)
end 

function DoBlackjackLossAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_bad_var_01")
    SetTimeout(duration * 0.9, function()
        shouldForceIdleCardGames = true
    end)
end 

function DoBlackjackPushAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_impartial_var_01")
    SetTimeout(duration * 0.9, function()
        shouldForceIdleCardGames = true
    end)
end 

function DoBlackjackWinAnimation()
    shouldForceIdleCardGames = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_good_var_01")
    SetTimeout(duration * 0.9, function()
        shouldForceIdleCardGames = true
    end)
end 

function startDealing(tableId, dealerPed, cardData, chairId, cardIndex, gotCurrentHand, fakeChairIdForDealerTurn)
    --print("startDealing()")
    --NEXT --> func_90 the FAT FUNCTION
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand") --need to stream this
    --ensureCardModelsLoaded() --request all 52 card models
    --AUDIO::_0xF8AD2EED7C47E8FE(iVar1, false, 1); call sound on dealer
    ----------------THIS CREATES A CARD AT THE MACHINE WHERE THE CARD COMES OUT OF-----------------------
    --print("dealerPed: " .. tostring(dealerPed))
    --print("DoesEntityExist(dealerPed): " .. tostring(DoesEntityExist(dealerPed)))
    --print("NetworkHasControlOfEntity(dealerPed): " .. tostring(NetworkHasControlOfEntity(dealerPed)))
    if DoesEntityExist(dealerPed) then
        --print("startDealing() - entityExists")
        --print("request cardId: " .. tostring(cardData[cardIndex])) 
        nextCard = getCardFromNumber(cardData[cardIndex],true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
        local genderAnimString = getDealerAnimString(tableId)

        if chairId >= 0 then
            --print("[blackjack] giving player cards")
            dealerGiveCards(chairId,genderAnimString,dealerPed,nextCardObj) 
        else 
            --print("[blackjack] giving dealers cards")
            dealerGiveSelfCard(genderAnimString,dealerPed,cardIndex,nextCardObj) 
        end
        DetachEntity(nextCardObj,false,true)
        if chairId >= 0 or cardIndex ~= 2 then
            local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
            --print("trying soundString: " .. tostring(soundCardString))
            PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        end
        --ENTITY::SET_ENTITY_COORDS_NO_OFFSET(Local_198.f_648[iVar6], OBJECT::_GET_OBJECT_OFFSET_FROM_COORDS(func_70(iVar2), vVar8.z, func_377(iVar5, iVar9, 0)), 0, 0, 1);
        --ENTITY::SET_ENTITY_ROTATION(Local_198.f_648[iVar6], vVar8 + func_376(iVar5, iVar9, 0, func_380(iVar6)), 2, 1);
        cardQueue = cardIndex -- number of card
        iVar5 = cardQueue
        iVar9 = chairId -- <-localChairId 0-3
        if chairId >= 0 then
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
            tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairId))
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, getLocalChairIndexFromGlobalChairId(chairId), 0) --iVar9 is the local seat number 0-3
        else
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(fakeChairIdForDealerTurn)))
            tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(fakeChairIdForDealerTurn))
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, 4, 1)
        end
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        --print("fakeChairIdForDealerTurn",fakeChairIdForDealerTurn)
        if chairId >= 0 then
            vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId))) 
            cardObjectOffsetRotation = vVar8 + func_376(iVar5, getLocalChairIndexFromGlobalChairId(chairId), 0, false)
            SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
        else 
            cardObjectOffsetRotation = blackjack_func_398(blackjack_func_368(fakeChairIdForDealerTurn))
        end
        --print("checking betttingInstructional",closestChair,chairId)
        -- if closestChair == chairId and sittingAtBlackjackTable then
        --     bettingInstructional = setupBlackjackMidBetScaleform("instructional_buttons")
        -- end
        --soundID = GetSoundId()
        --PlaySoundFromEntity(soundID,"DLC_VW_CHIP_BET_SML_MEDIUM",nextCardObj,"dlc_vw_table_games_sounds", 0, 0)
        return nextCardObj
    else 
        --print("Failed to deal cards, entity doesn't exist or we don't have control")
    end 
end

function ensureCardModelsLoaded()
    for i = 1, 52 do
        local model = getCardFromNumber(i, 1)
        if not HasModelLoaded(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
        end
    end
end

function getNewCardFromMachine(nextCard,chairId,tableId)
    print("getNewCardFromMachine:",chairId)
    RequestModel(nextCard)
    while not HasModelLoaded(nextCard) do  
        Wait(0)
        RequestModel(nextCard)
    end
    nextCardHash = GetHashKey(nextCard)
    local cardObjectOffset = blackjack_func_399(blackjack_func_368(chairId))
    local nextCardObj = CreateObjectNoOffset(nextCardHash, cardObjectOffset.x, cardObjectOffset.y, cardObjectOffset.z, false, false, 1)
    if _BJcardObjects[chairId] then
        if tableId then
            if not _BJcardObjects[tableId] then
                _BJcardObjects[tableId] = {}
            end
            --print("inserting chipsobjects with key: " .. tostring(tableId))
            table.insert(_BJcardObjects[tableId],nextCardObj)
        else
            --print("inserting chipsobjects with key: " .. tostring(chairId))
            table.insert(_BJcardObjects[chairId],nextCardObj)
        end
    else
        _BJcardObjects[chairId] = {}
        if tableId then
            if not _BJcardObjects[tableId] then
                _BJcardObjects[tableId] = {}
            end
            --print("inserting chipsobjects with key: " .. tostring(tableId))
            table.insert(_BJcardObjects[tableId],nextCardObj)
        else
            --print("inserting chipsobjects with key: " .. tostring(chairId))
            table.insert(_BJcardObjects[chairId],nextCardObj)
        end
    end
    SetEntityVisible(nextCardObj,false)
    SetModelAsNoLongerNeeded(nextCardHash)
    local cardObjectOffsetRotation = blackjack_func_398(blackjack_func_368(chairId))
    SetEntityCoordsNoOffset(nextCardObj, cardObjectOffset.x, cardObjectOffset.y, cardObjectOffset.z, 0, 0, 1)
    --vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
    
    --if chairId > 99 then 
    --    cardObjectOffsetRotation = vVar8 + func_376(iVar5, iVar9, 0, false)
    --else 
    --    cardObjectOffsetRotation = blackjack_func_398(blackjack_func_368(chairId))
    --end
    --print("cardObjectOffsetRotation.x: " .. tostring(cardObjectOffsetRotation.x))
    --print("cardObjectOffsetRotation.y: " .. tostring(cardObjectOffsetRotation.y))
    --print("cardObjectOffsetRotation.z: " .. tostring(cardObjectOffsetRotation.z))
    SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
    --FreezeEntityPosition(nextCardObj, true)
    return nextCardObj
end

function dealerGiveCards(chairId,gender,dealerPed,cardObj) --func_36
    local seatNumber = tostring(getLocalChairIdFromGlobalChairId(chairId))
    --local currentScene = NetworkCreateSynchronisedScene(x, y, z, 0.0, 0.0, zRot, 2, 1, 0, 1065353216, 0, 1065353216)
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", gender .. "deal_card_player_0" .. seatNumber, 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed,"deal_card_player_0"..seatNumber.."_facial")
    --NetworkStartSynchronisedScene(currentScene)
    --func_15(func_21(iParam0, Local_188.f_899[iVar2 /*9*/].f_8, 0, 0), Local_188.f_1[iParam0 /*211*/][Local_188.f_1[iParam0 /*211*/].f_209], 0, 0);
    Wait(300)
    SetEntityVisible(cardObj,true)
    while not HasAnimEventFired(dealerPed, 585557868) do 
        Wait(0)
        --print("waiting for anim event to fire.. for dealergivecards")
    end 
end

function dealerGiveSelfCard(gender,dealerPed,cardIndex,cardObj) --func_36
    if cardIndex == 1 then 
        cardAnim = "deal_card_self_second_card"
    elseif cardIndex == 2 then 
        cardAnim = "deal_card_self"
    else 
        cardAnim = "deal_card_self_card_10"
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", gender .. cardAnim, 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed, gender .. cardAnim.."_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    Wait(300)
    SetEntityVisible(cardObj,true)
    while not HasAnimEventFired(dealerPed, 585557868) do 
        Wait(0)
        --print("waiting for anim event to fire.. for dealerGiveSelfCard")
    end
    Wait(100)
end

function flipDealerCard(dealerPed, tableId, gotCurrentHand)
    cardObj = _BJlastDealerCard[tableId]

    local cardX,cardY,cardZ = GetEntityCoords(cardObj)
    local genderAnimString = getDealerAnimString(tableId) 
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "check_and_turn_card", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    --PlayFacialAnim(dealerPed, genderAnimString .. "check_and_turn_card_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    while not HasAnimEventFired(dealerPed,-1345695206) do
        --print("waiting for -1345695206 to fire")
        Wait(0)
    end
    AttachEntityToEntity(cardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
    while not HasAnimEventFired(dealerPed,585557868) do
        Wait(0)
    end
    DetachEntity(cardObj,false,true)
    -- if blackjack_func_368(closestChair) == tableId then
    --     dealersHand = gotCurrentHand
    -- end    
    local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
    PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
    SetEntityCoordsNoOffset(cardObj, cardX,cardY,cardZ)
end

-- function checkCard(dealerPed,cardObj)
--     local cardX,cardY,cardZ = GetEntityCoords(cardObj)
--     AttachEntityToEntity(cardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
--     local genderAnimString = getDealerAnimString(tableId)
--     -- local gender = getDealerGenderFromPed(dealerPed)
--     -- if gender == "male" then 
--     -- end 
--     -- if gender == "female" then 
--     --     genderAnimString = "female_" 
--     -- end 
--     TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "check_card", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
--     PlayFacialAnim(dealerPed, genderAnimString .. "check_card_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
--     while not HasAnimEventFired(dealerPed,585557868) do
--         Wait(0)
--     end
--     Wait(100)
--     DetachEntity(cardObj,false,true)
--     SetEntityCoordsNoOffset(cardObj, cardX,cardY,cardZ)
-- end

function startSingleDealerDealing(dealerPed, tableId, card, nextCardCount, gotCurrentHand, chairId)
    --print("startSingleDealerDealing", chairId)
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand") --need to stream this
    ensureCardModelsLoaded() --request all 52 card models
    --AUDIO::_0xF8AD2EED7C47E8FE(iVar1, false, 1); call sound on dealer
    ----------------THIS CREATES A CARD AT THE MACHINE WHERE THE CARD COMES OUT OF-----------------------
    --print("dealerPed: " .. tostring(dealerPed))
    --print("DoesEntityExist(dealerPed): " .. tostring(DoesEntityExist(dealerPed)))
    --print("NetworkHasControlOfEntity(dealerPed): " .. tostring(NetworkHasControlOfEntity(dealerPed)))
    --print("getLocalChairIdFromGlobalChairId: " .. tostring(getLocalChairIdFromGlobalChairId))
    if DoesEntityExist(dealerPed) then
        cardPosition = nextCardCount
        --print("getLocalChairIdFromGlobalChairId: " .. tostring(getLocalChairIdFromGlobalChairId))
        nextCard = getCardFromNumber(card, true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
        local genderAnimString = getDealerAnimString(tableId)

        dealerGiveSelfCard(genderAnimString,dealerPed,3,nextCardObj)
        DetachEntity(nextCardObj,false,true)
        --print("blackjack_func_368(closestChair)",blackjack_func_368(closestChair))
        --print("tableId",tableId)
        -- if blackjack_func_368(closestChair) == tableId then
        --     dealersHand = gotCurrentHand
        -- end
        local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
        --print(soundCardString)
        PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(tableId))
        local tablePosX,tablePosY,tablePosZ = getTableCoords(tableId)
        local cardQueue = cardPosition -- number of card
        local iVar5 = cardQueue
        cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, 4, 1) --iVar9 is seat number 0-3
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        Wait(400)
    else 
        --print("Failed to deal cards, entity doesn't exist or we don't have control")
    end
end

function startSingleDealing(chairId,dealerPed,cardData,nextCardCount,gotCurrentHand)
    N_0x469f2ecdec046337(1)
    StartAudioScene("DLC_VW_Casino_Cards_Focus_Hand") --need to stream this
    ensureCardModelsLoaded()

    local genderAnimString = getDealerAnimString(blackjack_func_368(chairId))
    if DoesEntityExist(dealerPed) then
        --print(chairId)
        local localChairId = getLocalChairIdFromGlobalChairId(chairId)
        cardPosition = nextCardCount
        nextCard = getCardFromNumber(cardData,true)
        local nextCardObj = getNewCardFromMachine(nextCard,chairId)
        AttachEntityToEntity(nextCardObj, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)

        dealerGiveCards(chairId,genderAnimString,dealerPed,nextCardObj) 
        DetachEntity(nextCardObj,false,true)
        -- if chairId == closestChair then
        --     currentHand = gotCurrentHand
        -- end
        local soundCardString = "MINIGAME_BJACK_DEALER_" .. tostring(gotCurrentHand)
        --print("trying soundString: " .. tostring(soundCardString))
        PlayAmbientSpeech1(dealerPed,soundCardString,"SPEECH_PARAMS_FORCE_NORMAL_CLEAR",1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
        local tablePosX,tablePosY,tablePosZ = getTableCoords(blackjack_func_368(chairId))
        local cardQueue = cardPosition -- number of card
        local iVar5 = cardQueue
        local iVar9 = localChairId - 1-- <-ChairID 0-3
        if iVar9 <= 4 then
            --print("single card pos: " .. tostring(iVar5)) 
            cardOffsetX,cardOffsetY,cardOffsetZ = blackjack_func_377(iVar5, iVar9, 0) --iVar9 is seat number 0-3
        else 
            cardOffsetX,cardOffsetY,cardOffsetZ = 0.5737, 0.2376, 0.948025
        end
        local cardPos = GetObjectOffsetFromCoords(tablePosX, tablePosY, tablePosZ, vVar8.z, cardOffsetX, cardOffsetY, cardOffsetZ)
        SetEntityCoordsNoOffset(nextCardObj, cardPos.x, cardPos.y, cardPos.z, 0, 0, 1)
        vVar8 =  vector3(0.0, 0.0, getTableHeading(blackjack_func_368(chairId)))
        cardObjectOffsetRotation = vVar8 + func_376(iVar5, iVar9, 0, false)
        SetEntityRotation(nextCardObj, cardObjectOffsetRotation.x, cardObjectOffsetRotation.y, cardObjectOffsetRotation.z, 2, 1)
        Wait(400)    
    else 
        --print("Failed to deal cards, entity doesn't exist or we don't have control")
    end
end

function startStandOrHit(dealerPed, tableId, chairId)
    chairAnimId = getLocalChairIdFromGlobalChairId(chairId)

    local genderAnimString = getDealerAnimString(tableId) 

    --print("dealerPed: " .. tostring(dealerPed))
    --print("chairAnimId: " .. tostring(chairAnimId))
    --print("genderAnimString: " .. tostring(genderAnimString))
    RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@dealer")
    while not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer") do 
        Wait(0)
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_intro", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    PlayFacialAnim(dealerPed, genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
    Wait(0)
    while IsEntityPlayingAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle_intro") do 
        Wait(10)
        --print("waiting for anim to end #1")
    end
    TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "dealer_focus_player_0" .. chairAnimId .. "_idle", 3.0, 1.0, -1, 2, 0, 0, 0, 0 )
    if actuallyPlaying then
        waitingForPlayerToHitOrStand = true
    end
end

function cleanUpChips(chairId, tableId)
    if string.sub(chairId, -5) ~= "chips" then
        local dealerPed = getDealerFromTableId(tableId)
        local genderAnimString = getDealerAnimString(tableId)

        localChairId = getLocalChairIdFromGlobalChairId(chairId)
        if chairId >= 0 then
            TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "retrieve_cards_player_0" .. tostring(localChairId), 3.0, 1.0, -1, 2, 0, 0, 0, 0)
            PlayFacialAnim(dealerPed, genderAnimString .. "retrieve_cards_player_0" .. tostring(localChairId).."_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
        else
            TaskPlayAnim(dealerPed, "anim_casino_b@amb@casino@games@blackjack@dealer", genderAnimString .. "retrieve_own_cards_and_remove", 3.0, 1.0, -1, 2, 0, 0, 0, 0)
            PlayFacialAnim(dealerPed, genderAnimString .. "retrieve_own_cards_and_remove_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")
        end
        while not HasAnimEventFired(dealerPed,-1345695206) do
            --print("waiting for -1345695206 to fire")
            Wait(0)
        end
        for k,v in pairs(_BJcardObjects) do
            if k == chairId then
                for k2,v2 in pairs(v) do
                    --print("attach entity chairId",k,"objkey",k2," objvalue",v2)
                    AttachEntityToEntity(v2, dealerPed, GetPedBoneIndex(dealerPed,28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
                end
            end
        end
        while not HasAnimEventFired(dealerPed,585557868) do
            --print("waiting for 585557868 to fire")
            Wait(0)
        end
        for k,v in pairs(_BJcardObjects) do
            if k == chairId then
                for k2,v2 in pairs(v) do
                    DeleteEntity(v2)
                    --v[k2] = nil
                end
            end
        end
    else
        for k,v in pairs(_BJcardObjects) do
            if k == chairId then
                for k2,v2 in pairs(v) do
                    DeleteEntity(v2)
                    --v[k2] = nil
                end
            end
        end
    end
end