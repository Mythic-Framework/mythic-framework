export const initialState = {
	show: process.env.NODE_ENV != 'production',
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'TOGGLE_BODYCAM':
			return {
				...state,
				show: !state.show,
			};
		case 'SET_BODYCAM':
			return {
				...state,
				show: action.payload.state,
			};
		default:
			return state;
	}
};
