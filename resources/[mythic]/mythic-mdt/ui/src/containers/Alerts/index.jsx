import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { usePermissions } from '../../hooks';
import Notifications from './Notifications';
import Roster from './Roster';
import { ErrorBoundary } from '../../components';

export default () => {
	const showing = useSelector((state) => state.alerts.showing);
	const useStyles = makeStyles((theme) => ({
		container: {
			height: '100%',
			width: '100%',
			maxWidth: 650,
			position: 'fixed',
			top: 0,
			bottom: 0,
			right: 0,
			paddingTop: 20,
			margin: 'auto',
			zIndex: showing ? 1 : -1,
		},
	}));

	const classes = useStyles();
	const hasPerm = usePermissions();

	if (!hasPerm('police_alerts') && !hasPerm('ems_alerts') && !hasPerm('tow_alerts')) return null;

	return (
		<div className={classes.container}>
			<Notifications />
			<ErrorBoundary>{showing && <Roster />}</ErrorBoundary>
		</div>
	);
};
