export const initialState = {
	tab: 0,
	selected: null,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_HOME_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'SET_SELECTED_PROPERTY':
			return {
				...state,
				selected: action.payload,
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
