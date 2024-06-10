import React, { useEffect, useState } from 'react';
import {
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert, useCompanyUpgrades } from '../../../hooks';
import { Confirm } from '../../../components';
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
}));

export default ({ upgrade }) => {
	const classes = useStyles();
	const sendAlert = useAlert();
	const hasUpgrade = useCompanyUpgrades();
	const isOwned = hasUpgrade(upgrade.value);

	const [buying, setBuying] = useState(false);

	const onPurchase = async () => {
		try {
			let res = await (await Nui.send('PurchaseUpgrade', upgrade)).json();

			if (!res.error) {
			} else {
				switch (res.code) {
					case 1:
						sendAlert('Unable to Purchase Upgrade');
						break;
					case 2:
						sendAlert('Not Authorized');
						break;
					case 3:
						sendAlert('Unable to Purchase Upgrade');
						break;
					case -1:
						sendAlert('Not Yet Implemented');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Purchase Upgrade');
		}
		setBuying(false);
	};

	return (
		<div className={classes.wrapper}>
			<ListItem className={classes.item}>
				<ListItemText
					primary={upgrade.label}
					secondary={isOwned ? 'Owned' : `$${upgrade.price}`}
				/>
				{!isOwned && (
					<ListItemSecondaryAction>
						<IconButton edge="end" onClick={() => setBuying(true)}>
							<FontAwesomeIcon icon={['fas', 'money-check-dollar-pen']} />
						</IconButton>
					</ListItemSecondaryAction>
				)}
			</ListItem>
			<Confirm
				title={`Purchase ${upgrade.label}?`}
				open={buying}
				confirm="Yes"
				decline="No"
				onConfirm={onPurchase}
				onDecline={() => setBuying(false)}
			>
				<p>
					Purchases may not be refunded, additional costs may be
					associated with using this purchase.
				</p>
			</Confirm>
		</div>
	);
};
