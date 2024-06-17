local badgeEntity = 0
local inBadgeAnim = false

local badgeModels = {
    ['lspd'] = `xrp_prop_pdbadge_1`,
    ['lscso'] = `xrp_prop_pdbadge_2`,
    ['safd'] = `xrp_prop_pdbadge_3`,
    ['doj'] = `xrp_prop_pdbadge_4`,
    ['sasp'] = `xrp_prop_pdbadge_2`,
}

function RegisterBadgeCallbacks()
    Callbacks:RegisterClientCallback("MDT:Client:CanShowBadge", function(data, cb)
        if not inBadgeAnim and not _mdtOpen and not LocalPlayer.state.doingAction and not LocalPlayer.state.isDead and not Animations.Emotes:Get() and IsPedOnFoot(LocalPlayer.state.ped) then
            StartBadgeAnim(data.Department)
            Wait(2500)

            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterClientCallback("MDT:Client:CanShowLicense", function(data, cb)
        if not inBadgeAnim and not _mdtOpen and not LocalPlayer.state.doingAction and not LocalPlayer.state.isDead and not Animations.Emotes:Get() and IsPedOnFoot(LocalPlayer.state.ped) then
            StartLicenseAnim()
            Wait(2500)

            cb(true)
        else
            cb(false)
        end
    end)
end

function StartBadgeAnim(department)
    if inBadgeAnim then return end

    local playerPed = PlayerPedId()
    local model = badgeModels[department] or `xrp_prop_pdbadge_4`
    inBadgeAnim = true

    LoadAnim('paper_1_rcm_alt1-7')
    LoadModel(model)

    badgeEntity = CreateObject(model, GetEntityCoords(playerPed), 1, 1, 0)
    AttachEntityToEntity(badgeEntity, playerPed, GetPedBoneIndex(playerPed, 57005), 0.13, 0.05, -0.06, 40.0, 55.0, -267.0, 1, 1, 0, 1, 0, 1)
    TaskPlayAnim(playerPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
    TaskPlayAnim(playerPed, 'paper_1_rcm_alt1-7', 'player_one_dual-7', 1.0, 1.0, -1, 50, 0, 0, 0, 0)

    SetTimeout(11000, function()
        StopBadgeAnim()
    end)
end

function StopBadgeAnim()
    if inBadgeAnim then
        StopAnimTask(PlayerPedId(), 'paper_1_rcm_alt1-7', 'player_one_dual-7', 3.0)
        DeleteEntity(badgeEntity)

        inBadgeAnim = false
    end
end

function StartLicenseAnim()
    if inBadgeAnim then return end

    local playerPed = PlayerPedId()
    inBadgeAnim = true

    LoadAnim('paper_1_rcm_alt1-7')

    TaskPlayAnim(playerPed, 1.0, -1, -1, 50, 0, 0, 0, 0)
    TaskPlayAnim(playerPed, 'paper_1_rcm_alt1-7', 'player_one_dual-7', 1.0, 1.0, -1, 50, 0, 0, 0, 0)

    SetTimeout(11000, function()
        StopLicenseAnim()
    end)
end

function StopLicenseAnim()
    if inBadgeAnim then
        StopAnimTask(PlayerPedId(), 'paper_1_rcm_alt1-7', 'player_one_dual-7', 3.0)

        inBadgeAnim = false
    end
end

RegisterNetEvent("MDT:Client:ShowBadge", function(sender, data)
    if not LocalPlayer.state.loggedIn or LocalPlayer.state.inventoryOpen then return; end

    local senderClient = GetPlayerFromServerId(sender)

    local isMe = false
    if sender == LocalPlayer.state.ID then
        isMe = true
    end

    Logger:Trace('MDT/Badge', string.format('Sender Source: %s; Sender Player: %s; My Source: %s; My Ped: %s', sender, senderClient, LocalPlayer.state.ID, LocalPlayer.state.ped))

    if senderClient < 0 and not isMe then
        return
    end

    if not senderClient then
        return
    end

    local myPed = LocalPlayer.state.ped
    local senderPed = GetPlayerPed(senderClient)

    if DoesEntityExist(senderPed) then
        local dist = #(GetEntityCoords(senderPed) - GetEntityCoords(myPed))

        if dist <= 4.0 and HasEntityClearLosToEntity(myPed, senderPed, 17) then
            MDT.Badges:Open(data)
        end
    end
end)

RegisterNetEvent("MDT:Client:ShowLicense", function(sender, data)
    if not LocalPlayer.state.loggedIn or LocalPlayer.state.inventoryOpen then return; end

    local senderClient = GetPlayerFromServerId(sender)

    local isMe = false
    if sender == LocalPlayer.state.ID then
        isMe = true
    end

    Logger:Trace('MDT/Badge', string.format('Sender Source: %s; Sender Player: %s; My Source: %s; My Ped: %s', sender, senderClient, LocalPlayer.state.ID, LocalPlayer.state.ped))

    if senderClient < 0 and not isMe then
        return
    end

    if not senderClient then
        return
    end

    local myPed = LocalPlayer.state.ped
    local senderPed = GetPlayerPed(senderClient)

    if DoesEntityExist(senderPed) then
        local dist = #(GetEntityCoords(senderPed) - GetEntityCoords(myPed))

        if dist <= 4.0 and HasEntityClearLosToEntity(myPed, senderPed, 17) then
            MDT.Licenses:Open(data)
        end
    end
end)