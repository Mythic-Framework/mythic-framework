import { applyMiddleware, createStore, compose } from 'redux';
import thunk from 'redux-thunk';

const enhancers = [];
const middleware = [thunk];

import createReducer from './reducers';

const composedEnhancers = compose(applyMiddleware(...middleware), ...enhancers);

export default function configureStore(initialState) {
	const store = createStore(createReducer(), initialState, composedEnhancers);

	if (module.hot) {
		module.hot.accept('./reducers', () => {
			store.replaceReducer(createReducer(store.injectedReducers));
		});
	}

	return store;
}
