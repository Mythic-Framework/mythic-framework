-- CreateThread(function()
--     local o = nil
--     local om = nil

--     while true do
--         local player = PlayerPedId()
--         if (IsPedSittingInAnyVehicle(player)) then
--             local c = GetVehiclePedIsUsing(player)
--             local cm = GetEntityModel(c)
--             if (c == o and cm ~= om and om ~= nil and om ~= 0) then
--                 Callbacks:ServerCallback('Pwnzor:Trigger', om .. '~=' .. cm, function(s)
--                     DeleteVehicle(c)
--                     return
--                 end)
--             end

--             o = c
--             om = cm
--         end

--         Wait(5000)
--     end
-- end)