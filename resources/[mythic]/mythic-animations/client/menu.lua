local inEmoteMenu, inEmoteSubMenu, inFeaturesMenu = false, false, false

local cachedEmoteMenu


ANIMATIONS = {
    OpenMainEmoteMenu = function(self)
        if not cachedEmoteMenu then
            local emoteMenu = {
                main = {
                    label = 'Emotes',
                    items = {
                        {
                            label = 'Emote Binds',
                            description = 'Edit Your Emote Binds',
                            event = 'Animations:Client:OpenEmoteBinds',
                        },
                        {
                            label = 'Prop Emotes',
                            description = 'Emotes',
                            submenu = 'emotes-prop',
                        },
                        {
                            label = 'Dance Emotes',
                            description = 'Emotes',
                            submenu = 'emotes-dance',
                        },
                    },
                },
                ['emotes-prop'] = {
                    label = 'Prop Emotes',
                    items = {},
                },
                ['emotes-dance'] = {
                    label = 'Dance Emotes',
                    items = {},
                }
            }
    
            for k,v in pairs(Config.EmoteNaming.regular) do
                local emoteSub = 'emotes-' .. k
    
                table.insert(emoteMenu.main.items, {
                    label = v.name,
                    description = 'Emotes',
                    submenu = emoteSub,
                })
    
                local subItems = {}
    
                for _, emote in ipairs(v.emotes) do
                    table.insert(subItems, {
                        label = emote[2],
                        description = '/e ' .. emote[1],
                        event = 'Animations:Client:EmoteMenuEmote',
                        data = emote[1]
                    })
                end
    
                emoteMenu[emoteSub] = {
                    label = v.name,
                    items = subItems,
                }
            end
    
            for _, emote in ipairs(Config.EmoteNaming.prop) do
                table.insert(emoteMenu['emotes-prop'].items, {
                    label = emote[2],
                    description = '/e ' .. emote[1],
                    event = 'Animations:Client:EmoteMenuEmote',
                    data = emote[1]
                })
            end
    
            for _, emote in ipairs(Config.EmoteNaming.dance) do
                table.insert(emoteMenu['emotes-dance'].items, {
                    label = emote[2],
                    description = '/e ' .. emote[1],
                    event = 'Animations:Client:EmoteMenuEmote',
                    data = emote[1]
                })
            end

            cachedEmoteMenu = emoteMenu
        end

        ListMenu:Show(cachedEmoteMenu)
    end,
    OpenWalksMenu = function(self, fromMainMenu)
        local emoteMenu = {
            main = {
                label = 'Walk Styles',
                items = {
                    {
                        label = 'Reset',
                        description = 'Reset Walk Style to Default',
                        event = 'Animations:Client:EmoteMenuWalkStyle',
                        data = {
                            walk = 'reset',
                            label = false,
                        }
                    }
                },
            },
        }
        
        for k,v in spairs(Config.Walks) do
            table.insert(emoteMenu.main.items, {
                label = k,
                event = 'Animations:Client:EmoteMenuWalkStyle',
                data = {
                    walk = v,
                    label = k,
                }
            })
        end

        ListMenu:Show(emoteMenu)
    end,
    OpenExpressionsMenu = function(self)
        local emoteMenu = {
            main = {
                label = 'Facial Expressions',
                items = {
                    {
                        label = 'Reset',
                        description = 'Reset Expressions to Default',
                        event = 'Animations:Client:EmoteMenuExpressions',
                        data = {
                            exp = 'reset',
                            label = false,
                        }
                    }
                },
            },
        }

        for k,v in spairs(Config.Expressions) do
            table.insert(emoteMenu.main.items, {
                label = k,
                event = 'Animations:Client:EmoteMenuExpressions',
                data = {
                    exp = v,
                    label = k,
                }
            })
        end

        ListMenu:Show(emoteMenu)
    end,
}

AddEventHandler('Animations:Client:EmoteMenuEmote', function(data)
    Animations.Emotes:Play(data, true)
    Wait(250)
    Animations:OpenMainEmoteMenu()
end)

AddEventHandler('Animations:Client:EmoteMenuWalkStyle', function(data)
    Animations.PedFeatures:SetWalk(data.walk, data.label)
end)

AddEventHandler('Animations:Client:EmoteMenuExpressions', function(data)
    Animations.PedFeatures:SetExpression(data.exp, data.label)
end)