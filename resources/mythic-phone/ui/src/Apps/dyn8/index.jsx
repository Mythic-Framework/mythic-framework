import React, { useState, useMemo, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	TextField,
	InputAdornment,
	IconButton,
	Alert,
	AppBar,
	Grid,
	MenuItem,
	Slider,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { debounce } from 'lodash';
import NumberFormat from 'react-number-format';

import logo from './assets/dyn8.png';

import { useAlert, useJobPermissions, useMyJob } from '../../hooks';
import { Loader, Modal, Confirm } from '../../components';
import Nui from '../../util/Nui';
import Property from './components/Property';
import { CurrencyFormat } from '../../util/Parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
	},
	branding: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
		width: '100%',
		maxWidth: 225,
		opacity: 0.5,
		pointerEvents: 'none',
	},
	header: {
		background: '#136231',
		color: theme.palette.text.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	searchField: {
		height: '10%',
		padding: 10,
	},
	content: {
		padding: 10,
		position: 'relative',
		height: '80%',
		overflow: 'auto',
	},
	editorField: {
		marginBottom: 15,
	},
	sliderField: {
		marginBottom: 15,
		width: '90%',
		marginRight: '5%',
		marginLeft: '5%',
	},
}));

const testProperties = Array(
	{
		_id: 155,
		label: '1 Grove St',
		sold: false,
		price: 125000,
	},
	{
		label: '2 Grove St',
		sold: true,
		owner: {
			First: 'Test',
			Last: 'McTesty',
			SID: 2,
		},
	},
);

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const hasJobPerm = useJobPermissions();
	const isMyJob = useMyJob();
	const search = useSelector((state) => state.dyn8.propertySearch);

	const [searched, setSearched] = useState(false);
	const [loading, setLoading] = useState(false);
	const [expanded, setExpanded] = useState(null);

	const [selling, setSelling] = useState(null);
	const [sellConf, setSellConf] = useState(false);

	const [creditCheck, setCreditCheck] = useState(null);
	const [creditCheckView, setCreditCheckView] = useState(null);

	const onSearchChange = (e) => {
		dispatch({
			type: 'DYN8_SEARCH_CHANGE',
			payload: {
				term: e.target.value,
			},
		});
		setSearched(false);
	};

	const onSearch = (e) => {
		e.preventDefault();
		setLoading(true);
		fetch(search.term);
	};

	const onSell = (e) => {
		if (!(hasJobPerm('JOB_SELL', 'realestate'))) return;
		setSelling({ 
			...e,
			target: '',
			loan: false,
			deposit: 20,
			time: 8,
		});
	};

	const onCheckCredit = (e) => {
		setCreditCheck({
			target: '',
		});
	};

	const onStartCreditCheck = async (e) => {
		try {
			let res = await (
				await Nui.send('Dyn8:CheckCredit', {
					target: +creditCheck.target,
				})
			).json();

			setCreditCheck(null);

			if (res) {
				setCreditCheckView(res);
			} else {
				showAlert('Error');
			}
		} catch (err) {
			console.log(err);
			showAlert('Error');
		}
	};

	const onStartSale = async (e) => {
		try {
			let res = await (
				await Nui.send('Dyn8:SellProperty', {
					property: selling._id,
					target: +selling.target,
					loan: selling.loan,
					deposit: selling.deposit,
					time: selling.time,
				})
			).json();

			if (!res.error) {
				showAlert('Notification of Sale Sent To Client');
			} else {
				switch (res.code) {
					case 0:
						showAlert('Not on Duty');
						break;
					case 1:
						showAlert('Invalid Property');
						break;
					case 2:
						showAlert('Property Already Being Sold');
						break;
					case 3:
						showAlert('Invalid Target');
						break;
				}
			}

			setSellConf(false);
			setSelling(null);
		} catch (err) {
			console.log(err);
			showAlert('Unable to Start Sale Process');
		}
	};

	const fetch = useMemo(
		() =>
			debounce(async (value) => {
				try {
					let res = await (
						await Nui.send('Dyn8:SearchProperty', value)
					).json();
					dispatch({
						type: 'DYN8_RESULTS',
						payload: {
							results: res,
						},
					});
					setLoading(false);
					setSearched(true);
				} catch (err) {
					dispatch({
						type: 'DYN8_RESULTS',
						payload: {
							results: testProperties,
						},
					});
					setLoading(false);
					setSearched(true);
				}
			}, 1000),
		[],
	);

	useEffect(() => {
		return () => {
			fetch.cancel();
		};
	}, []);

	const calculateLoanAfterInterest = (full, downpayment) => {
		const remaining = full - downpayment;
		const afterInterest = remaining * 1.15;
		return Math.round(afterInterest);
	};

	return (
		<>
			<div className={classes.wrapper}>
				<img src={logo} className={classes.branding} />
				<AppBar position="static" className={classes.header}>
					<Grid container>
						<Grid item xs={8}>
							Dynasty 8
						</Grid>
						<Grid item xs={4} className={classes.headerAction}>
							{hasJobPerm('JOB_SELL', 'realestate') && (
								<Tooltip title="Check Credit">
									<IconButton onClick={() => onCheckCredit()}>
										<FontAwesomeIcon icon={['fas', 'circle-dollar']} />
									</IconButton>
								</Tooltip>
							)}
							{/* {!jobData.Workplaces && <Tooltip title="Create New Grade">
								<IconButton
									onClick={() => setGrade({
										JobId: jobData.Id,
										WorkplaceId: null,
										...initialGrade,
									})}
								>
									<FontAwesomeIcon icon={['fas', 'plus']} />
								</IconButton>
							</Tooltip>}
							<Tooltip title="Home">
								<IconButton onClick={home}>
									<FontAwesomeIcon icon={['fas', 'house']} />
								</IconButton>
							</Tooltip> */}
						</Grid>
					</Grid>
				</AppBar>
				<div className={classes.searchField}>
					<form onSubmit={onSearch}>
						<TextField
							required
							fullWidth
							value={search.term}
							onChange={onSearchChange}
							label="Search Property"
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										<IconButton type="submit">
											<FontAwesomeIcon
												icon={['fas', 'magnifying-glass-location']}
											/>
										</IconButton>
									</InputAdornment>
								),
							}}
						/>
					</form>
				</div>
				<div className={classes.content}>
					{loading ? (
						<Loader static text="Loading" />
					) : search.results.length > 0 ? (
						search.results.map((v, k) => {
							return (
								<Property
									key={`property-${k}`}
									expanded={expanded === k}
									property={v}
									onSell={onSell}
									onClick={
										expanded === k
											? () => setExpanded(null)
											: () => setExpanded(k)
									}
								/>
							);
						})
					) : searched ? (
						<Alert variant="filled" severity="error">
							No Search Results
						</Alert>
					) : null}
				</div>
			</div>
			{Boolean(selling) && (
				<>
					<Modal
						form
						formStyle={{ position: 'relative' }}
						open={true}
						title={`Sell ${selling.label}`}
						onClose={() => {
							setSellConf(false);
							setSelling(null);
						}}
						onAccept={() => setSellConf(true)}
						submitLang="Begin Sale"
						closeLang="Cancel"
					>
						<>
							{loading && <Loader static text="Submitting" />}
							<TextField
								fullWidth
								label="Price"
								value={CurrencyFormat.format(selling.price)}
								disabled={true}
								className={classes.editorField}
							/>
							<TextField
								select
								fullWidth
								label="Type"
								className={classes.editorField}
								value={selling.loan}
								onChange={(e) => {
									setSelling({
										...selling,
										loan: e.target.value,
									});
								}}
							>
								<MenuItem key={'loan'} value={true}>
									Loan
								</MenuItem>
								<MenuItem key={'no-loan'} value={false}>
									Cash Sale
								</MenuItem>
							</TextField>

							{Boolean(selling.loan) && <>
								<p>Deposit: {CurrencyFormat.format(Math.ceil(selling.price * (selling.deposit / 100)))}</p>
								<Slider
									size="small"
									className={classes.sliderField}
									defaultValue={25}
									aria-label="Small"
									valueLabelDisplay="auto"
									value={selling.deposit}
									onChange={(e) => {
										setSelling({
											...selling,
											deposit: e.target.value,
										});
									}}
									min={20}
									step={5}
									max={75}
									valueLabelFormat={(x) => {
										return `${x}%`;
									}}
								/>
								<p>Length: {selling.time} Weeks</p>
								<Slider
									size="small"
									className={classes.sliderField}
									defaultValue={25}
									aria-label="Small"
									valueLabelDisplay="auto"
									value={selling.time}
									onChange={(e) => {
										setSelling({
											...selling,
											time: e.target.value,
										});
									}}
									min={8}
									step={1}
									max={24}
								/>
								<p>Remaining Cost After Interest: {CurrencyFormat.format(calculateLoanAfterInterest(selling.price, selling.price * (selling.deposit / 100)))}</p>
								<p>Weekly Payments: {CurrencyFormat.format(calculateLoanAfterInterest(selling.price, selling.price * (selling.deposit / 100)) / selling.time)}</p>
							</>}

							<NumberFormat
								fullWidth
								required
								autoFocus
								label="Target State ID"
								className={classes.editorField}
								value={selling.target}
								disabled={loading}
								onChange={(e) => {
									setSelling({
										...selling,
										target: e.target.value,
									});
								}}
								type="tel"
								isNumericString
								customInput={TextField}
							/>
						</>
					</Modal>
					<Confirm
						title="Start Sale?"
						open={sellConf}
						confirm="Yes"
						decline="No"
						onConfirm={onStartSale}
						onDecline={() => setSellConf(false)}
					>
						<p>
							By starting this sale, nobody else will be able to
							begin the sale process for this property until the
							client either declines the sale or it times out (~30
							minutes).
						</p>
					</Confirm>
				</>
			)}
			{Boolean(creditCheck) && (
				<>
					<Modal
						form
						formStyle={{ position: 'relative' }}
						open={true}
						title={`Check Credit`}
						onClose={() => {
							setCreditCheck(null);
						}}
						onAccept={() => onStartCreditCheck()}
						submitLang="Check Credit"
						closeLang="Cancel"
					>
						<>
							{loading && <Loader static text="Submitting" />}
							<NumberFormat
								fullWidth
								required
								autoFocus
								label="Target State ID"
								className={classes.editorField}
								value={creditCheck.target}
								disabled={loading}
								onChange={(e) => {
									setCreditCheck({
										...creditCheck,
										target: e.target.value,
									});
								}}
								type="tel"
								isNumericString
								customInput={TextField}
							/>
						</>
					</Modal>
				</>
			)}
			{Boolean(creditCheckView) && (
				<Confirm
				title="Credit Check Results"
				open={true}
				confirm="Okay"
				decline="Dismiss"
				onConfirm={() => setCreditCheckView(null)}
				onDecline={() => setCreditCheckView(null)}
			>
				<p>
					{creditCheckView.First} {creditCheckView.Last} has a credit score of {creditCheckView.Score} so can take out a loan of up to {CurrencyFormat.format(creditCheckView.Amount)}
				</p>
			</Confirm>
			)}
		</>
	);
};
