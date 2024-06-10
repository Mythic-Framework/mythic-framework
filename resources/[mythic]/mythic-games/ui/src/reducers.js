import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import gameReducer from './containers/Minigames/reducer';

export default () =>
    combineReducers({
        app: appReducer,
        game: gameReducer,
    });
