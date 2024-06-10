import React from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid, CircularProgress, Fab, Avatar, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { green, red, yellow } from '@material-ui/core/colors';

import { install, uninstall } from './action';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		background: theme.palette.secondary.dark,
		padding: '25px 12px',
		marginBottom: 5,
		width: '100%',
		'&::last-child': {
			marginBottom: 0,
		},
	},
	appIcon: {
		height: 55,
		width: 55,
		fontSize: 35,
		color: '#fff',
	},
	appText: {
		paddingLeft: 10,
	},
	appTitle: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '55px',
	},
	installbtn: {
		height: 60,
		width: 60,
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	installbtnText: {
		fontSize: '2.5rem',
	},
	completeBtn: {
		background: green[500],
	},
	installBtn: {
		background: green[500],
		'&:hover': {
			background: green[700],
		},
	},
	uninstallBtn: {
		background: red[500],
		'&:hover': {
			background: red[700],
		},
	},
	fabInstall: {
		color: green[500],
		position: 'absolute',
		top: -6,
		left: -6,
		zIndex: 1,
	},
	fabUninstall: {
		color: red[500],
		position: 'absolute',
		top: -6,
		left: -6,
		zIndex: 1,
	},
	fabPending: {
		color: yellow[500],
		position: 'absolute',
		top: -6,
		left: -6,
		zIndex: 1,
	},
	fabFailed: {
		color: red[800],
		position: 'absolute',
		top: -6,
		left: -6,
		zIndex: 1,
	},
}));

export default connect(null, { install, uninstall })((props) => {
	const classes = useStyles();

	const installing = useSelector((state) => state.store.installing).includes(
		props.app.name,
	);
	const installPending = useSelector(
		(state) => state.store.installPending,
	).includes(props.app.name);
	const installFailed = useSelector(
		(state) => state.store.installFailed,
	).includes(props.app.name);

	const uninstalling = useSelector(
		(state) => state.store.uninstalling,
	).includes(props.app.name);
	const uninstallPending = useSelector(
		(state) => state.store.uninstallPending,
	).includes(props.app.name);
	const uninstallFailed = useSelector(
		(state) => state.store.uninstallFailed,
	).includes(props.app.name);

	const installApp = (e) => {
		e.preventDefault();
		if (installing) return;
		props.install(props.app.name);
	};

	const uninstallApp = (e) => {
		e.preventDefault();
		props.uninstall(props.app.name);
	};

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<Avatar
						variant="rounded"
						className={classes.appIcon}
						style={{ backgroundColor: props.app.color }}
					>
						<FontAwesomeIcon
							style={{ margin: 'auto', width: 'auto' }}
							icon={props.app.icon}
						/>
					</Avatar>
				</Grid>
				<Grid item xs={8} className={classes.appText}>
					<span className={classes.appTitle}>{props.app.label}</span>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					{props.installed ? (
						<div>
							<Fab
								className={classes.uninstallBtn}
								onClick={uninstallApp}
								disabled={
									uninstalling ||
									uninstallPending ||
									uninstallFailed ||
									!props.app.canUninstall
								}
							>
								{false ? (
									<FontAwesomeIcon
										icon={['fas', 'check']}
										style={{ fontSize: 16 }}
									/>
								) : (
									<FontAwesomeIcon
										icon={['fas', 'x']}
										style={{ fontSize: 16 }}
									/>
								)}
							</Fab>
							{uninstalling || uninstallPending ? (
								<CircularProgress
									size={68}
									className={
										uninstalling
											? classes.fabInstall
											: uninstallPending
											? classes.fabPending
											: null
									}
								/>
							) : uninstallFailed ? (
								<CircularProgress
									size={68}
									variant="static"
									value={100}
									className={classes.fabFailed}
								/>
							) : null}
						</div>
					) : (
						<div>
							<Fab
								className={classes.installBtn}
								onClick={installApp}
								disabled={
									installing ||
									installPending ||
									installFailed
								}
							>
								{false ? (
									<FontAwesomeIcon
										icon={['fas', 'check']}
										style={{ fontSize: 16 }}
									/>
								) : (
									<FontAwesomeIcon
										icon={['fas', 'download']}
										style={{ fontSize: 16 }}
									/>
								)}
							</Fab>
							{installing || installPending ? (
								<CircularProgress
									size={68}
									className={
										installing
											? classes.fabInstall
											: installPending
											? classes.fabPending
											: null
									}
								/>
							) : installFailed ? (
								<CircularProgress
									size={68}
									variant="static"
									value={100}
									className={classes.fabFailed}
								/>
							) : null}
						</div>
					)}
				</Grid>
			</Grid>
		</Paper>
	);
});
