import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Avatar,
	IconButton,
	ListItem,
	ListItemAvatar,
	ListItemSecondaryAction,
	ListItemText,
	Tooltip,
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
	coinSecondary: {
		'& i': {
			color: '#b0e655',
		},
	},
	editorField: {
		marginBottom: 15,
	},
	na: {
		marginLeft: 5,
		color: theme.palette.error.light,
	},
}));

export default ({ coin, owned }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const [loading, setLoading] = useState(false);
	const [sending, setSending] = useState(false);
	const [selling, setSelling] = useState(null);

	const startSelling = () => {
		setSelling({
			Price: coin.Price,
			Quantity: 1,
		});
	};

	const onSell = async (e) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('SellCrypto', {
					Short: owned.Short,
					Quantity: selling.Quantity,
				})
			).json();

			if (!res.error) {
				showAlert(`Sold ${e.target.quantity.value} ${coin.Name}`);
				setSelling(null);
			} else {
				showAlert(`Unable to Sell ${coin.Name}`);
			}
		} catch (err) {
			console.log(err);
			showAlert(`Unable to Sell ${coin.Name}`);
		}
		setSelling(false);
		setLoading(false);
	};

	const onTransfer = async (e) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('TransferCrypto', {
					Short: owned.Short,
					Quantity: +e.target.quantity.value,
					Target: e.target.target.value,
				})
			).json();

			if (res) {
				showAlert(
					`Sent ${e.target.quantity.value} ${
						Boolean(coin) ? coin.Name : owned.Short
					}`,
				);
			} else {
				showAlert(
					`Unable to Transfer ${
						Boolean(coin) ? coin.Name : owned.Short
					}`,
				);
			}
		} catch (err) {
			console.log(err);
			showAlert(
				`Unable to Transfer ${Boolean(coin) ? coin.Name : owned.Short}`,
			);
		}
		setSending(false);
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
						Boolean(coin) ? (
							<span className={classes.coin}>
								{coin.Name} (
								<Tooltip title="Registered Coin">
									<small>
										<i>${coin.Short}</i>
									</small>
								</Tooltip>
								)
							</span>
						) : (
							<span className={classes.coin}>{owned.Short}</span>
						)
					}
					secondary={
						<span className={classes.coinSecondary}>
							You Own <i>{owned.Quantity}</i>{' '}
							{Boolean(coin) ? coin.Name : owned.Short} in Wallet{' '}
							<i>{player.CryptoWallet}</i>
						</span>
					}
				/>
				{owned.Quantity > 0 && (
					<ListItemSecondaryAction>
						{Boolean(coin) && Boolean(coin.Sellable) && (
							<Tooltip title={`Sell $${owned.Short}`}>
								<IconButton onClick={startSelling}>
									<FontAwesomeIcon
										icon={['fas', 'dollar-sign']}
									/>
								</IconButton>
							</Tooltip>
						)}
						<Tooltip title={`Send $${owned.Short}`}>
							<IconButton onClick={() => setSending(true)}>
								<FontAwesomeIcon
									icon={['fas', 'arrow-up-from-dotted-line']}
								/>
							</IconButton>
						</Tooltip>
					</ListItemSecondaryAction>
				)}
			</ListItem>
			{sending && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title={`Send $${owned.Short}`}
					onClose={() => setSending(false)}
					onAccept={onTransfer}
					submitLang="Send"
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Sending" />}
						<TextField
							fullWidth
							required
							label="Target Wallet ID"
							name="target"
							className={classes.editorField}
							disabled={loading}
							// type="tel"
							// isNumericString
							// customInput={TextField}
						/>
						<NumberFormat
							fullWidth
							required
							label="Quantity"
							name="quantity"
							className={classes.editorField}
							disabled={loading}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
					</>
				</Modal>
			)}
			{Boolean(selling) && (
				<Modal
					form
					formStyle={{ position: 'relative' }}
					open={true}
					title={`Sell $${owned.Short}`}
					onClose={() => setSelling(null)}
					onAccept={onSell}
					submitLang="Sell"
					closeLang="Cancel"
				>
					<>
						{loading && <Loader static text="Selling" />}
						<TextField
							fullWidth
							label="Price Per Unit"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(coin.Sellable)}
						/>
						<NumberFormat
							fullWidth
							required
							label="Quantity"
							name="quantity"
							className={classes.editorField}
							disabled={loading}
							value={selling.Quantity}
							onChange={(e) =>
								setSelling({
									...selling,
									Quantity: isNaN(e.target.value)
										? selling.Quantity
										: +e.target.value,
								})
							}
							isAllowed={({ floatValue }) =>
								floatValue >= 1 && floatValue <= owned.Quantity
							}
							type="tel"
							isNumericString
							customInput={TextField}
						/>
						<TextField
							fullWidth
							label="You Will Receive"
							disabled={true}
							className={classes.editorField}
							value={CurrencyFormat.format(
								coin.Sellable * selling.Quantity,
							)}
						/>
					</>
				</Modal>
			)}
		</>
	);
};
