table.insert(_defaultJobData, {
    Type = 'Government',
    LastUpdated = 1649778246,
    Id = 'ems',
    Name = 'Medical',
    Salary = 1000,
    SalaryTier = 1,
    Workplaces = {
        {
            Id = 'safd',
            Name = 'Fire & Medical Services',
            Grades = {
                {
                    Id = 'trainee',
                    Name = 'Trainee',
                    Level = 1,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'emt',
                    Name = 'Emergency Medical Technician',
                    Level = 5,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'semt',
                    Name = 'Senior Emergency Medical Technician',
                    Level = 6,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'paramedic',
                    Name = 'Paramedic',
                    Level = 10,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'sparamedic',
                    Name = 'Senior Paramedic',
                    Level = 20,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'nurse',
                    Name = 'Nurse',
                    Level = 20,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'doctor',
                    Name = 'Doctor',
                    Level = 20,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'hparamedic',
                    Name = 'Head Paramedic',
                    Level = 50,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'hdoctor',
                    Name = 'Head Doctor',
                    Level = 50,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'hnurse',
                    Name = 'Head Nurse',
                    Level = 50,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        JOB_STORAGE = true,
                        MDT_MEDICAL_REPORTS = true,
                    }
                },
                {
                    Id = 'achief',
                    Name = 'Assistant Chief',
                    Level = 98,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_VEHICLES_3 = true,
                        FLEET_VEHICLES_4 = true,
                        FLEET_MANAGEMENT = true,
                        SAFD_HIGH_COMMAND = true,
                        JOB_STORAGE = true,

                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,

                        MDT_MEDICAL_REPORTS = true,

                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,
                    }
                },
                {
                    Id = 'chief',
                    Name = 'Chief',
                    Level = 99,
                    Permissions = {
                        ems_alerts = true,
                        FLEET_VEHICLES_0 = true,
                        FLEET_VEHICLES_1 = true,
                        FLEET_VEHICLES_2 = true,
                        FLEET_VEHICLES_3 = true,
                        FLEET_VEHICLES_4 = true,
                        FLEET_MANAGEMENT = true,
                        SAFD_HIGH_COMMAND = true,
                        JOB_STORAGE = true,

                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,

                        MDT_MEDICAL_REPORTS = true,

                        BANK_ACCOUNT_MANAGE = true,
                        BANK_ACCOUNT_DEPOSIT = true,
                        BANK_ACCOUNT_WITHDRAW = true,
                        BANK_ACCOUNT_TRANSACTIONS = true,
                        BANK_ACCOUNT_BALANCE = true,
                    }
                },
            }
        },
        {
            Id = 'prison',
            Name = 'Bolingbroke Infirmary',
            Grades = {
                {
                    Id = 'headdoctor',
                    Name = 'Head Doctor',
                    Level = 10,
                    Permissions = {
                        MDT_HIRE = true,
                        MDT_FIRE = true,
                        MDT_PROMOTE = true,
                        MDT_EDIT_EMPLOYEE = true,
                        JOB_STORAGE = true,
                    },
                },
                {
                    Id = 'doctor',
                    Name = 'Doctor',
                    Level = 5,
                    Permissions = {
                        JOB_STORAGE = true,
                    },
                },
                {
                    Id = 'nurse',
                    Name = 'Nurse',
                    Level = 1,
                    Permissions = {
                        JOB_STORAGE = true,
                    },
                },
            }
        },
    }
})