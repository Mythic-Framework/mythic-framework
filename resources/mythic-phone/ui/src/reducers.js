import { combineReducers } from 'redux';

import dataReducer from 'dataReducer';
import phoneReducer from 'containers/Phone/reducer';
import usbReducer from 'components/USB/reducer';
import shareReducer from 'components/QuickShare/reducer';
import notifReducer from 'components/Notifications/reducer';
import alertsReducer from 'components/Alerts/reducer';
import callReducer from 'Apps/phone/reducer';
import storeReducer from 'Apps/store/reducer';
import twitterReducer from 'Apps/twitter/reducer';
import bankReducer from 'Apps/bank/reducer';
import loanReducer from 'Apps/loans/reducer';
import raceReducer from 'Apps/redline/reducer';
import pdRaceReducer from 'Apps/blueline/reducer';
import leoReducer from 'Apps/leoassist/reducer';
import trackReducer from 'containers/Race/reducer';
import comReducer from 'Apps/comanager/reducer';
import laborReducer from 'Apps/labor/reducer';
import cryptoReducer from 'Apps/crypto/reducer';
import dyn8Reducer from 'Apps/dyn8/reducer';
import homeReducer from 'Apps/homemanage/reducer';

export default () =>
	combineReducers({
		data: dataReducer,
		phone: phoneReducer,
		usb: usbReducer,
		share: shareReducer,
		alerts: alertsReducer,
		notifications: notifReducer,
		call: callReducer,
		store: storeReducer,
		twitter: twitterReducer,
		bank: bankReducer,
		loans: loanReducer,
		race: raceReducer,
		pdRace: pdRaceReducer,
		leo: leoReducer,
		track: trackReducer,
		com: comReducer,
		labor: laborReducer,
		crypto: cryptoReducer,
		dyn8: dyn8Reducer,
		home: homeReducer,
	});
