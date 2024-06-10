export const initialState = {
	selected: null,
};

export default (state = initialState, action) => {
	switch (action.type) {
        case 'CLOSE_UI':
            return {
                ...state,
                selected: null,
            }
		case 'SELECT_ACCOUNT':
			return {
				...state,
				selected: action.payload.account,
			};
		default:
			return state;
	}
};
