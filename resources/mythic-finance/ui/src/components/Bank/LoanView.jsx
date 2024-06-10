import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import {
	Alert,
	Grid,
	IconButton,
	List,
	ListItem,
	ListItemText,
} from '@material-ui/core';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useHistory } from 'react-router';
import {
	getLoanIdentifierType,
	getLoanTypeName,
	getNextPaymentAmount,
} from './utils';
import { CurrencyFormat } from '../../util/Parser';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	container: {
		padding: 16,
	},
	backBtn: {
		height: 40,
		width: 40,
	},
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
	negative: {
		color: theme.palette.error.main,
	},
	positive: {
		color: theme.palette.success.main,
	},
	blockHeader: {
		fontSize: 14,
		marginBottom: 10,
		color: theme.palette.text.alt,
		'& small': {
			color: theme.palette.primary.main,
			fontSize: 10,
		},
	},
	blockContent: {
		fontSize: 18,
		marginLeft: 20,
		height: 'fit-content',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const loan = useSelector((state) => state.data.data.loans).filter(
		(l) => l._id == props.match.params.id,
	)[0];

	const paymentDue = getNextPaymentAmount(loan);

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
	};

	return (
		<>
			<Grid container spacing={2} className={classes.container}>
				<Grid item xs={12}>
					<IconButton
						className={classes.backBtn}
						onClick={() => history.goBack()}
					>
						<FontAwesomeIcon icon={['fas', 'chevron-left']} />
					</IconButton>
				</Grid>
				<Grid item xs={12}>
					{getWarning() && (
						<Alert variant="filled" severity="error">
							{getWarning()}
						</Alert>
					)}
				</Grid>
				<Grid item xs={12}>
					<div className={classes.block}>
						<div className={classes.blockHeader}>Loan Details</div>
						<div className={classes.blockContent}>
							<List>
								<ListItem>
									<Grid container>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan ID"
												secondary={loan._id}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan Created"
												secondary={
													<Moment
														date={
															loan.Creation * 1000
														}
														format="LLLL"
													/>
												}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan Type"
												secondary={getLoanTypeName(
													loan.Type,
												)}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary={getLoanIdentifierType(
													loan.Type,
												)}
												secondary={loan.AssetIdentifier}
											/>
										</Grid>
									</Grid>
								</ListItem>
								<ListItem>
									<Grid container>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Total Loan Amount"
												secondary={
													<span
														className={
															classes.money
														}
													>
														{CurrencyFormat.format(
															loan.Total,
														)}
													</span>
												}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan Interest Rate"
												secondary={loan.InterestRate}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan Term Length"
												secondary={loan.TotalPayments}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Loan In Default?"
												secondary={
													loan.Defaulted ? (
														<span
															className={
																classes.negative
															}
														>
															Yes
														</span>
													) : (
														<span
															className={
																classes.positive
															}
														>
															No
														</span>
													)
												}
											/>
										</Grid>
									</Grid>
								</ListItem>
								<ListItem>
									<Grid container>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Remaining Loan Balance"
												secondary={
													<span
														className={
															classes.money
														}
													>
														{CurrencyFormat.format(
															loan.Remaining,
														)}
													</span>
												}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Paid Balance"
												secondary={
													<span
														className={
															classes.money
														}
													>
														{CurrencyFormat.format(
															loan.Paid,
														)}
													</span>
												}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Paid Downpayment"
												secondary={
													<span
														className={
															classes.money
														}
													>
														{CurrencyFormat.format(
															loan.DownPayment,
														)}
													</span>
												}
											/>
										</Grid>
										<Grid item xs={6} sm={3}>
											<ListItemText
												primary="Remaining Term"
												secondary={
													loan.TotalPayments -
													loan.PaidPayments
												}
											/>
										</Grid>
									</Grid>
								</ListItem>
							</List>
						</div>
					</div>
				</Grid>
				<Grid item xs={12}>
					<div className={classes.block}>
						<div className={classes.blockHeader}>
							Payment Details
						</div>
						{paymentDue > 0 ? (
							<div className={classes.blockContent}>
								<List>
									<ListItem>
										<Grid container>
											<Grid item xs={6} sm={3}>
												<ListItemText
													primary="Payment Due Amount"
													secondary={
														<span
															className={
																classes.money
															}
														>
															{CurrencyFormat.format(
																paymentDue,
															)}
														</span>
													}
												/>
											</Grid>
											<Grid item xs={6} sm={3}>
												<ListItemText
													primary="Payment Due Date"
													secondary={
														<Moment
															date={
																loan.NextPayment *
																1000
															}
															format="LLLL"
														/>
													}
												/>
											</Grid>
										</Grid>
									</ListItem>
								</List>
							</div>
						) : (
							<div className={classes.blockContent}>
								<Alert variant="filled" severity="success">
									Loan Paid Off
								</Alert>
							</div>
						)}
					</div>
				</Grid>
			</Grid>
		</>
	);
};
