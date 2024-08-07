
export const initialState = {
	hidden: process.env.NODE_ENV == 'production',
	opacity: false,
	user: process.env.NODE_ENV != 'production' ? {
		Source: 2,
		Name: 'Dr Nick',
		AccountID: 1,
		Identifier: '789723918798237',
		Groups: [7],
		Level: 99,
	} : null,
	permission: "Owner",
	permissionName: 'Owner',
	permissionLevel: 100,
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'SET_USERDATA':
			return {
				...state,
				user: {
					...action.payload.user,
				},
				permission: action.payload.permission,
				permissionName: action.payload.permissionName,
				permissionLevel: action.payload.permissionLevel,
			};
		case 'SET_OPACITY_MODE':
			return {
				...state,
				opacity: action.payload.state,
			}
		case 'APP_SHOW':
			return {
				...state,
				hidden: false,
				opacity: false,
			};
		case 'APP_HIDE':
			return {
				...state,
				hidden: true,
				opacity: false,
			};
		case 'LOGOUT':
			return {
				...initialState,
			};
		default:
			return state;
	}
};

export default appReducer;