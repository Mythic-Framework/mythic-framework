import '@babel/polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import CssBaseline from '@mui/material/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@mui/material';

import App from 'containers/App';

import WindowListener from 'containers/WindowListener';

import configureStore from './configureStore';
import KeyListener from './containers/KeyListener';

const initialState = {};
const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const render = () => {
	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Oswald'],
		},
		palette: {
			primary: {
				main: '#8a0000',
				light: '#ff2100',
				dark: '#560000',
				contrastText: '#ffffff',
			},
			secondary: {
				main: '#141414',
				light: '#1c1c1c',
				dark: '#0f0f0f',
				contrastText: '#ffffff',
			},
			error: {
				main: '#6e1616',
				light: '#a13434',
				dark: '#430b0b',
			},
			success: {
				main: '#52984a',
				light: '#60eb50',
				dark: '#244a20',
			},
			warning: {
				main: '#f09348',
				light: '#f2b583',
				dark: '#b05d1a',
			},
			info: {
				main: '#247ba5',
				light: '#247ba5',
				dark: '#175878',
			},
			text: {
				main: '#ffffff',
				alt: '#cecece',
				info: '#919191',
				light: '#ffffff',
				dark: '#000000',
			},
			rarities: {
				rare1: '#ffffff',
				rare2: '#52984a',
				rare3: '#247ba5',
				rare4: '#8e3bb8',
				rare5: '#f2d411',
			},
			border: {
				main: '#e0e0e008',
				light: '#ffffff',
				dark: '#26292d',
				input: 'rgba(255, 255, 255, 0.23)',
				divider: 'rgba(255, 255, 255, 0.12)',
			},
			mode: 'dark',
		},
		components: {
			MuiCssBaseline: {
				styleOverrides: {
					'.fade-enter': {
						opacity: 0,
					},
					'.fade-exit': {
						opacity: 1,
					},
					'.fade-enter-active': {
						opacity: 1,
					},
					'.fade-exit-active': {
						opacity: 0,
					},
					'.fade-enter-active, .fade-exit-active': {
						transition: 'opacity 500ms',
					},
					'*': {
						'&::-webkit-scrollbar': {
							width: 6,
						},
						'&::-webkit-scrollbar-thumb': {
							background: '#8a0000',
							transition: 'background ease-in 0.15s',
						},
						'&::-webkit-scrollbar-thumb:hover': {
							background: '#56000017',
						},
						'&::-webkit-scrollbar-track': {
							background: 'transparent',
						},
					},
				},
			},
			MuiTooltip: {
				styleOverrides: {
					tooltip: {
						fontSize: 16,
						backgroundColor: '#151515',
						border: '1px solid rgba(255, 255, 255, 0.23)',
						boxShadow: `0 0 10px #000`,
					},
				},
			},
			MuiPaper: {
				styleOverrides: {
					root: {
						background: '#0f0f0f',
					},
				},
			},
		},
	});
	ReactDOM.render(
		<Provider store={store}>
			<KeyListener>
				<WindowListener>
					<StyledEngineProvider injectFirst>
						<ThemeProvider theme={muiTheme}>
							<CssBaseline />
							<App />
						</ThemeProvider>
					</StyledEngineProvider>
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
