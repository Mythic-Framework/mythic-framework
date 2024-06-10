import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Slide } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Loadable from 'react-loadable';
import { Route, Switch, Redirect, useHistory } from 'react-router';
import { withRouter } from 'react-router-dom';

import {
	Header,
	Footer,
	AppLoader,
	Home,
	List,
	Notifications,
	Alerts,
	USB,
	QuickShare,
} from '../../components';
import { useMyApps } from '../../hooks';
import { Wallpapers } from '../../util/Wallpapers';
import phoneImg from '../../s10.png';

import Popups from '../../components/Popups';

export default withRouter((props) => {
	const history = useHistory();
	const apps = useMyApps();
	const dispatch = useDispatch();
	const visible = useSelector((state) => state.phone.visible);
	const player = useSelector((state) => state.data.data.player);
	const expanded = useSelector((state) => state.phone.expanded);
	const installed = useSelector(
		(state) => state.data.data.player?.Apps?.installed,
	);
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);
	const callData = useSelector((state) => state.call.call);

	const clear = useSelector((state) => state.phone.clear);
	useEffect(() => {
		if (clear) {
			setTimeout(() => {
				history.replace('/');
				dispatch({ type: 'CLEARED_HISTORY' });
			}, 2000);
		}
	}, [clear]);

	const useStyles = makeStyles((theme) => ({
		wrapper: expanded
			? {
					height: 1000,
					width: 500,
					position: 'absolute',
					top: 0,
					bottom: 0,
					left: 0,
					right: 0,
					margin: 'auto',
					overflow: 'hidden',
			  }
			: {
					height: 1000,
					width: 500,
					position: 'absolute',
					bottom: '2%',
					right: '2%',
					overflow: 'hidden',
					zoom: `${settings.zoom}%`,
			  },
		phoneImg: {
			zIndex: 100,
			background: `transparent no-repeat center`,
			height: '100%',
			width: '100%',
			position: 'absolute',
			pointerEvents: 'none',
			userSelect: 'none',
			right: 1,
		},
		phoneWallpaper: {
			height: '92%',
			width: '88%',
			position: 'absolute',
			background: `transparent no-repeat fixed center cover`,
			zIndex: -1,
			borderRadius: 30,
			userSelect: 'none',
		},
		phone: {
			height: '100%',
			width: '100%',
			padding: '35px 30px',
			overflow: 'hidden',
		},
		screen: {
			height: '84%',
			width: '99.099%',
			overflow: 'hidden',
		},
	}));
	const classes = useStyles();

	const DynamicLoad = (app, subapp) => {
		const LoadableSubComponent = Loadable({
			loader: () =>
				import(`../../Apps/${app}/${subapp != null ? subapp.app : ''}`),
			loading() {
				return <AppLoader app={apps[app]} />;
			},
		});
		LoadableSubComponent.preload(); // Hopefully load the shit? idk lol
		return LoadableSubComponent;
	};

	if (!Boolean(player)) return null;
	return (
		<Slide direction="up" in={visible} mountOnEnter unmountOnExit>
			<div className={classes.wrapper}>
				<img className={classes.phoneImg} src={phoneImg} />
				<div className={classes.phone}>
					<img
						className={classes.phoneWallpaper}
						src={
							Wallpapers[settings.wallpaper] != null
								? Wallpapers[settings.wallpaper].file
								: settings.wallpaper
						}
					/>
					<Header />
					<Alerts />
					<USB />
					<Popups />
					<QuickShare />
					<div className={classes.screen}>
						<Switch>
							<Route exact path="/" component={Home} />
							<Route exact path="/apps" component={List} />
							<Route
								exact
								path="/notifications"
								component={Notifications}
							/>
							{Object.keys(apps).length > 0 &&
							installed.length > 0
								? installed
										.filter((app, i) => app !== 'home')
										.map((app, i) => {
											let routes = [];

											let appData = apps[app];

											if (appData != null) {
												routes.push(
													<Route
														key={i}
														exact
														path={`/apps/${app}/${appData.params}`}
														component={DynamicLoad(
															app,
														)}
													/>,
												);

												if (appData.internal != null) {
													{
														appData.internal.map(
															(subapp, k) => {
																routes.push(
																	<Route
																		key={
																			installed.length +
																			k
																		}
																		exact
																		path={`/apps/${app}/${
																			subapp.app
																		}/${
																			subapp.params !=
																			null
																				? subapp.params
																				: ''
																		}`}
																		component={DynamicLoad(
																			app,
																			subapp,
																		)}
																	/>,
																);
															},
														);
													}
												}
											}

											return routes;
										})
								: null}
							<Redirect to="/" />
						</Switch>
					</div>
					<Footer />
				</div>
			</div>
		</Slide>
	);
});
