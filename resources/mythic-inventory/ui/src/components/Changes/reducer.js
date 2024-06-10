const initialState = {
	alerts: Array(),
	// alerts: [
	// 	{
	// 		id: 1,
	// 		type: 'add',
	// 		item: 'bread',
	// 		count: 2,
	// 	},
	// 	{
	// 		id: 2,
	// 		type: 'removed',
	// 		item: 'water',
	// 		count: 2,
	// 	},
	// 	{
	// 		id: 3,
	// 		type: 'used',
	// 		item: 'WEAPON_ADVANCEDRIFLE',
	// 		count: 1,
	// 	},
	// ],
};

const reducer = (state = initialState, action) => {
	switch (action.type) {
		case 'ADD_ALERT':
			return {
				...state,
				alerts: [...state.alerts, action.payload.alert],
			};
		case 'DISMISS_ALERT':
			return {
				...state,
				alerts: state.alerts.filter((a) => a.id != action.payload.id),
			};
		default: {
			return state;
		}
	}
};

export default reducer;
