import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import '@babel/polyfill';

import App from './containers/App';
import WindowListener from './containers/WindowListener';
import KeyListener from './containers/KeyListener';
import configureStore from './configureStore';

const initialState = {};
const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const render = () => {
	ReactDOM.render(
		<Provider store={store}>
			<KeyListener>
				<WindowListener>
					<App />
				</WindowListener>
			</KeyListener>
		</Provider>,
		MOUNT_NODE,
	);
};

if (module.hot) {
	module.hot.accept(['./containers/App'], () => {
		ReactDOM.unmountComponentAtNode(MOUNT_NODE);
		render();
	});
}

render();