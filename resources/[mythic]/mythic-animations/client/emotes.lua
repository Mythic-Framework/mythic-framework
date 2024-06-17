local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
local IsAbleToCancel = true
local MovementType = 0
local BlendInOut = 2.0
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
local isRequestAnim = false

local IsInEmoteName = false

local currentEmoteAllData = false

ANIMATIONS.Emotes = {
    Play = function(self, emote, fromUserInput, time, notCancellable, skipDisarm)
        if IsInAnimation and fromUserInput and not IsAbleToCancel then
            return
        end

        if fromUserInput and LocalPlayer.state.sitting then
            return
        end

        if fromUserInput and (IsPedBeingStunned(LocalPlayer.state.ped) or IsPedRagdoll(LocalPlayer.state.ped) or IsPedFalling(LocalPlayer.state.ped)) then
            return Notification:Error('Cannot Do Animation Now')
        end

        if fromUserInput and LocalPlayer.state.playingCasino then
            return Notification:Error('Cannot Do Animation Now')
        end

        if IsInAnimation then
            Animations.Emotes:ForceCancel()
            Wait(250)
        end

        if emote ~= nil and type(emote) == 'string' then
            local name = string.lower(emote)
            local animInfo

            if AnimData.Emotes[name] ~= nil then
                animInfo = AnimData.Emotes[name]
            elseif AnimData.Dances[name] ~= nil then
                animInfo = AnimData.Dances[name]
            elseif AnimData.PropEmotes[name] ~= nil then
                animInfo = AnimData.PropEmotes[name]
            else
                Notification:Error('Invalid Emote')
            end
            local animTime = (time ~= nil and tonumber(time) or nil)
            local notCancellable = notCancellable ~= nil and notCancellable or false
            if animInfo ~= nil then
                DoAnEmote(animInfo, fromUserInput, animTime, notCancellable, emote, skipDisarm)
            end
        elseif emote ~= nil and type(emote) == 'table' then
            local name = string.lower(emote.name)
            local animInfo

            if AnimData.Emotes[name] ~= nil then
                animInfo = AnimData.Emotes[name]
            elseif AnimData.Dances[name] ~= nil then
                animInfo = AnimData.Dances[name]
            elseif AnimData.PropEmotes[name] ~= nil then
                animInfo = AnimData.PropEmotes[name]
            else
                Notification:Error('Invalid Emote')
            end
            if emote.prop then
                animInfo.AdditionalOptions.Prop = emote.prop
            end
            local animTime = (time ~= nil and tonumber(time) or nil)
            local notCancellable = notCancellable ~= nil and notCancellable or false
            if animInfo ~= nil then
                DoAnEmote(animInfo, fromUserInput, animTime, notCancellable, emote, skipDisarm)
            end
        end
    end,
    Cancel = function(self)
        if IsAbleToCancel then
            CancelEmote()
        end
    end,
    ForceCancel = function(self)
        -- Force Cancel Regardless of If They Can
        CancelEmote()
    end,
    Get = function(self)
        if IsInAnimation then
            return IsInEmoteName
        end
        return false
    end,
    WakeUp = function(self, pos)
        LoadAnim("switch@franklin@bed")

        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)

        if pos then
            SetEntityCoords(ped, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
            SetEntityHeading(ped, pos.h + 0.0)
        end

        Wait(500)

        TaskPlayAnim(ped, "switch@franklin@bed", "sleep_getup_rubeyes", 8.0, 8.0, -1, 8, 0, false, false, false)

        Wait(5000)
        FreezeEntityPosition(ped, false)
    end,
}

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local x, y, z = table.unpack(GetEntityCoords(LocalPlayer.state.ped))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, LocalPlayer.state.ped, GetPedBoneIndex(LocalPlayer.state.ped, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    SetEntityCollision(prop, false, true)
	SetEntityCompletelyDisableCollision(prop, false, true)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
    return prop
end

function DestroyAllProps()
    for _, v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

function DoAnEmote(emoteData, fromUserInput, length, notCancellable, emoteName, skipDisarm)

    if emoteData.AdditionalOptions.BlockVehicle and IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
        return
    end

    currentEmoteAllData = {
        emoteData = emoteData,
        fromUserInput = fromUserInput,
        length = length,
        notCancellable = notCancellable,
        emoteName = emoteName,
        skipDisarm = skipDisarm,
    }

    if (fromUserInput and emoteData.AdditionalOptions.AvailableToChar) or (not fromUserInput) then
        IsAbleToCancel = not notCancellable

        if LocalPlayer.state.sitting then
            StandTheFuckUp(true)
        end

        if not skipDisarm then
            Weapons:UnequipIfEquippedNoAnim()
        end

        ChosenDict, ChosenAnimation = emoteData.AnDictionary, emoteData.AnAnim
        AnimationDuration = -1

        if PlayerHasProp then
            DestroyAllProps()
        end

        if not GLOBAL_VEH then
            if ChosenDict == "MaleScenario" then
                ClearPedTasks(LocalPlayer.state.ped)
                TaskStartScenarioInPlace(LocalPlayer.state.ped, ChosenAnimation, 0, true)
                IsInAnimation = true
                IsInEmoteName = emoteName
                return
            elseif ChosenDict == "ScenarioObject" then
                BehindPlayer = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0.0, 0 - 0.5, -0.5);
                ClearPedTasks(LocalPlayer.state.ped)
                TaskStartScenarioAtPosition(LocalPlayer.state.ped, ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(LocalPlayer.state.ped), 0, 1, false)
                IsInAnimation = true
                IsInEmoteName = emoteName
                return
            elseif ChosenDict == "Scenario" then
                ClearPedTasks(LocalPlayer.state.ped)
                TaskStartScenarioInPlace(LocalPlayer.state.ped, ChosenAnimation, 0, true)
                IsInAnimation = true
                IsInEmoteName = emoteName
                return
            end
        end

        if ChosenDict then
            LoadAnim(ChosenDict)
        end

        MovementType = 0

        if emoteData.AdditionalOptions.EmoteMoving or GLOBAL_VEH then
            MovementType = MovementType + 50
        end

        if emoteData.AdditionalOptions.EmoteLoop then
            MovementType = MovementType + 1
        end

        if emoteData.AdditionalOptions.UpperBody then
            MovementType = MovementType + 16
        end

        if emoteData.AdditionalOptions.FlagOverride and type(emoteData.AdditionalOptions.FlagOverride) == 'number' then
            MovementType = emoteData.AdditionalOptions.FlagOverride
        end

        BlendInOut = 2.0
        if emoteData.AdditionalOptions.BlendOverride then
            BlendInOut = emoteData.AdditionalOptions.BlendOverride
        end

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.EmoteDuration == nil then
                emoteData.AdditionalOptions.EmoteDuration = -1
                AttachWait = 0
            else
                AnimationDuration = emoteData.AdditionalOptions.EmoteDuration
                AttachWait = emoteData.AdditionalOptions.EmoteDuration
            end

            if emoteData.AdditionalOptions.PtfxAsset then
                if emoteData.AdditionalOptions.PtfxAlways then
                    CreateThread(function()
                        Wait(500)
                        LocalPlayer.state:set('animPtfx', emoteName, true)
                    end)
                else
                    PtfxWait = emoteData.AdditionalOptions.PtfxWait
                    PtfxPrompt = true
                    Notification:Info(emoteData.AdditionalOptions.PtfxInfo, 5000)
                    CreateThread(function()
                        while PtfxPrompt do
                            if IsControlPressed(0, 47) then
                                LocalPlayer.state:set('animPtfx', emoteName, true)
                                Wait(PtfxWait)
                                LocalPlayer.state:set('animPtfx', false, true)
                            end
                            Wait(5)
                        end
                    end)
                end
            else
                PtfxPrompt = false
            end
        end

        TaskPlayAnim(LocalPlayer.state.ped, ChosenDict, ChosenAnimation, BlendInOut, BlendInOut, AnimationDuration, MovementType, 0, false, false, false)
        IsInAnimation = true
        MostRecentDict = ChosenDict
        MostRecentAnimation = ChosenAnimation
        IsInEmoteName = emoteName

        LocalPlayer.state:set('anim', emoteName, true)

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.Prop then
                PropName = emoteData.AdditionalOptions.Prop
                PropBone = emoteData.AdditionalOptions.PropBone
                PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(emoteData.AdditionalOptions.PropPlacement)
                if emoteData.AdditionalOptions.SecondProp then
                    SecondPropName = emoteData.AdditionalOptions.SecondProp
                    SecondPropBone = emoteData.AdditionalOptions.SecondPropBone
                    SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(emoteData.AdditionalOptions.SecondPropPlacement)
                    SecondPropEmote = true
                else
                    SecondPropEmote = false
                end
                Wait(AttachWait)
                local stupidProp1 = AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
                LocalPlayer.state:set('animProp1', ObjToNet(stupidProp1), true)
                if SecondPropEmote then
                    local stupidProp2 = AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
                end
            end
        end

        local forcedLength = false
        local animLength = GetAnimDuration(ChosenDict, ChosenAnimation) * 1000
        if length ~= nil and length > 0 then
            forcedLength = true
            animLength = length
        end

        local isLooped = false
        if emoteData.AdditionalOptions and emoteData.AdditionalOptions.EmoteLoop then
            isLooped = true
        end

        if not isLooped or forcedLength then
            SetTimeout(animLength, function()
                Animations.Emotes:ForceCancel()
                IsAbleToCancel = true
            end)
        end

        CreateThread(function()
            while LocalPlayer.state.loggedIn and IsInAnimation and ChosenDict and ChosenAnimation do
                if not IsEntityPlayingAnim(LocalPlayer.state.ped, ChosenDict, ChosenAnimation, 3) then
                    TaskPlayAnim(LocalPlayer.state.ped, ChosenDict, ChosenAnimation, BlendInOut, BlendInOut, AnimationDuration, MovementType, 0, false, false, false)
                end

                if emoteData?.AdditionalOptions?.BlockVehicle and IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
                    Animations.Emotes:ForceCancel()
                end

                Wait(250)
            end
        end)
    end
end

-- RegisterNetEvent('Routing:Client:NewRoute', function()
--     if IsInAnimation then
--         DestroyAllProps()
--         Wait(500)
--         DoAnEmote(currentEmoteAllData.emoteData, currentEmoteAllData.fromUserInput, currentEmoteAllData.length, currentEmoteAllData.notCancellable, currentEmoteAllData.emoteName, currentEmoteAllData.skipDisarm)
--     end
-- end)

function CancelEmote()
    if not IsInAnimation then
        return
    end

    if ChosenDict == "MaleScenario" or ChosenDict == "ScenarioObject" or ChosenDict == "Scenario" then
        ClearPedTasksImmediately(LocalPlayer.state.ped)
    end
    PtfxPrompt = false
    PtfxStop()
    ClearPedTasks(LocalPlayer.state.ped)
    DestroyAllProps()
    RemoveAnimDict(ChosenDict)
    IsInAnimation = false

    _doingStateAnimation = false

    LocalPlayer.state:set('anim', false, true)
    LocalPlayer.state:set('animProp1', false, true)
    LocalPlayer.state:set('animPtfx', false, true)

    local emoteOptions = currentEmoteAllData?.emoteData?.AdditionalOptions
    if emoteOptions?.Prop then
        if emoteOptions?.SecondProp then
            TriggerServerEvent('Animations:Server:ClearAttached', { 
                [GetHashKey(emoteOptions?.Prop)] = true,
                [GetHashKey(emoteOptions?.SecondProp)] = true
            })
        else
            TriggerServerEvent('Animations:Server:ClearAttached', { 
                [GetHashKey(emoteOptions?.Prop)] = true
            })
        end
    end
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = LocalPlayer.state.ped
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
    for a, b in pairs(PlayerParticles) do
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end

RegisterNetEvent('Animations:Client:CharacterDoAnEmote')
AddEventHandler('Animations:Client:CharacterDoAnEmote', function(emote)
    if LocalPlayer.state.loggedIn then
        Animations.Emotes:Play(emote, true)
    end
end)

RegisterNetEvent('Animations:Client:CharacterCancelEmote')
AddEventHandler('Animations:Client:CharacterCancelEmote', function()
    if LocalPlayer.state.loggedIn and not LocalPlayer.state.doingAction then
        Animations.Emotes:Cancel()
    end
end)

AddEventHandler('Ped:Client:Died', function()
    Animations.Emotes:ForceCancel()
end)