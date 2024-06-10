table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1656967342,
    Id = 'dgang',
    Hidden = true,
    Name = 'Lua Holdings LLC',
    Salary = 600,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'member',
            Name = 'Board Member',
            Level = 99,
            Permissions = {
                JOB_MANAGEMENT = true,
                JOB_MANAGE_EMPLOYEES = true,
                JOB_HIRE = true,
                JOB_FIRE = true,
                JOB_DOORS = true,
                JOB_STORAGE = true,
				JOB_CRAFTING = true,

                BANK_ACCOUNT_BILL = true,
                BANK_ACCOUNT_MANAGE = true,
                BANK_ACCOUNT_DEPOSIT = true,
                BANK_ACCOUNT_WITHDRAW = true,
                BANK_ACCOUNT_TRANSACTIONS = true,
                BANK_ACCOUNT_BALANCE = true,
            },
        },
        {
            Id = 'employee',
            Name = 'Employee',
            Level = 1,
            Permissions = {},
        },
    }
})

table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1652471991,
    Id = 'block',
    Hidden = true,
    Name = 'The Block Neighborhood Watch',
    Salary = 100,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'member',
            Name = 'Member',
            Level = 1,
            Permissions = {

            },
        },
    }
})

