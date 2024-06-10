import { combineReducers } from 'redux';

import appReducer from './containers/App/reducer';
import dataReducer from './dataReducer';
import searchReducer from './searchReducer';

export default () =>
	combineReducers({
		app: appReducer,
		data: dataReducer,
		search: searchReducer,
	});