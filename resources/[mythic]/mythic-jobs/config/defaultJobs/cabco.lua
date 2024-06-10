table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1644072778,
    Id = 'taxicab',
    Name = 'Downtown Cab Co.',
    Salary = 250,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'driver',
            Name = 'Driver',
            Level = 2,
            Permissions = {
                JOB_STORAGE = true,
                JOB_CRAFTING = true,
            },
        },
        {
            Id = 'manager',
            Name = 'Manager',
            Level = 5,
            Permissions = {
				JOB_STORAGE = true,
				JOB_CRAFTING = true,
				JOB_HIRE = true,
                JOB_FIRE = true,
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