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
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';


import LCD from '../../assets/fonts/lcd.ttf';
import Window from '../Window';

library.add(fab, fas);

const LCDFont = {
    fontFamily: 'LCD',
    fontStyle: 'normal',
    fontDisplay: 'swap',
    fontWeight: 400,
    src: `
      url(${LCD}) format('truetype')
    `,
};

export default () => {
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
            alt: {
                green: '#008442',
                greenDark: '#064224',
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
						width: '90%',
						borderRadius: 10,
						overflowY: 'auto',
						overflowX: 'hidden',
						paddingRight: '0px !important',

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
                        '@font-face': [LCDFont],
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
				<ToastContainer />
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
