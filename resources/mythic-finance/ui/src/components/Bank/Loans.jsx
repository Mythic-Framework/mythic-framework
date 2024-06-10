import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import {
	Alert,
	Grid,
	List,
	ListItem,
	ListItemText,
	Button,
} from '@material-ui/core';

import { Titlebar } from '../';
import Nui from '../../util/Nui';
import Moment from 'react-moment';
import { CurrencyFormat } from '../../util/Parser';

import { getNextPaymentAmount } from './utils';
import { Link } from 'react-router-dom';

const useStyles = makeStyles((theme) => ({
	loansPanel: {
		padding: 16,
	},
	loanItem: {},
	block: {
		height: '100%',
		width: '100%',
		padding: 25,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
		color: theme.palette.text.main,
		fontWeight: 'normal',
		textAlign: 'left',
		fontSize: 16,
	},
	money: {
		color: theme.palette.success.main,
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const loans = useSelector((state) => state.data.data.loans);

	return (
		<>
			{loans.length > 0 ? (
				<div className={classes.loansPanel}>
					<Grid className={classes.container} container spacing={2}>
						{loans.map((loan) => {
							return (
								<Grid key={loan._id} className={classes.loanItem} item xs={12} sm={6} md={4}>
									<Button className={classes.block} component={Link} to={`/loans/${loan._id}`}>
										<List style={{ width: '100%' }}>
											<ListItem>
												<Grid container>
													<Grid item xs={4}>
														<ListItemText
															primary="Loan ID"
															secondary={loan._id}
														/>
													</Grid>
													<Grid item xs={4}>
														<ListItemText
															primary="Payment Amt"
															secondary={<span className={classes.cash}>{CurrencyFormat.format(getNextPaymentAmount(loan))}</span>}
														/>
													</Grid>
													<Grid item xs={4}>
														<ListItemText
															primary="Due Date"
															secondary={<Moment date={loan.NextPayment * 1000} format="ll" />}
														/>
													</Grid>
												</Grid>
											</ListItem>
										</List>
									</Button>
								</Grid>
							);
						})}
					</Grid>
				</div>
			) : (
				<div className={classes.loansPanel}>
					<Alert
						style={{ width: '100%' }}
						variant="filled"
						severity="info"
					>
						You Have No Loans
					</Alert>
				</div>
			)}
		</>
	);
};
