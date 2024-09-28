import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
	Grid,
	Button,
	List,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	TextField,
	MenuItem,
	IconButton,
} from '@mui/material';
import NumberFormat from 'react-number-format';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Modal } from '../../../components';

import Order from './components/Order';
import Team from './components/Team';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '100%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '93.25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
	upper: {
		height: '10%',
		textAlign: 'center',
		position: 'relative',
	},
	lower: {
		height: '90%',
		padding: 8,
	},
	orderBtn: {
		position: 'absolute',
		height: 45,
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	col: {
		paddingRight: 14,

		'& h3': {
			borderBottom: `1px solid ${theme.palette.border.divider}`,
			paddingBottom: 6,
		},

		'&:not(:last-of-type)': {
			borderRight: `1px solid ${theme.palette.border.divider}`,
		},
	},
	header: {
		fontSize: 16,

		'& small': {
			fontSize: 12,
			color: theme.palette.text.alt,
		},
		'& svg': {
			fontSize: 14,
		},
	},
}));

const buyableItems = {
	rubber: 2000,
	plastic: 2000,
	electronic_parts: 2000,
	copperwire: 2000,
	glue: 2000,
	heavy_glue: 2000,
	ironbar: 700,
	silverbar: 120,
	goldbar: 70,
};

const defOrderState = {
	tier: 1,
	paymentCoin: 'PLEB',
	paymentAmount: 0,
	items: Array(),
};

const defItemState = {
	item: '',
	amount: 1000,
};

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const items = useSelector((state) => state.data.data.items);
	const activeOrders = useSelector((state) => state.data.data.activeOrders);
	const pastOrders = useSelector((state) => state.data.data.pastOrders);
	const activeTeams = useSelector((state) => state.data.data.activeTeams);

	const [loading, setLoading] = useState(false);
	const [orderOpen, setOrderOpen] = useState(false);
	const [addingItem, setAddingItem] = useState(false);
	const [orderState, setOrderState] = useState({ ...defOrderState });
	const [itemState, setItemState] = useState({ ...defItemState });

	const onItemChange = (e) => {
		setItemState({
			...itemState,
			[e.target.name]: e.target.value,
			amount: buyableItems[e.target.value],
		});
	};

	const onItemClose = () => {
		setAddingItem(false);
		setItemState({ ...defItemState });
	};

	const onItemSubmit = (e) => {
		e.preventDefault();
		setOrderState({
			...orderState,
			items: [...orderState.items, itemState],
		});
		setAddingItem(false);
		setItemState({ ...defItemState });
	};

	const removeItem = (index) => {
		setOrderState({
			...orderState,
			items: orderState.items.filter((_, i) => i != index),
		});
	};

	const onClose = () => {
		setOrderOpen(false);
		setOrderState({ ...defOrderState });
		setAddingItem(false);
		setItemState({ ...defItemState });
	};

	const onChange = (e) => {
		setOrderState({
			...orderState,
			[e.target.name]: e.target.value,
		});
	};

	const onSubmit = (e) => {
		e.preventDefault();

		dispatch({
			type: 'ADD_DATA',
			payload: {
				id: 'activeOrders',
				data: {
					_id: activeOrders.length,
					tier: orderState.tier,
					date: Date.now() / 1000,
					items: orderState.items,
					payment: {
						coin: orderState.paymentCoin,
						amount: orderState.paymentAmount,
					},
				},
			},
		});

		setOrderOpen(false);
		setOrderState({ ...defOrderState });
	};

	return (
		<div className={classes.wrapper}>
			<Grid container className={classes.upper}>
				<Button
					className={classes.orderBtn}
					variant="contained"
					onClick={() => setOrderOpen(true)}
				>
					Submit New Order
				</Button>
			</Grid>
			<Grid container spacing={2} className={classes.lower}>
				<Grid item xs={4} className={classes.col}>
					<h3>Your Active Orders</h3>
					<List>
						{activeOrders.length > 0 ? (
							activeOrders
								.sort((a, b) => b.date - a.date)
								.map((order) => {
									return (
										<Order
											key={`order-${order._id}`}
											order={order}
										/>
									);
								})
						) : (
							<ListItem divider>
								<ListItemText primary="No Active Orders" />
							</ListItem>
						)}
					</List>
				</Grid>
				<Grid item xs={4} className={classes.col}>
					<h3>Your Past Orders</h3>
					<List>
						{pastOrders.length > 0 ? (
							pastOrders
								.sort((a, b) => b.date - a.date)
								.map((order) => {
									return (
										<Order
											key={`order-${order._id}`}
											order={order}
										/>
									);
								})
						) : (
							<ListItem divider>
								<ListItemText primary="No Past Orders" />
							</ListItem>
						)}
					</List>
				</Grid>
				<Grid item xs={4} className={classes.col}>
					<h3>Available Teams</h3>
					<List>
						{activeTeams.length > 0 ? (
							activeTeams.map((team) => {
								return (
									<Team
										key={`team-${team._id}`}
										team={team}
									/>
								);
							})
						) : (
							<ListItem divider>
								<ListItemText primary="No Active Teams" />
							</ListItem>
						)}
					</List>
				</Grid>
			</Grid>

			<Modal
				open={orderOpen}
				title="Submit New Order"
				submitLang="Submit"
				onSubmit={onSubmit}
				onClose={onClose}
			>
				<Grid container spacing={2}>
					<Grid item xs={12}>
						<TextField
							fullWidth
							select
							name="tier"
							label="Tier"
							onChange={onChange}
							value={orderState.tier}
						>
							{[...Array(5).keys()].map((option) => (
								<MenuItem
									key={`tier-${option}`}
									value={option + 1}
								>
									{option + 1}
								</MenuItem>
							))}
						</TextField>
					</Grid>
					<Grid item xs={2}>
						<TextField
							fullWidth
							select
							name="paymentCoin"
							label="Coin"
							onChange={onChange}
							value={orderState.paymentCoin}
						>
							<MenuItem value="PLEB">Plebian</MenuItem>
						</TextField>
					</Grid>
					<Grid item xs={5}>
						<TextField
							disabled
							fullWidth
							label="Base Cost"
							value={`${orderState.tier * 100} $${
								orderState.paymentCoin
							}`}
						/>
					</Grid>
					<Grid item xs={5}>
						<NumberFormat
							fullWidth
							required
							name="paymentAmount"
							label="Bonus Payment"
							value={orderState.paymentAmount}
							disabled={loading}
							onChange={(e) =>
								setOrderState({
									...orderState,
									paymentAmount: +e.target.value,
								})
							}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
					</Grid>
					<Grid item xs={12}>
						<TextField
							disabled
							fullWidth
							label="Fee"
							value={`${orderState.tier * 20} $${
								orderState.paymentCoin
							}`}
						/>
					</Grid>
					<Grid item xs={12}>
						<TextField
							disabled
							fullWidth
							label="Total Cost"
							value={`${
								orderState.tier * 100 +
								orderState.tier * 20 +
								orderState.paymentAmount
							} $${orderState.paymentCoin}`}
						/>
					</Grid>
					<Grid item xs={12}>
						<h3 className={classes.header}>
							Items{' '}
							<small>
								{orderState.tier * 2 - orderState.items.length}{' '}
								Slots Available
							</small>
							{orderState.tier * 2 - orderState.items.length >
								0 && (
								<IconButton onClick={() => setAddingItem(true)}>
									<FontAwesomeIcon icon={['fas', 'plus']} />
								</IconButton>
							)}
						</h3>
						<List dense>
							{orderState.items.map((item, i) => {
								const itemData = items[item.item];
								if (!Boolean(itemData)) return null;
								return (
									<ListItem divider key={`orderitem-${i}`}>
										<ListItemText
											primary={itemData.label}
											secondary={item.amount}
										/>
										<ListItemSecondaryAction>
											<IconButton
												onClick={() => removeItem(i)}
											>
												<FontAwesomeIcon
													icon={['fas', 'trash']}
												/>
											</IconButton>
										</ListItemSecondaryAction>
									</ListItem>
								);
							})}
						</List>
					</Grid>
				</Grid>
			</Modal>

			{addingItem && orderOpen && (
				<Modal
					maxWidth="sm"
					open={addingItem}
					title="Add Item To Order"
					submitLang="Add"
					onSubmit={onItemSubmit}
					onClose={onItemClose}
				>
					<Grid container spacing={2}>
						<Grid item xs={12}>
							<TextField
								fullWidth
								select
								name="item"
								label="Item"
								onChange={onItemChange}
								value={itemState.item}
							>
								{Object.keys(buyableItems).map((option) => {
									const item = items[option];
									return (
										<MenuItem
											key={`item-${option}`}
											value={option}
										>
											{item.label} - Amount:{' '}
											{buyableItems[option]}
										</MenuItem>
									);
								})}
							</TextField>
						</Grid>
					</Grid>
				</Modal>
			)}
		</div>
	);
};
