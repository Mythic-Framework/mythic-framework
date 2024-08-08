import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import chatReducer from 'containers/Chat/reducer';

export default () =>
    combineReducers({
        app: appReducer,
        chat: chatReducer,
    });
