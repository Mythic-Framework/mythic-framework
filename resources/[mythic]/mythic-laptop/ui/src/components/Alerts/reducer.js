export const initialState = {
	alerts: [
		//"Test alert",
	],
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'ALERT_SHOW':
			return {
				...state,
				alerts: [...state.alerts, action.payload.alert],
			};
		case 'ALERT_EXPIRE':
			return {
				...state,
				alerts: state.alerts.filter((a, i) => i > 0),
			};
        case 'ALERTS_RESET':
            return {
                ...state,
                alerts: [],
            };
		default:
			return state;
	}
};
