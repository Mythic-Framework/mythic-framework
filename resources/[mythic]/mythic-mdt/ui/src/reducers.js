import { combineReducers } from 'redux';

import appReducer from './containers/App/reducer';
import badgeReducer from './containers/GovBadge/reducer';
import dataReducer from './dataReducer';
import searchReducer from './searchReducer';
import alertReducer from './containers/Alerts/reducer';
import bodyCamReducer from './containers/BodyCam/reducer';

export default () =>
	combineReducers({
		app: appReducer,
		data: dataReducer,
		search: searchReducer,
		alerts: alertReducer,
		badge: badgeReducer,
		bodycam: bodyCamReducer,
	});
