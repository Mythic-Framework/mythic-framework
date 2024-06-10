export const initialState = {
	open: false,
	sharing: null,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'USE_SHARE':
			return {
				...state,
				open: action.payload,
			};
		case 'RECEIVE_SHARE':
			return {
				...state,
				sharing: action.payload,
			};
		case 'REMOVE_SHARE':
			return {
				...state,
				sharing: null,
				open: false,
			};
		default:
			return state;
	}
};
