export const initialState = {
	tab: 0,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_LABOR_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
