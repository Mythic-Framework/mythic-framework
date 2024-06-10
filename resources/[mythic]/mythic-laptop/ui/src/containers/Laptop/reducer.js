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
					// internet: {
					// 	label: 'Interwebz',
					// 	name: 'internet',
					// 	icon: ['fab', 'internet-explorer'],
					// 	color: '#1db5e7',
					// 	hidden: false,
					// 	unread: 0,
					// },
					// terminal: {
					// 	label: 'Terminal',
					// 	name: 'terminal',
					// 	icon: ['fas', 'terminal'],
					// 	color: '#000000',
					// 	hidden: false,
					// 	size: {
					// 		width: 600,
					// 		height: 400,
					// 	},
					// 	unread: 0,
					// },
					// supplymate: {
					// 	label: 'Supply Mate',
					// 	name: 'supplymate',
					// 	icon: 'parachute-box',
					// 	color: '#9808c7',
					// 	unread: 0,
					// 	restricted: {
					// 		state: 'PHONE_VPN',
					// 	},
					// },
					lsunderground: {
						label: 'LS UGND',
						name: 'lsunderground',
						icon: 'user-secret',
						color: '#E95200',
						unread: 0,
						restricted: {
							state: 'ACCESS_LSUNDERGROUND',
						},
					},
					teams: {
						label: 'Teams',
						name: 'teams',
						icon: 'people-group',
						color: '#00FF8A',
						unread: 0,
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
		case 'TABLET_VISIBLE':
			return {
				...state,
				visible: true,
			};
		case 'TABLET_NOT_VISIBLE':
			Nui.send('CloseTablet', null);
			return {
				...state,
				visible: false,
				limited: false,
			};
		case 'TABLET_VISIBLE_LIMITED':
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
