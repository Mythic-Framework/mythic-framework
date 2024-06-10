local manageMenu
local manageMenuSub

local updatingData = {}

AddEventHandler('Dealerships:Client:StartManagement', function(hit, data)
    if data and data.dealerId then
        OpenDealerManagementMenu(data.dealerId)
    end
end)

function OpenDealerManagementMenu(dealer)
    Callbacks:ServerCallback('Dealerships:GetDealershipData', { dealerId = dealer }, function(data)
        local dealerData = _dealerships[dealer]
        if not data or not dealerData then
            return
        end

        manageMenuSub = {}
        updatingData = {}

        manageMenu = Menu:Create('dmanageMenu', string.format('Manage %s', dealerData.abbreviation), function()

        end, function()
            manageMenu = nil
            manageMenuSub = nil
            collectgarbage()
        end)

        manageMenu.Add:Slider('Dealership Profit %', {
            current = data.profitPercentage,
            min = _profitPercentages.min,
            max = _profitPercentages.max,
            step = 1,
        }, function(data)
            updatingData.profitPercentage = data.data.value
        end)

        manageMenu.Add:Slider('Employee Earned Commission %', {
            current = data.commission,
            min = 5,
            max = 75,
            step = 5,
        }, function(data)
            updatingData.commission = data.data.value
        end)

        manageMenu.Add:Button('Save Changes', { success = true }, function()
            manageMenu:Close()

            Callbacks:ServerCallback('Dealerships:UpdateDealershipData', {
                dealerId = dealer,
                updating = updatingData,
            }, function(success)
                if success then
                    Notification:Success('Changes Saved Successfully', 2500, 'car-building')
                else
                    Notification:Error('Failed Saving Changes', 2500, 'car-building')
                end
            end)
        end)

        manageMenu:Show()
    end)
end