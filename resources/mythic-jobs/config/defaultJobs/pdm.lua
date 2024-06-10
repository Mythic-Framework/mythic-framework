table.insert(_defaultJobData, {
    Type = 'Company',
    LastUpdated = 1629906634,
    Id = 'pdm',
    Name = 'Premium Deluxe Motorsport',
    Salary = 200,
    SalaryTier = 1,
    Grades = {
        {
            Id = 'owner',
            Name = 'Owner',
            Level = 100,
            Permissions = {
                JOB_MANAGEMENT = true,
                JOB_MANAGE_EMPLOYEES = true,
                JOB_HIRE = true,
                JOB_FIRE = true,
                dealership_stock = true,
                dealership_showroom = true,
                dealership_sell = true,
                dealership_testdrive = true,
                dealership_manage = true,
            }
        },
        {
            Id = 'manager',
            Name = 'Manager',
            Level = 10,
            Permissions = {
                dealership_stock = true,
                dealership_showroom = true,
                dealership_sell = true,
                dealership_testdrive = true,
            }
        },
        {
            Id = 'dealer',
            Name = 'Car Dealer',
            Level = 1,
            Permissions = {
                dealership_stock = true,
                dealership_showroom = true,
                dealership_sell = true,
                dealership_testdrive = true,
            }
        }
    }
})