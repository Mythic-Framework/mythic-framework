import React, { useEffect, useState } from 'react';
import {
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../../hooks';
import { Modal } from '../../../components';
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

export default ({ property, type, upgrade, setLoading, onRefresh }) => {
	const classes = useStyles();
	const sendAlert = useAlert();

	const [buying, setBuying] = useState(false);

    const current = upgrade.levels?.[(property?.upgrades?.[type] ?? 1) - 1];
    const next = upgrade.levels?.[(property?.upgrades?.[type] ?? 1)];

	const onPurchase = async () => {
        setLoading(true);
        setBuying(false);
		try {
			let res = await (await Nui.send('PurchasePropertyUpgrade', { upgrade: type, id: property.id })).json();

			if (res) {
                sendAlert('Upgrade Purchased');
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

	return (
		<div className={classes.wrapper}>
			<ListItem className={classes.item}>
				<ListItemText
					primary={`${current.name}`}
					secondary={`${current.info}${next ? '' : ' - Max Upgrade Reached'}`}
				/>
                <ListItemSecondaryAction>
                    <IconButton edge="end" onClick={() => setBuying(true)} disabled={!next}>
                        <FontAwesomeIcon icon={['fas', 'turn-up']} />
                    </IconButton>
                </ListItemSecondaryAction>
			</ListItem>
            <Modal
                form
				open={buying}
				title={`Purchase ${next?.name}?`}
				onAccept={onPurchase}
                submitLang="Purchase"
				onClose={() => setBuying(false)}
			>
                <p>{next?.name} - {next?.info}</p>
				<p>Upgrade Cost: ${next?.price?.toLocaleString("en-US")}</p>
				<p><i>Money will be taken from your main bank account.</i></p>
				<p>
					Are you sure you want to upgrade? Purchases may not be refunded.
				</p>
			</Modal>
		</div>
	);
};
