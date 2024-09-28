_businessNotices = {}

_bizWizTypes = {
	default = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},

		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "Create/Receipt",
			hidden = true,
		},
		{
			id = "Search/Receipt",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts",
		},
		{
			id = "Search/ReceiptCount",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts Count",
			permission = "LAPTOP_MANAGE_RECEIPT",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
	mechanic = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},

		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "Create/Receipt",
			hidden = true,
		},
		{
			id = "Search/Receipt",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts",
		},
		{
			id = "Search/ReceiptCount",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts Count",
			permission = "LAPTOP_MANAGE_RECEIPT",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
	dealerships = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},
		{
			id = "Create/Receipt",
			hidden = true,
		},
		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "PDM/Sales",
			icon = { "fas", "car-on" },
			label = "Vehicle Stock",
			permission = "dealership_sell",
		},
		{
			id = "PDM/Credit",
			icon = { "fas", "magnifying-glass-dollar" },
			label = "Run Credit Check",
			permission = "dealership_sell",
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
			id = "PDM/Manage",
			icon = { "fas", "list-check" },
			label = "Manage Dealership",
			permission = "JOB_MANAGEMENT",
		},
		{
			id = "PDM/SalesHistory",
			icon = { "fas", "clock-rotate-left" },
			label = "Sales History",
			permission = "dealership_manage",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
	dealership_mechanic = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},

		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "Search/Receipt",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts",
		},
		{
			id = "Search/ReceiptCount",
			icon = { "fas", "money-check-dollar" },
			label = "Receipts Count",
			permission = "LAPTOP_MANAGE_RECEIPT",
		},
		{
			id = "PDM/Sales",
			icon = { "fas", "car-on" },
			label = "Vehicle Stock",
			permission = "dealership_sell",
		},
		{
			id = "PDM/Credit",
			icon = { "fas", "magnifying-glass-dollar" },
			label = "Run Credit Check",
			permission = "dealership_sell",
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
			id = "PDM/Manage",
			icon = { "fas", "list-check" },
			label = "Manage Dealership",
			permission = "dealership_manage",
		},
		{
			id = "PDM/SalesHistory",
			icon = { "fas", "clock-rotate-left" },
			label = "Sales History",
			permission = "dealership_manage",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
	realestate = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},
		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "Dynasty/Credit",
			icon = { "fas", "magnifying-glass-dollar" },
			label = "Run Credit Check",
			permission = "JOB_SELL",
		},
		{
			id = "Dynasty/Properties",
			icon = { "fas", "house" },
			label = "Properties",
			permission = "JOB_SELL",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
	casino = {
		{
			id = "Dashboard",
			icon = { "fas", "house" },
			label = "Dashboard",
		},
		{
			id = "Search/Document",
			icon = { "fas", "file-lines" },
			label = "Documents",
			permission = "LAPTOP_VIEW_DOCUMENT",
		},
		{
			id = "View/Document",
			hidden = true,
		},
		{
			id = "View/Receipt",
			hidden = true,
		},

		{
			id = "Create/Document",
			hidden = true,
		},
		{
			id = "Create/Notice",
			hidden = true,
		},
		{
			id = "Create/Receipt",
			hidden = true,
		},
		{
			id = "Casino/BigWins",
			icon = { "fas", "credit-card" },
			label = "Big Wins",
			permission = "JOB_MANAGEMENT",
		},
		--[[{
			id = "Tweet",
			icon = { "fas", "face-smile-beam" },
			label = "Business Twitter",
			permission = "LAPTOP_TWEET",
		},
		{
			id = "TweetSettings",
			icon = { "fas", "user" },
			label = "Twitter Profile",
			permission = "JOB_MANAGEMENT",
		},]]
		{
			id = "FleetManagement",
			icon = { "fas", "car-on" },
			label = "Fleet Management",
			permission = "FLEET_MANAGEMENT",
		},
	},
}

_bizWizConfig = {
	pdm = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/pdm.png',
		type = "dealerships",
	},
	tuna = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/tuna.png',
		type = "dealership_mechanic",
	},
	hayes = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/hayes.png',
		type = "mechanic",
	},
	realestate = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/realestate.png',
		type = "realestate",
	},
	autoexotics = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/autoexotics.png',
		type = "mechanic",
	},
	ottos = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/ottos.png',
		type = "mechanic",
	},
	redline = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/redline.png',
		type = "mechanic",
	},
	casino = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/casino.png',
		type = "casino",
	},
	burgershot = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/burgershot.png',
		type = "default",
	},
	beanmachine = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/beanmachine.png',
		type = "default",
	},
	uwu = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/uwu.png',
		type = "default",
	},
	demonetti_storage = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/demonetti_storage.png',
		type = "default",
	},
	sagma = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/sagma.png',
		type = "default",
	},
	tequila = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/tequila.png',
		type = "default",
	},
	woods_saloon = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/woods_saloon.png',
		type = "default",
	},
	prego = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/prego.png',
		type = "default",
	},
	pizza_this = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/pizza_this.png',
		type = "default",
	},
	bakery = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/bakery.png',
		type = "default",
	},
	noodle = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/noodle.png',
		type = "default",
	},
	lasttrain = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/lasttrain.png',
		type = "default",
	},
	securoserv = {
		logo = "https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/securoserv.png",
		type = "default",
	},
	unicorn = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/unicorn.png',
		type = "default",
	},
	dreamworks = {
		logo = 'https://raw.githubusercontent.com/Mythic-Framework/mythic-images/main/dreamworks.png',
		type = "mechanic",
	},
}
