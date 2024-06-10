export const initialState = {
	hidden: process.env.NODE_ENV == 'production',
	trip: 0,
	rate: 10,
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'APP_SHOW':
			return {
				...state,
				hidden: false,
				rate: action.payload.rate,
				trip: 0,
			};
		case 'APP_HIDE':
			return {
				...state,
				hidden: true,
			};
		case 'APP_RESET':
			return {
				...initialState,
			};
		case 'SET_RATE':
			return {
				...state,
				rate: action.payload.rate,
			};
		case 'RESET_TRIP':
			return {
				...state,
				trip: 0,
			};
		case 'UPDATE_TRIP':
			return {
				...state,
				trip: state.trip + action.payload.trip,
			};
		default:
			return state;
	}
};

export default appReducer;
