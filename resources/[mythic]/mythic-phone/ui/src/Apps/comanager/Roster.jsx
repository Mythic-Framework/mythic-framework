import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router';
import {
	List,
	AppBar,
	Grid,
	IconButton,
	ListItem,
	ListItemText,
	TextField,
	MenuItem,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Truncate from 'react-truncate';
import NumberFormat from 'react-number-format';
import moment from 'moment';

import Nui from '../../util/Nui';
import { useAlert, useJobPermissions } from '../../hooks';
import { Modal, Confirm } from '../../components';
import Workplace from './components/Workplace';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	avatar: {
		backgroundColor: theme.palette.primary.main,
	},
	editorField: {
		marginBottom: 15,
	},
	owner: {
		fontSize: 14,
		color: 'gold',
		marginRight: 5,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

// const parseDutyTime = (dutyTime, job) => {
// 	if (dutyTime && dutyTime[job]) {
// 		const afterTime = moment().subtract(7, 'days').unix();
// 		let timeWorked = 0;
// 		for (const [key, value] of Object.entries(dutyTime[job])) {
// 			if (key >= afterTime) {
// 				timeWorked += value;
// 			}
// 		}

// 		if (timeWorked > 0) {
// 			return moment.duration(timeWorked, "minutes").humanize();
// 		} else {
// 			return '0 minutes';
// 		}
	
// 	} else {
// 		return '0 minutes';
// 	}
// }

// const parseLastDutyTime = (lastDuty, job) => {
// 	if (lastDuty && lastDuty[job]) {
// 		return `${moment(lastDuty[job] * 1000).format('LLL')} (${moment(lastDuty[job] * 1000).fromNow()})`;
// 	} else {
// 		return 'Never';
// 	}
// }

export default ({ refreshRoster, loading, jobData, playerJob }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const sendAlert = useAlert();
	const hasPerm = useJobPermissions();
	const player = useSelector((state) => state.data.data.player);

	const home = () => {
		history.goBack();
	};

	let initalPendingHire;
	if (jobData?.Workplaces) {
		initalPendingHire = {
			SID: '',
			Job: {
				Id: jobData.Id,
				Workplace: jobData?.Workplaces[0],
				Grade: jobData?.Workplaces[0]?.Grades[0],
			},
		};
	} else {
		initalPendingHire = {
			SID: '',
			Job: {
				Id: jobData.Id,
				Workplace: null,
				Grade: jobData?.Grades[0],
			},
		};
	}

	const isOwner = player.SID == jobData?.Owner;
	const manageCompany = hasPerm('JOB_MANAGEMENT', jobData.Id) || isOwner;
	const hireEmployee = hasPerm('JOB_HIRE', jobData.Id) || isOwner;
	const fireEmployee = hasPerm('JOB_FIRE', jobData.Id) || isOwner;

	const [viewing, setViewing] = useState(false);
	const [quitConf, setQuitConf] = useState(false);

	const [hiring, setHiring] = useState(null);
	const [firing, setFiring] = useState(false);

	const onHire = async (e) => {
		e.preventDefault();

		if (hiring.edit) {
			try {
				let res = await (
					await Nui.send('UpdateEmployee', hiring)
				).json();

				if (res.success) {
					refreshRoster();
				} else sendAlert('Unable To Update Employee');
			} catch (err) {
				console.log(err);
				sendAlert('Unable To Update Employee');
			}
		} else {
			try {
				if (hiring.SID != player.SID) {
					let res = await (
						await Nui.send('HireEmployee', hiring)
					).json();

					if (res.success) {
						sendAlert('Employment Offer Sent');
					} else {
						switch (res.code) {
							default:
							case 'ERROR':
								sendAlert('Unable To Hire Employee');
								break;
							case 'INVALID_PERMISSIONS':
								sendAlert('Not Authorized');
								break;
							case 'INVALID_TARGET':
								sendAlert('Invalid or Offline State ID');
								break;
							case 'OUTSTANDING_OFFER':
								sendAlert('Person Has An Outstanding Employment Offer');
								break;
						}
					}
				} else {
					sendAlert('You Cannot Hire Yourself, Dumbass');
				}
			} catch (err) {
				console.log(err);
				sendAlert('Unable To Hire Employee');
			}
		}
		setHiring(null);
	};

	const onFire = async () => {
		try {
			let res = await (await Nui.send('FireEmployee', hiring)).json();
			if (res.success) {
				sendAlert(`${hiring.First} ${hiring.Last} Has Been Fired`);
				refreshRoster();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					default:
					case 'ERROR':
						sendAlert(`Unable To Fire ${hiring.First} ${hiring.Last}`);
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert(`Unable To Fire ${hiring.First} ${hiring.Last}`);
		}
		setFiring(false);
		setHiring(null);
	};

	const onQuit = async () => {
		if (isOwner) return;
		try {
			let res = await (await Nui.send('QuitJob', {
				JobId: jobData.Id,
			})).json();

			if (res) {
				sendAlert('Congrats, You Quit');
			} else sendAlert('Unable To Quit Job');
			setQuitConf(false);
			setViewing(false);
		} catch (err) {
			console.log(err);
			sendAlert('Unable To Quit Job');
		}
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7}>
						<Truncate lines={1}>{jobData.Name}</Truncate>
					</Grid>
					<Grid item xs={5} className={classes.headerAction}>
						<Tooltip title="My Employment Details">
							<IconButton onClick={() => setViewing(true)}>
								<FontAwesomeIcon icon={['fas', 'user']} />
							</IconButton>
						</Tooltip>
						{hireEmployee && (
							<Tooltip title="Hire New Employee">
								<IconButton
									onClick={() => setHiring(initalPendingHire)}
								>
									<FontAwesomeIcon icon={['fas', 'plus']} />
								</IconButton>
							</Tooltip>
						)}
						<Tooltip title="Force Refresh">
							<IconButton onClick={() => refreshRoster()} disabled={loading}>
								<FontAwesomeIcon
									className={`fa ${loading ? 'fa-spin' : ''}`}
									icon={['fas', 'arrows-rotate']}
								/>
							</IconButton>
						</Tooltip>
						<Tooltip title="Home">
							<IconButton onClick={home}>
								<FontAwesomeIcon icon={['fas', 'house']} />
							</IconButton>
						</Tooltip>
					</Grid>
				</Grid>
				<Modal
					open={viewing}
					title="My Employment"
					onClose={() => setViewing(null)}
					onDelete={
						!isOwner
							? () => setQuitConf(true)
							: null
					}
					deleteLang="Quit"
				>
					<List>
						<ListItem>
							<ListItemText
								primary="Job"
								secondary={playerJob.Name}
							/>
						</ListItem>
						{isOwner && <ListItem>
							<ListItemText
								primary="Owner"
								secondary={"You Are the Owner"}
							/>
						</ListItem>}
						{playerJob.Workplace && <ListItem>
							<ListItemText
								primary="Workplace"
								secondary={playerJob.Workplace.Name}
							/>
						</ListItem>}
						<ListItem>
							<ListItemText
								primary="Grade"
								secondary={playerJob.Grade.Name}
							/>
						</ListItem>
					</List>
				</Modal>
				{!isOwner && (
					<Confirm
						title={`Quit ${jobData.Name}?`}
						open={quitConf}
						confirm="Yes"
						decline="No"
						onConfirm={onQuit}
						onDecline={() => setQuitConf(false)}
					/>
				)}
			</AppBar>
				{jobData.Workplaces ? 
					jobData.Workplaces.map((workplace) => {
						return (
							<Workplace
								key={workplace.Id}
								workplace={workplace}
								jobData={jobData}
								playerJob={playerJob}
								onEmployeeClick={(e) =>
									setHiring({ ...e, SID: e.SID, Job: e.JobData, edit: true })
								}
							/>
						);
					}) 
					: <Workplace
						workplace={false}
						jobData={jobData}
						playerJob={playerJob}
						onEmployeeClick={(e) =>
							setHiring({ ...e, SID: e.SID, Job: e.JobData, edit: true })
						}
					/>
				}

				{hireEmployee && Boolean(hiring) && (
					<Modal
						form
						open={hiring != null}
						title={
							hiring?.edit
								? `Update Employment`
								: `Hire Employee`
						}
						onClose={() => setHiring(null)}
						onAccept={onHire}
						onDelete={
							hiring?.edit && (manageCompany || fireEmployee) && hiring?.SID != player.SID
							? () => setFiring(true)
							: null
						}
						deleteLang="Fire"
					>
						{Boolean(hiring) && (
							<>
								<NumberFormat
									fullWidth
									required
									label="State ID"
									name="sid"
									className={classes.editorField}
									value={hiring.SID}
									disabled={hiring?.edit}
									onChange={(e) =>
										setHiring({
											...hiring,
											SID: e.target.value,
										})
									}
									type="tel"
									isNumericString
									customInput={TextField}
								/>
								{jobData.Workplaces && <TextField
									select
									fullWidth
									label="Workplace"
									className={classes.editorField}
									value={hiring.Job.Workplace.Id}
									disabled={!manageCompany}
									onChange={(e) =>
										setHiring({
											...hiring,
											Job: {
												...hiring.Job,
												Workplace:
													jobData.Workplaces.filter(
														(w) => w.Id == e.target.value,
													)[0],
												Grade: jobData.Workplaces.filter(
													(w) => w.Id == e.target.value,
												)[0].Grades[0],
											},
										})
									}
								>
									{jobData.Workplaces.map((w, k) => (
										<MenuItem key={w.Id} value={w.Id}>
											{w.Name}
										</MenuItem>
									))}
								</TextField>}
								{jobData.Workplaces ?
									<TextField
										select
										fullWidth
										label="Grade"
										className={classes.editorField}
										value={hiring.Job.Grade.Id}
										onChange={(e) =>
											setHiring({
												...hiring,
												Job: {
													...hiring.Job,
													Grade: jobData.Workplaces.filter(
														(w) => w.Id == hiring.Job.Workplace.Id,
													)[0].Grades.filter(
														(g) => g.Id == e.target.value,
													)[0],
												},
											})
										}
									>
										{jobData.Workplaces.filter(
											(w) =>
												w.Id == hiring.Job.Workplace.Id,
										)[0]
											.Grades.sort(
												(a, b) => a.Level - b.Level,
											)
											.map((g, k) => (
												<MenuItem
													key={g.Id}
													value={g.Id}
													disabled={!isOwner && playerJob.Grade.Level <= g.Level}
												>
													{g.Name}
												</MenuItem>
											))}
									</TextField>
									: <TextField
										select
										fullWidth
										label="Grade"
										className={classes.editorField}
										value={hiring.Job.Grade.Id}
										onChange={(e) =>
											setHiring({
												...hiring,
												Job: {
													...hiring.Job,
													Grade: jobData.Grades.filter((g) =>
														g.Id == e.target.value,
													)[0],
												},
											})
										}
									>
										{jobData.Grades.sort((a, b) => a.Level - b.Level)
											.map((g, k) => (
												<MenuItem
													key={g.Id}
													value={g.Id}
													disabled={!isOwner && playerJob.Grade.Level <= g.Level}
												>
													{g.Name}
												</MenuItem>
											))}
									</TextField>
								}
							</>
						)}
					</Modal>
				)}
				{Boolean(hiring) && hiring?.edit && (
					<Confirm
						title={`Fire ${hiring.First} ${hiring.Last}?`}
						open={firing}
						confirm="Yes"
						decline="No"
						onConfirm={onFire}
						onDecline={() => setFiring(false)}
					/>
				)}
		</div>
	);
};
