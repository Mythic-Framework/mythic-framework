import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Divider,
	Button,
	AccordionActions,
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Typography,
	List,
	ListItem,
	ListItemText,
	TextField,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';

import { Modal, CurrencyInput } from '../../components';
import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';
import { TrackTypes } from '.';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	heading: {
		fontSize: theme.typography.pxToRem(15),
		flexBasis: '33.33%',
		flexShrink: 0,
	},
	secondaryHeading: {
		fontSize: theme.typography.pxToRem(15),
		color: theme.palette.text.secondary,
	},
	track: {
		background: theme.palette.secondary.dark,
	},
	creatorInput: {
		marginBottom: 10,
	},
	buttons: {
		width: '100%',
		display: 'flex',
		margin: 'auto',
	},
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.warning.main,
		'&:hover': {
			backgroundColor: `${theme.palette.warning.main}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const tracks = useSelector((state) => state.data.data.tracks_pd);
	const inRace = useSelector((state) => state.pdRace.inRace);
	const alias = useSelector((state) => state.data.data.player.Callsign);

	const [expanded, setExpanded] = useState(null);
	const [selected, setSelected] = useState(null);
	const [records, setShowRecords] = useState(null);

	const [createState, setCreateState] = useState({
		name: '',
		host: alias,
		buyin: '',
		laps: 1,
		dnf_start: '',
		dnf_time: '',
		countdown: '5',
	});

	const onCreateChange = (e) => {
		setCreateState({
			...createState,
			[e.target.name]: e.target.value,
		});
	};

	const onCreate = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('CreateRacePD', {
					...createState,
					track: selected._id,
				})
			).json();
			setSelected(null);
			showAlert(!res?.failed ? 'Race Created' : 'Unable to Create');
			if (!res?.failed) {
				dispatch({
					type: 'PD_I_RACE',
					payload: {
						state: true,
					},
				});
			}
		} catch (err) {
			console.log(err);
			setSelected(null);
			showAlert('Unable To Create');
		}
	};

	const addZero = (v) => {
		return (v < 10 ? '0' : '') + Math.floor(v);
	};

	return (
		<div className={classes.wrapper}>
			{tracks.length > 0 ? (
				tracks.map((track, k) => {
					return (
						<Accordion
							key={`track-${k}`}
							className={classes.track}
							expanded={expanded === k}
							onChange={
								expanded === k
									? () => setExpanded(null)
									: () => setExpanded(k)
							}
						>
							<AccordionSummary
								expandIcon={
									<FontAwesomeIcon
										icon={['fas', 'chevron-down']}
									/>
								}
							>
								<Typography className={classes.heading}>
									{track.Name}
								</Typography>
								<Typography
									className={classes.secondaryHeading}
								>
									{track.Distance}
								</Typography>
							</AccordionSummary>
							<AccordionDetails>
								<List>
									<ListItem>
										<ListItemText
											primary="Name"
											secondary={track.Name}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Type"
											secondary={TrackTypes[track.Type]}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Distance"
											secondary={track.Distance}
										/>
									</ListItem>
								</List>
							</AccordionDetails>
							<Divider />
							<AccordionActions>
								<Button
									size="small"
									color="primary"
									onClick={() => setShowRecords(track)}
								>
									Lap Records
								</Button>
								{/* <Button size="small" disabled={inRace}>
									Practice Track
								</Button> */}
								<Button
									size="small"
									color="primary"
									disabled={inRace}
									onClick={() => setSelected(track)}
								>
									Create
								</Button>
							</AccordionActions>
						</Accordion>
					);
				})
			) : (
				<div className={classes.emptyMsg}>No Tracks Available</div>
			)}

			<Modal
				open={Boolean(records)}
				title="Lap Records"
				onClose={() => setShowRecords(null)}
				closeLang="Close"
			>
				{Boolean(records) && (
					<List>
						{Boolean(records.Fastest) &&
						records.Fastest.length > 0 ? (
							records.Fastest.map((lap, i) => {
								let duration = moment.duration(
									lap.lapEnd - lap.lapStart,
								);
								return (
									<ListItem key={`${records._id}-${i}`}>
										<ListItemText
											primary={`#${i + 1} ${
												lap.alias
											} - ${lap.car}`}
											secondary={`${String(
												duration.hours(),
											).padStart(2, '0')}:${String(
												duration.minutes(),
											).padStart(2, '0')}:${String(
												duration.seconds(),
											).padStart(2, '0')}:${String(
												duration.milliseconds(),
											).padStart(3, '0')}`}
										/>
									</ListItem>
								);
							})
						) : (
							<ListItem>
								<ListItemText primary="No Lap Records" />
							</ListItem>
						)}
					</List>
				)}
			</Modal>
			<Modal
				form
				open={Boolean(selected)}
				title="Create"
				onClose={() => setSelected(null)}
				onAccept={onCreate}
				submitLang="Create"
				closeLang="Cancel"
			>
				{Boolean(selected) && (
					<>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="Host"
							name="host"
							variant="outlined"
							disabled
							value={alias}
							required
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="Track"
							name="track"
							variant="outlined"
							disabled
							value={selected.Name}
							required
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="Event Name"
							name="name"
							variant="outlined"
							value={createState.name}
							onChange={onCreateChange}
							required
							inputProps={{
								maxLength: 32,
							}}
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="# of Laps"
							name="laps"
							variant="outlined"
							type="number"
							disabled={selected.Type == 'p2p'}
							value={createState.laps}
							onChange={onCreateChange}
							required
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="Countdown"
							name="countdown"
							variant="outlined"
							type="number"
							value={createState.countdown}
							onChange={onCreateChange}
							required
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="DNF Start"
							name="dnf_start"
							variant="outlined"
							type="number"
							value={createState.dnf_start}
							onChange={onCreateChange}
							required
						/>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="DNF Time"
							name="dnf_time"
							variant="outlined"
							type="number"
							value={createState.dnf_time}
							onChange={onCreateChange}
							required
						/>
					</>
				)}
			</Modal>
		</div>
	);
};
