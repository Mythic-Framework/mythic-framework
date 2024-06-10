import { combineReducers } from 'redux';

import dataReducer from 'dataReducer';
import laptopReducer from 'containers/Laptop/reducer';
import appsReducer from 'containers/AppHandler/reducer';
import notifReducer from 'components/Notifications/reducer';
import alertsReducer from 'components/Alerts/reducer';

export default () =>
	combineReducers({
		data: dataReducer,
		laptop: laptopReducer,
		apps: appsReducer,
		alerts: alertsReducer,
		notifications: notifReducer,
	});
