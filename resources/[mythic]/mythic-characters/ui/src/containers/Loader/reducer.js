import { APP_RESET, LOADING_SHOW, LOADING_HIDE } from '../../actions/types';

export const initialState = {
	loading: false,
	message: null,
};

const loaderReducer = (state = initialState, action) => {
	switch (action.type) {
		case LOADING_SHOW:
			return { ...state, loading: true, message: action.payload.message };
		case LOADING_HIDE:
			return { ...state, loading: false, message: null };
		case APP_RESET:
			return { ...initialState };
		default:
			return state;
	}
};

export default loaderReducer;
