_businessNotices = {}

local restaurantTabletLinks = {
	{
		name = 'home',
		icon = {'fas', 'house'},
		label = 'Home',
		path = '/',
		exact = true,
	},
	{
		name = 'documents',
		icon = {'fas', 'file-lines'},
		label = 'Documents',
		path = '/business/search/document',
		exact = true,
		permission = 'TABLET_VIEW_DOCUMENT',
	},
	{
		name = 'receipts',
		icon = {'fas', 'money-check-dollar'},
		label = 'Receipts',
		path = '/business/search/receipt',
		exact = true,
	},
	{
		name = 'receipts-count',
		icon = {'fas', 'money-check-dollar'},
		label = 'Receipts Count',
		path = '/business/search/receipt-count',
		exact = true,
		permission = 'JOB_MANAGE_EMPLOYEES',
	},
}

_businessTablets = {
    pdm = {
		logo = 'https://i.imgur.com/EU7HQji.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			-- {
			-- 	name = 'employees',
			-- 	icon = {'fas', 'person'},
			-- 	label = 'Employees',
			-- 	path = '/business/search/documents',
			-- 	exact = true,
			-- },
			{
				name = 'pdm-stocks',
				icon = {'fas', 'cars'},
				label = 'Vehicle Stock',
				path = '/business/pdm-sales',
				exact = true,
				permission = 'dealership_sell',
			},
			{
				name = 'pdm-credit-check',
				icon = {'fas', 'magnifying-glass-dollar'},
				label = 'Run Credit Check',
				path = '/business/pdm-credit',
				exact = true,
				permission = 'dealership_sell',
			},
			-- {
			-- 	name = 'pdm-licence-check',
			-- 	icon = {'fas', 'id-card'},
			-- 	label = 'Run License Check',
			-- 	path = '/business/search/documents',
			-- 	exact = true,
			-- 	permission = 'dealership_manage',
			-- },
			{
				name = 'pdm-manage',
				icon = {'fas', 'list-check'},
				label = 'Manage Dealership',
				path = '/business/pdm-manage',
				permission = 'dealership_manage',
			},
			{
				name = 'pdm-history',
				icon = {'fas', 'clock-rotate-left'},
				label = 'Sales History',
				path = '/business/pdm-saleshistory',
				exact = true,
				permission = 'dealership_manage',
			},
        }
    },
	tuna = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			-- {
			-- 	name = 'employees',
			-- 	icon = {'fas', 'person'},
			-- 	label = 'Employees',
			-- 	path = '/business/search/documents',
			-- 	exact = true,
			-- },
			{
				name = 'pdm-stocks',
				icon = {'fas', 'cars'},
				label = 'Vehicle Stock',
				path = '/business/pdm-sales',
				exact = true,
				permission = 'dealership_sell',
			},
			{
				name = 'pdm-credit-check',
				icon = {'fas', 'magnifying-glass-dollar'},
				label = 'Run Credit Check',
				path = '/business/pdm-credit',
				exact = true,
				permission = 'dealership_sell',
			},
			-- {
			-- 	name = 'pdm-licence-check',
			-- 	icon = {'fas', 'id-card'},
			-- 	label = 'Run License Check',
			-- 	path = '/business/search/documents',
			-- 	exact = true,
			-- 	permission = 'dealership_manage',
			-- },
			{
				name = 'pdm-manage',
				icon = {'fas', 'list-check'},
				label = 'Manage Dealership',
				path = '/business/pdm-manage',
				permission = 'dealership_manage',
			},
			{
				name = 'pdm-history',
				icon = {'fas', 'clock-rotate-left'},
				label = 'Sales History',
				path = '/business/pdm-saleshistory',
				exact = true,
				permission = 'dealership_manage',
			},
        }
    },
	redline = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	hayes = {
		logo = 'https://i.imgur.com/tgShkKW.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	realestate = {
		logo = 'https://i.imgur.com/XbKVB4k.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'dyn8-properties',
				icon = {'fas', 'house-building'},
				label = 'Properties',
				path = '/business/dyn8-properties',
				exact = true,
				permission = 'JOB_SELL',
			},
			{
				name = 'dyn8-credit',
				icon = {'fas', 'magnifying-glass-dollar'},
				label = 'Run Credit Check',
				path = '/business/dyn8-credit',
				exact = true,
				permission = 'JOB_SELL',
			},
        }
    },
	autoexotics = {
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	ottos = {
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	dreamworks = {
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	securoserv = {
		logo = "https://i.imgur.com/ACIpaH3.png",
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'receipts-count',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts Count',
				path = '/business/search/receipt-count',
				exact = true,
				permission = 'JOB_MANAGE_EMPLOYEES',
			},
        }
    },
	casino = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = {
			{
				name = 'home',
				icon = {'fas', 'house'},
				label = 'Home',
				path = '/',
				exact = true,
			},
			{
				name = 'documents',
				icon = {'fas', 'file-lines'},
				label = 'Documents',
				path = '/business/search/document',
				exact = true,
				permission = 'TABLET_VIEW_DOCUMENT',
			},
			{
				name = 'receipts',
				icon = {'fas', 'money-check-dollar'},
				label = 'Receipts',
				path = '/business/search/receipt',
				exact = true,
			},
			{
				name = 'casino-big-wins',
				icon = {'fas', 'cards'},
				label = 'Big Wins',
				path = '/business/casino-big-wins',
				exact = true,
				permission = 'JOB_MANAGEMENT',
			},
        }
    },
	burgershot = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = restaurantTabletLinks
    },
	demonetti_storage = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = restaurantTabletLinks
    },
	sagma = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = restaurantTabletLinks
    },
	ferrari_pawn = {
		logo = 'https://i.imgur.com/aSXFH3P.png',
		links = restaurantTabletLinks
    },
}

_businessesWithTablets = {}
for k, v in pairs(_businessTablets) do
	table.insert(_businessesWithTablets, {
		Id = k,
	})
end