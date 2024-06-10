import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Loan from './component/Loan';
import { getLoanTypeName } from './utils';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	accountList: {},
	emptyLogo: {
		width: '100%',
		fontSize: 170,
		textAlign: 'center',
		marginTop: '25%',
		color: `#30518c29`,
	},
	emptyMsg: {
		color: theme.palette.text.alt,
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
	},
    subTitle: {
        textAlign: 'center',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		marginBottom: 10,
		'& h3': {
			color: '#30518c',
			fontWeight: 400,
			fontSize: 19,
			marginBottom: 5,
        }
    }
}));

export default connect()(({ loanType }) => {
	const classes = useStyles();
	const myLoans = useSelector((state) => state.data.data.bankLoans.loans);
	const loansWithType = myLoans && myLoans.filter((acc) => acc.Type === loanType && acc.Remaining > 0);
	const loansExpiredWithType = myLoans && myLoans.filter((acc) => acc.Type === loanType && acc.Remaining <= 0);

	if ((loansWithType && loansWithType.length > 0) || (loansExpiredWithType && loansExpiredWithType.length > 0)) {
		return (
			<div className={classes.wrapper}>
				{<div className={classes.accountList}>
					{(loansWithType && loansWithType?.length > 0) && loansWithType.sort((a, b) => a.NextPayment - b.NextPayment).map(loan => {
						return <Loan key={loan._id} loan={loan} />;
					})}
					{loansExpiredWithType?.length > 0 && 
						<div className={classes.subTitle}>
							<h3>Paid Off {getLoanTypeName(loanType)} Loans</h3>
						</div>
					}
					{loansExpiredWithType?.length > 0 && loansExpiredWithType.sort((a, b) => b.LastPayment - a.LastPayment).map(loan => {
						return <Loan key={loan._id} loan={loan} />;
					})}
				</div>}
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyLogo}>
					<FontAwesomeIcon icon={['fas', 'face-disappointed']} />
				</div>
				<div className={classes.emptyMsg}>
					You Have No {getLoanTypeName(loanType)} Loans
				</div>
			</div>
		);
	}
});