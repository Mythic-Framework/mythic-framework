import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Grid } from '@material-ui/core';
import { toast } from 'react-toastify';
import { Redirect, Route, Switch } from 'react-router';
import useKeypress from 'react-use-keypress';

import { Titlebar, Loader } from '../';
import Nui from '../../util/Nui';
import Accounts from './Accounts';
import Loans from './Loans';
import LoanView from './LoanView';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		height: 'calc(100% - 126px)',
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: '100%',
		border: `1px solid ${theme.palette.border.divider}`,
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
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const [loading, setLoading] = useState(false);

	useEffect(() => {
		const f = async () => {
			setLoading(true);
			try {
				let res = await (await Nui.send('Bank:Fetch')).json();

				if (Boolean(res?.accounts)) {
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'accounts',
							data: res.accounts,
						},
					});
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: 'transactions',
							data: res.transactions,
						},
					});
					// dispatch({
					// 	type: 'SET_DATA',
					// 	payload: {
					// 		type: 'loans',
					// 		data: res.loans,
					// 	},
					// });
					// dispatch({
					// 	type: 'SET_DATA',
					// 	payload: {
					// 		type: 'credit',
					// 		data: res.credit,
					// 	},
					// });
				} else toast.error('Error Loading Accounts');
			} catch (err) {
				console.log(err);
				toast.error('Error Loading Accounts');
			}

			setLoading(false);
		};
		if (process.env.NODE_ENV == 'production') f();
	}, []);

	useKeypress(['Escape'], () => {
		Nui.send('Close');
	});

	return (
		<div className={classes.container}>
			<Grid container className={classes.maxHeight}>
				<Grid item xs={12}>
					<Titlebar />
				</Grid>
				<Grid item xs={12} className={classes.wrapper}>
					<div className={classes.content}>
						{loading && <Loader static text="Loading Accounts" />}
						<Switch>
							<Route path="/" exact component={Accounts} />
							{/* <Route path="/loans" exact component={Loans} />
							<Route path="/loans/:id" exact component={LoanView} /> */}
							<Redirect to="/" />
						</Switch>
					</div>
				</Grid>
			</Grid>
		</div>
	);
};
