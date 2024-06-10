import '@babel/polyfill';

import React from 'react';
import { useSelector } from 'react-redux';
import CssBaseline from '@mui/material/CssBaseline';
import { ThemeProvider, createTheme, StyledEngineProvider } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { HashRouter } from 'react-router-dom';

import 'react-image-lightbox/style.css';

import MDT from '../MDT';
import Alerts from '../Alerts';
import Badge from '../GovBadge';
import { GetDeptPalette } from './Palettes';
import BodyCam from '../BodyCam';

library.add(fab, fas);

export default () => {
	const theme = 'dark';
	const job = useSelector((state) => state.app.govJob);
	const palette = GetDeptPalette(job?.Workplace?.Id, theme);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Exo'],
			fontWeightRegular: 400,
		},
		palette: palette,
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
						background: process.env.NODE_ENV != 'production' ? '#1e1e1e' : 'transparent',
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
						'.ck.ck-list__item .ck-button .ck-button__label': {
							lineHeight: '34px !important',
						},

						'--ck-border-radius': 4,
						'--ck-custom-background': '#121212',
						'--ck-custom-foreground': 'hsl(255, 3%, 18%)',
						'--ck-custom-border': 'hsl(300, 1%, 22%)',
						'--ck-custom-white': 'hsl(0, 0%, 100%)',
						'--ck-color-base-foreground': 'var(--ck-custom-background)',
						'--ck-color-focus-border': 'hsl(208, 90%, 62%)',
						'--ck-color-text': 'hsl(0, 0%, 98%)',
						'--ck-color-shadow-drop': 'hsla(0, 0%, 0%, 0.2)',
						'--ck-color-shadow-inner': 'hsla(0, 0%, 0%, 0.1)',
						'--ck-color-button-default-background': 'var(--ck-custom-background)',
						'--ck-color-button-default-hover-background': 'hsl(270, 1%, 22%)',
						'--ck-color-button-default-active-background': 'hsl(270, 2%, 20%)',
						'--ck-color-button-default-active-shadow': 'hsl(270, 2%, 23%)',
						'--ck-color-button-default-disabled-background': 'var(--ck-custom-background)',
						'--ck-color-button-on-background': 'var(--ck-custom-foreground)',
						'--ck-color-button-on-hover-background': 'hsl(255, 4%, 16%)',
						'--ck-color-button-on-active-background': 'hsl(255, 4%, 14%)',
						'--ck-color-button-on-active-shadow': 'hsl(240, 3%, 19%)',
						'--ck-color-button-on-disabled-background': 'var(--ck-custom-foreground)',
						'--ck-color-button-action-background': 'hsl(168, 76%, 42%)',
						'--ck-color-button-action-hover-background': 'hsl(168, 76%, 38%)',
						'--ck-color-button-action-active-background': 'hsl(168, 76%, 36%)',
						'--ck-color-button-action-active-shadow': 'hsl(168, 75%, 34%)',
						'--ck-color-button-action-disabled-background': 'hsl(168, 76%, 42%)',
						'--ck-color-button-action-text': 'var(--ck-custom-white)',
						'--ck-color-button-save': 'hsl(120, 100%, 46%)',
						'--ck-color-button-cancel': 'hsl(15, 100%, 56%)',
						'--ck-color-dropdown-panel-background': 'var(--ck-custom-background)',
						'--ck-color-dropdown-panel-border': 'var(--ck-custom-foreground)',
						'--ck-color-split-button-hover-background': 'var(--ck-color-button-default-hover-background)',
						'--ck-color-split-button-hover-border': 'var(--ck-custom-foreground)',
						'--ck-color-input-background': 'var(--ck-custom-background)',
						'--ck-color-input-border': 'hsl(257, 3%, 43%)',
						'--ck-color-input-text': 'hsl(0, 0%, 98%)',
						'--ck-color-input-disabled-background': 'hsl(255, 4%, 21%)',
						'--ck-color-input-disabled-border': 'hsl(250, 3%, 38%)',
						'--ck-color-input-disabled-text': 'hsl(0, 0%, 78%)',
						'--ck-color-labeled-field-label-background': 'var(--ck-custom-background)',
						'--ck-color-list-background': 'var(--ck-custom-background)',
						'--ck-color-list-button-hover-background': 'var(--ck-color-base-foreground)',
						'--ck-color-list-button-on-background': 'var(--ck-color-base-active)',
						'--ck-color-list-button-on-background-focus': 'var(--ck-color-base-active-focus)',
						'--ck-color-list-button-on-text': 'var(--ck-color-base-background)',
						'--ck-color-panel-background': 'var(--ck-custom-background)',
						'--ck-color-panel-border': 'var(--ck-custom-border)',
						'--ck-color-toolbar-background': 'var(--ck-custom-background)',
						'--ck-color-toolbar-border': 'var(--ck-custom-border)',
						'--ck-color-tooltip-background': 'hsl(252, 7%, 14%)',
						'--ck-color-tooltip-text': 'hsl(0, 0%, 93%)',
						'--ck-color-image-caption-background': 'hsl(0, 0%, 97%)',
						'--ck-color-image-caption-text': 'hsl(0, 0%, 20%)',
						'--ck-color-widget-blurred-border': 'hsl(0, 0%, 87%)',
						'--ck-color-widget-hover-border': 'hsl(43, 100%, 68%)',
						'--ck-color-widget-editable-focus-background': 'var(--ck-custom-white)',
						'--ck-color-link-default': 'hsl(190, 100%, 75%)',
						'--ck-color-base-background': '#0a0a0a',
						'--ck-color-base-border': 'rgba(255, 255, 255, 0.23)',
						'--ck-color-focus-border': '#fff',
						'.ck-content pre': {
							color: '#ffffff',
							background: '#191919',
							borderColor: theme === 'dark' ? 'rgba(255, 255, 255, 0.23)' : 'rgba(0, 0, 0, 0.23)',
						},
					},
					'.ck-content': {
						minHeight: 300,
					},
					'.ck-balloon-panel_visible': {
						zIndex: '10000 !important',
					},
					a: {
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
					'@keyframes pd-panic': {
						'0%, 49%': {
							backgroundColor: '#6e1616c7',
						},
						'50%, 100%': {
							backgroundColor: '#247ba5c7',
						},
					},
					'@keyframes pd-panic-border': {
						'0%, 49%': {
							borderColor: '#247ba5c7',
						},
						'50%, 100%': {
							borderColor: `#6e1616c7`,
						},
					},
					'@keyframes ems-panic': {
						'0%, 49%': {
							backgroundColor: '#760036c7',
						},
						'50%, 100%': {
							backgroundColor: '#2b0215c7',
						},
					},
					'@keyframes misc-panic': {
						'0%, 49%': {
							backgroundColor: '#270d3dc7',
						},
						'50%, 100%': {
							backgroundColor: '#6818adc7',
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
				<BodyCam />
				<HashRouter>
					<MDT />
				</HashRouter>
				<Alerts />
				<Badge />
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
