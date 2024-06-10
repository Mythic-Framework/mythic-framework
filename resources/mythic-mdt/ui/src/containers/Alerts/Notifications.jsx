import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import Alert from './components/Alert';
import { ErrorBoundary } from '../../components';

export default () => {
	const dispatch = useDispatch();
	const alerts = useSelector((state) => state.alerts.alerts);
	const showing = useSelector((state) => state.alerts.showing);
	const useStyles = makeStyles((theme) => ({
		container: {
			height: showing ? '60%' : '100%',
			width: '100%',
			overflowY: 'auto',
			overflowX: 'hidden',
		},
	}));
	const classes = useStyles();

	const onReset = () => {
		dispatch({
			type: 'RESET_ALERTS',
		});
	};

	return (
		<div className={classes.container}>
			<ErrorBoundary mini onRefresh={onReset}>
				<>
					{Boolean(alerts) &&
						alerts
							.sort((a, b) => b.time - a.time)
							.filter((a) => a.onScreen || (showing && a != null))
							.map((alert, k) => {
								return <Alert key={`em-alert-${alert.id}`} alert={alert} />;
							})}
				</>
			</ErrorBoundary>
		</div>
	);
};
