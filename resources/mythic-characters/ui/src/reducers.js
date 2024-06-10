import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import loaderReducer from 'containers/Loader/reducer';
import charReducer from 'containers/Characters/reducer';
import spawnReducer from 'containers/Spawn/reducer';

export default () =>
	combineReducers({
		app: appReducer,
		loader: loaderReducer,
		characters: charReducer,
		spawn: spawnReducer,
	});
