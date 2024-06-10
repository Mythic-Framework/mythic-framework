export const initialState = {
	tab: 0,
	personSearch: {
		term: '',
		results: Array(),
	},
	vehicleSearch: {
		term: '',
		results: Array(),
	},
	propertySearch: {
		term: '',
		results: Array(),
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_LEO_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'SEARCH_VAL_CHANGE':
			return {
				...state,
				[`${action.payload.type}Search`]: {
					...state[`${action.payload.type}Search`],
					term: action.payload.term,
				},
			};
		case 'SEARCH_RESULTS':
			return {
				...state,
				[`${action.payload.type}Search`]: {
					...state[`${action.payload.type}Search`],
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
