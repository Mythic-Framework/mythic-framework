import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Grid } from '@material-ui/core';
import { SwitchTransition, CSSTransition } from 'react-transition-group';

import { Titlebar, AccountButton } from '../';
import CreateAccountBtn from '../AccountButton/Create';
import Nui from '../../util/Nui';
import AccountPanel from './components/AccountPanel';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		height: 'calc(100% - 125px)',
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: '100%',
	},
	accountPanel: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	accountList: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
		backgroundColor: theme.palette.secondary.main,
		width: '100%',
		borderRight: `1px solid ${theme.palette.border.divider}`,
	},
	accountDetails: {
		maxHeight: '100%',
	},
	accHeader: {
		width: '95%',
		fontSize: 16,
		marginTop: '5%',
		fontWeight: 'normal',
		color: theme.palette.text.alt,
		borderBottom: `1px solid ${theme.palette.primary.main}`,
		paddingLeft: 10,
		display: 'block',
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);
	const selected = useSelector((state) => state.bank.selected);

	useEffect(() => {
		if (accounts.length > 0) {
			setPersonal(accounts.filter((a) => a.Type == 'personal'));
			setSavings(accounts.filter((a) => a.Type == 'personal_savings'));
			setOrganization(accounts.filter((a) => a.Type == 'organization'));
		} else {
			setPersonal(Array());
			setSavings(Array());
			setOrganization(Array());
		}
	}, [accounts]);

	const [personal, setPersonal] = useState(Array());
	const [savings, setSavings] = useState(Array());
	const [organization, setOrganization] = useState(Array());

	const onClick = (acc) => {
		dispatch({
			type: 'SELECT_ACCOUNT',
			payload: {
				account: acc,
			},
		});
	};

	return (
		<Grid container className={classes.accountPanel}>
			<Grid
				item
				xs={6}
				sm={4}
				md={3}
				lg={2}
				className={classes.accountList}
			>
				<div className={classes.accHeader}>Personal Accounts</div>
				{personal.map((acc) => {
					return (
						<AccountButton
							key={acc._id}
							account={acc}
							onSelected={onClick}
						/>
					);
				})}

				<div className={classes.accHeader}>Saving Accounts</div>

				{savings.length > 0 ? (
					<>
						{savings.filter((a) => a.Owner == user.SID).length ==
							0 && <CreateAccountBtn />}
						{savings.map((acc) => {
							return (
								<AccountButton
									key={acc._id}
									account={acc}
									onSelected={onClick}
								/>
							);
						})}
					</>
				) : (
					<CreateAccountBtn />
				)}

				{organization.length > 0 && (
					<>
						<div className={classes.accHeader}>
							Organization Accounts
						</div>
						{organization.map((acc) => {
							return (
								<AccountButton
									key={acc._id}
									account={acc}
									onSelected={onClick}
								/>
							);
						})}
					</>
				)}
			</Grid>
			<Grid
				item
				xs={6}
				sm={8}
				md={9}
				lg={10}
				className={classes.accountDetails}
			>
				<AccountPanel />
			</Grid>
		</Grid>
	);
};
