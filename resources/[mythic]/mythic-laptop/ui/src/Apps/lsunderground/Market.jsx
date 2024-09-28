import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import {
	Fab,
	IconButton,
	List,
	ListItem,
	ListItemSecondaryAction,
	ListItemText,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader, Modal } from '../../components';
import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'relative',
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'auto',
	},
	body: {
		padding: 10,
		height: '100%',
	},
	fab: {
		position: 'absolute',
		bottom: 25,
		right: 150,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '22%',
	},
}));

export default ({ banned, items }) => {
	const classes = useStyles();
	const sendAlert = useAlert();

	const [submitting, setSubmitting] = useState(false);
	const [cart, setCart] = useState(Array());
	const [checkout, setCheckout] = useState(false);

	const onAdd = (item) => {
		if (cart.filter((i) => i.id == item.id).length > 0) {
			if (cart.find((i) => i.id == item.id)?.quantity >= 5) {
				return sendAlert("Your Cart is Full of That Item");
			}

			if (cart.find((i) => i.id == item.id)?.quantity >= item.qty && item.qty !== -1) {
				return sendAlert("Limited Stock Remaining");
			}

			setCart([
				...cart.map((i) => {
					if (i.id == item.id)
						return { ...i, quantity: i.quantity + 1 };
					else return i;
				}),
			]);
		} else {
			setCart([
				...cart,
				{
					...item,
					quantity: 1,
				},
			]);
		}
	};

	const onRemove = (item) => {
		if (cart.filter((i) => i.id == item.id).length > 0) {
			if (cart.find((i) => i.id == item.id)?.quantity > 1) {
				setCart([
					...cart.map((i) => {
						if (i.id == item.id)
							return { ...i, quantity: i.quantity - 1 };
						else return i;
					}),
				]);
			} else {
				setCart(cart.filter((i) => i.id !== item.id));
			}
		}
	};

	const onCheckout = async () => {
		if (submitting) return;

		try {
			setSubmitting(true);
			let res = await (
				await Nui.send('LSUNDG:Market:Checkout', cart)
			).json();
			setSubmitting(false);
			setCheckout(false);
			setCart(Array());
		} catch (err) {
			console.log(err);
			setSubmitting(false);
			setCheckout(false);
			setCart(Array());
		}
	};

	if (banned) {
		return <div className={classes.wrapper}>
			<div className={classes.emptyMsg}>Denied...</div>
		</div>
	};

	return (
		<div className={classes.wrapper}>
			<List className={classes.body}>
				{items.map((item, i) => {
					return (
						<ListItem key={`market-item-${i}`} divider>
							<ListItemText
								primary={item.itemData.label}
								secondary={Boolean(item.delayed) ? 'Not For Sale Yet' : `${item.price} $${item.coin}${item.qty > -1 ? ` | ${item.qty} In Stock` : ''}`}
							/>
							<ListItemSecondaryAction>
								{cart.filter((i) => i.id == item.id).length >
									0 && (
										<span>
											{
												cart.filter(
													(i) => i.id == item.id,
												)[0].quantity
											}
										</span>
									)}
								{cart.filter((i) => i.id == item.id).length > 0 && (
									<IconButton
										disabled={submitting}
										onClick={() => onRemove(item)}
										color="error"
									>
										<FontAwesomeIcon icon={['fas', 'minus']} />
									</IconButton>
								)}
								<IconButton
									disabled={submitting || (item.qty <= 0 && item.qty != -1)}
									onClick={() => onAdd(item)}
									color="success"
								>
									<FontAwesomeIcon icon={['fas', 'plus']} />
								</IconButton>
							</ListItemSecondaryAction>
						</ListItem>
					);
				})}

				{Boolean(cart) && cart.length > 0 && (
					<Fab
						color="primary"
						disabled={submitting}
						className={classes.fab}
						onClick={() => setCheckout(true)}
					>
						<FontAwesomeIcon icon={['fas', 'shopping-cart']} />
					</Fab>
				)}

				{Boolean(checkout) && (
					<Modal
						disabled={submitting}
						open={Boolean(checkout)}
						title="Purchase Items"
						closeLang="Cancel"
						closeColor="error"
						acceptLang={`Checkout`}
						acceptColor="success"
						maxWidth="xs"
						onClose={!submitting ? () => setCheckout(false) : null}
						onAccept={onCheckout}
					>
						{submitting && (
							<Loader static text="Submitting Order" />
						)}
						<List>
							{cart.map((item) => {
								return (
									<ListItem key={`checkout-${item.id}`}>
										<ListItemText
											primary={item.itemData.label}
											secondary={`${item.price * item.quantity
												} $${item.coin} | (${item.quantity
												} at ${item.price} $${item.coin
												}/each)`}
										/>
									</ListItem>
								);
							})}
						</List>
					</Modal>
				)}
			</List>
		</div>
	);
};
