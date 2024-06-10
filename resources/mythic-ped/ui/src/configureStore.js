import { applyMiddleware, createStore } from 'redux';
import thunk from 'redux-thunk';
import createReducer from './reducers';

export default function configureStore(initialState) {
  const store = createStore(
    createReducer(),
    initialState,
    applyMiddleware(thunk),
  );

  if (module.hot) {
    module.hot.accept('./reducers', () => {
      store.replaceReducer(createReducer(store.injectedReducers));
    });
  }

  return store;
}
