import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Avatar,
	IconButton,
	ListItem,
	ListItemAvatar,
	ListItemSecondaryAction,
	ListItemText,
	TextField,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import NumberFormat from 'react-number-format';

import Nui from '../../../util/Nui';
import { Modal, Loader } from '../../../components';
import { CurrencyFormat } from '../../../util/Parser';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	icon: {
		background: '#b0e655',
	},
	coin: {
		'& small': {
			fontSize: 12,
			color: '#b0e655',
		},
	},
	editorField: {
		marginBottom: 15,
	},
}));

export default ({ coin }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const [loading, setLoading] = useState(false);
	const [buying, setBuying] = useState(false);

	const startBuying = () => {
		setBuying({
			Price: coin.Price,
			Quantity: 1,
		});
	};

	const onBuy = async (e) => {
		setLoading(true);
		try {
			let res = await (await Nui.send('BuyCrypto', {
				Short: coin.Short,
				Quantity: buying.Quantity,
			})).json();

			if (!res.error) {
				showAlert(`Purchased ${coin.Name}`);
				setBuying(null);
			} else {
				showAlert(`Unable to Buy ${coin.Name}`);
			}
		} catch (err) {
			console.log(err);
			showAlert(`Unable to Buy ${coin.Name}`);
		}
		setBuying(null);
		setLoading(false);
	};

	return (
		<>
			<ListItem>
				<ListItemAvatar>
					<Avatar className={classes.icon}>
						<FontAwesomeIcon icon={['fab', 'bitcoin']} />
					</Avatar>
				</ListItemAvatar>
				<ListItemText
					primary={
						<span className={classes.coin}>
							{coin.Name} (
							<small>
								<i>${coin.Short}</i>
							</small>
							)
						</span>
					}
					secondary={
						coin.Price > 0
							? `Buying Price: $${coin.Price}/coin`
							: null
					}
				/>
				<ListItemSecondaryAction>
					<IconButton onClick={startBuying}>
						<FontAwesomeIcon icon={['fas', 'bag-shopping']} />
					</IconButton>
				</ListItemSecondaryAction>
			</ListItem>
			{Boolean(buying) && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title={`Buy $${coin.Short}`}
					onClose={() => setBuying(null)}
					onAccept={onBuy}
					submitLang={`Buy ${coin.Name}`}
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Buying" />}
						<TextField
							fullWidth
							label="Price Per Unit"
							disabled={true}
							className={classes.editorField}
							value={buying.Price}
							value={CurrencyFormat.format(buying.Price)}
						/>
						<NumberFormat
							fullWidth
							required
							label="Quantity"
							className={classes.editorField}
							value={buying.Quantity}
							disabled={loading}
							onChange={(e) =>
								setBuying({
									...buying,
									Quantity: +e.target.value,
								})
							}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
						<TextField
							fullWidth
							label="You Will Pay"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(
								buying.Price * buying.Quantity,
							)}
						/>
					</>
				</Modal>
			)}
		</>
	);
};
