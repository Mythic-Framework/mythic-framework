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
import { HashRouter } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import Positioning from './positioning';

import Segment7Standard from '../../fonts/Segment7Standard.otf';

//import Window from '../Window';
import Radar from '../Radar';
import Remote from '../Remote';

library.add(fab, fas);

export default () => {
	const theme = 'light';
	const radarScale = useSelector(state => state.radar.settings.scale);
	const radarPosition = useSelector(state => state.radar.settings.location);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Segment7Standard', 'Exo', 'Lato'],
			fontWeightRegular: 400,
		},
		palette: {
			primary: {
				main: '#b40000',
				light: '#c33333',
				dark: '#7e0000',
				contrastText: theme === 'dark' ? '#ffffff' : '#26292d',
			},
			secondary: {
				main: theme === 'dark' ? '#18191e' : '#ffffff',
				light: theme === 'dark' ? '#2e3037' : '#F5F6F4',
				dark: theme === 'dark' ? '#1e1f24' : '#EBEBEB',
				contrastText: theme === 'dark' ? '#ffffff' : '#2e2e2e',
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
				alt: theme === 'dark' ? '#cecece' : '#858585',
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
			speedDisplays: {
				red: {
					background: 'rgb(50, 0, 0)',
					text: 'rgb(243, 12, 10)',
					textShadow: '0 0 5px rgba(243, 14, 10, 0.65)',
					ghostText: 'rgb(70, 0, 0)',
				},
				orange: {
					background: 'rgb(61, 18, 0)',
					text: 'rgb(252, 113, 1)',
					textShadow: '0 0 5px rgba(252, 114, 1, 0.65)',
					ghostText: 'rgb(90, 35, 1)',
				},
				green: {
					background: 'rgb(0, 57, 35)',
					text: 'rgb(15, 244, 57)',
					textShadow: '0 0 5px rgba(15, 244, 57, 0.65)',
					ghostText: 'rgb(0, 91, 68)',
				},
			},
		},
		currentPositioning: Positioning?.[radarPosition] ?? Positioning[1],
		scale: radarScale / 100,
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
			MuiCssBaseline: {
				styleOverrides: {
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
						'@font-face': {
							fontFamily: 'Segment7Standard',
							src: `url(${Segment7Standard}) format('truetype')`,
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
						margin: 0,
						height: '100%',
						width: '100%',
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
					<Radar />
					<Remote />
				</HashRouter>
				<ToastContainer />
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
