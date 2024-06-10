export const initialState = {
	showingRadar: false,
	showingRemote: false,
	settings: {
		scale: 100,
		location: 1,
		fastSpeed: 80,
		frontRadar: {
			lane: true, // true is same
			transmit: false,
		},
		rearRadar: {
			lane: true,
			transmit: false,
		},
	},
	data: {
		patrolSpeed: 0,
		frontRadar: {
			speed: null,
			direction: false,
			plate: false,
		},
		rearRadar: {
			speed: null,
			direction: false,
			plate: false,
		},
		frontFast: {
			locked: false,
			fast: false,
			speed: null,
			plate: false,
		},
		rearFast: {
			locked: false,
			fast: false,
			speed: null,
			plate: false,
		}
	},
	menu: {
		showing: false,
		radarText: '',
		fastText: '',
		patrolNumber: 0,
	}
};

const radarReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'RESET_RADAR':
			return initialState;
		case 'RADAR_SHOW':
			return {
				...state,
				showingRadar: true,
			};
		case 'RADAR_HIDE':
			return {
				...state,
				showingRadar: false,
			};
		case 'REMOTE_SHOW':
			return {
				...state,
				showingRemote: true,
			};
		case 'REMOTE_HIDE': 
			return {
				...state,
				showingRemote: false,
				menu: {
					...state.menu,
					showing: false,
				}
			};
		case 'MENU_SHOW': 
			return {
				...state,
				menu: {
					showing: true,
					radar: action.payload.radar,
					fast: action.payload.fast,
					patrol: action.payload.patrol,
				}
			}
		case 'MENU_HIDE':
			return {
				...state,
				menu: {
					showing: false,
				}
			};
        case 'UPDATE_SETTINGS':
            return {
                ...state,
				settings: {
					...state.settings,
					...action.payload,
				}
            };
		case 'UPDATE_DATA':
			return {
				...state,
				data: {
					...state.data,
					...action.payload,
				}
			};
		default:
			return state;
	}
};

export default radarReducer;
