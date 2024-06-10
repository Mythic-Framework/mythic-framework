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
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { Modal } from '../../components';

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
		'& span': {
			marginLeft: 5,
			fontSize: 12,
			color: theme.palette.text.alt,
			'&::before': {
				content: '"("',
			},
			'&::after': {
				content: '")"',
			},
		},
	},
	track: {
		background: theme.palette.secondary.dark,
	},
	youindic: {
		color: 'gold',
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

	const cid = useSelector((state) => state.data.data.player.ID);
	const alias = useSelector((state) => state.data.data.player.Alias?.redline);
	const inRace = useSelector((state) => state.race.inRace);
	const tracks = useSelector((state) => state.data.data.tracks);
	const races = useSelector((state) => state.race.races)
		.filter(
			(r) =>
				r.state != -1 &&
				r.state != 2 &&
				Boolean(tracks.filter((t) => t._id == r.track)[0]),
		)
		.sort((a, b) => b.time - a.time);

	const [selected, setSelected] = useState(null);
	const [expanded, setExpanded] = useState(null);

	const joinRace = async (index) => {
		try {
			let res = await (await Nui.send('JoinRace', index)).json();
			showAlert(res ? 'Joined Race' : 'Unable to Join Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: true,
					},
				});
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Join Race');
		}
	};

	const leaveRace = async (index) => {
		try {
			let res = await (await Nui.send('LeaveRace', index)).json();
			showAlert(res ? 'Left Race' : 'Unable to Leave Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: false,
					},
				});
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Leave Race');
		}
	};

	const cancelRace = async (index) => {
		try {
			let res = await (await Nui.send('CancelRace', index)).json();
			showAlert(res ? 'Cancelled Race' : 'Unable to Cancel Race');
			if (res) {
				dispatch({
					type: 'I_RACE',
					payload: {
						state: false,
					},
				});
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Cancel Race');
		}
	};

	const startRace = async (index) => {
		try {
			let res = await (await Nui.send('StartRace', index)).json();
			showAlert(!res?.failed ? 'Starting Race' : res.message);
		} catch (err) {
			console.log(err);
			showAlert('Unable to Start Race');
		}
	};

	const endRace = async (index) => {
		try {
			let res = await (await Nui.send('EndRace', index)).json();
			showAlert(res ? 'Race Ended' : 'Unable to End Race');
		} catch (err) {
			console.log(err);
			showAlert('Unable to End Race');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div>
				{races.length > 0 ? (
					races.map((race, k) => {
						let track = tracks.filter(
							(t) => t._id == race.track,
						)[0];
						return (
							<Accordion
								key={`race-${k}`}
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
										{race.name}
										{race.racers[alias] != null && (
											<span className={classes.youindic}>
												*
											</span>
										)}
									</Typography>
									<Typography
										className={classes.secondaryHeading}
									>
										{track.Name}
										<span>
											{race.state == 0
												? 'Setup'
												: 'In-Progress'}
										</span>
									</Typography>
								</AccordionSummary>
								<AccordionDetails>
									<List>
										<ListItem>
											<ListItemText
												primary="Name"
												secondary={race.name}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Host"
												secondary={`${race.host} (${race.host_src})`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Track"
												secondary={`${track.Name} (${track.Distance})`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="# of Laps"
												secondary={race.laps}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Joined Racers"
												secondary={
													Object.keys(race.racers)
														.length > 0
														? `${
																Object.keys(
																	race.racers,
																).length
														  } Racers`
														: null
												}
											/>
										</ListItem>
										<ListItem>
											<List>
												{Object.keys(race.racers)
													.length > 0 ? (
													<ListItem>
														<Button
															variant="contained"
															color="primary"
															onClick={() =>
																setSelected(
																	race,
																)
															}
														>
															View Racers
														</Button>
													</ListItem>
												) : (
													<ListItem>
														<ListItemText primary="No Racers Have Joined" />
													</ListItem>
												)}
											</List>
										</ListItem>
									</List>
								</AccordionDetails>
								<Divider />
								<AccordionActions>
									{race.host_id == cid ? (
										race.state == 0 ? (
											<>
												<Button
													size="small"
													color="primary"
													onClick={() =>
														cancelRace(race._id)
													}
												>
													Cancel Race
												</Button>
												<Button
													size="small"
													color="primary"
													onClick={() =>
														startRace(race._id)
													}
												>
													Start Race
												</Button>
											</>
										) : (
											<Button
												size="small"
												color="primary"
												onClick={() =>
													endRace(race._id)
												}
											>
												End Race
											</Button>
										)
									) : (
										<>
											{race.racers[alias] != null ? (
												<Button
													size="small"
													disabled={
														race.host_id == cid
													}
													onClick={() =>
														leaveRace(race._id)
													}
												>
													Leave Race
												</Button>
											) : (
												<Button
													size="small"
													disabled={
														inRace ||
														race.state != 0
													}
													onClick={() =>
														joinRace(race._id)
													}
												>
													Join Race
												</Button>
											)}
										</>
									)}
								</AccordionActions>
							</Accordion>
						);
					})
				) : (
					<div className={classes.emptyMsg}>No Pending Races</div>
				)}

				<Modal
					open={selected != null}
					title="Joined Racers"
					onClose={() => setSelected(null)}
				>
					{selected != null && (
						<List>
							{Object.keys(selected.racers).map((name) => {
								return (
									<ListItem>
										<ListItemText primary={name} />
									</ListItem>
								);
							})}
						</List>
					)}
				</Modal>
			</div>
		</div>
	);
};
