export const initialState = {
	hidden: process.env.NODE_ENV === 'production',
	showHotbar: false,
	showing: null,
	mode: 'inventory', // crafting

	settings: {
		muted: false,
		useBank: false,
	},

	hotbarItems: [],
	equipped: null,
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'APP_SHOW':
			return {
				...state,
				hidden: false,
			};
		case 'APP_HIDE':
			return {
				...state,
				hidden: true,
			};
		case 'UPDATE_SETTINGS': {
			return {
				...state,
				settings: {
					...state.settings,
					...action.payload.settings,
				},
			};
		}
		case 'SET_MODE': {
			return {
				...state,
				mode: action.payload.mode,
			};
		}
		case 'HOTBAR_HIDE':
			return {
				...state,
				showHotbar: false,
			};
		case 'HOTBAR_SHOW':
			return {
				...state,
				showHotbar: true,
				showing: action.payload.hotkey,
				hotbarItems: action.payload.items,
			};
		case 'SET_EQUIPPED':
			return {
				...state,
				equipped: action.payload.item,
			};
		case 'RESET_SLOT':
			return {
				...state,
				showing: null,
			};
		default:
			return state;
	}
};

export default appReducer;
