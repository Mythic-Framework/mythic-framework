import { combineReducers } from 'redux';

import appReducer from 'containers/App/reducer';
import menuReducer from 'components/Menu/reducer';

export default () =>
  combineReducers({
    app: appReducer,
    menu : menuReducer
  });
