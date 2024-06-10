import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useHistory } from 'react-router';
import { withRouter } from 'react-router-dom';

import { Footer, Home, Alerts } from '../../components';
import { Wallpapers } from '../../util/Wallpapers';

import Popups from '../../components/Popups';
import AppHandler from '../AppHandler';

export default withRouter((props) => {
	const history = useHistory();
	const dispatch = useDispatch();
	const visible = useSelector((state) => state.laptop.visible);
	const player = useSelector((state) => state.data.data.player);
	const settings = useSelector(
		(state) => state.data.data.player.LaptopSettings,
	);

	const clear = useSelector((state) => state.laptop.clear);
	useEffect(() => {
		if (clear) {
			setTimeout(() => {
				history.replace('/');
				dispatch({ type: 'CLEARED_HISTORY' });
			}, 2000);
		}
	}, [clear]);

	const useStyles = makeStyles((theme) => ({
		wrapper: {
			maxHeight: 1100,
			height: '100%',
			maxWidth: 1600,
			width: '100%',
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
			overflow: 'hidden',
			border: `6px solid #0f0f10`,
			borderRadius: 8,
		},
		laptopWallpaper: {
			height: '100%',
			width: '100%',
			position: 'absolute',
			background: `transparent no-repeat fixed center cover`,
			zIndex: -1,
			userSelect: 'none',
		},
		laptop: {
			position: 'absolute',
			top: 0,
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
			height: '100%',
			width: '100%',
			overflow: 'hidden',
		},
		screen: {
			height: 'calc(100% - 50px)',
			width: '100%',
			overflow: 'hidden',
			position: 'relative',
		},
	}));
	const classes = useStyles();

	if (!Boolean(player)) return null;
	return (
		<Slide direction="up" in={visible} mountOnEnter unmountOnExit>
			<div className={classes.wrapper}>
				<div className={classes.laptop}>
					<img
						className={classes.laptopWallpaper}
						src={
							Wallpapers[settings.wallpaper] != null
								? Wallpapers[settings.wallpaper].file
								: settings.wallpaper
						}
					/>
					<Alerts />
					<Popups />
					<div className={classes.screen}>
						<AppHandler />
						<Home />
					</div>
					<Footer />
				</div>
			</div>
		</Slide>
	);
});
