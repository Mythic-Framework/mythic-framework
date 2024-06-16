function CreateMechanicDutyPoints()
    for k, v in ipairs(_mechanicShops) do
        if v.dutyPoint then
            local menu = {
                {
                    icon = 'clipboard-check',
                    text = 'Go On Duty',
                    event = 'Mechanic:Client:OnDuty',
                    data = v.job,
                    jobPerms = {
                        {
                            job = v.job,
                            reqOffDuty = true,
                        }
                    },
                },
                {
                    icon = 'clipboard',
                    text = 'Go Off Duty',
                    event = 'Mechanic:Client:OffDuty',
                    data = v.job,
                    jobPerms = {
                        {
                            job = v.job,
                            reqDuty = true,
                        }
                    },
                },
            }

            Targeting.Zones:AddBox('mechanic_duty_' .. k, 'clock', v.dutyPoint.center, v.dutyPoint.length, v.dutyPoint.width, v.dutyPoint.options, menu, 3.0, true)
        end
    end
end

AddEventHandler('Mechanic:Client:OnDuty', function(_, job)
    if not _mechanicJobs[job] then 
        return;
    end

    Jobs.Duty:On(job)
end)

AddEventHandler('Mechanic:Client:OffDuty', function(_, job)
    if not _mechanicJobs[job] then 
        return; 
    end

    Jobs.Duty:Off(job)
end)