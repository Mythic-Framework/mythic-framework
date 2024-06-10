function FetchCharacterJobsFromDB(stateId)
    local p = promise.new()

    Database.Game:findOne({
        collection = 'characters',
        query = {
            SID = stateId,
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results[1].Jobs or {})
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function RegisterJobChatCommands()

    Chat:RegisterAdminCommand('givejob', function(source, args, rawCommand)
        local target, jobId, gradeId, workplaceId = table.unpack(args)
        target = math.tointeger(target)
        if not workplaceId then workplaceId = false; end

        if target and jobId and gradeId then
            local jobExists = Jobs:DoesExist(jobId, workplaceId, gradeId)
            if jobExists then
                local success = Jobs:GiveJob(target, jobId, workplaceId, gradeId)
                if success then
                    if jobExists.Workplace then
                        Chat.Send.System:Single(source, string.format('Gave State ID: %s Job: %s - %s - %s', target, jobExists.Name, jobExists.Workplace.Name, jobExists.Grade.Name))
                    else
                        Chat.Send.System:Single(source, string.format('Gave State ID: %s Job: %s - %s', target, jobExists.Name, jobExists.Grade.Name))
                    end
                else
                    Chat.Send.System:Single(source, 'Error Giving Job - Maybe that State ID Doesn\'t Exist')
                end
            else
                Chat.Send.System:Single(source, 'Job Doesn\'t Exist Fuckface')
            end
            return
        else
            Chat.Send.System:Single(source, 'Invalid Arguments')
        end
    end, {
        help = 'Give Player a Job',
        params = {
            { name = 'State ID', help = 'Character State ID' },
            { name = 'Job ID', help = 'Job (e.g. police)' },
            { name = 'Grade ID', help = 'Grade (e.g. chief)' },
            { name = 'Workplace ID', help = 'Workplace (e.g lspd)' },
        }
    }, -1)

    Chat:RegisterAdminCommand('removejob', function(source, args, rawCommand)
        local target, jobId = math.tointeger(args[1]), args[2]
        local success = Jobs:RemoveJob(target, jobId)
        if success then
            Chat.Send.System:Single(source, 'Successfully Removed Job From State ID:'.. target)
        else
            Chat.Send.System:Single(source, 'Error Removing Job - State ID Doesn\'t Exist or Maybe They Don\'t that Job')
        end
    end, {
        help = 'Remove A Job From a Character',
        params = {
            { name = 'State ID', help = 'Character State ID' },
            { name = 'Job ID', help = 'Job ID (e.g. Police)' },
        }
    }, 2)

    Chat:RegisterAdminCommand('setowner', function(source, args, rawCommand)
        local jobId, target = table.unpack(args)
        target = math.tointeger(target)

        if target and jobId then
            local jobExists = Jobs:Get(jobId)
            if jobExists and jobExists.Type == 'Company' then
                local success = Jobs.Management:Edit(jobId, {
                    Owner = target
                })
                if success then
                    Chat.Send.System:Single(source, string.format('Set Owner of %s (%s) to State ID %s', jobExists.Name, jobExists.Id, target))
                else
                    Chat.Send.System:Single(source, 'Error Setting Job Owner')
                end
            else
                Chat.Send.System:Single(source, 'Job Doesn\'t Exist or Isn\'t a Company You Fuck')
            end
        else
            Chat.Send.System:Single(source, 'Invalid Job or State ID')
        end
    end, {
        help = 'Sets the Owner of a Company',
        params = {
            { name = 'Job ID', help = 'Job (e.g. burgershot)' },
            { name = 'State ID', help = 'Owner\'s State ID' },
        }
    }, 2)

    Chat:RegisterAdminCommand('onduty', function(source, args, rawCommand)
        Jobs.Duty:On(source, args[1])
    end, {
        help = 'Go On Duty',
        params = {
            { name = 'Job ID', help = 'The Job You Want to Go On Duty As' },
        }
    }, 1)

    Chat:RegisterAdminCommand('offduty', function(source, args, rawCommand)
        Jobs.Duty:Off(source)
    end, {
        help = 'Go Off Duty'
    })

    Chat:RegisterAdminCommand('checkjobs', function(source, args, rawCommand)
        local target = math.tointeger(args[1])
        local player
        if not args[1] then 
            player = Fetch:Source(source)
        else
            player = Fetch:SID(target)
        end

        local charJobs = false

        if player then
            local char = player:GetData('Character')
            if char then
                stateId = char:GetData('SID')
                charJobs = char:GetData('Jobs') or {}
            end
        elseif target and target > 0 then
            stateId = target
            charJobs = FetchCharacterJobsFromDB(target)
        end

        if charJobs then
            if #charJobs > 0 then
                for k, v in ipairs(charJobs) do
                    if v.Workplace then
                        Chat.Send.System:Single(source, string.format('State ID: %s - Job #%s: %s - %s - %s', stateId, k, v.Name, v.Workplace.Name, v.Grade.Name))
                    else
                        Chat.Send.System:Single(source, string.format('State ID: %s - Job #%s: %s - %s', stateId, k, v.Name, v.Grade.Name))
                    end
                end
            else
                Chat.Send.System:Single(source, string.format('State ID: %s -  Has No Jobs', stateId))
            end
        else
            Chat.Send.System:Single(source, 'Invalid State ID')
        end
    end, {
        help = 'Shows the Jobs a Character Has',
        params = {
            { name = 'State ID', help = 'Optional - Character State ID' },
        }
    }, -1)

    Chat:RegisterAdminCommand('dutycount', function(source, args, rawCommand)
        local jobId = args[1]
        local jobExists = Jobs:Get(jobId)
        if jobExists then
            local dutyData = Jobs.Duty:GetDutyData(jobId)
            Chat.Send.System:Single(source, string.format('Job: %s -  %s On Duty', jobExists.Name, dutyData?.Count or 0))
        end
    end, {
        help = 'Go On Duty',
        params = {
            { name = 'Job ID', help = 'The Job' },
        }
    }, 1)

    Chat:RegisterAdminCommand('dutytest', function(source, args, rawCommand)
        local jobId = args[1]
        local jobExists = Jobs:Get(jobId)
        if jobExists then
            Chat.Send.System:Single(source, string.format('Before Job: %s -  %s On Duty', jobExists.Name, GlobalState[string.format('Duty:%s', jobId)]))
            Jobs.Duty:RefreshDutyData(jobId)
            Chat.Send.System:Single(source, string.format('After Job: %s -  %s On Duty', jobExists.Name, GlobalState[string.format('Duty:%s', jobId)]))
        end
    end, {
        help = 'Test',
        params = {
            { name = 'Job ID', help = 'The Job' },
        }
    }, 1)
end