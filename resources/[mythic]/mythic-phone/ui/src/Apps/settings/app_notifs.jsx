import React from 'react';
import { useSelector } from 'react-redux';
import { Grid, Alert } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { useMyApps } from '../../hooks';
import AppNotif from './components/AppNotif';
import Version from './components/Version';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	listWrapper: {
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		flexDirection: 'column',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	listWrapperShort: {
		height: '86%',
		overflowY: 'auto',
		overflowX: 'hidden',
		flexDirection: 'column',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	error: {
		fontWeight: 'bold',
		height: '9%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const apps = useMyApps();
	const installed = useSelector((state) => state.data.data.player?.Apps?.installed);
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);

	return (
		<div className={classes.wrapper}>
			{!settings.notifications ? (
				<Alert
					variant="filled"
					severity="error"
					elevation={6}
					className={classes.error}
				>
					Notifications Are Currently Disabled System-wide, enable
					them to control on a per-app level.
				</Alert>
			) : null}
			<Grid
				container
				spacing={0}
				wrap="nowrap"
				className={
					settings.notifications
						? classes.listWrapper
						: classes.listWrapperShort
				}
			>
				{installed.map((a, index) => {
					let app = apps[a];
					if (app == null) return null;
					return <AppNotif key={index} app={app} />;
				})}
			</Grid>
			<Version />
		</div>
	);
};
