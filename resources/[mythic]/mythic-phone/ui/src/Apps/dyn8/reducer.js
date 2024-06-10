export const initialState = {
	propertySearch: {
		term: '',
		results: Array(),
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'DYN8_SEARCH_CHANGE':
			return {
				...state,
				propertySearch: {
					...state.propertySearch,
					term: action.payload.term,
				},
			};
		case 'DYN8_RESULTS':
			return {
				...state,
				propertySearch: {
					...state.propertySearch,
					results: action.payload.results,
				},
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
