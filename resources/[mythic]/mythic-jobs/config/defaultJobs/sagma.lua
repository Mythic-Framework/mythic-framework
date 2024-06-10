table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1655231376,
    Id = 'sagma',
    Name = 'Gallery of Modern Art',
    Salary = 650,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'employee',
            Name = 'Employee',
            Level = 2,
            Permissions = {
                JOB_STORAGE = true,
                JOB_CRAFTING = true,
            },
        },
        {
            Id = 'manager',
            Name = 'Manager',
            Level = 90,
            Permissions = {
				JOB_STORAGE = true,
				JOB_CRAFTING = true,
				JOB_HIRE = true,
                JOB_FIRE = true,
            },
        },
        {
            Id = 'coo',
            Name = 'COO',
            Level = 98,
            Permissions = {
                JOB_MANAGEMENT = true,
                JOB_MANAGE_EMPLOYEES = true,
                JOB_HIRE = true,
                JOB_FIRE = true,
                JOB_STORAGE = true,
				JOB_CRAFTING = true,
            },
        },
        {
            Id = 'ceo',
            Name = 'CEO',
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