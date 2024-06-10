import { combineReducers } from 'redux';

import appReducer from './containers/App/reducer';
import dataReducer from './dataReducer';

export default () =>
	combineReducers({
		app: appReducer,
		data: dataReducer,
	});
