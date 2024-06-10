table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1649188117,
    Id = 'realestate',
    Name = 'Dynasty 8',
    Salary = 300,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'agent',
            Name = 'Real Estate Agent',
            Level = 1,
            Permissions = {
                SELL_PROPERTY = true,
                ACCESS_LISTED_PROPERTIES = true,
                JOB_DOORS = true,
                JOB_SELL = true,
            },
        },
        {
            Id = 'manager',
            Name = 'Real Estate Manager',
            Level = 50,
            Permissions = {
                SELL_PROPERTY = true,
                ACCESS_LISTED_PROPERTIES = true,
                JOB_DOORS = true,
                JOB_SELL = true,
            },
        },
        {
            Id = 'ceo',
            Name = 'CEO',
            Level = 99,
            Permissions = {
                SELL_PROPERTY = true,
                ACCESS_LISTED_PROPERTIES = true,
                JOB_MANAGEMENT = true,
                JOB_MANAGE_EMPLOYEES = true,
                JOB_HIRE = true,
                JOB_FIRE = true,
                JOB_DOORS = true,
                JOB_SELL = true,
            },
        },
    }
})