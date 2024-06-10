export const initialState = {
	installing: [],
	installPending: [],
	installFailed: [],
	uninstalling: [],
	uninstallPending: [],
	uninstallFailed: [],
	tab: 0,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'PENDING_INSTALL':
			return {
				...state,
				installPending: [...state.installPending, action.payload.app],
			};
		case 'START_INSTALL':
			return {
				...state,
				installing: state.installPending.filter(
					(a) => a !== action.payload.app,
				),
				installing: [...state.installing, action.payload.app],
			};
		case 'END_INSTALL':
			return {
				...state,
				installing: state.installing.filter(
					(i) => i !== action.payload.app,
				),
				installPending: state.installPending.filter(
					(i) => i !== action.payload.app,
				),
				installFailed: state.installFailed.filter(
					(i) => i !== action.payload.app,
				),
			};
		case 'FAILED_INSTALL':
			return {
				...state,
				installing: state.installing.filter(
					(i) => i !== action.payload.app,
				),
				installPending: state.installPending.filter(
					(i) => i !== action.payload.app,
				),
				installFailed: [...state.installFailed, action.payload.app],
			};
		case 'PENDING_UNINSTALL':
			return {
				...state,
				uninstallPending: [
					...state.uninstallPending,
					action.payload.app,
				],
			};
		case 'START_UNINSTALL':
			return {
				...state,
				uninstallPending: state.uninstallPending.filter(
					(a) => a !== action.payload.app,
				),
				uninstalling: [...state.uninstalling, action.payload.app],
			};
		case 'FAILED_UNINSTALL':
			return {
				...state,
				uninstalling: state.uninstalling.filter(
					(i) => i !== action.payload.app,
				),
				uninstallPending: state.uninstallPending.filter(
					(i) => i !== action.payload.app,
				),
				uninstallFailed: [...state.uninstallFailed, action.payload.app],
			};
		case 'END_UNINSTALL':
			return {
				...state,
				uninstalling: state.uninstalling.filter(
					(i) => i !== action.payload.app,
				),
				uninstallPending: state.uninstallPending.filter(
					(i) => i !== action.payload.app,
				),
				uninstallFailed: state.uninstallFailed.filter(
					(i) => i !== action.payload.app,
				),
			};
		case 'SET_STORE_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
