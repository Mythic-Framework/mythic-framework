_payPeriod = 20

CreateThread(function()
    while not _loaded do
        Wait(100)
    end

    Logger:Info("Jobs", "Salary Thread Starting")

    while true do
        Wait(1000 * 60 * _payPeriod)

        for k, v in pairs(Fetch:All()) do
            local char = v:GetData("Character")
            if char ~= nil then
                local dutyData = _characterDuty[char:GetData('SID')]
                if dutyData and not Player(v:GetData("Source")).state.gettingPaycheck then
                    local existing = char:GetData("Salary") or {}
                    local workedMinutes = math.floor((os.time() - dutyData.Time) / 60)
                    local j = Jobs:Get(dutyData.Id)
                    local salary = math.ceil((j.Salary * j.SalaryTier) * (workedMinutes / _payPeriod))

                    Logger:Info("Jobs", string.format("Adding Salary Data For ^3%s^7 (^2%s Minutes^7 - ^3$%s^7)", char:GetData("SID"), workedMinutes, salary))

                    if existing[dutyData.Id] then
                        existing[dutyData.Id] = {
                            date = os.time(),
                            job = dutyData.Id,
                            minutes = (existing[dutyData.Id]?.minutes or 0) + workedMinutes,
                            total = (existing[dutyData.Id]?.total or 0) + salary,
                        }
                    else
                        existing[dutyData.Id] = {
                            date = os.time(),
                            job = dutyData.Id,
                            minutes = workedMinutes,
                            total = salary,
                        }
                    end

                    _characterDuty[char:GetData('SID')].Time = os.time()
                    char:SetData("Salary", existing)
                end
            end
        end
    end
end)