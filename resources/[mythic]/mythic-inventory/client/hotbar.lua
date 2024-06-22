local _openCd = false
function OpenHotBar()
    if not _openCd then
        _openCd = true
        Callbacks:ServerCallback('Inventory:GetHotbar', {}, function(inventory)
            Inventory.Set.Secondary:Refresh()
            Inventory.Set.Player:Inventory(inventory)
            Wait(100)
            SendNUIMessage({
                type = 'HOTBAR_SHOW'
            })
            CreateThread(function()
                Wait(5000)
                _openCd = false
            end)
        end)
    end
end

function CloseHotBar()
    SendNUIMessage({
        type = 'HOTBAR_HIDE'
    })
end