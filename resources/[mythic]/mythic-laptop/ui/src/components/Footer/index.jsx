import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { useMyApps, useMyStates } from '../../hooks';
import mfwLogo from '../../assets/imgs/mythic_logo_laptop.png';

export default (props) => {
	const dispatch = useDispatch();
	const hasState = useMyStates();
	const apps = useMyApps();
	const time = useSelector((state) => state.laptop.time);
	const focused = useSelector((state) => state.apps.focused);
	const openApps = useSelector((state) => state.apps.appStates);
	const myGroup = useSelector((state) => state.data.data.myGroup);

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
			'&.signal': {
				color: hasState('PHONE_VPN')
					? theme.palette.error.main
					: theme.palette.text.main,
			},
			'&.race': {
				color: theme.palette.info.main,
			},
			'&.team': {
				color: '#00FF8A',
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
		history.push('/');
	};

	return (
		<div className={classes.taskbar}>
			<div className={classes.startBtn} onClick={GoHome}>
				<img src={mfwLogo} className={classes.startIcon} />
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
				{myGroup && (
					<div className={classes.sysTime}>
						<FontAwesomeIcon
							className={`${classes.headerIcon} team`}
							icon="people-group"
						/>
					</div>
				)}
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
						className={`${classes.headerIcon} signal`}
						icon="signal"
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
						icon="wifi"
					/>
				</div>
				<div className={classes.sysTime} style={{ width: '90px' }}>
					<div className={classes.dateWrapper}>
						<div className={classes.dateDetails}>
						{String(time?.hour ?? 0).padStart(2, '0')}:
						{String(time?.minute ?? 0).padStart(2, '0')}
						</div>
						<div className={classes.dateDetails}>
						<Moment format="MM/DD/YYYY" />
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};
