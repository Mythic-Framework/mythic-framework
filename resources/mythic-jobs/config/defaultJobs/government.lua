table.insert(_defaultJobData, {
    Type = 'Government',
    LastUpdated = 1653140963,
    Id = 'government',
    Name = 'Government',
    Salary = 1300,
    SalaryTier = 1,
    Workplaces = {
        {
            Id = 'doj',
            Name = 'San Andreas Department of Justice',
            Grades = {
                {
                    Id = 'countyclerk',
                    Name = 'County Clerk',
                    Level = 0,
                    Permissions = {
                        BANK_ACCOUNT_BILL = true,
                    },
                },
                {
                    Id = 'judge',
                    Name = 'Judge',
                    Level = 90,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_VEHICLES_3 = true,
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_EDIT_EMPLOYEE = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        MDT_INVESTIGATIVE_REPORT_VIEW = true,
                        MDT_CIVILIAN_REPORT_VIEW = true,
                        MDT_JUDGE_REPORTS = true,

                        JOB_STORAGE = true,

                        BANK_ACCOUNT_BILL = true,
                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,

                        STATE_ACCOUNT_DEPOSIT = true,
                        STATE_ACCOUNT_BALANCE = true,
                    },
                },
                {
                    Id = 'sjudge',
                    Name = 'Superior Court Judge',
                    Level = 99,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_VEHICLES_3 = true,
                        FLEET_VEHICLES_4 = true,
                        FLEET_MANAGEMENT = true,
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        MDT_CIVILIAN_REPORT_VIEW = true,
                        MDT_INVESTIGATIVE_REPORT_VIEW = true,
                        MDT_POLICE_DISCIPLINARY_REPORTS = true,
                        MDT_POLICE_FTO_REPORTS = true,
                        MDT_DA_REPORTS = true,
                        MDT_JUDGE_REPORTS = true,

                        JOB_STORAGE = true,

                        BANK_ACCOUNT_BILL = true,
                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,

                        STATE_ACCOUNT_MANAGE = true,
                        STATE_ACCOUNT_DEPOSIT = true,
                        STATE_ACCOUNT_WITHDRAW = true,
                        STATE_ACCOUNT_TRANSACTIONS = true,
                        STATE_ACCOUNT_BALANCE = true,
                    },
                },
            }
        },
        {
            Id = 'dattorney',
            Name = 'District Attorney\'s Office',
            Grades = {
                {
                    Id = 'prosecutor',
                    Name = 'Prosecutor',
                    Level = 10,
                    Permissions = {
                        MDT_DA_REPORTS = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                    },
                },
                {
                    Id = 'ada',
                    Name = 'Asst. District Attorney',
                    Level = 75,
                    Permissions = {
                        MDT_DA_REPORTS = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        MDT_CIVILIAN_REPORT_VIEW = true,

                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,
                    },
                },
                {
                    Id = 'da',
                    Name = 'District Attorney',
                    Level = 85,
                    Permissions = {
                        MDT_DA_REPORTS = true,
                        MDT_INCIDENT_REPORT_VIEW = true,
                        MDT_CIVILIAN_REPORT_VIEW = true,

                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,
                    },
                },
            }
        },
        {
            Id = 'publicdefenders',
            Name = 'Public Defenders Office',
            Grades = {
                {
                    Id = 'publicdefender',
                    Name = 'Public Defender',
                    Level = 10,
                    Permissions = {
                        
                    },
                },
                {
                    Id = 'cpublicdefender',
                    Name = 'Chief Public Defender',
                    Level = 75,
                    Permissions = {
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,
                    },
                },
            }
        },
        {
            Id = 'mayoroffice',
            Name = 'Mayor\'s Office',
            Grades = {
                {
                    Id = 'mayor_assistant',
                    Name = 'Mayor\'s Assistant',
                    Level = 1,
                    Permissions = {

                    },
                },
                {
                    Id = 'dmayor',
                    Name = 'Deputy Mayor',
                    Level = 75,
                    Permissions = {

                    },
                },
                {
                    Id = 'mayor',
                    Name = 'Mayor',
                    Level = 95,
                    Permissions = {
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_VEHICLES_3 = true,
                        FLEET_VEHICLES_4 = true,
                        FLEET_MANAGEMENT = true,
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,

                        JOB_STORAGE = true,

                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,

                        STATE_ACCOUNT_MANAGE = true,
                        STATE_ACCOUNT_DEPOSIT = true,
                        STATE_ACCOUNT_WITHDRAW = true,
                        STATE_ACCOUNT_TRANSACTIONS = true,
                        STATE_ACCOUNT_BALANCE = true,
                    },
                },
            }
        },
    }
})