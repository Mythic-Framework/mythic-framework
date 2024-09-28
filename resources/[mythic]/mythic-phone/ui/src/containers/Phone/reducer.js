import Nui from '../../util/Nui';

export const initialState = {
	visible: process.env.NODE_ENV != 'production',
	clear: false,
	expanded: true,
	limited: false,
	time: {
		hour: 4,
		minute: 20,
	},
	apps:
		process.env.NODE_ENV == 'production'
			? {}
			: {
					phone: {
						storeLabel: 'Phone',
						label: 'Phone',
						icon: 'phone',
						name: 'phone',
						color: '#21a500',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'call',
								params: ':number?',
							},
						],
					},
					messages: {
						storeLabel: 'Messages',
						label: 'Messages',
						icon: 'comment',
						name: 'messages',
						color: '#ff0000',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'new',
							},
							{
								app: 'convo',
								params: ':number?',
							},
						],
					},
					contacts: {
						storeLabel: 'Contacts',
						label: 'Contacts',
						icon: 'address-book',
						name: 'contacts',
						color: '#ff6a00',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'add',
								params: ':number?',
							},
							{
								app: 'edit',
								params: ':id?',
							},
						],
					},
					store: {
						storeLabel: 'Blue Sky App Store',
						label: 'App Store',
						icon: 'rocket',
						name: 'store',
						color: '#1a7cc1',
						canUninstall: false,
						unread: 0,
						params: '',
					},
					settings: {
						storeLabel: 'Settings',
						label: 'Settings',
						icon: 'gear',
						name: 'settings',
						color: '#18191e',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'software',
								params: '',
							},
							{
								app: 'profile',
								params: '',
							},
							{
								app: 'app_notifs',
								params: '',
							},
							{
								app: 'sounds',
								params: '',
							},
							{
								app: 'wallpaper',
								params: '',
							},
							{
								app: 'colors',
								params: '',
							},
						],
					},
					email: {
						storeLabel: 'Email',
						label: 'Email',
						icon: 'envelope',
						name: 'email',
						color: '#5600a5',
						canUninstall: false,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id',
							},
						],
					},
					bank: {
						storeLabel: 'Bank',
						label: 'Bank',
						icon: 'bank',
						name: 'bank',
						color: '#ff0000',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':account',
							},
						],
					},
					loans: {
						storeLabel: 'Loans',
						label: 'Loans',
						icon: 'hand-holding-dollar',
						name: 'loans',
						color: '#30518c',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':loan',
							},
						],
					},
					twitter: {
						storeLabel: 'Twitter',
						label: 'Twitter',
						icon: ['fab', 'twitter'],
						name: 'twitter',
						color: '#00aced',
						canUninstall: true,
						unread: 0,
						// restricted: {
						// 	state: 'PHONE_VPN',
						// },
						params: '',
					},
					irc: {
						storeLabel: 'IRC',
						label: 'IRC',
						icon: 'comment-slash',
						name: 'irc',
						color: '#1de9b6',
						canUninstall: true,
						unread: 0,
						params: '',
						// restricted: {
						// 	job: {
						// 		police: 1,
						// 	},
						// },
						internal: [
							{
								app: 'view',
								params: ':channel',
							},
							{
								app: 'join',
								params: ':channel',
							},
						],
					},
					adverts: {
						storeLabel: 'Yellow Pages',
						label: 'YP',
						icon: 'rectangle-ad',
						name: 'adverts',
						color: '#f9a825',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id',
							},
							{
								app: 'category-view',
								params: ':category',
							},
							{
								app: 'add',
								params: '',
							},
							{
								app: 'edit',
								params: '',
							},
						],
					},
					documents: {
						storeLabel: 'Documents',
						label: 'Documents',
						icon: 'file-lines',
						name: 'documents',
						color: '#18191e',
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':id/:mode',
							},
						],
					},
					// xor: {
					// 	storeLabel: 'xor',
					// 	label: 'Xor',
					// 	name: 'xor',
					// 	icon: 'flask-potion',
					// 	color: '#d97334',
					// 	hidden: true,
					// 	store: false,
					// 	canUninstall: true,
					// 	unread: 0,
					// 	params: '',
					// },
					redline: {
						storeLabel: 'Vroom',
						label: 'Vroom',
						name: 'redline',
						icon: 'gauge-simple-high',
						color: '#8a172e',
						hidden: true,
						store: false,
						canUninstall: true,
						unread: 0,
						params: ':tab?',
						restricted: {
							state: 'RACE_DONGLE',
						},
					},
					blueline: {
						storeLabel: 'Trials',
						label: 'Trials',
						name: 'blueline',
						icon: 'gauge-simple-high',
						color: '#1258a3',
						hidden: true,
						store: false,
						canUninstall: true,
						unread: 0,
						params: ':tab?',
						// restricted: {
						// 	job: {
						// 		police: true,
						// 	},
						// },
					},
					// leoassist: {
					// 	storeLabel: 'LEO Assist',
					// 	label: 'LEO Assist',
					// 	name: 'leoassist',
					// 	icon: 'siren-on',
					// 	color: '#1258a3',
					// 	hidden: true,
					// 	store: false,
					// 	canUninstall: true,
					// 	restricted: false,
					// 	unread: 0,
					// 	params: '',
					// 	restricted: {
					// 		job: {
					// 			police: true,
					// 		},
					// 	},
					// },
					comanager: {
						storeLabel: 'Company Manager',
						label: 'Company Manager',
						name: 'comanager',
						icon: 'briefcase',
						color: '#428030',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':jobId',
							},
						],
					},
					labor: {
						storeLabel: 'Labor',
						label: 'Labor',
						name: 'labor',
						icon: 'person-digging',
						color: '#785920',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					crypto: {
						storeLabel: 'CryptoX',
						label: 'CryptoX',
						name: 'crypto',
						icon: ['fab', 'bitcoin'],
						color: '#b0e655',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					dyn8: {
						storeLabel: 'Dynasty 8',
						label: 'Dynasty 8',
						name: 'dyn8',
						icon: 'house',
						color: '#136231',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					homemanage: {
						storeLabel: 'Smart Home',
						label: 'Smart Home',
						name: 'homemanage',
						icon: 'house-signal',
						color: '#30518c',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					// govt: {
					// 	storeLabel: 'Los Santos Services',
					// 	label: 'Los Santos Services',
					// 	name: 'govt',
					// 	icon: 'flag-usa',
					// 	color: '#5597d0',
					// 	hidden: false,
					// 	store: true,
					// 	canUninstall: true,
					// 	unread: 0,
					// 	params: '',
					// },
					garage: {
						storeLabel: 'Garage',
						label: 'Garage',
						name: 'garage',
						icon: 'warehouse',
						color: '#eb34de',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
						internal: [
							{
								app: 'view',
								params: ':vin',
							},
						],
					},
					pingem: {
						storeLabel: "Ping'Em",
						label: "Ping'Em",
						name: 'pingem',
						icon: 'location-crosshairs',
						color: '#8E1467',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
					// Add the app itself					
					camera: {
						storeLabel: 'Camera',
						label: 'Camera',
						name: 'camera',
						icon: 'camera',
						color: '#007494',
						hidden: false,
						store: false,
						canUninstall: false,
						unread: 0,
						params: '',
					},
					calculator: {
						storeLabel: 'Calculator',
						label: 'Calculator',
						name: 'calculator',
						icon: 'calculator',
						color: '#E95200',
						hidden: false,
						store: true,
						canUninstall: true,
						unread: 0,
						params: '',
					},
			  },
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'LOAD_PERMS':
			return {
				...state,
				permissions: action.payload,
			};
		case 'PHONE_VISIBLE':
			return {
				...state,
				visible: true,
			};
		case 'PHONE_NOT_VISIBLE':
			Nui.send('ClosePhone', null);
			return {
				...state,
				visible: false,
				limited: false,
			};
		case 'PHONE_NOT_VISIBLE_FORCED':
			return {
				...state,
				visible: false,
				limited: false,
			}
		case 'PHONE_VISIBLE_LIMITED':
			return {
				...state,
				visible: true,
				limited: true,
			};
		case 'CLEAR_HISTORY':
			return {
				...state,
				clear: true,
			};
		case 'TOGGLE_EXPANDED':
			Nui.send('UpdateSetting', {
				type: 'Expanded',
				val: !state.expanded,
			});
			return {
				...state,
				expanded: !state.expanded,
			};
		case 'SET_EXPANDED':
			return {
				...state,
				expanded: action.payload.expanded,
			};
		case 'CLEARED_HISTORY':
			Nui.send('CDExpired');
			return {
				...state,
				clear: false,
			};
		case 'SET_APPS':
			return {
				...state,
				apps: action.payload,
			};
		case 'REORDER_APP':
			let home = state.player?.Apps?.home.filter(
				(app) => app !== action.payload.app,
			);
			home.splice(action.payload.index, 0, action.payload.app);
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						home: home,
					},
				},
			};
		case 'REORDER_APP_DOCK':
			let dock = state.player?.Apps?.dock.filter(
				(app) => app !== action.payload.app,
			);
			dock.splice(action.payload.index, 0, action.payload.app);
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						dock: dock,
					},
				},
			};
		case 'ADD_UNREAD':
			return {
				...state,
				apps: apps.map((app) => {
					if (app.name == action.payload.name)
						return {
							...app,
							unread: app.unread + action.payload.count,
						};
					else return app;
				}),
			};
		case 'ADD_TO_HOME':
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						home: [...state.player?.Apps?.home, action.payload.app],
					},
				},
			};
		case 'REMOVE_FROM_HOME':
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						home: state.player?.Apps?.home.filter(
							(app) => app != action.payload.app,
						),
					},
				},
			};
		case 'DOCK_APP':
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						dock: [...state.player?.Apps?.dock, action.payload.app],
					},
				},
			};
		case 'UNDOCK_APP':
			return {
				...state,
				player: {
					...state.player,
					Apps: {
						...state.player.Apps,
						dock: state.player?.Apps?.dock.filter(
							(app) => app != action.payload.app,
						),
					},
				},
			};
		case 'SET_TIME':
			return {
				...state,
				time: action.payload,
			};
		default:
			return state;
	}
};

export default appReducer;
