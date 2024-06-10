table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1651815333,
    Id = 'tow',
    Name = 'Towing',
    Salary = 300,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'employee',
            Name = 'Employee',
            Level = 1,
            Permissions = {
                tow_alerts = true,
                impound = true,
            },
        },
    }
})