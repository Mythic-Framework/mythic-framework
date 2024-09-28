import React, { Fragment } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
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
import StaticTooltip from '../../components/Inventory/StaticTooltip';

library.add(fab, fas);

export default () => {
	const dispatch = useDispatch();
	const hidden = useSelector((state) => state.app.hidden);
	const mode = useSelector((state) => state.app.mode);
	const crafting = useSelector((state) => state.crafting.crafting);
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const items = useSelector((state) => state.inventory.items);
	const staticTooltip = useSelector((state) => state.inventory.staticTooltip);

	const muiTheme = createTheme({
		typography: {
			fontFamily: ['Noto Sans', 'Exo', 'sans-serif'].join(','),
		},
		palette: {
			primary: {
				main: '#000000',
				light: '#3483ebce',
				dark: '#023373 ',
				contrastText: '#ffffff',
			},
			secondary: {
				main: '#141414',
				light: '#000000',
				dark: '#000000',
				contrastText: '#ffffff',
			},
			error: {
				main: '#6e1616',
				light: '#a13434',
				dark: '#430b0b',
			},
			success: {
				main: '#9CE60D',
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
				rare2: '#9CE60D',
				rare3: '#247ba5',
				rare4: '#8e3bb8',
				rare5: '#f2d411',
			},
			border: {
				main: '#e0e0e008',
				light: '#1d75a8c7',
				dark: '#26292d',
				input: 'rgba(255, 255, 255, 0.23)',
				divider: 'rgba(255, 255, 255, 0.12)',
			},
			mode: 'dark',
		},
		components: {
			MuiButton: {
				root: {
                    color: 'rgba(0, 0, 0, 1.0)',
                },
			},
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
			MuiTooltip: {
				styleOverrides: {
					tooltip: {
						fontSize: 16,
						background: 'rgb(18,18,28)',
						background: 'rgb(18,18,28)',
						border: '1px solid rgba(255, 255, 255, 0.23)',
						boxShadow: `0 0 10px #000`,
					},
				},
			},
			MuiPaper: {
				styleOverrides: {
					root: {
						background: 'rgb(18,18,28)',
					},
				},
			},
		},
	});

	const onHide = () => {
		dispatch({
			type: 'HIDE_SECONDARY_INVENTORY',
		});
		dispatch({
			type: 'RESET_INVENTORY',
		});
	};

	return (
		<StyledEngineProvider injectFirst>
			<ThemeProvider theme={muiTheme}>
				<CssBaseline />
				<Hotbar />
				<ChangeAlerts />
				{Boolean(itemsLoaded) && Boolean(staticTooltip) && (
					<StaticTooltip
						item={items[staticTooltip.Name]}
						instance={staticTooltip}
					/>
				)}
				<Fade in={!hidden} timeout={500} onExited={onHide}>
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