import '@babel/polyfill';

import React from 'react';
import { useSelector } from 'react-redux';
import CssBaseline from '@material-ui/core/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { HashRouter } from 'react-router-dom';

import 'react-image-lightbox/style.css';

import Panel from '../Panel';

library.add(fab, fas);

export default () => {
	const theme = 'dark';
	const job = useSelector(state => state.app.govJob);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Exo'],
			fontWeightRegular: 400,
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
				main: theme === 'dark' ? '#ffffff' : '#2e2e2e',
				alt: theme === 'dark' ? 'rgba(255, 255, 255, 0.7)' : '#858585',
				info: theme === 'dark' ? '#919191' : '#919191',
				light: '#ffffff',
				dark: '#000000',
			},
			alt: {
				green: '#008442',
				greenDark: '#064224',
			},
			border: {
				main: theme === 'dark' ? '#e0e0e008' : '#e0e0e008',
				light: '#ffffff',
				dark: '#26292d',
				input:
					theme === 'dark'
						? 'rgba(255, 255, 255, 0.23)'
						: 'rgba(0, 0, 0, 0.23)',
				divider:
					theme === 'dark'
						? 'rgba(255, 255, 255, 0.12)'
						: 'rgba(0, 0, 0, 0.12)',
			},
			mode: theme,
		},
		components: {
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
						background: '#151515',
					},
				},
			},
			MuiAutocomplete: {
				styleOverrides: {
					paper: {
						boxShadow: '0 0 25px #000',
					},
				},
			},
			MuiBackdrop: {
				styleOverrides: {
					root: {
						height: '90%',
						width: '60%',
						margin: 'auto',
					},
				},
			},
			MuiCssBaseline: {
				styleOverrides: {
					'.Toastify__toast-container--bottom-right': {
						bottom: '0.5em !important',
						right: '0.5em !important',
						position: 'absolute !important',
					},
					'.tox-dialog-wrap__backdrop': {
						height: '90% !important',
						width: '90% !important',
						margin: 'auto !important',
						background: '#151515bf !important',
					},
					'.tox-statusbar__branding': {
						display: 'none !important',
					},
					'*': {
						'&::-webkit-scrollbar': {
							width: 6,
						},
						'&::-webkit-scrollbar-thumb': {
							background: 'rgba(0, 0, 0, 0.5)',
							transition: 'background ease-in 0.15s',
						},
						'&::-webkit-scrollbar-thumb:hover': {
							background: '#ffffff17',
						},
						'&::-webkit-scrollbar-track': {
							background: 'transparent',
						},
					},
					html: {
						background:
							process.env.NODE_ENV != 'production'
								? '#1e1e1e'
								: 'transparent',
						'input::-webkit-outer-spin-button, input::-webkit-inner-spin-button': {
							WebkitAppearance: 'none',
							margin: 0,
						},
					},
					body: {
						position: 'relative',
						zIndex: -15,
						backgroundColor: '#0b0a0a',
						position: 'absolute',
						top: 0,
						bottom: 0,
						left: 0,
						right: 0,
						margin: 'auto',
						height: '90%',
						width: '60%',
						borderRadius: 10,
						overflowY: 'auto',
						overflowX: 'hidden',
						paddingRight: '0px !important',

						'.item-enter': {
							opacity: 0,
						},
						'.item-enter-active': {
							opacity: 1,
							transition: 'opacity 500ms ease-in',
						},
						'.item-exit': {
							opacity: 1,
						},
						'.item-exit-active': {
							opacity: 0,
							transition: 'opacity 500ms ease-in',
						},
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
					},
					'a': {
						textDecoration: 'none',
						color: '#fff',
					},
					'#root': {
						position: 'relative',
						zIndex: -10,
					},
					'@keyframes bouncing': {
						'0%': {
							bottom: 0,
							opacity: 0.25,
						},
						'100%': {
							bottom: 50,
							opacity: 1.0,
						},
					},
					'@keyframes ripple': {
						'0%': {
							transform: 'scale(.8)',
							opacity: 1,
						},
						'100%': {
							transform: 'scale(2.4)',
							opacity: 0,
						},
					},
				},
			},
		},
	});

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<HashRouter>
					<Panel />
				</HashRouter>
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
