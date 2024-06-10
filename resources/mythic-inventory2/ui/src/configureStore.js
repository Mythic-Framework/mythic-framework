import { applyMiddleware, compose, createStore } from 'redux';
import createReducer from './reducers';
import thunk from 'redux-thunk';

export default function configureStore(initialState) {
  let composeEnhancers = compose;

  if (process.env.NODE_ENV !== 'production' && typeof window === 'object') {
    if (window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__) {
      composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({});
    }
  }

  const enhancers = [];

  const store = createStore(
    createReducer(),
    initialState,
    applyMiddleware(thunk)
  );

  if (module.hot) {
    module.hot.accept('./reducers', () => {
      store.replaceReducer(createReducer(store.injectedReducers));
    });
  }

  return store;
}
