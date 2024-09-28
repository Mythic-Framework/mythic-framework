import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@material-ui/core';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { HashRouter } from 'react-router-dom';
import 'react-toastify/dist/ReactToastify.css';

import Window from '../Window';
import { useSelector } from 'react-redux';

import GetPalette from './Palettes';

library.add(fab, fas);

export default () => {
	const app = useSelector((state) => state.app.app);
	const brand = useSelector((state) => state.app.brand);
	const palette = GetPalette(brand, 'dark');

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Oswald'],
		},
		palette: palette,
		components: {
			MuiTooltip: {
				styleOverrides: {
					tooltip: {
						fontSize: 16,
						backgroundColor: '#111315',
						border: '1px solid rgba(255, 255, 255, 0.23)',
						boxShadow: `0 0 10px #000`,
					},
				},
			},
			MuiPaper: {
				styleOverrides: {
					root: {
						background: '#111315',
					},
				},
			},
			MuiBackdrop: {
				styleOverrides: {
					root: {
						height: app == 'ATM' ? 605 : 900,
						width: app == 'ATM' ? '30%' : '75%',
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
					'*': {
						'&::-webkit-scrollbar': {
							width: 6,
						},
						'&::-webkit-scrollbar-thumb': {
							background: '#ffffff52',
							transition: 'background ease-in 0.15s',
						},
						'&::-webkit-scrollbar-thumb:hover': {
							background: '#ffffff17',
						},
						'&::-webkit-scrollbar-track': {
							background: 'transparent',
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
					html: {
						background:
							process.env.NODE_ENV != 'production'
								? '#1e1e1e'
								: 'transparent',
						'input::-webkit-outer-spin-button, input::-webkit-inner-spin-button':
							{
								WebkitAppearance: 'none',
								margin: 0,
							},
					},
					body: {
						position: 'relative',
						zIndex: -15,
						position: 'absolute',
						top: 0,
						bottom: 0,
						left: 0,
						right: 0,
						margin: 'auto',
						height: app == 'ATM' ? 605 : 900,
						width: app == 'ATM' ? '30%' : '75%',
						borderRadius: 10,
						overflowY: 'auto',
						overflowX: 'hidden',
						paddingRight: '0px !important',
					},
					a: {
						textDecoration: 'none',
						color: '#fff',
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
					<Window />
				</HashRouter>
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
