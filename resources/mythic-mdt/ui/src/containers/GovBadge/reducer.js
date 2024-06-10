
export const initialState = {
    showing: false,
	type: 2,
	data: {},


	// showing: true,
	// data: {
	// 	Department: 'doj',
	// 	SID: 3,
	// 	First: 'Walter',
	// 	Last: 'Western',
	// 	Callsign: 202,
	// 	Mugshot: 'https://i.imgur.com/B2A7EiH.png',
	// 	Title: 'Justice',
	// }
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'SHOW_GOV_ID':
			return {
				...state,
				type: 1,
				showing: true,
				data: action.payload,
			};
		case 'HIDE_GOV_ID':
			return {
				...state,
				showing: false,
			};
		case 'SHOW_DRIVER_LICENSE':
			return {
				...state,
				type: 2,
				showing: true,
				data: action.payload,
			};
		case 'HIDE_DRIVER_LICENSE':
			return {
				...state,
				showing: false,
			}
		case 'UI_RESET':
		case 'LOGOUT':
			return {
				...initialState,
			};
		default:
			return state;
	}
};

export default appReducer;