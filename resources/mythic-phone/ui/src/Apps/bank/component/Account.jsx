import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { Paper } from '@material-ui/core';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { getAccountName, getAccountType } from '../utils';

const useStyles = makeStyles((theme) => ({
	link: {
		textDecoration: 'none',
	},
	account: {
		width: '100%',
		padding: '10px 15px',
        marginBottom: '5%',
		position: 'relative',
		background: theme.palette.secondary.dark,
		willChange: 'background',
		transition: 'background 400ms',
		borderRadius: 5,
		boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',

		'&:hover': {
			cursor: 'pointer',
			background: 'rgba(255, 255, 255, 0.01)',
		},
	},
	accountDetails: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'& h3': {
			color: theme.palette.primary.main,
			fontWeight: 400,
			fontSize: 19,
			marginBottom: 0,
			'& small': {
				fontSize: 12,
				color: theme.palette.text.alt,
				'&::before': {
					content: '" - "',
				},
			},
		},
	},
	accountBalance: {
		marginLeft: '5%',
		'& h2': {
			fontWeight: 400,
			color: theme.palette.text.alt,
			marginTop: 24,
		},
		'& span': {
			fontWeight: 400,
			color: theme.palette.success.main,
			marginTop: 24,
		}
	},
	backIcon: {
		color: `${theme.palette.primary.main}12`,
		position: 'absolute',
		top: '6%',
		right: '4%',
		fontSize: 80,
	},
}));

export default ({ acc }) => {
	const classes = useStyles();
	const accountName = getAccountName(acc);
	const accountType = getAccountType(acc);

	return (
		<Link to={`/apps/bank/view/${acc.Account}`} className={classes.link}>
			<Paper className={classes.account}>
				<div className={classes.accountDetails}>
					<h3>
						{accountName}
					</h3>
					<p>
						Account Number: {acc.Account}<br />
						Account Type: {accountType}
					</p>
				</div>
				<div className={classes.accountBalance}>
					<h2>Balance:{' '}
						<span>
							{acc.Permissions?.BALANCE ? `$${acc.Balance.toLocaleString('en-US')}` : '???'}
						</span>
					</h2>
				</div>
				{acc.Type === 'personal_savings' ? (
					<FontAwesomeIcon
						className={classes.backIcon}
						icon={['fas', 'piggy-bank']}
					/>
				) : (
					<FontAwesomeIcon
						className={classes.backIcon}
						icon={['fas', 'bank']}
					/>
				)}
			</Paper>
		</Link>
	);
};
