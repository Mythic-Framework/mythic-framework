function DrawUIText(font, centre, x, y, scale, r, g, b, a, text)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y) 
end

RegisterNetEvent('Damage:Client:Die', function()
    Callbacks:ServerCallback('Commands:ValidateAdmin', nil, function(isAdmin)
        if isAdmin then
			ApplyDamageToPed(PlayerPedId(), 300, false)
		end
	end)
end)

RegisterNetEvent('Damage:Client:Debug', function(model)
    Callbacks:ServerCallback('Commands:ValidateAdmin', nil, function(isAdmin)
        if isAdmin then
            Config.Debug = not Config.Debug

            Citizen.CreateThread(function()
                if Config.Debug then
                    while Config.Debug and LocalPlayer.state.loggedIn do
                        if LocalDamage == nil then
                            DrawUIText(4, 0, 0.015, 0.72, 0.35, 255, 255, 255, 255, 'LOCAL DAMGE NIL')
                        else
                            local limbs = ''
                            for k, v in pairs(_damagedLimbs) do
                                if limbs ~= '' then
                                    limbs = limbs .. '~s~, ~r~' .. k .. '~s~[~r~' .. v.severity .. '~s~]'
                                else
                                    limbs = k .. '~s~[~r~' .. v.severity .. '~s~]'
                                end
                            end
                            
                            DrawUIText(4, 0, 0.015, 0.72, 0.35, 255, 255, 255, 255, 'Injured: ~r~' .. limbs)
                            DrawUIText(4, 0, 0.015, 0.7, 0.35, 255, 255, 255, 255, 'Next Damage: ~r~' .. tonumber(isBleeding) * Config.BleedTickDamage)
                            DrawUIText(4, 0, 0.015, 0.68, 0.35, 255, 255, 255, 255, 'Bleed: ~r~' .. bleedTickTimer .. '~s~ / ~r~' .. Config.BleedTickRate .. '~s~ | ~r~' .. LocalDamage.Bleed)
                            DrawUIText(4, 0, 0.015, 0.66, 0.35, 255, 255, 255, 255, 'Adv. Bleed: ~r~' .. advanceBleedTimer .. '~s~ / ~r~' .. Config.AdvanceBleedTimer)
                            DrawUIText(4, 0, 0.015, 0.64, 0.35, 255, 255, 255, 255, 'Adrenaline: ~r~' .. LocalPlayer.state.onDrugs .. ' ~s~| ~r~' .. tostring(LocalPlayer.state.wasOnDrugs))
                            DrawUIText(4, 0, 0.015, 0.62, 0.35, 255, 255, 255, 255, 'Painkiller: ~r~' .. LocalPlayer.state.onPainKillers .. ' ~s~| ~r~' .. tostring(LocalPlayer.state.wasOnPainKillers))
                            DrawUIText(4, 0, 0.015, 0.60, 0.35, 255, 255, 255, 255, 'Limping: ~r~' .. tostring(IsInjuryCausingLimp() and not (LocalPlayer.state.onPainKillers > 0)))
                            DrawUIText(4, 0, 0.015, 0.58, 0.35, 255, 255, 255, 255, 'HP: ~r~' .. GetEntityHealth(PlayerPedId()) .. '~s~ | Armor: ~r~' .. GetPedArmour(PlayerPedId()))
                            DrawUIText(4, 0, 0.015, 0.56, 0.35, 255, 255, 255, 255, 'IsDead: ~r~' .. tostring(LocalPlayer.state.isDead))
                        end
                        Citizen.Wait(1)
                    end
                    Config.Debug = false
                end
            end)
        end
    end)
end)