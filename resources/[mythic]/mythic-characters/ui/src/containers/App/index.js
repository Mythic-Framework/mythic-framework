import '@babel/polyfill';
import React from 'react';
import { useSelector } from 'react-redux';
import { CssBaseline, ThemeProvider, createTheme, StyledEngineProvider } from '@mui/material';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

import Loader from '../Loader';
import Splash from '../Splash';
import Characters from '../Characters';
import Create from '../Create';
import Spawn from '../Spawn';

import { STATE_CHARACTERS, STATE_CREATE, STATE_SPAWN } from '../../util/States';

library.add(fab, fas);

export default () => {
	const hidden = useSelector((state) => state.app.hidden);
	const appState = useSelector((state) => state.app.state);
	const loading = useSelector((state) => state.loader.loading);

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
			MuiPaper: {
				styleOverrides: {
					root: {
                        background: '#0f0f0f',
					},
				},
			},
		},
	});

	let display;

	switch (appState) {
		case STATE_CHARACTERS:
			display = <Characters />;
			break;
		case STATE_CREATE:
			display = <Create />;
			break;
		case STATE_SPAWN:
			display = <Spawn />;
			break;
		default:
			display = <Splash />;
			break;
	}

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				{!hidden && <div className="App">{loading ? <Loader /> : display}</div>}
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
