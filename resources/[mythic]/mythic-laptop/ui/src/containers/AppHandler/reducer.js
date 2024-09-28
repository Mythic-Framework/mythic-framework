import Nui from '../../util/Nui';

export const initialState = {
	focused: null,
	appStates: Array(),
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'UPDATE_FOCUS':
			return {
				...state,
				focused: action.payload.app,
			};
		case 'OPEN_APP':
			if (
				state.appStates.filter((a) => a.app == action.payload.state.app)
					.length > 0
			) {
				return {
					...state,
					appStates: [
						...state.appStates.map((a) => {
							if (a.app == action.payload.state.app)
								return { ...a, minimized: false, };
							else return a;
						}),
					],
					focused: action.payload.state.app,
				};
			} else {
				return {
					...state,
					appStates: [...state.appStates, action.payload.state],
					focused: action.payload.state.app,
				};
			}
		case 'CLOSE_APP':
			let n = [
				...state.appStates.filter((a) => a.app != action.payload.app),
			];
			return {
				...state,
				appStates: n,
				focused: !Boolean(n[0]?.minimized) ? n[0]?.app : null,
			};
		case 'UPDATE_APP_STATE':
			return {
				...state,
				appStates: [
					...state.appStates.map((app) => {
						if (app.app == action.payload.app)
							return { ...app, ...action.payload.state };
						else return app;
					}),
				],
				focused: action.payload.focus
					? action.payload.app
					: state.focused,
			};
		case 'MINIMIZE_APP':
			return {
				...state,
				appStates: [
					...state.appStates.map((app) => {
						if (app.app == action.payload.app)
							return { ...app, minimized: true };
						else return app;
					}),
				],
				focused:
					state.focused == action.payload.app ? null : state.focused,
			};
		case 'MINIMIZE_ALL_APPS':
			return {
				...state,
				appStates: [
					...state.appStates.map((app) => ({
						...app,
						minimized: true,
					})),
				],
			};
		case 'CLOSE_ALL_APPS':
			return {
				...state,
				appStates: Array(),
			};
		default:
			return state;
	}
};

export default appReducer;
