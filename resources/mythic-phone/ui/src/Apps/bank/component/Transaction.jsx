import React from 'react';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	item: {
		width: '100%',
		height: '12.5%',
		marginBottom: 4,

		'& h3': {
			// Title
			color: theme.palette.secondary.contrastText,
			fontWeight: 500,
			fontSize: 16,
			marginBottom: 0,
			marginTop: 0,
		},

		'& h2': {
			// Amount
			fontWeight: 400,
			fontSize: 16,
			marginTop: -8,
			marginBottom: 0,
			textAlign: 'end',

			color: theme.palette.success.main,

			'&.error': {
				color: theme.palette.error.main,
			},
		},

		'& p': {
			// Time/Date
			color: theme.palette.secondary.contrastText,
			fontWeight: 400,
			marginBottom: 0,
			marginTop: -15,
			fontSize: 10,
		},
	},

	hr: {
		width: '100%',
		borderColor: 'rgba(200, 200, 200, 0.04)',
		borderWidth: 0.5,
		borderStyle: 'solid',
		marginTop: 8,
	},
}));

export default ({ transaction }) => {
	const classes = useStyles();

	return (
		<div>
			<div className={classes.item}>
				<h3>{transaction.Title ?? 'Unknown'}</h3>
				<h2 className={transaction.Amount > 0 ? '' : 'error'}>
					{transaction.Amount > 0 ? '+' : '-'}$
					{Math.abs(transaction.Amount).toLocaleString('en-US', {
						minimumFractionDigits: 2,
					})}
				</h2>
				<i>
					<p>
						<Moment unix date={transaction.Timestamp} calendar /> {' '}
						(<Moment unix date={transaction.Timestamp} fromNow />)
					</p>
				</i>
			</div>
			<hr className={classes.hr} />
		</div>
	);
};
