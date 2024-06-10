import { combineReducers } from 'redux';

import appReducer from './containers/App/reducer';
import dataReducer from './dataReducer';
import bankReducer from './components/Bank/reducer';

export default () =>
	combineReducers({
		app: appReducer,
		data: dataReducer,
		bank: bankReducer,
	});
