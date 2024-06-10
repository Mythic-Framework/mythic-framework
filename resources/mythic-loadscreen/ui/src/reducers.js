import { combineReducers } from 'redux';

import loadReducer from 'containers/Loadscreen/reducer';

export default () =>
	combineReducers({
		load: loadReducer,
	});
