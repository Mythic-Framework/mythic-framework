import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Grid, Slide } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert, useAppView, useDismisser } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	notifications: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#131317',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: theme.palette.secondary.main,
		},
	},
	footer: {
		height: '5%',
		lineHeight: '40px',
		textAlign: 'center',
		fontSize: 18,
		paddingRight: 15,
		borderTop: '1px solid #000',
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	notifIcon: {
		textAlign: 'center',
		lineHeight: '65px',
		padding: 15,
	},
	icon: {
		marginRight: 10,
	},
	notification: {
		fontSize: 22,
		paddingLeft: 15,
		borderBottom: `1px solid #000`,
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
		'&:last-child': {
			borderBottom: 'none',
		},
	},
	dismiss: {
		color: theme.palette.error.main,
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	time: {
		fontSize: 14,
		lineHeight: '25px',
		color: theme.palette.text.main,
	},
}));

export default () => {
	const openedApp = useAppView();
	const showAlert = useAlert();
	const dismisser = useDismisser();
	const classes = useStyles();
	const history = useHistory();
	const notifications = useSelector(
		(state) => state.notifications.notifications,
	);

	const [open, setOpen] = useState(false);

	const back = () => {
		history.goBack();
	};

	useEffect(() => {
		setOpen(notifications.length >= 0);
	}, []);

	useEffect(() => {
		if (notifications.length == 0) {
			setOpen(false);
		}
	}, [notifications]);

	const onClick = (notif) => {
		openedApp(notif.app);
		history.push(
			`/apps/${notif.app}${
				notif.app_data != null ? '/' + notif.app_data : ''
			}`,
		);
	};

	const dismiss = (index) => {
		dismisser(index);
	};

	const dismissAll = () => {
		dismisser();
		showAlert('Notifications Dismissed');
	};

	return (
		<Slide in={open} onExited={back}>
			<div className={classes.wrapper}>
				<div className={classes.notifications}>
					{notifications.map((notif, i) => {
						return (
							<Grid
								key={i}
								container
								className={classes.notification}
							>
								<Grid
									item
									xs={2}
									className={classes.notifIcon}
									onClick={
										notif.app != null
											? () => onClick(notif)
											: null
									}
								>
									<FontAwesomeIcon
										className={classes.icon}
										icon={notif.icon}
										style={{ color: notif.color }}
									/>
								</Grid>
								<Grid
									item
									xs={8}
									style={{ lineHeight: '60px' }}
									onClick={
										notif.app != null
											? () => onClick(notif)
											: null
									}
								>
									{notif.text}
									<div className={classes.time}>
										<Moment interval={60000} fromNow>
											{+notif.time}
										</Moment>
									</div>
								</Grid>
								<Grid
									item
									xs={2}
									className={classes.dismiss}
									style={{
										textAlign: 'center',
										lineHeight: '65px',
										padding: 15,
									}}
									onClick={() => dismiss(i)}
								>
									<FontAwesomeIcon icon="bell-slash" />
								</Grid>
							</Grid>
						);
					})}
				</div>
				<div className={classes.footer} onClick={dismissAll}>
					Dismiss All
				</div>
			</div>
		</Slide>
	);
};
