import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';

import App from './containers/App';

import KeyListener from './containers/KeyListener';
import WindowListener from './containers/WindowListener';

import configureStore from './configureStore';

const initialState = {};
export const store = configureStore(initialState);
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
	module.hot.accept(['containers/App'], () => {
		ReactDOM.unmountComponentAtNode(MOUNT_NODE);
		render();
	});
}

render();
