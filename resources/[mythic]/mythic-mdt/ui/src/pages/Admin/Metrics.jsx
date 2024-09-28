import React, { useEffect, useState, useMemo } from 'react';
import { Alert, TextField } from '@mui/material';
import { makeStyles } from '@mui/styles';
import 'chart.js/auto';
import { Pie } from 'react-chartjs-2';
import { AdapterMoment } from '@mui/x-date-pickers/AdapterMoment';
import { LocalizationProvider, DatePicker } from '@mui/x-date-pickers';
import { throttle } from 'lodash';
import moment from 'moment';

import Nui from '../../util/Nui';
import { Loader } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		height: '100%',
	},
	graph: {
		width: '100%',
		height: '100%',
		maxHeight: 600,
	},
	alert: {
		width: 'fit-content',
		margin: 'auto',
	},
}));

export default () => {
	const classes = useStyles();

	const [loading, setLoading] = useState(false);
	const [metrics, setMetrics] = useState(null);
	const [date, setDate] = useState(moment(Date.now()));

	useEffect(() => {
		fetch(date);
	}, [date]);

	const fetch = useMemo(
		() =>
			throttle(async (value) => {
				setLoading(true);
				try {
					let res = await (await Nui.send('GetMetrics', value.format('l'))).json();
					setMetrics(res);
				} catch (err) {
					setMetrics(null);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	const onChange = (e) => {
		setDate(e);
	};

	return (
		<div className={classes.wrapper}>
			<div style={{ position: 'relative', height: '100%' }}>
				<LocalizationProvider dateAdapter={AdapterMoment}>
					<DatePicker
						label="Metrics For"
						value={date}
						onChange={onChange}
						renderInput={(params) => <TextField {...params} />}
					/>
				</LocalizationProvider>
				{loading ? (
					<Loader static text="Loading" />
				) : !metrics ? (
					<Alert className={classes.alert} variant="filled" severity="info">
						No Metrics For {date.format('L')}
					</Alert>
				) : (
					<Pie className={classes.graph} data={metrics} />
				)}
			</div>
		</div>
	);
};
