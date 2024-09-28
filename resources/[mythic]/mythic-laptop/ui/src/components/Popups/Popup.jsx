import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Avatar, IconButton, Paper, Collapse } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAppView, useDismisser, useMyApps } from '../../hooks';
import Nui from '../../util/Nui';
import DOMPurify from 'dompurify';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: `${theme.palette.secondary.dark}f5`,
		borderRadius: 4,
		marginBottom: 10,
	},
	appInfo: {
		paddingBottom: 5,
		marginBottom: 5,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'filter ease-in 0.15s',
		'&.clickable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	appIcon: {
		height: 30,
		width: 30,
		color: theme.palette.text.main,
		display: 'inline-block',
		position: 'relative',

		'& svg': {
			height: '75%',
			width: '75%',
		}
	},
	appIconfa: {
		height: 'fit-content',
		width: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	appName: {
		height: 'fit-content',
		color: theme.palette.text.alt,
		textTransform: 'uppercase',
		position: 'absolute',
		marginLeft: 5,
		top: 0,
		bottom: 0,
		margin: 'auto',
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	time: {
		height: 'fit-content',
		color: theme.palette.text.main,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	notifTitle: {
		display: 'block',
		fontSize: 20,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		position: 'relative',
	},
	notifDescrip: {
		display: 'block',
		fontSize: 14,
		color: theme.palette.text.alt,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	actionView: {
		color: theme.palette.info.light,
		fontSize: 18,
		height: 28,
		width: 28,
	},
	actionAccept: {
		color: theme.palette.success.main,
		fontSize: 18,
		height: 28,
		width: 28,
	},
	actionCancel: {
		color: theme.palette.error.light,
		fontSize: 18,
		height: 28,
		width: 28,
	},
	actionBtns: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: -2,
		right: '2%',
		margin: 'auto',
	},
}));

export default ({ id, notification }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const dismisser = useDismisser();
	const laptopOpen = useSelector((state) => state.laptop.visible);
	const apps = useMyApps();
	const viewApp = useAppView();
	let app =
		typeof notification.app === 'object'
			? notification.app
			: apps[notification.app];

	const [showIcons, setShowIcons] = useState(false);
	const [show, setShow] = useState(false);

	useEffect(() => {
		setShow(true);

		if (notification.duration != -1) {
			let i = setInterval(() => {
				if (Date.now() > notification.time + notification.duration) {
					setShow(false);
					clearInterval(i);
				}
			}, 1000);

			return () => {
				clearInterval(i);
			};
		}
	}, []);

	useEffect(() => {
		if (notification.collapsed) return;
		if (notification.duration == -1) {
			let t = setTimeout(() => {
				dispatch({
					type: 'NOTIF_COLLAPSE',
					payload: { id: notification._id },
				});
			}, 5000);

			return () => {
				clearTimeout(t);
			};
		}
	}, [notification]);

	const onClick = () => {
		if (notification.duration != -1) {
			setShow(false);
		} else {
			dispatch({
				type: 'NOTIF_COLLAPSE',
				payload: { id: notification._id },
			});
		}
	};

	const onView = () => {
		if (notification.duration != -1) setShow(false);

		if (notification.action?.view === 'USE_SHARE') {
			dispatch({
				type: 'USE_SHARE',
				payload: {},
			});
		} else {
			viewApp(notification.app);
		}
	};

	const onAccept = () => {
		setShow(false);
		Nui.send('AcceptPopup', {
			event: notification.action?.accept,
			data: notification.data,
		});
	};

	const onCancel = () => {
		setShow(false);
		Nui.send('CancelPopup', {
			event: notification.action?.cancel,
			data: notification.data,
		});
	};

	const onAnimEnd = () => {
		dismisser(notification._id);
	};

	if (!Boolean(app)) return null;
	return (
		<Collapse
			collapsedSize={0}
			in={show}
			onEntered={() => setShowIcons(true)}
			onExiting={() => setShowIcons(false)}
			onExited={onAnimEnd}
		>
			<Paper elevation={20} className={classes.wrapper}>
				<Collapse in={!notification.collapsed} collapsedSize={0}>
					<Grid
						container
						className={`${classes.appInfo} clickable`}
						onClick={onClick}
					>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<Avatar
								variant="rounded"
								className={classes.appIcon}
								style={{
									background: `${app.color}`,
								}}
							>
								<FontAwesomeIcon
									className={classes.appIconfa}
									icon={app.icon}
								/>
							</Avatar>
							<span className={classes.appName}>{app.label}</span>
						</Grid>
						<Grid item xs={6} style={{ position: 'relative' }}>
							<Moment
								className={classes.time}
								date={notification.time}
								fromNow
							/>
						</Grid>
					</Grid>
				</Collapse>
				<Grid container>
					<Grid item xs={12}>
						<span className={classes.notifTitle}>
							<Collapse
								in={
									!notification.collapsed ||
									!laptopOpen
								}
								collapsedSize={0}
							>
								<span>{notification.title}</span>
							</Collapse>

							{laptopOpen && showIcons && (
								<div className={classes.actionBtns}>
									{Boolean(notification.action?.view) && (
										<IconButton
											onClick={onView}
											className={classes.actionView}
										>
											<FontAwesomeIcon
												icon={['fas', 'eye']}
											/>
										</IconButton>
									)}
									{Boolean(notification.action?.accept) && (
										<IconButton
											onClick={onAccept}
											className={classes.actionAccept}
										>
											<FontAwesomeIcon
												icon={['fas', 'circle-check']}
											/>
										</IconButton>
									)}
									{Boolean(notification.action?.cancel) && (
										<IconButton
											onClick={onCancel}
											className={classes.actionCancel}
										>
											<FontAwesomeIcon
												icon={['fas', 'circle-xmark']}
											/>
										</IconButton>
									)}
								</div>
							)}
						</span>
						<span className={classes.notifDescrip}>
							{DOMPurify.sanitize(notification.description, {ALLOWED_TAGS: []})}
						</span>
					</Grid>
				</Grid>
			</Paper>
		</Collapse>
	);
};
