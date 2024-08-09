import React from 'react';
import { useSelector } from 'react-redux';
import CssBaseline from '@material-ui/core/CssBaseline';
import {
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
} from '@material-ui/core';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { HashRouter as Router } from 'react-router-dom';

import 'react-image-lightbox/style.css';

import Phone from '../Phone';
import Race from '../Race';
import Popups from '../../components/Popups';

library.add(fab, fas);

export default (props) => {
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);
	const showTrack = useSelector((state) => state.track.show);
	const phoneOpen = useSelector((state) => state.phone.visible);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Roboto', 'sans-serif'],
		},
		palette: {
			primary: {
				main: Boolean(settings?.colors)
					? settings.colors.accent
					: '#b40000',
				light: Boolean(settings?.colors)
					? settings.colors.accent
					: '#c33333',
				dark: Boolean(settings?.colors)
					? settings.colors.accent
					: '#7e0000',
				contrastText: '#ffffff',
			},
			secondary: {
				main: '#18191e',
				light: '#2e3037',
				dark: '#1e1f24',
				contrastText: '#cecece',
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
				light: '#ffffff',
				dark: '#000000',
				alt: '#cecece',
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
						width: '90%',
						margin: 'auto',
					},
				},
			},
			MuiPopover: {
				styleOverrides: {
					root: {
						zIndex: '100000 !important',
					},
				},
			},
			MuiCssBaseline: {
				styleOverrides: {
					'*': {
						'&::-webkit-outer-spin-button, &::-webkit-inner-spin-button':
							{
								WebkitAppearance: 'none',
								margin: 0,
							},
						'&::-webkit-scrollbar': {
							width: 6,
						},
						'&::-webkit-scrollbar-thumb': {
							background: '#ffffff52',
						},
						'&::-webkit-scrollbar-thumb:hover': {
							background: Boolean(settings?.colors)
								? settings.colors.accent
								: '#dd1e36',
						},
						'&::-webkit-scrollbar-track': {
							background: 'transparent',
						},
						'.twitter-picker': {
							backgroundColor: '#2e3037 !important',
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
				},
			},
		},
	});
	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Router>
					<Phone />
					{!phoneOpen && <Popups />}
					{showTrack && <Race />}
				</Router>
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
