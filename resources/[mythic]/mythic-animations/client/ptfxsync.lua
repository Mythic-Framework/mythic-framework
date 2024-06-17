-- local _syncedPtfx = {}

-- AddStateBagChangeHandler('animPtfx', nil, function(bagName, key, value, _unused, replicated)
--     if not LocalPlayer.state.loggedIn then return; end

--     local pSrc, count = bagName:gsub('player:', '')
--     if count > 0 then
--         UpdatePlayerPtfx(tonumber(pSrc), value)
--     end
-- end)

-- function UpdatePlayerPtfx(source, value)
--     -- Clear Old Particle FX
--     if _syncedPtfx[source] then
--         StopParticleFxLooped(_syncedPtfx[source].fx, false)
--         RemoveNamedPtfxAsset(_syncedPtfx[source].asset)

--         _syncedPtfx[source] = nil
--     end

--     if value then -- Play the New Particle FX
--         local animData = AnimData.PropEmotes[value]
--         if not animData then return end

--         PtfxLoad(animData.AdditionalOptions.PtfxAsset)

--         local fxLocation = GetPlayerPed(GetPlayerFromServerId(source))
--         if not animData.AdditionalOptions.PtfxNoProp then
--             fxLocation = NetToObj(Player(source)?.state?.animProp1)
--         end

--         UseParticleFxAssetNextCall(animData.AdditionalOptions.PtfxAsset)
--         local x, y, z, xRot, yRot, zRot, scale = table.unpack(animData.AdditionalOptions.PtfxPlacement)
--         newHandle = StartNetworkedParticleFxLoopedOnEntityBone(
--             animData.AdditionalOptions.PtfxName,
--             fxLocation,
--             x, y, z, xRot, yRot, zRot,
--             GetEntityBoneIndexByName(animData.AdditionalOptions.PtfxName, "VFX"),
--             1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0
--         )

--         SetParticleFxLoopedColour(newHandle, 1.0, 1.0, 1.0)

--         _syncedPtfx[source] = {
--             fx = newHandle,
--             asset = animData.AdditionalOptions.PtfxAsset,
--         }
--     end
-- end

-- RegisterNetEvent('Scopes:Client:PlayerLeftScope', function(player)
--     if not LocalPlayer.state.loggedIn then return; end

--     player = tonumber(player)

--     if _syncedPtfx[player] then
--         StopParticleFxLooped(_syncedPtfx[player].fx, false)
--         RemoveNamedPtfxAsset(_syncedPtfx[player].asset)

--         _syncedPtfx[player] = nil
--     end
-- end)

-- RegisterNetEvent('Scopes:Client:PlayerEnterScope', function(player)
--     if not LocalPlayer.state.loggedIn then return; end

--     Wait(100)
--     player = tonumber(player)

--     local ptfxVal = Player(player)?.state?.animPtfx
--     if ptfxVal then
--         UpdatePlayerPtfx(player, ptfxVal)
--     end
-- end)

-- RegisterNetEvent('Characters:Client:Logout')
-- AddEventHandler('Characters:Client:Logout', function()
--     for k, v in pairs(_syncedPtfx) do
--         StopParticleFxLooped(v.fx, false)
--         RemoveNamedPtfxAsset(v.asset)

--         _syncedPtfx[k] = nil
--         Wait(10)
--     end
-- end)