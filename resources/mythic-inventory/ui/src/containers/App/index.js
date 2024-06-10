import React, { Fragment } from 'react';
import { useSelector } from 'react-redux';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import {
	CssBaseline,
	ThemeProvider,
	createTheme,
	StyledEngineProvider,
	Fade,
} from '@mui/material';

import CraftingProcessor from '../../components/Crafting/Process';
import AppScreen from '../../components/AppScreen/AppScreen';
import Inventory from '../../components/Inventory/Inventory';
import HoverSlot from '../../components/Inventory/HoverSlot';
import Hotbar from '../../components/Inventory/Hotbar';
import Crafting from '../../components/Crafting';
import ChangeAlerts from '../../components/Changes';

library.add(fab, fas);

export default () => {
	const hidden = useSelector((state) => state.app.hidden);
	const mode = useSelector((state) => state.app.mode);
	const crafting = useSelector((state) => state.crafting.crafting);

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

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Hotbar />
				<ChangeAlerts />
				<Fade in={!hidden}>
					<div>
						{mode === 'inventory' && (
							<Fragment>
								<AppScreen>
									<Inventory />
								</AppScreen>
								<HoverSlot />
							</Fragment>
						)}
						{mode === 'crafting' && (
							<Fragment>
								<AppScreen>
									<Crafting />
								</AppScreen>
							</Fragment>
						)}
					</div>
				</Fade>
				{Boolean(crafting) && <CraftingProcessor crafting={crafting} />}
			</ThemeProvider>
		</StyledEngineProvider>
	);
};
