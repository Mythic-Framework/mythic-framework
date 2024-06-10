table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1653583984,
    Id = 'securoserv',
    Name = 'SecuroServ',
    Salary = 400,
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
            Id = 'director',
            Name = 'Director',
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