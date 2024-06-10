import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import {
	Grid,
	Button,
	List,
	ListItem,
	TextField,
	ListItemText,
	Alert,
	MenuItem,
	ListItemSecondaryAction,
	IconButton,
} from '@material-ui/core';
import NumberFormat from 'react-number-format';
import { toast } from 'react-toastify';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../';
import Transaction from './Transaction';
import { CurrencyFormat } from '../../../util/Parser';

import { getAccountType } from '../utils';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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

const Types = [
	{
		value: false,
		label: 'Account Number',
	},
	{
		value: true,
		label: 'State ID',
	},
];
export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);
	const transactions = useSelector((state) => state.data.data.transactions);
	const sel = useSelector((state) => state.bank.selected);

	const [loading, setLoading] = useState(null);

	const [account, setAccount] = useState(
		accounts.filter((a) => a._id == sel).length > 0
			? accounts.filter((a) => a._id == sel)[0]
			: null,
	);
	const [accTrans, setAccTrans] = useState(Array());
	const [page, setPage] = useState(1);

	const [viewingOwners, setViewingOwners] = useState(false);
	const [renaming, setRenaming] = useState(false);
	const [depositing, setDepositing] = useState(false);
	const [withdrawing, setWithdrawing] = useState(false);
	const [transferring, setTransferring] = useState(false);
	const [addOwner, setAddOwner] = useState(false);

	const [xferType, setXferType] = useState(false);
	useEffect(() => {
		if (transferring) setXferType(false);
	}, [transferring]);

	useEffect(() => {
		let f = accounts.filter((a) => a._id == sel);
		if (f.length > 0) {
			setAccount(f[0]);
		} else setAccount(null);
	}, [accounts, sel]);

	useEffect(() => {
		if (Boolean(account)) {
			setAccTrans(transactions[account.Account] || Array());
		} else setAccTrans(Array());
	}, [account, transactions]);

	const onRename = async (e) => {
		e.preventDefault();

		if (account.Type == 'organization' || !account?.Permissions?.MANAGE) {
			setRenaming(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Rename', {
					account: account.Account,
					name: e.target.name.value,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account._id,
						data: {
							...account,
							Name: e.target.name.value,
						},
					},
				});
				toast.success('Account Renamed');
			} else {
				toast.error('Unable To Rename Account');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Rename Account');
		}

		setLoading(false);
		setRenaming(false);
	};

	const onDeposit = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.DEPOSIT) {
			setDepositing(false);
			return;
		}

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

				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'character',
						data: {
							...user,
							Cash: user.Cash - +e.target.amount.value,
						},
					},
				});

				dispatch({
					type: 'ADD_DATA',
					payload: {
						type: 'transactions',
						key: account.Account,
						data: [
							...accTrans,
							{
								Amount: e.target.amount.value,
								Type: 'deposit',
								TransactionAccount: false,
								Title: 'Cash Deposit',
								Data: {
									character: user.SID,
								},
								Account: account.Account,
								Timestamp: Date.now() / 1000,
								Description:
									e.target.notes.value ?? 'No Description',
							},
						],
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

		setLoading(false);
		setDepositing(false);
	};

	const onWithdraw = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.WITHDRAW) {
			setWithdrawing(false);
			return;
		}

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

				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'character',
						data: {
							...user,
							Cash: user.Cash + +e.target.amount.value,
						},
					},
				});

				dispatch({
					type: 'ADD_DATA',
					payload: {
						type: 'transactions',
						key: account.Account,
						data: [
							...accTrans,
							{
								Amount: e.target.amount.value,
								Type: 'withdraw',
								TransactionAccount: false,
								Title: 'Cash Withdrawal',
								Data: {
									character: user.SID,
								},
								Account: account.Account,
								Timestamp: Date.now() / 1000,
								Description:
									e.target.notes.value ?? 'No Description',
							},
						],
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

		setLoading(false);
		setWithdrawing(false);
	};

	const onTransfer = async (e) => {
		e.preventDefault();

		if (!account?.Permissions?.WITHDRAW) {
			setWithdrawing(false);
			return;
		}

		let xferType = e.target.type.value === 'true';
		if (xferType && e.target.target.value == user.SID) {
			toast.error(
				'Cannot Transfer To Your Own State ID, Use Account Numbers',
			);
			return;
		}

		if (!xferType && e.target.target.value == account.Account) {
			toast.error('Cannot Transfer Funds To The Same Account');
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Transfer', {
					account: account.Account,
					type: xferType,
					target: e.target.target.value,
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
				dispatch({
					type: 'ADD_DATA',
					payload: {
						type: 'transactions',
						key: account.Account,
						data: [
							...accTrans,
							{
								Amount: e.target.amount.value,
								Type: 'transfer',
								TransactionAccount: false,
								Title: 'Outgoing Bank Transfer',
								Data: {
									character: user.SID,
								},
								Account: account.Account,
								Timestamp: Date.now() / 1000,
								Description: `Transfer To Account: ${
									e.target.target.value
								}.${
									e.target.notes.value != ''
										? ` Description: ${e.target.notes.value}`
										: ''
								}`,
							},
						],
					},
				});

				if (!xferType) {
					let t = accounts.filter(
						(a) => a.Account == e.target.target.value,
					);

					if (t.length > 0) {
						dispatch({
							type: 'UPDATE_DATA',
							payload: {
								type: 'accounts',
								id: t[0]._id,
								data: {
									...t[0],
									Balance:
										+t[0].Balance + +e.target.amount.value,
								},
							},
						});

						let tt = Boolean(transactions[t[0].Account])
							? transactions[t[0].Account]
							: Array();

						dispatch({
							type: 'ADD_DATA',
							payload: {
								type: 'transactions',
								key: t[0].Account,
								data: [
									...tt,
									{
										Amount: e.target.amount.value,
										Type: 'transfer',
										TransactionAccount: false,
										Title: 'Incoming Bank Transfer',
										Data: {
											character: user.SID,
										},
										Account: t[0].Account,
										Timestamp: Date.now() / 1000,
										Description: `Transfer From Account: ${
											account.Account
										}.${
											e.target.notes.value != ''
												? ` Description: ${e.target.notes.value}`
												: ''
										}`,
									},
								],
							},
						});
					}
				}

				toast.success('Funds Transferred');
			} else {
				toast.error('Unable To Transfer Funds');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Transfer Funds');
		}

		setTransferring(false);
		setLoading(false);
	};

	const onAddOwner = async (e) => {
		e.preventDefault();

		if (
			account.Type != 'personal_savings' ||
			account.Owner != user.SID ||
			!account?.Permissions?.MANAGE
		) {
			setAddOwner(false);
			return;
		}

		if (user.SID == e.target.target.value) {
			toast.error('You Cannot Add Yourself As A Joint Owner');
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:AddJoint', {
					account: account.Account,
					target: e.target.target.value,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account._id,
						data: {
							...account,
							JointOwners: [
								...account.JointOwners,
								+e.target.target.value,
							],
						},
					},
				});
				toast.success('Joint Owner Added');
			} else {
				toast.error('Unable To Add Joint Owner');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Add Joint Owner');
		}

		setLoading(false);
		setAddOwner(false);
	};

	const onRemoveOwner = async (stateId) => {
		if (
			account.Type != 'personal_savings' ||
			account.Owner != user.SID ||
			!account?.Permissions?.MANAGE
		) {
			setAddOwner(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:RemoveJoint', {
					account: account.Account,
					target: stateId,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'accounts',
						id: account._id,
						data: {
							...account,
							JointOwners: account.JointOwners.filter((o) => o != stateId),
						},
					},
				});
				toast.success('Joint Owner Removed');
			} else {
				toast.error('Unable To Remove Joint Owner');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable To Remove Joint Owner');
		}

		setLoading(false);
		setAddOwner(false);
	};

	return (
		<>
			{Boolean(account) ? (
				<Grid className={classes.container} container spacing={2}>
					<Grid item xs={6}>
						<div className={classes.block}>
							<Grid container>
								<Grid item xs={6}>
									<div className={classes.blockHeader}>
										Account Number
									</div>
									<div className={classes.blockContent}>
										{account.Account}
									</div>
									<div className={classes.blockHeader}>
										Account Type
									</div>
									<div className={classes.blockContent}>
										{getAccountType(account)}
									</div>
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
								<Grid item xs={6}>
									<div className={classes.blockHeader}>
										Account Management
									</div>
									{account.Type != 'organization' && (
										<Button
											fullWidth
											color="success"
											variant="contained"
											disabled={
												loading ||
												!account?.Permissions?.WITHDRAW
											}
											className={classes.quickBtn}
											onClick={() => setRenaming(true)}
										>
											Change Account Nickname
										</Button>
									)}
									{account.Type == 'personal_savings' &&
										account.Owner == user.SID && (
											<Button
												fullWidth
												color="info"
												variant="contained"
												disabled={
													loading ||
													!account?.Permissions
														?.WITHDRAW
												}
												className={classes.quickBtn}
												onClick={() =>
													setViewingOwners(true)
												}
											>
												Manage Joint Owners
											</Button>
										)}
								</Grid>
							</Grid>
						</div>
					</Grid>
					<Grid item xs={6}>
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
									onClick={() => setDepositing(true)}
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
									onClick={() => setWithdrawing(true)}
								>
									Withdraw Cash
								</Button>
								<Button
									fullWidth
									color="info"
									variant="contained"
									className={classes.quickBtn}
									disabled={
										!account?.Permissions?.WITHDRAW ||
										account.Balance == 0
									}
									onClick={() => setTransferring(true)}
								>
									Transfer Funds
								</Button>
							</div>
						</div>
					</Grid>
					{account?.Permissions?.TRANSACTIONS ? (
						<Grid
							item
							xs={12}
							style={{ width: '98%', margin: 'auto' }}
						>
							<div className={classes.block}>
								<div className={classes.blockHeader}>
									Recent Transactions{' '}
									<small>({accTrans.length} Total)</small>
								</div>
								<List
									className={classes.blockContent}
									style={{ paddingRight: 10, height: 395 }}
								>
									{Boolean(accTrans) &&
									accTrans.length > 0 ? (
										accTrans
											.sort(
												(a, b) =>
													b.Timestamp - a.Timestamp,
											)
											.slice(0, page * 10)
											.map((t, k) => {
												return (
													<Transaction
														key={`${account._id}-${k}`}
														transaction={t}
													/>
												);
											})
									) : (
										<ListItem
											style={{ textAlign: 'center' }}
										>
											No Recent Transactions
										</ListItem>
									)}
									{Boolean(accTrans) &&
										accTrans.length > 10 &&
										page <
											Math.ceil(accTrans.length / 10) && (
											<Button
												fullWidth
												color="success"
												variant="contained"
												style={{ marginTop: 10 }}
												onClick={() =>
													setPage(page + 1)
												}
											>
												Load More
											</Button>
										)}
								</List>
							</div>
						</Grid>
					) : (
						<Grid
							item
							xs={12}
							style={{ width: '98%', margin: 'auto' }}
						>
							<div className={classes.block}>
								<div className={classes.blockHeader}>
									Recent Transactions <small>(0 Total)</small>
								</div>
								<List
									className={classes.blockContent}
									style={{ paddingRight: 10 }}
								>
									<ListItem style={{ textAlign: 'center' }}>
										No Recent Transactions
									</ListItem>
								</List>
							</div>
						</Grid>
					)}
				</Grid>
			) : (
				<div className={classes.accountPanel} style={{ padding: 20 }}>
					<Alert variant="filled" severity="error">
						Please Select An Account
					</Alert>
				</div>
			)}

			{Boolean(account) && (
				<>
					{account?.Permissions?.MANAGE &&
						account.Type != 'organization' && (
							<Modal
								open={renaming}
								title={`Rename ${account.Name}`}
								closeLang="Cancel"
								maxWidth="md"
								onClose={() => setRenaming(false)}
								onSubmit={onRename}
							>
								{loading && <Loader static text="Loading" />}
								<TextField
									fullWidth
									required
									className={classes.input}
									label="Account Nickname"
									defaultValue={account.Name}
									name="name"
									variant="outlined"
								/>
							</Modal>
						)}
					{account?.Permissions?.DEPOSIT && (
						<Modal
							open={depositing}
							title={`Deposit Funds Into ${account.Name}`}
							closeLang="Cancel"
							maxWidth="md"
							onClose={() => setDepositing(false)}
							onSubmit={onDeposit}
						>
							{loading && <Loader static text="Loading" />}
							<NumberFormat
								fullWidth
								required
								label="Deposit To"
								className={classes.field}
								disabled={true}
								type="tel"
								isNumericString
								value={account.Account}
								customInput={TextField}
							/>
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
							maxWidth="md"
							onClose={() => setWithdrawing(false)}
							onSubmit={onWithdraw}
						>
							{loading && <Loader static text="Loading" />}
							<NumberFormat
								fullWidth
								required
								label="Withdraw From"
								className={classes.field}
								disabled={true}
								type="tel"
								isNumericString
								value={account.Account}
								customInput={TextField}
							/>
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
							open={transferring}
							title={`Transfer Funds From ${account.Name}`}
							closeLang="Cancel"
							maxWidth="md"
							onClose={() => setTransferring(false)}
							onSubmit={onTransfer}
						>
							{loading && <Loader static text="Loading" />}
							<NumberFormat
								fullWidth
								required
								label="Transfer From"
								className={classes.field}
								disabled={true}
								type="tel"
								isNumericString
								value={account.Account}
								customInput={TextField}
							/>
							<TextField
								select
								fullWidth
								required
								name="type"
								className={classes.field}
								label="Transfer Type"
								onChange={(e) => setXferType(e.target.value)}
								value={xferType}
							>
								{Types.map((option) => (
									<MenuItem
										key={option.value}
										value={option.value}
									>
										{option.label}
									</MenuItem>
								))}
							</TextField>
							<NumberFormat
								fullWidth
								required
								label={xferType ? 'State ID' : 'Account Number'}
								name="target"
								className={classes.field}
								disabled={loading}
								type="tel"
								isNumericString
								customInput={TextField}
							/>
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
					{account?.Permissions?.MANAGE &&
						account.Type == 'personal_savings' && (
							<>
								<Modal
									open={viewingOwners}
									title={`${account.Name} Joint Owners`}
									closeLang="Close"
									acceptLang="Add Owner"
									maxWidth="md"
									onClose={() => setViewingOwners(false)}
									onAccept={
										account.Owner == user.SID
											? () => setAddOwner(true)
											: null
									}
								>
									<List>
										{account.JointOwners.length > 0 ? (
											account.JointOwners.map((o) => {
												return (
													<ListItem
														key={`${account.Account}-${o}`}
													>
														<ListItemText
															primary="State ID"
															secondary={o}
														/>
														<ListItemSecondaryAction>
															<IconButton
																onClick={() =>
																	onRemoveOwner(
																		o,
																	)
																}
															>
																<FontAwesomeIcon
																	icon={[
																		'fas',
																		'x',
																	]}
																/>
															</IconButton>
														</ListItemSecondaryAction>
													</ListItem>
												);
											})
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
									</List>
								</Modal>
								{account.Owner == user.SID && (
									<Modal
										open={addOwner}
										title={`Add Joint Owner To ${account.Name}`}
										closeLang="Cancel"
										maxWidth="md"
										onClose={() => setAddOwner(false)}
										onSubmit={onAddOwner}
									>
										{loading && (
											<Loader static text="Loading" />
										)}
										<NumberFormat
											fullWidth
											required
											label="State ID"
											name="target"
											className={classes.field}
											disabled={loading}
											type="tel"
											isNumericString
											customInput={TextField}
										/>
									</Modal>
								)}
							</>
						)}
				</>
			)}
		</>
	);
};
