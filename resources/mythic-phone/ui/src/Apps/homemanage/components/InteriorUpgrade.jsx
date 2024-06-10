import React, { useEffect, useState } from 'react';
import {
	List,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	IconButton,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../../hooks';
import { Modal, Confirm } from '../../../components';
import Nui from '../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-child': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	list: {
		position: 'inherit',
	},
	items: {
		height: 400,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	item2: {
		padding: '10px 5px 10px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

const calculatePrice = (currentPrice, price, cost) => {
	if (currentPrice > price) {
		return cost;
	} else {
		return cost + (price - currentPrice);
	}
}

export default ({ property, type, upgrade, setLoading, onRefresh }) => {
	const classes = useStyles();
	const sendAlert = useAlert();

	const [buying, setBuying] = useState(false);
	const [purchase, setPurchase] = useState(null);

    const current = upgrade.levels.find(l => l.id == property?.upgrades?.interior);

	const onConfirmPurchase = (name, int) => {
		setPurchase({
			name,
			int,
		});
	}

	const onPurchase = async (int) => {
		setPurchase(false);
		setLoading(true);
		setBuying(false);

		try {
			let res = await (await Nui.send('PurchasePropertyInterior', { int, id: property.id })).json();

			if (res) {
				sendAlert('Interior Upgraded');
				onRefresh();
			} else {
				sendAlert('Unable to Purchase Upgrade');
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Purchase Upgrade');
		}

		setLoading(false);
	};

	const onPreview = (e, int) => {
		e.stopPropagation();
		Nui.send('PreviewPropertyInterior', { int });
	};

	return (
		<div className={classes.wrapper}>
			<ListItem className={classes.item}>
				<ListItemText
					primary={`Interior`}
					secondary={`${current.name} ($${current.price?.toLocaleString('en-US')})`}
				/>
                <ListItemSecondaryAction>
					<IconButton edge="end" onClick={() => setBuying(true)}>
						<FontAwesomeIcon icon={['fas', 'bag-shopping']} />
					</IconButton>
                </ListItemSecondaryAction>
			</ListItem>
            <Modal
				open={buying}
				title={`Upgrade Interior`}
				onClose={() => setBuying(false)}
			>
                <List className={classes.items}>
					<p>Upgrading the Interior Will <b>RESET</b> All Placed Furniture!</p>
					<p><i>Money will be taken from your main bank account.</i></p>
					{upgrade.levels.sort((a, b) => a.price - b.price).map(int => {
						return <ListItem className={classes.item}>
							<ListItemText
								primary={int.name}
								secondary={`$${calculatePrice(current.price, int.price, 50000).toLocaleString('en-US')} - ${int.info?.description}`}
							/>
							<ListItemSecondaryAction>
								<IconButton
									onClick={(e) => onPreview(e, int.id)}
									disabled={int.id == current.id}
								>
									<FontAwesomeIcon
										icon={['fas', 'eye']}
									/>
								</IconButton>
								<IconButton
									onClick={(e) => onConfirmPurchase(int.name, int.id)}
									disabled={int.id == current.id}
								>
									<FontAwesomeIcon
										icon={['fas', 'bag-shopping']}
									/>
								</IconButton>
							</ListItemSecondaryAction>
						</ListItem>
					})}
				</List>
			</Modal>
			<Confirm
				title={`Purchase Interior ${purchase?.name}`}
				open={purchase != null}
				confirm="Yes"
				decline="No"
				onConfirm={() => onPurchase(purchase?.int)}
				onDecline={() => setPurchase(null)}
			/>
		</div>
	);
};
