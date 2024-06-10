import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Button,
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Typography,
	List,
	ListItem,
	ListItemText,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';

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
	owned: {
		color: 'gold',
		marginLeft: 5,
	},
}));

export default (props) => {
	const classes = useStyles();
	const alias = useSelector((state) => state.data.data.player.Callsign);
	const tracks = useSelector((state) => state.data.data.tracks_pd);
	const races = useSelector((state) => state.pdRace.races)
		.filter((r) => r.state == 2)
		.sort((a, b) => b.time - a.time);

	const [selected, setSelected] = useState(null);
	const [expanded, setExpanded] = useState(null);

	return (
		<div className={classes.wrapper}>
			<div>
				{races.length > 0 ? (
					races.map((race, k) => {
						let track = tracks.filter(
							(t) => t._id == race.track,
						)[0];

						if (!track) return null;
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
												secondary={`${race.host}`}
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
												primary="Participants"
												secondary={
													Object.keys(race.racers)
														.length > 0
														? `${
																Object.keys(
																	race.racers,
																).length
														  } Participants`
														: null
												}
											/>
										</ListItem>
										<ListItem>
											<List>
												<ListItem>
													<Button
														variant="contained"
														color="primary"
														onClick={() =>
															setSelected(race)
														}
													>
														View Participants
													</Button>
												</ListItem>
											</List>
										</ListItem>
									</List>
								</AccordionDetails>
							</Accordion>
						);
					})
				) : (
					<div className={classes.emptyMsg}>No Recent Trials</div>
				)}

				<Modal
					open={selected != null}
					title="Race Results"
					onClose={() => setSelected(null)}
				>
					{selected != null && (
						<List>
							{Object.keys(selected.racers)
								.filter((r) => selected.racers[r].finished)
								.sort(
									(a, b) =>
										selected.racers[a]?.place -
										selected.racers[b]?.place,
								)
								.map((name) => {
									let duration = moment.duration(
										selected.racers[name].fastest.lapEnd -
											selected.racers[name].fastest
												.lapStart,
									);
									return (
										<ListItem>
											<ListItemText
												primary={
													<span>
														{`#${selected.racers[name].place} ${name}`}
														{Boolean(
															selected.racers[
																name
															].isOwned,
														) && (
															<FontAwesomeIcon
																className={
																	classes.owned
																}
																icon={[
																	'fas',
																	'award',
																]}
															/>
														)}
													</span>
												}
												secondary={
													<div>
														<div>
															Fastest Lap:{' '}
															{`${String(
																duration.hours(),
															).padStart(
																2,
																'0',
															)}:${String(
																duration.minutes(),
															).padStart(
																2,
																'0',
															)}:${String(
																duration.seconds(),
															).padStart(
																2,
																'0',
															)}:${String(
																duration.milliseconds(),
															).padStart(
																3,
																'0',
															)}`}
														</div>
													</div>
												}
											/>
										</ListItem>
									);
								})}
							{Object.keys(selected.racers)
								.filter((r) => !selected.racers[r].finished)
								.map((name) => {
									return (
										<ListItem>
											<ListItemText
												primary={`${name}`}
												secondary="DNF"
											/>
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
