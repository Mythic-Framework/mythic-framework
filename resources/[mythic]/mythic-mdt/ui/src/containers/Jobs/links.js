export default (job, workplace) => {
	switch (job) {
		case 'police':
			return police;
		case 'government':
			switch(workplace) {
				case 'doj':
					return doj;
				case 'dattorney':
					return districtattorney;
				case 'mayoroffice':
				default:
					return base;
			};
		case 'ems':
			return medical;
		case 'attorney':
			return attorney;
		default:
			return base;
	}
};

const base = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Home',
		path: '/',
		exact: true,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-shield'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
];

const attorney = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Home',
		path: '/',
		exact: true,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-shield'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'search',
		icon: ['fas', 'magnifying-glass'],
		label: 'Search',
		path: '/search',
		submenu: true,
		exact: false,
		items: [
			{
				icon: ['fas', 'file-lines'],
				label: 'Reports',
				path: '/search/reports',
				exact: false,
			},
		],
	},
];

const systemAdmin = [
	{
		name: 'system-admin',
		icon: ['fas', 'terminal'],
		label: 'System Admin',
		path: '/system',
		exact: false,
		restrict: {
			permission: true,
		},
		items: [
			{
				icon: ['fas', 'chart-pie'],
				label: 'Metrics',
				path: '/system',
				exact: true,
			},
			{
				icon: ['fas', 'users-line'],
				label: 'Full Roster',
				path: '/system/gov-roster',
				exact: true,
			},
			{
				icon: ['fas', 'pen-to-square'],
				label: 'Permissions',
				path: '/system/gov-permissions',
				exact: true,
			},
			{
				icon: ['fas', 'gavel'],
				label: 'Charges',
				path: '/system/charges',
				exact: true,
			},
			{
				icon: ['fas', 'tag'],
				label: 'Tags',
				path: '/system/tags',
				exact: true,
			},
		],
	}
]

const police = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'report',
		icon: ['fas', 'file-contract'],
		label: 'Create Report',
		path: '/create/report',
		submenu: false,
		exact: true,
	},
	{
		name: 'search',
		icon: ['fas', 'magnifying-glass'],
		label: 'Search',
		path: '/search',
		submenu: true,
		exact: false,
		items: [
			{
				icon: ['fas', 'person'],
				label: 'People',
				path: '/search/people',
				exact: false,
			},
			{
				icon: ['fas', 'car'],
				label: 'Vehicles',
				path: '/search/vehicles',
				exact: false,
			},
			{
				icon: ['fas', 'house-chimney'],
				label: 'Properties',
				path: '/search/properties',
				exact: false,
			},
			{
				icon: ['fas', 'gun'],
				label: 'Firearms',
				path: '/search/firearms',
				exact: false,
			},
			{
				icon: ['fas', 'file-lines'],
				label: 'Reports',
				path: '/search/reports',
				exact: false,
			},
			{
				icon: ['fas', 'dna'],
				label: 'Evidence',
				path: '/search/evidence',
				exact: false,
			},
		],
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-shield'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'roster',
		icon: ['fas', 'users-line'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	{
		name: 'sops',
		icon: ['fas', 'swatchbook'],
		label: 'SOP\'s',
		path: '/sops',
		exact: true,
	},
	{
		name: 'comms',
		icon: ['fas', 'book'],
		label: 'Communication Guide',
		path: '/comms',
		exact: true,
	},
	{
		name: 'admin',
		icon: ['fas', 'building-shield'],
		label: 'High Command',
		path: '/admin',
		exact: false,
		restrict: {
			permission: 'PD_HIGH_COMMAND',
		},
		items: [
			{
				icon: ['fas', 'chart-pie'],
				label: 'Metrics',
				path: '/admin',
				exact: true,
			},
			{
				icon: ['fas', 'pen-to-square'],
				label: 'Permissions',
				path: '/admin/permissions',
				exact: true,
			},
		],
	},
	...systemAdmin,
];

const doj = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'search',
		icon: ['fas', 'magnifying-glass'],
		label: 'Search',
		path: '/search',
		submenu: true,
		exact: false,
		items: [
			{
				icon: ['fas', 'person'],
				label: 'People',
				path: '/search/people',
				exact: false,
			},
			{
				icon: ['fas', 'car'],
				label: 'Vehicles',
				path: '/search/vehicles',
				exact: false,
			},
			{
				icon: ['fas', 'house-chimney'],
				label: 'Properties',
				path: '/search/properties',
				exact: false,
			},
			{
				icon: ['fas', 'gun'],
				label: 'Firearms',
				path: '/search/firearms',
				exact: false,
			},
			{
				icon: ['fas', 'file-lines'],
				label: 'Reports',
				path: '/search/reports',
				exact: false,
			},
			{
				icon: ['fas', 'dna'],
				label: 'Evidence',
				path: '/search/evidence',
				exact: false,
			},
		],
	},
	{
		name: 'report',
		icon: ['fas', 'file-contract'],
		label: 'Create Report',
		path: '/create/report',
		submenu: false,
		exact: true,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-shield'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	...systemAdmin,
];

const districtattorney = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'search',
		icon: ['fas', 'magnifying-glass'],
		label: 'Search',
		path: '/search',
		submenu: true,
		exact: false,
		items: [
			{
				icon: ['fas', 'person'],
				label: 'People',
				path: '/search/people',
				exact: false,
			},
			{
				icon: ['fas', 'car'],
				label: 'Vehicles',
				path: '/search/vehicles',
				exact: false,
			},
			{
				icon: ['fas', 'house-chimney'],
				label: 'Properties',
				path: '/search/properties',
				exact: false,
			},
			{
				icon: ['fas', 'gun'],
				label: 'Firearms',
				path: '/search/firearms',
				exact: false,
			},
			{
				icon: ['fas', 'file-lines'],
				label: 'Reports',
				path: '/search/reports',
				exact: false,
			},
			{
				icon: ['fas', 'dna'],
				label: 'Evidence',
				path: '/search/evidence',
				exact: false,
			},
		],
	},
	{
		name: 'report',
		icon: ['fas', 'file-contract'],
		label: 'Create Report',
		path: '/create/report',
		submenu: false,
		exact: true,
	},
	{
		name: 'warrants',
		icon: ['fas', 'file-shield'],
		label: 'Warrants',
		path: '/warrants',
		exact: false,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'penalcode',
		icon: ['fas', 'gavel'],
		label: 'Penal Code',
		path: '/penal-code',
		exact: true,
	},
	...systemAdmin,
];



const medical = [
	{
		name: 'home',
		icon: ['fas', 'house'],
		label: 'Dashboard',
		path: '/',
		exact: true,
	},
	{
		name: 'report',
		icon: ['fas', 'file-contract'],
		label: 'Create Report',
		path: '/create/report',
		submenu: false,
		exact: false,
	},
	{
		name: 'home',
		icon: ['fas', 'file-lines'],
		label: 'Reports',
		path: '/search/reports',
		exact: true,
	},
	{
		name: 'roster',
		icon: ['fas', 'user-tie'],
		label: 'Roster',
		path: '/roster',
		exact: false,
	},
	{
		name: 'comms',
		icon: ['fas', 'book'],
		label: 'Communication Guide',
		path: '/comms',
		exact: true,
	},
	// {
	// 	name: 'penalcode',
	// 	icon: ['fas', 'gavel'],
	// 	label: 'Penal Code',
	// 	path: '/penal-code',
	// 	exact: true,
	// },
	{
		name: 'admin',
		icon: ['fas', 'building-shield'],
		label: 'Management',
		path: '/admin',
		exact: false,
		restrict: {
			permission: 'SAFD_HIGH_COMMAND',
		},
		items: [
			// {
			// 	icon: ['fas', 'chart-pie'],
			// 	label: 'Metrics',
			// 	path: '/admin',
			// 	exact: true,
			// },
			{
				icon: ['fas', 'pen-to-square'],
				label: 'Permissions',
				path: '/admin/permissions',
				exact: true,
			},
		],
	},
	...systemAdmin,
];