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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/pdm.png',
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
				icon = {'fas', 'car'},
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/tuna.png',
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
				icon = {'fas', 'car'},
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/redline.png',
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/hayes.png',
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/realestate.png',
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/autoexotics.png',
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/ottos.png',
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/dreamworks.png',
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
		logo = "https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/securoserv.png",
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
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/casino.png',
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
				icon = {'fas', 'address-card'},
				label = 'Big Wins',
				path = '/business/casino-big-wins',
				exact = true,
				permission = 'JOB_MANAGEMENT',
			},
        }
    },
	burgershot = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/burgershot.png',
		links = restaurantTabletLinks
    },
	demonetti_storage = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/demonetti_storage.png',
		links = restaurantTabletLinks
    },
	sagma = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/sagma.png',
		links = restaurantTabletLinks
    },
	ferrari_pawn = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/ferrari_pawn.png',
		links = restaurantTabletLinks
    },
	cluckinbell = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/cluckinbell.png',
		links = restaurantTabletLinks
    },
	lasttrain = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/lasttrain.png',
		links = restaurantTabletLinks
    },
	uwu = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/uwu.png',
		links = restaurantTabletLinks
    },
	woods_saloon = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/woods_saloon.png',
		links = restaurantTabletLinks
    },
	pizza_this = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/pizza_this.png',
		links = restaurantTabletLinks
    },
	prego = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/prego.png',
		links = restaurantTabletLinks
    },
	unicorn = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/unicorn.png',
		links = restaurantTabletLinks
    },
	tequila = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/tequila.png',
		links = restaurantTabletLinks
    },
	noodle = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/noodle.png',
		links = restaurantTabletLinks
    },
	beanmachine = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/beanmachine.png',
		links = restaurantTabletLinks
    },
	bakery = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/bakery.png',
		links = restaurantTabletLinks
    },
	-- TODO : Add the rest of the restaurants !!
}

_businessesWithTablets = {}
for k, v in pairs(_businessTablets) do
	table.insert(_businessesWithTablets, {
		Id = k,
	})
end