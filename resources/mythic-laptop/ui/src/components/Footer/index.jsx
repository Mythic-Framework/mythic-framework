import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link, useHistory } from 'react-router-dom';
import { Grid, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { useMyApps, useMyStates } from '../../hooks';
import mrpLogo from '../../assets/imgs/mrp.png';

export default (props) => {
	const history = useHistory();
	const dispatch = useDispatch();
	const hasState = useMyStates();
	const apps = useMyApps();
	const time = useSelector((state) => state.laptop.time);
	const focused = useSelector((state) => state.apps.focused);
	const openApps = useSelector((state) => state.apps.appStates);

	const useStyles = makeStyles((theme) => ({
		taskbar: {
			height: 50,
			background: theme.palette.secondary.dark,
			display: 'flex',
		},
		startBtn: {
			height: 50,
			width: 80,
			userSelect: 'none',
			borderBottom: `2px solid transparent`,
			borderBottomLeftRadius: 0,
			borderBottomRightRadius: 0,
			color: theme.palette.text.main,
			'&.focused': {
				borderBottom: `2px solid ${theme.palette.primary.main}`,
				background: theme.palette.secondary.light,
			},
			'&:hover': {
				transition: 'background ease-in 0.15s',
				background: theme.palette.secondary.main,
				cursor: 'pointer',
			},
		},
		startIcon: {
			width: '100%',
			height: '100%',
			userSelect: 'none',
			pointerEvents: 'none',
			padding: 5,
		},
		appIcons: {
			height: 50,
			flex: 1,
		},
		appIcon: {
			padding: 10,
			borderRadius: 8,
		},
		systemInfo: {
			height: 50,
			minWidth: 160,
			position: 'relative',
			lineHeight: '55px',
			textAlign: 'center',
			display: 'flex',
			gap: 10,
		},
		headerIcon: {
			marginLeft: 10,
			'&.clickable': {
				transition: 'color ease-in 0.15s',
				'&:hover': {
					color: theme.palette.primary.main,
				},
			},
			'&:first-of-type': {
				marginLeft: 0,
			},
			'&.wifi': {
				color: hasState('PHONE_VPN')
					? theme.palette.error.main
					: theme.palette.text.main,
			},
			'&.race': {
				color: theme.palette.info.main,
			},
		},
		sysTime: {
			display: 'inline-block',
			position: 'relative',
		},
		dateWrapper: {
			height: 'fit-content',
			width: 'fit-content',
			position: 'absolute',
			bottom: 0,
			left: 0,
			right: 0,
			margin: 'auto',
		},
		dateDetails: {
			height: 20,
			lineHeight: 'normal',
			fontSize: 14,
		},
	}));
	const classes = useStyles();

	const onClick = (app) => {
		if (focused == app) {
			dispatch({
				type: 'MINIMIZE_APP',
				payload: {
					app,
				},
			});
		} else {
			dispatch({
				type: 'UPDATE_APP_STATE',
				payload: {
					app,
					focus: true,
					state: {
						minimized: false,
					},
				},
			});
		}
	};

	const GoHome = () => {
		//history.push('/');
	};

	return (
		<div className={classes.taskbar}>
			<div className={classes.startBtn} onClick={GoHome}>
				<img src={mrpLogo} className={classes.startIcon} />
			</div>
			<div className={classes.appIcons}>
				{openApps.map((appState) => {
					let appData = apps[appState.app];
					if (Boolean(appData)) {
						return (
							<Button
								key={`appstart-${appState.app}`}
								className={`${classes.startBtn}${
									focused == appState.app ? ' focused' : ''
								}`}
								onClick={() => onClick(appState.app)}
							>
								<FontAwesomeIcon
									className={classes.appIcon}
									icon={appData.icon}
									style={{ backgroundColor: appData.color }}
								/>
							</Button>
						);
					} else return null;
				})}
			</div>
			<div className={classes.systemInfo}>
				{hasState('RACE_DONGLE') && (
					<div className={classes.sysTime}>
						<FontAwesomeIcon
							className={`${classes.headerIcon} race`}
							icon="flag-checkered"
						/>
					</div>
				)}
				<div className={classes.sysTime}>
					<FontAwesomeIcon
						className={`${classes.headerIcon} wifi`}
						icon={'wifi'}
					/>
				</div>
				<div className={classes.sysTime}>
					<FontAwesomeIcon
						className={classes.headerIcon}
						icon="gear"
					/>
				</div>
				<div className={classes.sysTime}>
					<FontAwesomeIcon
						className={classes.headerIcon}
						icon="signal"
					/>
				</div>
				<div className={classes.sysTime} style={{ width: 90 }}>
					<div className={classes.dateWrapper}>
						<div className={classes.dateDetails}>
							{(time?.hour ?? 0).toString().padStart(2, '0')}:
							{(time?.minute ?? 0).toString().padStart(2, '0')}
						</div>
						<div className={classes.dateDetails}>
							<Moment format="YYYY/MM/DD" />
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};
