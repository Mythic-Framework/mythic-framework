local _openCd = false
function OpenHotBar()
    if not _openCd then
        _openCd = true
        Callbacks:ServerCallback('Inventory:GetHotbar', {}, function(inventory)
            Inventory.Set.Secondary:Refresh()
            Inventory.Set.Player:Inventory(inventory)
            Citizen.Wait(100)
            SendNUIMessage({
                type = 'HOTBAR_SHOW'
            })
            Citizen.CreateThread(function()
                Citizen.Wait(5000)
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