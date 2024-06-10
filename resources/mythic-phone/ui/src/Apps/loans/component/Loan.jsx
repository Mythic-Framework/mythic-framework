import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Paper } from '@material-ui/core';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { getLoanTypeName, getActualRemainingAmount, getNextPaymentAmount } from '../utils';

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
    defaultedAccount: {
        border: `3px solid ${theme.palette.error.main}`,
    },
	missedLastPayment: {
		border: `3px solid ${theme.palette.warning.dark}`,
	},
	accountDetails: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'& h3': {
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
		color: `#30518c29`,
		position: 'absolute',
		top: '6%',
		right: '4%',
		fontSize: 80,
	},
	cancelButton: {
		position: 'absolute',
		marginLeft: '5%',
		bottom: '5%',
		color: theme.palette.error.main,
	},
}));

export default ({ loan }) => {
	const classes = useStyles();
	const loanRemainingAmount = getActualRemainingAmount(loan);
	const loanRemainingPayments = loan.TotalPayments - loan.PaidPayments

	const getNextDuePayment = () => {
		if (loan.NextPayment) {
			return <Moment unix date={loan.NextPayment} calendar />;
		} else {
			return 'No Due Payments';
		}
	}

	const getWarning = () => {
		if (loan.Defaulted) {
			return 'This loan has been defaulted because you missed too many payments.';
		} else if (loan.MissedPayments > 0) {
			if (loan.MissedPayments > 1) {
				return `You missed the last ${loan.MissedPayments} payments for this loan.`;
			} else {
				return 'You missed the last payment for this loan.';
			}
		} else {
			return false;
		}
	}

	return (
		<Link to={`/apps/loans/view/${loan._id}`} className={classes.link}>
			<Paper className={`${classes.account} ${(loan.Defaulted || (loan.MissablePayments > 1 && loan.MissedPayments >= (loan.MissablePayments - 1))) ? classes.defaultedAccount : (loan.MissedPayments > 0 && classes.missedLastPayment)}`}>
				<div className={classes.accountDetails}>
					<h3>{getLoanTypeName(loan.Type)} Loan</h3>
					<p>
                        Interest Rate: {loan.InterestRate}%<br />
						Remaining Payments: {loanRemainingPayments}<br />
						Next Payment Due: {getNextDuePayment()}<br />
						{(loan.Remaining > 0 && loan.NextPayment) && (
							<span>
								Next Payment Amount:{' '}
								<span className={classes.currency}>
									${getNextPaymentAmount(loan).toLocaleString('en-US')}
								</span>
							</span>
						)}
                    </p>
					{getWarning() && <p>
						<b>{getWarning()}</b>
					</p>}
				</div>
				<div className={classes.accountBalance}>
					<h2>Remaining:{' '}
						<span>
						${loanRemainingAmount.toLocaleString('en-US')}
						</span>
					</h2>
				</div>
				<FontAwesomeIcon
                    className={classes.backIcon}
                    icon={['fas', 'hand-holding-dollar']}
                />
			</Paper>
		</Link>
	);
};
