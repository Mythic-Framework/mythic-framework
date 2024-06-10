import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';

import Alert from './components/Alert';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default (props) => {
	const classes = useStyles();
	const alerts = useSelector((state) => state.data.data.leoAlerts);

	return (
		<div className={classes.wrapper}>
			{alerts
				.sort((a, b) => a.time - b.time)
				.map((alert, key) => {
					return <Alert key={key} alert={alert} />;
				})}
		</div>
	);
};
