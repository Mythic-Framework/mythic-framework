import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Grid,
	AppBar,
	IconButton,
	TextField,
	Pagination,
	Select,
	MenuItem,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import NumberFormat from 'react-number-format';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Loader } from '../../components';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';
import Transaction from './component/Transaction';

import { getAccountName, getAccountType } from './utils';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	titleBar: {
		padding: '10px 8px',
		textAlign: 'center',
	},
	accountTitle: {
		fontSize: 20,
		fontWeight: 'bold',
		margin: 'auto',
		width: '100%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
	},
	accountBody: {
		padding: 20,
		overflowX: 'hidden',
		overflowY: 'auto',
		background: theme.palette.secondary.main,
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	accountBtn: {
		width: '90%',
		padding: 10,
		margin: '2.5% auto',
		position: 'relative',
		height: 100,
		background: theme.palette.secondary.dark,
		willChange: 'background',
		transition: 'background 400ms',
		borderRadius: 5,
		boxShadow: '0px 0px 12px -2px rgba(0,0,0,0.3)',
		'&:hover': {
			cursor: 'pointer',
		},
		'&:hover:not(.disabled)': {
			background: 'rgba(255, 255, 255, 0.01)',
		},
		'&.disabled': {
			opacity: '60%',
			color: theme.palette.secondary.contrastText,
		},
	},
	content: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: '100%',
		padding: '5px 7.5% 5px 2%',
		textAlign: 'center',
		margin: 'auto',
		fontSize: 28,
		'& svg': {
			color: theme.palette.primary.main,
			fontSize: 35,
		},
	},
	subBar: {
		padding: 15,
		textAlign: 'left',
		lineHeight: '30px',
		backgroundColor: theme.palette.secondary.light,
	},
	currency: {
		color: theme.palette.success.main,
	},
	editField: {
		marginBottom: 20,
		width: '100%',
	},
}));

const NumberFormatCustom = React.forwardRef((props, ref) => {
	const { inputRef, onChange, ...other } = props;
	const withValueLimit = ({ floatValue }) => floatValue >= 1 && floatValue <= 10000000;

	return (
		<NumberFormat
			{...other}
			getInputRef={inputRef}
			isAllowed={withValueLimit}
			onValueChange={(values) => {
				onChange({
					target: {
						name: props.name,
						value: values.floatValue,
					},
				});
			}}
			thousandSeparator
			isNumericString
			prefix="$"
		/>
	);
});

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const dispatch = useDispatch();
	const { account } = props.match.params;
	const myAccounts = useSelector((state) => state.data.data.bankAccounts);
	const accountData = myAccounts?.accounts && myAccounts.accounts.find(acc => acc.Account == account);
	const accountTransactions = myAccounts?.transactions?.[accountData?.Account?.toString()];

	const pages = accountTransactions ? Math.ceil(accountTransactions.length / 8): 0;
	const [page, setPage] = useState(1);
	const [loading, setLoading] = useState(0);

	const [transactions, setTransactions] = useState(false);
	const openTransactionLogs = () => {
		if (accountData.Permissions?.TRANSACTIONS && accountTransactions) {
			setTransactions(true);
		}
	};

	const [transfer, setTransfer] = useState(false);
	const [tState, setTState] = useState({
		targetType: false,
		target: '',
		amount: '',
		description: '',
	});

	const openTransferModal = () => {
		if (accountData.Permissions?.WITHDRAW) {
			if (accountData.Balance > 0) {
				setTState({
					targetType: false,
					target: tState.target,
					amount: '',
				});
				setTransfer(true);
			} else {
				showAlert('No Balance to Transfer');
			}
		}
	};

	const onTChange = (e) => {
		setTState({
			...tState,
			[e.target.name]: e.target.value,
		});
	};

	const onTransfer = async (e) => {
		e.preventDefault();
		setLoading(1);

		try {
			let res = await (await Nui.send('Banking:Transfer', {
				account: accountData.Account,
				targetType: tState.targetType,
				target: tState.target,
				amount:
					tState.amount > accountData.Balance
						? accountData.Balance
						: tState.amount,
				description: tState.description,
			})).json();
			if (res) {
				showAlert('Funds Transferred Successfully');
				setTimeout(() => {
					history.goBack();
				}, 250);
			} else {
				showAlert('Error Transferring Funds');
			}
		} catch (err) {
			showAlert('Error Transferring Funds');
		}

		setTransfer(false);
		setTState({
			targetType: false,
			target: '',
			amount: '',
			description: '',
		});
		setLoading(0);
	};

	const [billing, setBilling] = useState(false);
	const [bState, setBState] = useState({
		target: '',
		description: '',
		amount: '',
	});

	const openBilling = () => {
		if (accountData.Permissions?.BILL) {
			setBilling(true);
		}
	};

	const onBChange = (e) => {
		setBState({
			...bState,
			[e.target.name]: e.target.value,
		});
	};

	const onBill = async (e) => {
		e.preventDefault();
		setLoading(2);

		try {
			let res = await (await Nui.send('Banking:Bill', {
				fromAccount: accountData.Account,
				target: bState.target,
				description: bState.description,
				amount: bState.amount,
			})).json();
			if (res) {
				showAlert('Bill Sent Successfully');
				history.goBack();
			} else {
				showAlert('Error Creating Bill');
			}
		} catch (err) {
			showAlert('Error Creating Bill');
		}

		setBilling(false);
		setBState({
			target: '',
			description: '',
			amount: '',
		});
		setLoading(0);
	};

	if (loading) {
		return (
			<div className={classes.wrapper}>
				<Loader static text={loading === 1 ? "Completing Transfer" : "Creating Bill"} />
			</div> 
		);
	} else {
		return (
			<div className={classes.wrapper}>
				{accountData != null ? (
					<>
						<AppBar position="static">
							<Grid container className={classes.titleBar}>
								<Grid item xs={2} style={{ textAlign: 'left' }}>
									<IconButton onClick={() => history.goBack()}>
										<FontAwesomeIcon icon={['fas', 'arrow-left']} />
									</IconButton>
								</Grid>
								<Grid
									item
									xs={8}
									className={classes.accountTitle}
									title={accountData.Name}
								>
									{getAccountName(accountData)}
								</Grid>
								<Grid item xs={2} style={{ textAlign: 'right' }}>
	
								</Grid>
							</Grid>
							<Grid container className={classes.subBar}>
								<Grid item xs={12}>
									Account Number: {accountData.Account}
								</Grid>
								<Grid item xs={12}>
									Account Type: {getAccountType(accountData)}
								</Grid>
								<Grid item xs={6}>
									Balance:{' '}
									<span className={classes.currency}>
										{accountData.Permissions?.BALANCE ? `$${accountData.Balance.toLocaleString('en-US')}` : '???'}
									</span>
								</Grid>
							</Grid>
						</AppBar>
						<div className={classes.accountBody}>
							<Grid container>
								<Grid item xs={12} className={classes.accountBtn}>
									<div className={classes.content}>
										<Grid container direction="row" justifyContent="center" alignItems="center">
											<Grid item xs={2}>
												<FontAwesomeIcon icon={['fas', 'dollar-sign']} />
											</Grid>
											<Grid item xs={10}>
												Balance: {' '}
												<span className={classes.currency}>
													{accountData.Permissions?.BALANCE ? `$${accountData.Balance.toLocaleString('en-US')}` : '???'}
												</span>
											</Grid>
										</Grid>
									</div>
								</Grid>
								<Grid item xs={12} className={`${classes.accountBtn} ${!accountData.Permissions?.TRANSACTIONS && 'disabled'}`}
									onClick={() => openTransactionLogs()}
								>
									<div className={classes.content}>
										<Grid container direction="row" justifyContent="center" alignItems="center">
											<Grid item xs={2}>
												<FontAwesomeIcon
													icon={['fas', 'magnifying-glass-dollar']}
												/>
											</Grid>
											<Grid item xs={10}>
												Previous Transactions
											</Grid>
										</Grid>
									</div>
								</Grid>
								<Grid item xs={12} className={`${classes.accountBtn} ${!accountData.Permissions?.WITHDRAW && 'disabled'}`}
									onClick={() => openTransferModal()}
								>
									<div className={classes.content}>
										<Grid container direction="row" justifyContent="center" alignItems="center">
											<Grid item xs={2}>
												<FontAwesomeIcon icon={['fas', 'money-bill-1-wave']} />
											</Grid>
											<Grid item xs={10}>
												Transfer Funds
											</Grid>
										</Grid>
									</div>
								</Grid>
								{accountData.Permissions?.BILL &&
									<Grid item xs={12} className={classes.accountBtn}
									onClick={() => openBilling()}
								>
									<div className={classes.content}>
										<Grid container direction="row" justifyContent="center" alignItems="center">
											<Grid item xs={2}>
												<FontAwesomeIcon icon={['fas', 'file-invoice-dollar']} />
											</Grid>
											<Grid item xs={10}>
												Create Bill
											</Grid>
										</Grid>
									</div>
								</Grid>}
							</Grid>
						</div>
						<Modal
							form
							open={billing}
							title="Send Bill"
							submitLang="Bill"
							onAccept={onBill}
							onClose={() => setBilling(false)}
						>
							<TextField
								required
								fullWidth
								className={classes.editField}
								label="Billing State ID"
								name="target"
								type="text"
								value={bState.target}
								helperText={'The State ID of who you want to bill.'}
								inputProps={{
									maxLength: 6,
								}}
								onChange={onBChange}
							/>
							<TextField
								required
								fullWidth
								className={classes.editField}
								label="Billing Description"
								name="description"
								type="text"
								value={bState.description}
								multiline={true}
								inputProps={{
									maxLength: 240,
								}}
								onChange={onBChange}
							/>
							<TextField
								required
								fullWidth
								className={classes.editField}
								label="Bill Amount"
								name="amount"
								value={bState.amount}
								onChange={onBChange}
								InputProps={{
									inputComponent: NumberFormatCustom,
								}}
								inputProps={{
									maxLength: 16,
								}}
							/>
						</Modal>
						<Modal
							open={transactions}
							title="Account Transaction History"
							onClose={() => setTransactions(false)}
						>
							{transactions && (
								<div>
									{accountTransactions.sort(
										(a, b) => b.Timestamp - a.Timestamp,
									)
										.slice((page - 1) * 8, page * 8)
										.map((transactionLog, k) => {
											return (
												<Transaction
													key={`trans-${k}`}
													transaction={transactionLog}
												/>
											);
										})}
								</div>
							)}
							{pages > 1 && (
								<Pagination
									count={pages}
									page={page}
									onChange={(_, value) => setPage(value)}
									variant="outlined"
									color="primary"
								/>
							)}
						</Modal>
						<Modal
							form
							open={transfer}
							title="Transfer Funds"
							submitLang="Transfer"
							onAccept={onTransfer}
							onClose={() => setTransfer(false)}
						>
							<TextField
								disabled
								required
								fullWidth
								className={classes.editField}
								value={accountData.Account}
								label="Transfering From"
								name="source"
								type="text"
							/>
							<Select
								id="targetType"
								name="targetType"
								className={classes.editField}
								value={tState.targetType}
								onChange={onTChange}
							>
								<MenuItem value={false}>Transfer By Bank Account</MenuItem>
								<MenuItem value={true}>Transfer By State ID</MenuItem>
							</Select>
							<TextField
								required
								fullWidth
								className={classes.editField}
								label="Transfering To"
								name="target"
								type="text"
								helperText={tState.targetType ? 'Transferring By State ID': 'Transferring By Bank Account'}
								value={tState.target}
								inputProps={{
									maxLength: 6,
								}}
								onChange={onTChange}
							/>
							<TextField
								required
								fullWidth
								className={classes.editField}
								label="Transfering Amount"
								helperText={`Max Transferable: $${accountData.Balance.toLocaleString('en-US')}`}
								name="amount"
								value={tState.amount}
								onChange={onTChange}
								InputProps={{
									inputComponent: NumberFormatCustom,
								}}
								inputProps={{
									maxLength: 16,
								}}
							/>
							<TextField
								fullWidth
								multiline
								className={classes.editField}
								label="Transfering Description"
								helperText={'Not Required but Recommended'}
								name="description"
								value={tState.description}
								onChange={onTChange}
								inputProps={{
									maxLength: 240,
								}}
							/>
						</Modal>
					</>
				) : (
					<p>Something Went Wrong</p>
				)}
			</div>
		);
	}
};
