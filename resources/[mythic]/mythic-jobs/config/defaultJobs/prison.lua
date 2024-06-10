table.insert(_defaultJobData, {
    Type = 'Government',
    LastUpdated = 1630428968,
    Id = 'prison',
    Name = 'Bolingbroke State Penitentiary',
    Salary = 400,
    SalaryTier = 1,
    Workplaces = {
        {
            Id = 'corrections',
            Name = 'San Andreas Department of Corrections',
            Grades = {
                {
                    Id = 'warden',
                    Name = 'Prison Warden',
                    Level = 10,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_MANAGEMENT = true,
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        JOB_STORAGE = true,

                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,
                    },
                },
                {
                    Id = 'captain',
                    Name = 'Captain',
                    Level = 5,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        PD_COMMAND = true,
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        JOB_STORAGE = true,
                    },
                },
                {
                    Id = 'sofficer',
                    Name = 'Senior Officer',
                    Level = 3,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        JOB_STORAGE = true,
                    },
                },
                {
                    Id = 'officer',
                    Name = 'Officer',
                    Level = 2,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        JOB_STORAGE = true,
                    },
                },
                {
                    Id = 'cadet',
                    Name = 'Cadet',
                    Level = 1,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                    },
                },
            }
        },
    }
})