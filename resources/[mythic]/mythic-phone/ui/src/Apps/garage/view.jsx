import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
	Paper,
	ListItem,
	ListItemText,
} from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Truncate from 'react-truncate';

import Nui from '../../util/Nui';
import { useHistory } from 'react-router';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#eb34de',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	subheader: {
		background: '#3a0436',
		fontSize: 14,
		padding: 15,
		lineHeight: '25px',
		height: 48,
	},
	content: {
		padding: 10,
		height: '84%',
		overflowX: 'hidden',
		overflowY: 'auto',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: '#1de9b6',
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	section: {
		padding: 10,
		'&:not(:last-of-type)': {
			marginBottom: 15,
		},
		'& h3': {
			borderBottom: `1px solid #eb34de`,
		},
	},
	status: {
		color: theme.palette.success.main,
		'&::before': {
			content: '" - "',
			color: theme.palette.text.main,
		},
		'&.spawned': {
			color: theme.palette.error.main,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const showAlert = useAlert();
	const { vin } = props.match.params;
	const garages = useSelector((state) => state.data.data.garages);
	const car = useSelector((state) => state.data.data.myVehicles).filter(
		(v) => v.VIN == vin,
	)[0];

	useEffect(() => {
		if (!Boolean(car)) {
			history.replace('/apps/garage');
		}
	}, [car]);

	const getGarage = () => {
		switch (car?.Storage?.Type) {
			case 0:
				return garages.impound;
			case 1:
				return garages[car.Storage.Id];
			case 2:
				return car.PropertyStorage;
		}
	};
	const garage = getGarage();

	const onGPS = async () => {
		try {
			let res = await (await Nui.send('Garage:TrackVehicle', vin)).json();
			showAlert(res ? 'Vehicle Marked on GPS' : 'Unable To Mark Vehicle');
		} catch (err) {
			console.log(err);
			showAlert('Unable To Mark Vehicle');
		}
	};

	if (!Boolean(car)) return null;
	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7} style={{ lineHeight: '50px' }}>
						<Truncate lines={1}>
							{car.Make} {car.Model}
						</Truncate>
					</Grid>
					<Grid item xs={5} style={{ textAlign: 'right' }}>
						<Tooltip title="Route To Vehicle">
							<span>
								<IconButton
									onClick={onGPS}
									className={classes.headerAction}
								>
									<FontAwesomeIcon
										icon={['fas', 'location-crosshairs']}
									/>
								</IconButton>
							</span>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
			<AppBar position="static" className={classes.subheader}>
				<Grid container style={{ textAlign: 'center' }}>
					<Grid item xs={6}>
						VIN: {car.VIN}
					</Grid>
					<Grid item xs={6}>
						Plate: {car.RegisteredPlate}
					</Grid>
				</Grid>
			</AppBar>
			<div className={classes.content}>
				<Paper className={classes.section}>
					<h3>Storage</h3>
					<div>
						{garage?.label ?? 'Unknown'}
						{Boolean(car.Spawned) ? (
							<span className={`${classes.status} spawned`}>
								Out
							</span>
						) : (
							<span className={classes.status}>
								{car.Storage.Type == 0
									? 'In Impound'
									: 'In Garage'}
							</span>
						)}
						{car.Storage.Type == 0 && (
							<List className={classes.data}>
								<ListItem>
									<ListItemText
										primary="Fine"
										secondary={`$${car.Storage.Fine}`}
									/>
								</ListItem>
								{Boolean(car.Storage.TimeHold) && (
									<ListItem>
										<ListItemText
											primary="Hold Release"
											secondary={
												<Moment
													className={
														classes.postedTime
													}
													interval={1000}
													fromNow
													date={
														+car.Storage.TimeHold
															.ExpiresAt * 1000
													}
												/>
											}
										/>
									</ListItem>
								)}
							</List>
						)}
					</div>
				</Paper>
				<Paper className={classes.section}>
					<h3>Diagnostics</h3>
					<div>
						<List className={classes.data}>
							<ListItem>
								<ListItemText
									primary="Mileage"
									secondary={`${car.Mileage} Miles`}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Body"
									secondary={`${Math.ceil(
										((car.Damage?.Body ?? 1000) / 1000) * 100,
									)}%`}
								/>
							</ListItem>
							<ListItem>
								<ListItemText
									primary="Engine"
									secondary={`${Math.ceil(
										((car.Damage?.Engine ?? 1000) / 1000) * 100,
									)}%`}
								/>
							</ListItem>
							{car.DamagedParts && Object.keys(car.DamagedParts).map((part) => {
								return (
									<ListItem key={part}>
										<ListItemText
											primary={part
												.split(
													/(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])/g,
												)
												.join(' ')}
											secondary={`${Math.ceil(
												car.DamagedParts[part],
											)}%`}
										/>
									</ListItem>
								);
							})}
						</List>
					</div>
				</Paper>
			</div>
		</div>
	);
};
