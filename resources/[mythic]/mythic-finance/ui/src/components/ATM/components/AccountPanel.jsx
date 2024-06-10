import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Grid, Button, Alert, ListItem, TextField } from '@material-ui/core';
import NumberFormat from 'react-number-format';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../';
import { CurrencyFormat } from '../../../util/Parser';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
	container: {
		padding: 16,
		maxHeight: '100%',
	},
	block: {
		height: '100%',
		padding: 25,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
		color: theme.palette.text.main,
		fontWeight: 'normal',
		fontSize: 16,
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
		maxHeight: 'calc(45vh - 10px)',
		height: 'fit-content',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
	money: {
		color: theme.palette.success.main,
	},
	quickBtn: {
		display: 'block',
		padding: 10,
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
	field: {
		marginBottom: 15,
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);
	const sel = useSelector((state) => state.bank.selected);

	const [loading, setLoading] = useState(null);

	const [account, setAccount] = useState(null);

	const [depositing, setDepositing] = useState(false);
	const [withdrawing, setWithdrawing] = useState(false);

	useEffect(() => {
		let f = accounts.filter((a) => a._id == sel);
		if (f.length > 0) {
			setAccount(f[0]);
		} else setAccount(null);
	}, [accounts, sel]);

	const onDeposit = async (e) => {
		e.preventDefault();

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Deposit', {
					account: account.Account,
					amount: e.target.amount.value,
					comments: e.target.notes.value,
				})
			).json();

			if (res?.state) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account._id,
						data: {
							...account,
							Balance: +account.Balance + +e.target.amount.value,
						},
					},
				});
				toast.success('Funds Deposited');
			} else {
				toast.error('Unable To Deposit Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Deposit Funds');
		}

		setDepositing(false);
		setLoading(false);
	};

	const onWithdraw = async (e) => {
		e.preventDefault();

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Withdraw', {
					account: account.Account,
					amount: e.target.amount.value,
					comments: e.target.notes.value,
				})
			).json();

			if (res?.state) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account._id,
						data: {
							...account,
							Balance: +account.Balance - +e.target.amount.value,
						},
					},
				});
				toast.success('Funds Withdrawn');
			} else {
				toast.error('Unable To Withdraw Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Withdraw Funds');
		}

		setWithdrawing(false);
		setLoading(false);
	};

	return (
		<>
			{Boolean(account) ? (
				<Grid className={classes.container} container spacing={2}>
					<Grid item xs={12}>
						<div className={classes.block}>
							<Grid container>
								<Grid item xs={12}>
									<div className={classes.blockHeader}>
										Account Number
									</div>
									<div className={classes.blockContent}>
										{account.Account}
									</div>
									{/* <div className={classes.blockHeader}>
										Account Owner (State ID)
									</div>
									<div className={classes.blockContent}>
										{account.Owner}
									</div> */}
									<div className={classes.blockHeader}>
										Available Balance
									</div>
									<div className={classes.blockContent}>
										{account?.Permissions?.BALANCE ? (
											<span className={classes.money}>
												{CurrencyFormat.format(
													account.Balance,
												)}
											</span>
										) : (
											<span>???</span>
										)}
									</div>
								</Grid>
							</Grid>
						</div>
					</Grid>
					<Grid item xs={12}>
						<div className={classes.block}>
							<div className={classes.blockHeader}>
								Account Quick Actions
							</div>
							<div className={classes.blockContent}>
								<Button
									fullWidth
									color="success"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.DEPOSIT &&
										user.Cash == 0
									}
									onClick={
										account?.Permissions?.DEPOSIT
											? () => setDepositing(true)
											: null
									}
								>
									Deposit Cash
								</Button>
								<Button
									fullWidth
									color="warning"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.WITHDRAW ||
										account.Balance == 0
									}
									onClick={
										account?.Permissions?.WITHDRAW
											? () => setWithdrawing(true)
											: null
									}
								>
									Withdraw Cash
								</Button>
							</div>
						</div>
					</Grid>
				</Grid>
			) : (
				<ListItem>
					<Alert
						style={{ width: '100%' }}
						variant="filled"
						severity="error"
					>
						No Joint Owners
					</Alert>
				</ListItem>
			)}

			{Boolean(account) && (
				<>
					{account?.Permissions?.DEPOSIT && (
						<Modal
							open={depositing}
							title={`Deposit Funds Into ${account.Name}`}
							closeLang="Cancel"
							maxWidth="xs"
							onClose={() => setDepositing(false)}
							onSubmit={onDeposit}
						>
							{loading && <Loader static text="Loading" />}
							<NumberFormat
								fullWidth
								required
								label="Amount"
								name="amount"
								className={classes.field}
								disabled={loading}
								type="tel"
								isNumericString
								customInput={TextField}
							/>
							<TextField
								fullWidth
								multiline
								minRows={3}
								className={classes.input}
								disabled={loading}
								label="Transaction Comment"
								name="notes"
								variant="outlined"
							/>
						</Modal>
					)}
					{account?.Permissions?.WITHDRAW && (
						<Modal
							open={withdrawing}
							title={`Withdraw Funds From ${account.Name}`}
							closeLang="Cancel"
							maxWidth="xs"
							onClose={() => setWithdrawing(false)}
							onSubmit={onWithdraw}
						>
							{loading && <Loader static text="Loading" />}
							<NumberFormat
								fullWidth
								required
								label="Amount"
								name="amount"
								className={classes.field}
								disabled={loading}
								type="tel"
								isNumericString
								customInput={TextField}
							/>
							<TextField
								fullWidth
								multiline
								minRows={3}
								className={classes.input}
								disabled={loading}
								label="Transaction Comment"
								name="notes"
								variant="outlined"
							/>
						</Modal>
					)}
				</>
			)}
		</>
	);
};
