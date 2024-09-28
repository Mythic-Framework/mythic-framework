import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { Avatar, Button, Grid, TextField } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';
import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';
import { Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	contract: {
		padding: 10,
		background: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.border.divider}`,
		textAlign: 'center',
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
	contractClass: {
		width: 80,
		height: 80,
		margin: 'auto',
		marginBottom: 15,
	},
	vehicleLabel: {
		fontSize: 18,
		color: theme.palette.text.main,
	},
	contractOwner: {
		fontSize: 14,
		color: theme.palette.text.alt,
	},
	contractPrice: {
		fontSize: 14,
		color: theme.palette.success.main,

		'& small': {
			marginLeft: 4,

			'&::before': {
				content: '"("',
				marginRight: 2,
			},
			'&::after': {
				content: '")"',
				marginLeft: 2,
			},
		},
	},
	contractExpiration: {
		fontSize: 12,
	},
}));

export default ({ contract, repLevel }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alert = useAlert();

	const disabledContracts = useSelector(state => state.data.data.disabledBoostingContracts);
	const [accepting, setAccepting] = useState(false);
	const [loading, setLoading] = useState(false);

	const acceptContract = async (c, isScratch) => {
		setLoading(true);
		setAccepting(false);

		try {
			const res = await (await Nui.send("Boosting:AcceptContract", {
				...c,
				scratch: isScratch,
			})).json();

			if (res?.success) {
				alert('Request Sent to Team Leader');
			} else {
				if (res?.message) {
					alert(res.message);
				} else {
					alert('Failed to Accept Contract');
				}
			}
		} catch (e) {
			console.log(e);
		}

		setLoading(false);
	};

	const [transferContract, setTransferContract] = useState(null);

	const startTransferContract = () => {
		setTransferContract({
			alias: '',
		});
	};

	const onTransferContract = async (e) => {
		e.preventDefault();
		setLoading(true);

		try {
			const data = {
				...transferContract,
				id: contract.id,
			}
			setTransferContract(null);

			const res = await (await Nui.send("Boosting:TransferContract", data)).json();
			if (res) {
				alert('Contract Transferred Successfully');
			} else {
				alert('Failed to Transfer Contract');
			}
		} catch (e) {
			console.log(e);
			alert('Failed to Transfer Contract');
		}

		setLoading(false);
	};

	const declineContract = async (c) => {
		setLoading(true);

		try {

			const res = await (await Nui.send("Boosting:DeclineContract", {
				...c
			})).json();
			if (res) {
				alert('Contract Declined Successfully');
			} else {
				alert('Failed to Decline Contract');
			}
		} catch (e) {
			console.log(e);
			alert('Failed to Decline Contract');
		}

		setLoading(false);
	};

	const isDisabled = disabledContracts?.includes(contract.id);
	const isDisabledByRep = (repLevel < contract.vehicle.classLevel && !contract.vehicle.rewarded);
	//console.log("BC Disabled", contract.vehicle.label, isDisabled, isDisabledByRep);

	return (
		<Grid item xs={2}>
			<Grid container className={classes.contract}>
				<Grid item xs={12}>
					<Avatar
						className={`${classes.contractClass} ${contract.vehicle.class}`}
					>
						{contract.vehicle.class}
					</Avatar>
				</Grid>
				<Grid item xs={12} className={classes.vehicleLabel}>
					{contract.vehicle.label}
				</Grid>
				<Grid item xs={12} className={classes.contractOwner}>
					{contract.owner.Alias}
				</Grid>
				<Grid item xs={12} className={classes.contractPrice}>
					<span>
						{contract.prices.standard.price}
						{' $'}{contract.prices.standard.coin}
					</span>
					{Boolean(contract.prices.scratch) && (
						<small>
							{contract.prices.scratch.price}
							{' $'}{contract.prices.scratch.coin}
						</small>
					)}
				</Grid>
				<Grid item xs={12} className={classes.contractExpiration}>
					Expires: <Moment fromNow unix date={contract.expires} />
				</Grid>
				{!accepting ? (
					<>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="success"
								onClick={() => setAccepting(true)}
								disabled={isDisabled || loading || isDisabledByRep}
							>
								Accept Contract
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="warning"
								disabled={isDisabled || loading || Boolean(transferContract)}
								onClick={startTransferContract}
							>
								Transfer Contract
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="info"
								//disabled={isDisabled || loading}
								disabled
							>
								List On Market
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="error"
								disabled={isDisabled || loading}
								onClick={() => declineContract(contract)}
							>
								Decline Contract
							</Button>
						</Grid>
					</>
				) : (
					<>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="info"
								onClick={() => acceptContract(contract, false)}
							>
								Standard ({contract.prices.standard.price} $
								{contract.prices.standard.coin})
							</Button>
						</Grid>
						{Boolean(contract.prices.scratch) && (
							<Grid item xs={12} style={{ marginTop: 15 }}>
								<Button
									fullWidth
									variant="contained"
									color="warning"
									onClick={() => acceptContract(contract, false)}
								>
									VIN Scratch ({contract.prices.scratch.price}{' '}
									${contract.prices.scratch.coin})
								</Button>
							</Grid>
						)}
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="error"
								onClick={() => setAccepting(false)}
							>
								Cancel
							</Button>
						</Grid>
					</>
				)}
			</Grid>
			<Modal
				open={Boolean(transferContract)}
				title="Transferring Contract"
				closeLang="Cancel"
				closeColor="error"
				maxWidth="md"
				submitLang="Transfer"
				onSubmit={onTransferContract}
				onClose={() => setTransferContract(null)}
			>
				{transferContract && (
					<TextField
						fullWidth
						required
						label="Target"
						name="alias"
						className={classes.editorField}
						value={transferContract.alias}
						onChange={(e) => setTransferContract({
							...transferContract,
							alias: e.target.value
						})}
						helperText="The alias of who you want to transfer the contract to."
					/>
				)}
			</Modal>
		</Grid>
	);
};
