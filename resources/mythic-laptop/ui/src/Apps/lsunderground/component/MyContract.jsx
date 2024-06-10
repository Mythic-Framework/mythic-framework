import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import { Avatar, Button, Grid } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

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

export default ({ contract }) => {
	const classes = useStyles();

	const [accepting, setAccepting] = useState(false);

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
						{contract.prices.standard.coin}
					</span>
					{Boolean(contract.prices.scratch) && (
						<small>
							{contract.prices.scratch.price}
							{contract.prices.scratch.coin}
						</small>
					)}
				</Grid>
				<Grid item xs={12} className={classes.contractExpiration}>
					Expires: <Moment fromNow date={contract.expires} />
				</Grid>
				{!accepting ? (
					<>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="success"
								onClick={() => setAccepting(true)}
							>
								Accept Contract
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button
								fullWidth
								variant="contained"
								color="warning"
							>
								Transfer Contract
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button fullWidth variant="contained" color="info">
								List On Market
							</Button>
						</Grid>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button fullWidth variant="contained" color="error">
								Decline Contract
							</Button>
						</Grid>
					</>
				) : (
					<>
						<Grid item xs={12} style={{ marginTop: 15 }}>
							<Button fullWidth variant="contained" color="info">
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
		</Grid>
	);
};
