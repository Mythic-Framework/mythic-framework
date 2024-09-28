import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	callsign: {
		fontSize: 14,
		color: theme.palette.primary.main,
	},
}));

export default () => {
	const classes = useStyles();
	const cData = useSelector((state) => state.app.user);
	const job = useSelector(state => state.app.govJob);

	if (!cData || !job) {
		return null;
	}

	switch (job?.Id) {
		case 'police':
			return (
				<>
					<small>
						{job.Workplace?.Name}
					</small>
					{Boolean(cData) && (
						<>
							[
							<span className={classes.callsign}>
								{cData.Callsign}
							</span>
							]{' '}
						</>
					)}
					<span>
						{job.Grade?.Name} {cData.First} {cData.Last}
					</span>
				</>
			);
		case 'government':
			return (
				<>
					<small>
						{job.Workplace?.Name}
					</small>
					<span>
						{job.Grade?.Name} {cData.First} {cData.Last}
					</span>
				</>
			);
		case 'ems':
			return (
				<>
					<small>
						{job.Workplace?.Name}
					</small>
					{(Boolean(cData) && cData.Callsign) && (
						<>
							[
							<span className={classes.callsign}>
								{cData.Callsign}
							</span>
							]{' '}
						</>
					)}
					<span>
						{job.Grade?.Name} {cData.First} {cData.Last}
					</span>
				</>
			);
		default:
		return null;
	}
};
