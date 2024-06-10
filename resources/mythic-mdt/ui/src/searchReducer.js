export const initialState = {
	searchTerms: {
		people: '',
		vehicle: '',
		firearm: '',
		report: '',
		warrant: '',
		property: '',
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'UPDATE_SEARCH_TERM':
			return {
				...state,
				searchTerms: {
					...state.searchTerms,
					[action.payload.type]: action.payload.term,
				},
			};
		case 'CLEAR_SEARCH':
			return {
				...state,
				searchTerms: {
					...state.searchTerms,
					[action.payload.type]: '',
				},
			};
		default:
			return state;
	}
};
