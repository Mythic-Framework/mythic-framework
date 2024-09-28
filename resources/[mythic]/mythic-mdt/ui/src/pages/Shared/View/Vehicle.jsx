import React, { useState, useEffect } from 'react';
import { Alert, Grid, IconButton, List, ListItem, ListItemText } from '@mui/material';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { toast } from 'react-toastify';
import Moment from 'react-moment';
import moment from 'moment';
import { useParams } from 'react-router';

import Nui from '../../../util/Nui';
import { Loader } from '../../../components';
import VehicleFlag, { FlagTypes } from './components/VehicleFlag';
import VehicleStrike from './components/VehicleStrike';
import FlagForm from './components/FlagForm';
import StrikeForm from './components/StrikeForm';

import { VehicleTypes } from '../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
		position: 'relative',
	},
	link: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
		'&:not(:last-of-type)::after': {
			color: theme.palette.text.main,
			content: '", "',
		},
	},
	newLineStuff: {
		whiteSpace: 'pre-wrap',
	}
}));

export default ({ match }) => {
	const classes = useStyles();
	const params = useParams();
	const govJobs = useSelector((state) => state.data.data.governmentJobs);

	const [adding, setAdding] = useState(false);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [vehicle, setVehicle] = useState(null);

	const [addingStrike, setAddingStrike] = useState(false);

	useEffect(() => {
		const fetch = async () => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('View', {
						type: 'vehicle',
						id: params.id,
					})
				).json();

				if (res) setVehicle(res);
				else toast.error('Unable to Load');
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load');
				setErr(true);
			}

			setLoading(false);
		};
		fetch();
	}, []);

	const addFlag = async (flag) => {
		if (vehicle.Flags && vehicle.Flags.find((f) => f.Type == flag.Type)) {
			toast.error('Unable to Create Flag');
			return;
		}

		setLoading(true);
		try {
			let res = await (
				await Nui.send('Create', {
					type: 'vehicle-flag',
					parent: vehicle.VIN,
					plate: vehicle.RegisteredPlate,
					doc: flag,
				})
			).json();

			if (res) {
				const currentFlags = vehicle.Flags ?? [];
				setVehicle({
					...vehicle,
					Flags: [...currentFlags, flag],
				});
			} else toast.error('Unable to Create Flag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Create Flag');
		}

		setLoading(false);
		setAdding(false);
	};

	const addStrike = async (strike) => {
		let currentStrikes = vehicle.Strikes ?? Array();
		if (currentStrikes.length >= 15) {
			toast.error('Unable to Add Strike');
			return;
		};

		currentStrikes.push(strike);
		setLoading(true);
		try {
			let res = await (
				await Nui.send('Update', {
					type: 'vehicle-strikes',
					VIN: vehicle.VIN,
					strikes: currentStrikes,
				})
			).json();

			if (res) {
				setVehicle({
					...vehicle,
					Strikes: currentStrikes,
				});
			} else toast.error('Unable to Add Strike');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Add Strike');
		}

		setLoading(false);
		setAddingStrike(false);
	};

	const dismissStrike = async (id) => {
		let currentStrikes = vehicle.Strikes ?? Array();

		currentStrikes.splice(id, 1)

		setLoading(true);
		try {
			let res = await (
				await Nui.send('Update', {
					type: 'vehicle-strikes',
					VIN: vehicle.VIN,
					strikes: currentStrikes,
				})
			).json();

			if (res) {
				setVehicle({
					...vehicle,
					Strikes: currentStrikes,
				});
			} else toast.error('Unable to Remove Strike');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Remove Strike');
		}

		setLoading(false);
		setAddingStrike(false);
	};

	const dismissFlag = async (id, removeFlag) => {
		try {
			let res = await (
				await Nui.send('Delete', {
					type: 'vehicle-flag',
					parent: vehicle.VIN,
					plate: removeFlag ? vehicle.RegisteredPlate : false,
					id: id,
				})
			).json();

			if (res) {
				setVehicle({
					...vehicle,
					Flags: vehicle.Flags.filter((f) => f.Type !== id),
				});
			} else toast.error('Unable to Create Flag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Create Flag');
		}
		setAdding(false);
	};

	const getOrganizationType = (jobId) => {
		if (govJobs.includes(jobId)) {
			return 'Government';
		};
	};

	return (
		<div className={classes.wrapper}>
			{loading || (!Boolean(vehicle) && !err) ? (
				<Loader static text="Loading" />
			) : Boolean(!err) ? (
				<>
					<Grid container spacing={2}>
						<Grid item xs={6}>
							<List>
								<ListItem>
									<ListItemText
										primary="Vehicle Type"
										secondary={VehicleTypes?.[vehicle?.Type] ?? 'Vehicle'}
									/>
								</ListItem>
								<ListItem>
									<ListItemText primary="VIN" secondary={vehicle.VIN} />
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Make / Model"
										secondary={`${vehicle.Make} ${vehicle.Model}`}
									/>
								</ListItem>
								<ListItem>
									<ListItemText primary="Registered Plate" secondary={vehicle.RegisteredPlate} />
								</ListItem>
								{vehicle.Owner?.Type === 0 ? (
									<ListItem>
										<ListItemText
											primary="Registered Owner"
											secondary={
												<Link
													className={classes.link}
													to={`/search/people/${vehicle.Owner?.Id}`}
												>
													{`${vehicle.Owner?.Person?.First} ${vehicle.Owner.Person?.Last}`}
												</Link>
											}
										/>
									</ListItem>
								) : (
									<ListItem>
										<ListItemText
											primary="Registered Owner"
											secondary={`${getOrganizationType(vehicle.Owner?.Id)} - ${
												vehicle.Owner?.JobName ?? 'Unknown'
											}`}
										/>
									</ListItem>
								)}
								<ListItem>
									<ListItemText
										primary="Registration Date"
										secondary={
											vehicle.RegistrationDate ? (
												<Moment date={vehicle.RegistrationDate} unix format="LL" />
											) : (
												'Unknown'
											)
										}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Impounded"
										secondary={vehicle.Storage?.Type === 0 ? 'Yes' : 'No'}
									/>
								</ListItem>
							</List>
						</Grid>
						<Grid item xs={6}>
							<ListItem>
								<ListItemText
									primary={
										<span>
											Flags{' '}
											<IconButton style={{ fontSize: 16 }} onClick={() => setAdding(true)}>
												<FontAwesomeIcon icon={['fas', 'plus']} />
											</IconButton>
										</span>
									}
									secondary={vehicle.Flags?.length == 0 ? 'No Flags' : null}
								/>
							</ListItem>
							{vehicle.Flags?.length > 0 && (
								<ListItem>
									<List
										style={{
											maxHeight: 650,
											height: '100%',
											overflowY: 'auto',
											overflowX: 'hidden',
										}}
									>
										{vehicle.Flags.map((f) => {
											return <VehicleFlag key={`flag-${f.value}`} flag={f} onDismiss={dismissFlag} />;
										})}
									</List>
								</ListItem>
							)}
							<ListItem>
								<ListItemText
									primary={
										<span>
											Vehicle Strikes{' '}
											<IconButton style={{ fontSize: 16 }} onClick={() => setAddingStrike(true)}>
												<FontAwesomeIcon icon={['fas', 'plus']} />
											</IconButton>
										</span>
									}
									secondary={vehicle.Strikes?.length == 0 ? 'No Flags' : null}
								/>
							</ListItem>
							{vehicle.Strikes?.length > 0 && (
								<ListItem>
									<List
										style={{
											maxHeight: 650,
											height: '100%',
											overflowY: 'auto',
											overflowX: 'hidden',
										}}
									>
										{vehicle.Strikes.map((v, k) => {
											return <VehicleStrike key={`strike-${k}`} index={k} strike={v} onDismiss={dismissStrike} />;
										})}
									</List>
								</ListItem>
							)}
							<ListItem>
								<ListItemText
									primary={'Ownership History'}
									secondary={<span className={classes.newLineStuff}>{
										vehicle.OwnerHistory ? vehicle.OwnerHistory.map(o => {
											if (o.Type == 0) {
												if (o.First) {
													return `Transferred From State ID: ${o.Id} (${o.First} ${o.Last}) on ${moment(o.Time * 1000).format('LLLL')}`;
												} else {
													return `Transferred From State ID: ${o.Id}`;
												}
											} else {
												return `Transferred From Organization`;
											}
										}).concat('; \n') : 'No Previous Owners'}
									</span>}
								/>
							</ListItem>
							{vehicle.PreviousPlates && <ListItem>
								<ListItemText
									primary={'License Plate History'}
									secondary={
										vehicle.PreviousPlates ? vehicle.PreviousPlates.map(o => {
											return <span>{`${o.oldPlate} -> ${o.newPlate} on ${moment(o.time * 1000).format('LLLL')}`}<br></br></span>
										}) 
										: 'No Previous Plates'
									}
								/>
							</ListItem>}
						</Grid>
					</Grid>

					<FlagForm open={adding} flagTypes={FlagTypes} onSubmit={addFlag} onClose={() => setAdding(false)} />
					<StrikeForm open={addingStrike} onSubmit={addStrike} onClose={() => setAddingStrike(false)} />
				</>
			) : (
				<Alert variant="outlined" severity="error">
					Invalid Vehicle Identification Number
				</Alert>
			)}
		</div>
	);
};
