import React, { useState, useEffect } from 'react';
import { Alert, Grid, IconButton, List, ListItem, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { toast } from 'react-toastify';
import Moment from 'react-moment';
import { useParams } from 'react-router';

import Nui from '../../../util/Nui';
import { Loader } from '../../../components';
import FirearmFlag, { FlagTypes } from './components/FirearmFlag';
import FlagForm from './components/FlagForm';
import { usePerson } from '../../../hooks';

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
}));

export default ({ match }) => {
	const classes = useStyles();
	const formatPerson = usePerson();
	const params = useParams();

	const [adding, setAdding] = useState(false);
	const [loading, setLoading] = useState(false);
	const [err, setErr] = useState(false);
	const [firearm, setFirearm] = useState(null);

	useEffect(() => {
		const fetch = async () => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('View', {
						type: 'firearm',
						id: params.id,
					})
				).json();

				if (res) setFirearm(res);
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
		if (firearm.Flags && firearm.Flags.find((f) => f.value == flag.value)) {
			toast.error('Unable to Create Flag');
			return;
		}

		setLoading(true);
		try {
			let res = await (
				await Nui.send('Create', {
					type: 'firearm-flag',
					parentId: firearm._id,
					doc: flag,
				})
			).json();

			if (res) {
				const currentFlags = firearm.Flags ?? [];
				setFirearm({
					...firearm,
					Flags: [...currentFlags, flag],
				});
			} else toast.error('Unable to Create Flag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Create Flag');
		}
		setAdding(false);
		setLoading(false);
	};

	const dismissFlag = async (id) => {
		setLoading(true);
		try {
			let res = await (
				await Nui.send('Delete', {
					type: 'firearm-flag',
					parentId: firearm._id,
					id: id,
				})
			).json();

			if (res) {
				const currentFlags = firearm.Flags ?? [];
				setFirearm({
					...firearm,
					Flags: currentFlags.filter((f) => f.Type != id),
				});
			} else toast.error('Unable to Delete Flag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Delete Flag');
		}
		setAdding(false);
		setLoading(false);
	};

	return (
		<div className={classes.wrapper}>
			{loading || !Boolean(firearm) ? (
				<Loader static text="Loading" />
			) : Boolean(!err) ? (
				<>
					<Grid container spacing={2}>
						<Grid item xs={6}>
							<List>
								<ListItem>
									<ListItemText primary="Firearm" secondary={firearm.Model ?? 'Unknown'} />
								</ListItem>
								<ListItem>
									<ListItemText primary="Serial Number" secondary={firearm.Serial} />
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Registered Owner"
										secondary={
											Boolean(firearm.Owner?.Company) ? (
												<span>{firearm.Owner?.Company}</span>
											) : (
												<Link
													className={classes.link}
													to={`/search/people/${firearm.Owner?.SID}`}
												>
													{formatPerson(
														firearm.Owner?.First,
														firearm.Owner?.Last,
														false,
														firearm.Owner?.SID,
														true,
														true,
														true,
													)}
												</Link>
											)
										}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Date of Purchase"
										secondary={<Moment date={firearm.PurchaseTime} format="LLL" />}
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
									secondary={firearm.Flags?.length == 0 ? 'No Flags' : null}
								/>
							</ListItem>
							{firearm.Flags?.length > 0 && (
								<ListItem>
									{firearm.Flags.map((f, k) => {
										return <FirearmFlag key={`flag-${k}`} flag={f} onDismiss={dismissFlag} />;
									})}
								</ListItem>
							)}
						</Grid>
					</Grid>

					<FlagForm open={adding} flagTypes={FlagTypes} onSubmit={addFlag} onClose={() => setAdding(false)} />
				</>
			) : (
				<Alert variant="outlined" severity="error">
					Invalid Firearm Serial Number
				</Alert>
			)}
		</div>
	);
};
