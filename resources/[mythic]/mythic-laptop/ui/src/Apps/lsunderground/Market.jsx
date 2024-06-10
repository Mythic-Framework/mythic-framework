import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import {
	Fab,
	IconButton,
	List,
	ListItem,
	ListItemSecondaryAction,
	ListItemText,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import ChopItem from './component/ChopItem';
import { Loader, Modal } from '../../components';
import Moment from 'react-moment';
import Nui from '../../util/Nui';

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
		right: 25,
	},
}));

export default ({ items }) => {
	const classes = useStyles();

	const [submitting, setSubmitting] = useState(false);
	const [cart, setCart] = useState(Array());
	const [checkout, setCheckout] = useState(false);

	const onAdd = (item) => {
		if (cart.filter((i) => i.id == item.id).length > 0) {
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

	return (
		<div className={classes.wrapper}>
			<List className={classes.body}>
				{items.map((item, i) => {
					return (
						<ListItem key={`market-item-${i}`} divider>
							<ListItemText
								primary={item.itemData.label}
								secondary={`${item.price} $${item.coin}`}
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
								<IconButton
									disabled={submitting}
									onClick={() => onAdd(item)}
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
						acceptLang={`Checkout: `}
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
											secondary={`${
												item.price * item.quantity
											} $${item.coin} | (${
												item.quantity
											} at ${item.price} $${
												item.coin
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
