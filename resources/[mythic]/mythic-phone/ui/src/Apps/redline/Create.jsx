import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Button,
	MenuItem,
	TextField,
	AccordionActions,
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Typography,
	List,
	ListItem,
	ListItemText,
	Divider,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';
import { Modal, Confirm } from '../../components';
import { TrackTypes } from './';

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
	btn: {
		marginBottom: 5,
	},
	details: {
		'& h3': {
			color: theme.palette.primary.main,
		},
	},
	detailsList: {
		padding: 10,
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
	creatorInput: {
		marginBottom: 5,
	},
	track: {
		background: theme.palette.secondary.dark,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const tracks = useSelector((state) => state.data.data.tracks);
	const createState = useSelector((state) => state.race.creator);

	const [expanded, setExpanded] = useState(null);
	const [saving, setSaving] = useState(false);
	const [deleteing, setDeleteing] = useState(null);
	const [resetting, setResetting] = useState(null);
	const onCreate = async () => {
		try {
			let res = await (await Nui.send('CreateTrack')).json();

			showAlert(res ? 'Creator Started' : 'Unable to Start Creator');
			if (res) {
				dispatch({
					type: 'RACE_STATE_CHANGE',
					payload: {
						state: {
							checkpoints: 0,
							distance: 0,
							type: 'lap',
						},
					},
				});
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Start Creator');
		}
	};

	const onCancel = async () => {
		try {
			Nui.send('StopCreator');
		} catch (err) {
			console.log(err);
		}
		dispatch({
			type: 'RACE_STATE_CHANGE',
			payload: { state: null },
		});
	};

	const onSave = async (e) => {
		e.preventDefault();
		try {
			let res = await (
				await Nui.send('FinishCreator', {
					name: e.target.name.value,
					type: e.target.type.value,
				})
			).json();
			showAlert(res ? 'Track Create' : 'Unable to Create Track');
			setSaving(false);
		} catch (err) {
			console.log(err);
			showAlert('Unable to Create Track');
			setSaving(false);
		}
	};

	const onDelete = async () => {
		try {
			let res = await (await Nui.send('DeleteTrack', deleteing)).json();
			setDeleteing(null);
			setExpanded(null);
			showAlert(res ? 'Track Deleted' : 'Unable to Delete Track');
		} catch (err) {
			console.log(err);
			setDeleteing(null);
			setExpanded(null);
			showAlert('Unable to Delete Track');
		}
	};

	const onReset = async () => {
		try {
			let res = await (
				await Nui.send('ResetTrackHistory', resetting)
			).json();
			setResetting(null);
			showAlert(
				res ? 'Track History Reset' : 'Unable to Reset Track History',
			);
		} catch (err) {
			console.log(err);
			setResetting(null);
			showAlert('Unable to Reset Track History');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.btnContainer}>
				{createState == null ? (
					<Button
						fullWidth
						className={classes.btn}
						variant="contained"
						color="primary"
						onClick={onCreate}
					>
						Create Map
					</Button>
				) : (
					<>
						<Button
							fullWidth
							className={classes.btn}
							variant="contained"
							color="primary"
							onClick={() => setSaving(true)}
						>
							Save Map
						</Button>
						<Button
							fullWidth
							className={classes.btn}
							variant="contained"
							color="inherit"
							onClick={onCancel}
						>
							Cancel Map Create
						</Button>
					</>
				)}
			</div>
			<div style={{ marginTop: 25 }}>
				{tracks.map((track, k) => {
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
									onClick={() => setResetting(track._id)}
								>
									Reset Lap History
								</Button>
								<Button
									size="small"
									onClick={() => setDeleteing(track._id)}
								>
									Delete Track
								</Button>
							</AccordionActions>
						</Accordion>
					);
				})}
			</div>

			<Confirm
				title="Delete Track?"
				open={deleteing != null}
				confirm="Yes"
				decline="No"
				onConfirm={onDelete}
				onDecline={() => setDeleteing(null)}
			/>
			<Confirm
				title="Reset Track History?"
				open={resetting != null}
				confirm="Yes"
				decline="No"
				onConfirm={onReset}
				onDecline={() => setResetting(null)}
			/>
			<Modal
				form
				open={saving}
				title="Create New Track"
				onClose={() => setSaving(false)}
				onAccept={onSave}
				submitLang="Save Track"
				closeLang="Cancel"
			>
				<TextField
					className={classes.creatorInput}
					fullWidth
					required
					label="Name"
					name="name"
					variant="outlined"
				/>
				<TextField
					select
					fullWidth
					required
					variant="outlined"
					label="Type"
					name="type"
					defaultValue="laps"
				>
					{Object.keys(TrackTypes).map((key) => {
						return (
							<MenuItem key={key} value={key}>
								{TrackTypes[key]}
							</MenuItem>
						);
					})}
				</TextField>
			</Modal>
		</div>
	);
};
