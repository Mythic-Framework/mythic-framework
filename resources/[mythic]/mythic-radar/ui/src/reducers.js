import { combineReducers } from 'redux';

import radarReducer from './radarReducer';

export default () =>
	combineReducers({
		radar: radarReducer,
	});
