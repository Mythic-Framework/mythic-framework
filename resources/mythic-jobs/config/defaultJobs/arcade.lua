

table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1641230343,
    Id = 'avast_arcade',
    Name = 'Avast Arcade',
    Salary = 200,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'bartender',
            Name = 'Bar Tender',
            Level = 1,
            Permissions = {
                JOB_STORAGE = true,
                JOB_CRAFTING = true,
            },
        },
        {
            Id = 'manager',
            Name = 'Manager',
            Level = 4,
            Permissions = {
				JOB_STORAGE = true,
				JOB_CRAFTING = true,
				JOB_HIRE = true,
            },
        },
        {
            Id = 'owner',
            Name = 'Owner',
            Level = 99,
            Permissions = {
                JOB_MANAGEMENT = true,
                JOB_MANAGE_EMPLOYEES = true,
                JOB_HIRE = true,
                JOB_FIRE = true,
                JOB_STORAGE = true,
				JOB_CRAFTING = true,
            },
        },
    }
})