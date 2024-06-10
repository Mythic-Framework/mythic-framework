import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Account from './component/Account';

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
}));

export default connect()((props) => {
	const classes = useStyles();
	const myAccounts = useSelector((state) => state.data.data.bankAccounts)?.accounts;

	const personalAccount = myAccounts && myAccounts.filter((acc) => acc.Type == 'personal')[0];
	const personalSavingsAccounts = myAccounts && myAccounts.filter((acc) => acc.Type == 'personal_savings');
	const organizationAccounts = myAccounts && myAccounts.filter((acc) => acc.Type == 'organization');

	if (myAccounts && personalSavingsAccounts && organizationAccounts) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.accountList}>
					{personalAccount && <Account key={personalAccount.Account} acc={personalAccount} />}
					{personalSavingsAccounts?.length > 0 && personalSavingsAccounts.map((acc) => {
						return <Account key={acc.Account} acc={acc} />;
					})}
					{organizationAccounts.length > 0 && organizationAccounts.map((acc) => {
						return <Account key={acc.Account} acc={acc} />;
					})}
				</div>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyLogo}>
					<FontAwesomeIcon icon={['fas', 'face-disappointed']} />
				</div>
				<div className={classes.emptyMsg}>
					No Accounts?
				</div>
			</div>
		);
	}
});