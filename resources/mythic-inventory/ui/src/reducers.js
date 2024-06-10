import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import inventoryReducer from 'components/Inventory/reducer';
import craftingReducer from 'components/Crafting/reducer';
import changeReducer from 'components/Changes/reducer';

export default () =>
	combineReducers({
		app: appReducer,
		inventory: inventoryReducer,
		crafting: craftingReducer,
		changes: changeReducer,
	});
