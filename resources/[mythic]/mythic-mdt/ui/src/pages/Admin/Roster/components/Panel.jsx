import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	Avatar,
	ListItem,
	ListItemText,
	Grid,
	List,
	TextField,
	Button,
	MenuItem,
	ButtonGroup,
	Select,
	Chip,
	FormControl,
	InputLabel,
	Box,
	OutlinedInput,
	DialogContent,
	DialogContentText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
//import _ from 'lodash';
import { toast } from 'react-toastify';

import { usePermissions } from '../../../../hooks';
import { Modal } from '../../../../components';
import Nui from '../../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		height: '100%',
		background: theme.palette.secondary.main,
	},
	inner: {
		padding: 10,
		background: theme.palette.secondary.dark,
		height: '100%',
		border: `3px inset ${theme.palette.border.divider}`,
	},
	avatar: {
		height: 250,
		width: 250,
		margin: 'auto',
		transition: 'filter ease-in 0.15s',
		'&.hoverable:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	field: {
		marginTop: 20,
	},
	hoverable: {
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ selectedJob, officer, onUpdate }) => {
	const classes = useStyles();
	const hasPerm = usePermissions();
	const user = useSelector((state) => state.app.user);
	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[selectedJob];
	const availablePermissions = useSelector(state => state.data.data.permissions);
	const availableQualifications = useSelector(state => state.data.data.qualifications);
	const governmentJobData = officer.Jobs?.find(j => j.Id == selectedJob);

	const [picture, setPicture] = useState(false);
	const [callsign, setCallsign] = useState(false);
	const [qualEdit, setQualEdit] = useState(false);
	const [jobEdit, setJobEdit] = useState(false);
	const [jobFire, setJobFire] = useState(false);
	const [pendingQuals, setPendingQual] = useState(Array());
	const [pJob, setPJob] = useState(governmentJobData);

	const [pending, setPending] = useState({
		picture: officer.Mugshot ?? '',
		callsign: Boolean(officer.Callsign) ? officer.Callsign : '',
	});

	useEffect(() => {
		if (governmentJobData) {
			setPicture(false);
			setCallsign(false);
			setPJob(officer.Jobs?.find(j => j.Id == selectedJob));
			setPendingQual(officer.Qualifications ?? Array());
			setPending({
				picture: officer.Mugshot ?? '',
				callsign: Boolean(officer.Callsign) ? officer.Callsign : '',
			});
		}
	}, [officer, selectedJob]);

	const onPrintBadge = async () => {
		try {
			await Nui.send('Close', {})
			Nui.send('PrintBadge', {
				SID: officer.SID,
				JobId: pJob?.Id,
			});
		} catch (err) {
			console.log(err);
		}
	}

	const onSavePicture = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: officer.SID,
					Key: 'Mugshot',
					Data: pending.picture,
				})
			).json();
			if (res) {
				toast.success('Profile Picture Updated');
				onUpdate();
				setPicture(false);
			} else toast.error('Unable to Update Profile Picture');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Profile Picture');
		}
	};

	const onSaveCallsign = async (e) => {
		e.preventDefault();
		if (officer.Callsign == pending.callsign) {
			toast.success('Callsign Updated');
			setCallsign(false);
			return;
		}

		try {
			let res = await (
				await Nui.send('CheckCallsign', pending.callsign)
			).json();

			if (res) {
				let res2 = await (
					await Nui.send('Update', {
						type: 'person',
						SID: officer.SID,
						Key: 'Callsign',
						Data: pending.callsign,
					})
				).json();
				if (res2) {
					toast.success('Callsign Updated');
					onUpdate();
					setCallsign(false);
				} else toast.error('Unable to Update Callsign');
			} else toast.error('Callsign Already Assigned');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Callsign');
		}
	};

	const onRemoveCallsign = async (e) => {
		e.preventDefault();
		if (!officer.Callsign) {
			toast.success('Callsign Updated');
			setCallsign(false);
			return;
		}

		try {
			let res2 = await (
				await Nui.send('Update', {
					type: 'person',
					SID: officer.SID,
					Key: 'Callsign',
					Data: false,
				})
			).json();
			if (res2) {
				toast.success('Callsign Removed');
				onUpdate();
				setCallsign(false);
			} else toast.error('Unable to Remove Callsign');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Remove Callsign');
		}
	};

	const onSaveJob = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('ManageEmployment', {
					SID: officer.SID,
					data: pJob,
				})
			).json();
			if (res) {
				toast.success('Employment Updated');
				onUpdate();
				setJobEdit(false);
			} else toast.error('Unable to Update Employment');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Employment');
		}
	};

	const onQualChange = (e) => {
		setPendingQual([...e.target.value]);
	};

	const onSaveQuals = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: officer.SID,
					Key: 'Qualifications',
					Data: pendingQuals,
				})
			).json();
			if (res) {
				toast.success('Qualifications Updated');
				onUpdate();
				setQualEdit(false);
			} else toast.error('Unable to Update Qualifications');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Qualifications');
		}
	};

	const fireEmployee = async () => {
		try {
			let res = await (
				await Nui.send('FireEmployee', {
					SID: officer.SID,
					JobId: 'police',
				})
			).json();

			if (res) {
				toast.success('Employee Terminated');
				onUpdate();
			} else toast.error('Unable to Fire Employee');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Fire Employee');
		}
	};

	return (
		<>
			{governmentJobData && pJob ? (
				<div className={classes.wrapper}>
					<Grid container style={{ height: '100%' }}>
						<Grid item xs={6}>
							<div className={classes.inner} style={{ marginRight: 10 }}>
								<Avatar
									className={`${classes.avatar} hoverable`}
									src={Boolean(officer?.Mugshot) ? officer?.Mugshot : ''}
									alt={officer.First}
									onClick={() => setPicture(true)}
								/>
								<List>
									<ListItem>
										<ListItemText
											primary="State ID"
											secondary={officer.SID}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Name"
											secondary={`${officer.First} ${officer.Last}`}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											onClick={() => setCallsign(true)}
											className={classes.hoverable}
											primary="Callsign"
											secondary={
												Boolean(officer.Callsign)
													? officer.Callsign
													: 'Not Set'
											}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Phone Number"
											secondary={officer.Phone}
										/>
									</ListItem>
								</List>
							</div>
						</Grid>
						<Grid item xs={6}>
							<div className={classes.inner} style={{ marginLeft: 10 }}>
								<List>
									<ListItem>
										<ButtonGroup fullWidth>
											<Button onClick={() => setJobEdit(true)}>
												Edit
											</Button>
											<Button disabled={officer.SID === user.SID} onClick={() => setJobFire(true)}>
												Fire
											</Button>
											<Button onClick={() => setQualEdit(true)}>
												Qual
											</Button>
											<Button onClick={() => onPrintBadge()} disabled={pJob?.Id !== 'police' && pJob?.Id !== 'government'}>
												Badge
											</Button>
										</ButtonGroup>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Department"
											secondary={pJob?.Workplace?.Name}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Rank"
											secondary={pJob?.Grade?.Name}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Qualifications"
											secondary={
												Boolean(officer.Qualifications) && officer.Qualifications.length > 0
												? officer.Qualifications
													.map(q => availableQualifications[q]?.name ?? 'Unknown')
													.join(', ')
												: 'No Qualifications'
											}
										/>
									</ListItem>
									<ListItem>
										<ListItemText
											primary="Permissions"
											secondary={
												Object.keys(jobData?.Workplaces.find(w => w.Id == pJob?.Workplace?.Id)?.Grades.find(g => g.Id == pJob?.Grade?.Id)?.Permissions)
													.map(k => availablePermissions[k]?.name ?? 'Unknown')
													.join(', ')
											}
										/>
									</ListItem>
								</List>
							</div>
						</Grid>
					</Grid>
					<Modal
						open={picture}
						maxWidth="sm"
						title="Update Profile Picture"
						onSubmit={onSavePicture}
						onClose={() => setPicture(false)}
					>
						<Avatar
							className={classes.avatar}
							src={pending.picture}
							alt={officer.First}
						/>
						<TextField
							fullWidth
							required
							label="Image URL"
							variant="outlined"
							name="picture"
							value={pending.picture}
							className={classes.field}
							onChange={(e) =>
								setPending({
									...pending,
									picture: e.target.value,
								})
							}
						/>
					</Modal>
					<Modal
						open={callsign}
						maxWidth="sm"
						title="Update Callsign"
						onSubmit={onSaveCallsign}
						deleteLang="Remove"
						onDelete={onRemoveCallsign}
						onClose={() => setCallsign(false)}
					>
						<TextField
							fullWidth
							required
							label="Callsign"
							helperText="3 characters long, NUMBERS ONLY"
							variant="outlined"
							name="callsign"
							value={pending.callsign}
							className={classes.field}
							inputProps={{
								pattern: '[0-9]{3}',
								maxLength: 3,
							}}
							onChange={(e) => {
								let v = e.target.value;
								if (v == '' || /[0-9\b]+$/.test(v))
									setPending({
										...pending,
										callsign: e.target.value,
									});
							}}
						/>
					</Modal>
					<Modal
						open={jobEdit}
						maxWidth="sm"
						title="Update Job"
						onSubmit={onSaveJob}
						onClose={() => setJobEdit(false)}
					>
						<TextField
							select
							fullWidth
							label="Department"
							className={classes.editorField}
							value={pJob?.Workplace?.Id}
							onChange={(e) =>
								setPJob({
									...pJob,
									Workplace: jobData.Workplaces?.find(
										(w) => w.Id == e.target.value,
									),
									Grade: jobData.Workplaces?.find(
										(w) => w.Id == e.target.value,
									)?.Grades.sort((a, b) => a.Level - b.Level)[0],
								})
							}
						>
							{jobData.Workplaces?.map((w) => (
								<MenuItem key={w.Id} value={w.Id}>
									{w.Name}
								</MenuItem>
							))}
						</TextField>
						<TextField
							select
							fullWidth
							label="Rank"
							className={classes.editorField}
							value={pJob.Grade?.Id}
							onChange={(e) =>
								setPJob({
									...pJob,
									Grade: jobData.Workplaces.find(
										(w) => w.Id == pJob.Workplace?.Id
									)?.Grades.find(
										(g) => g.Id == e.target.value
									),
								})
							}
						>
							{jobData.Workplaces.find(
								(w) => w.Id == pJob.Workplace?.Id
							)?.Grades.map(g => (
								<MenuItem
									key={g.Id}
									value={g.Id}
								>
									{g.Name}
								</MenuItem>
							))}
						</TextField>
					</Modal>
		
					<Modal
						open={qualEdit}
						maxWidth="sm"
						title="Update Qualifications"
						onSubmit={onSaveQuals}
						onClose={() => setQualEdit(false)}
					>
						<FormControl fullWidth className={classes.editorField}>
							<InputLabel>
								Qualifications
							</InputLabel>
							<Select
								multiple
								fullWidth
								value={pendingQuals}
								onChange={onQualChange}
								input={
									<OutlinedInput fullWidth label="Qualifications" />
								}
								renderValue={(selected) => (
									<Box style={{ display: 'flex', flexWrap: 'wrap' }}>
										{selected.map((value) => (
											<Chip
												key={value}
												label={availableQualifications[value]?.name ?? 'Unknown'}
												style={{ margin: 2 }}
											/>
										))}
									</Box>
								)}
							>
								{Object.keys(availableQualifications)
									.filter(qual => {
										const data = availableQualifications[qual];
										return (data && (!data.restrict || (data.restrict.job === myJob.Id && (!data.restrict.workplace || data.restrict.workplace == myJob?.Workplace?.Id))));
									}).map(qual => (
										<MenuItem key={`q-${qual}`} value={qual}>
											{availableQualifications[qual]?.name}
										</MenuItem>
									)
								)}
							</Select>
						</FormControl>
					</Modal>
					<Modal
						open={jobFire}
						maxWidth="sm"
						title={`Fire ${officer.First} ${officer.Last}?`}
						acceptLang="Yes"
						closeLang="No"
						onAccept={fireEmployee}
						onClose={() => setJobFire(false)}
					>
						<DialogContent>
							<DialogContentText>
								Are you sure you want to terminate{' '}
								{pJob?.Workplace?.Name} {pJob?.Grade?.Name}{' '}
								{officer.First} {officer.Last}?
							</DialogContentText>
						</DialogContent>
					</Modal>
				</div>
			) : null}
		</>
	);
};
