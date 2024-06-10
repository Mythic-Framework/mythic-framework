import React, { useEffect, useState } from 'react';
import {
	List,
	ListItem,
	ListItemText,
	Grid,
	Alert,
	Button,
	Avatar,
	TextField,
	InputAdornment,
	IconButton,
	ButtonGroup,
	FormGroup,
	FormControlLabel,
	Switch,
	Chip,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import moment from 'moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link, useNavigate } from 'react-router-dom';
import { useParams } from 'react-router';

import { Loader, Modal } from '../../../components';
import Nui from '../../../util/Nui';
import { useSelector } from 'react-redux';

import { usePermissions } from '../../../hooks';

const VehicleIcons = ['car-side', 'ship', 'plane-engines'];

import { ReportTypes } from '../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	mugshot: {
		margin: 'auto',
		marginBottom: 25,
		height: 250,
		width: 250,
		border: `3px solid ${theme.palette.primary.main}8a`,
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
	item: {
		margin: 4,
		transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		margin: 7.5,
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.8)',
			cursor: 'pointer',
		},
	},
	jobChip: {
		backgroundColor: '#00497d',
	},
	vehicleChip: {
		backgroundColor: '#81449c',
	},
	charge: {
		margin: 4,
		'&.type-1': {
			backgroundColor: theme.palette.info.main,
		},
		'&.type-2': {
			backgroundColor: theme.palette.warning.main,
		},
		'&.type-3': {
			backgroundColor: theme.palette.error.main,
		},
	},
	editorField: {
		marginTop: 10,
	},
	items: {
		maxHeight: '95%',
		height: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	itemWrapper: {
		padding: '5px 2.5px 5px 5px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

const getLicenceStatus = (data) => {
	let status = 'Active';
	if (data?.Suspended) {
		status = 'Suspended';
	}

	if (data?.Points && data?.Points > 0) {
		status += ` - ${data?.Points} Points`;
	}

	return status;
};

export default ({ match }) => {
	const classes = useStyles();
	const history = useNavigate();
	const hasPermission = usePermissions();
	const params = useParams();
	const myJob = useSelector((state) => state.app.govJob);

	const govJobs = useSelector((state) => state.data.data.governmentJobs);
	const _w = useSelector((state) => state.data.data.warrants);

	const [err, setErr] = useState(false);
	const [loading, setLoading] = useState(false);
	const [person, setPerson] = useState(null);
	const [warrants, setWarrants] = useState(Array());
	const [prevConvictions, setPrevConvictions] = useState(null);
	const [parole, setParole] = useState(null);

	const [editFlags, setEditFlags] = useState(false);
	const [editLawyer, setEditLawyer] = useState(false);
	const [editSuspended, setEditSuspended] = useState(false);
	const [clearRecord, setClearRecord] = useState(false);
	const [mugshot, setMugshot] = useState(false);
	const [pendingMugshot, setPendingMugshot] = useState('');

	const [viewingLogs, setViewingLogs] = useState(false);

	const isGovernment = (jobs) => {
		if (jobs && jobs?.length > 0 && govJobs?.length > 0) {
			return jobs?.find((j) => govJobs.includes(j.Id));
		}
	};

	useEffect(() => {
		if (Boolean(person)) setWarrants(_w.filter((w) => w.suspect.SID == person.data.SID && w.state == 'active'));
	}, [person]);

	const onCreate = () => {
		history(`/create/report?id=${person.data.SID}`);
	};

	const onSearch = () => {
		history(`/search/reports?search=${encodeURIComponent(`${person.data.First} ${person.data.Last}`)}`);
	};

	const onEditMugshot = () => {
		setPendingMugshot(person.data.Mugshot);
		setMugshot(true);
	};

	const onMugshotSave = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: person.data.SID,
					Key: 'Mugshot',
					Data: pendingMugshot,
				})
			).json();
			if (res) {
				setPerson({
					...person,
					data: {
						...person.data,
						Mugshot: pendingMugshot,
					},
				});
				setMugshot(false);
				setPendingMugshot('');
				toast.success('Mugshot Updated');
			}
		} catch (err) {
			console.log(err);
		}
	};

	const onFlagsSave = async (e) => {
		e.preventDefault();

		let t = {
			Violent: e.target.violent.checked,
			Gang: e.target.gang.value,
		};
		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: person.data.SID,
					Key: 'Flags',
					Data: t,
				})
			).json();

			if (res) {
				setPerson({
					...person,
					data: {
						...person.data,
						Flags: t,
					},
				});
				setEditFlags(false);
				toast.success('Flags Updated');
			}
		} catch (err) {
			console.log(err);
			setEditFlags(false);
		}
	};

	const onLawyerSave = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'person',
					SID: person.data.SID,
					Key: 'Attorney',
					Data: e.target.attorney.checked,
				})
			).json();

			if (res) {
				setPerson({
					...person,
					data: {
						...person.data,
						Attorney: e.target.attorney.checked,
					},
				});
				setEditLawyer(false);
				toast.success('Certification Updated');
			}
		} catch (err) {
			console.log(err);
			setEditLawyer(false);
		}
	};

	const onSuspensionSave = async (e) => {
		e.preventDefault();

		let unSuspending = {};

		Object.keys(person.data.Licenses).map((license) => {
			const licenseData = person.data.Licenses[license];
			if (licenseData?.Suspended && !e.target[license].checked) {
				unSuspending[license] = true;
			}
		})

		try {
			let res = await (
				await Nui.send('RevokeSuspension', {
					SID: person.data.SID,
					unsuspend: unSuspending,
				})
			).json();

			if (res) {
				setPerson({
					...person,
					data: {
						...person.data,
						Licenses: res,
					},
				});
				setEditSuspended(false);
				toast.success('License Suspensions Updated');
			} else {
				setEditSuspended(false);
				toast.error('Failed to Update License Suspensions');
			}
		} catch (err) {
			console.log(err);
			setEditSuspended(false);
		}
	};

	const onRecordClear = async (e) => {
		e.preventDefault();

		if (!e.target.confirm.checked) {
			setClearRecord(false);
			return toast.error('Failed to Clear Record');
		}

		try {
			let res = await (
				await Nui.send('ClearRecord', {
					SID: person.data.SID,
				})
			).json();

			if (res) {
				setPrevConvictions(null);

				setClearRecord(false);
				toast.success('Criminal Record Cleared');
			} else {
				setClearRecord(false);
				toast.error('Failed to Clear Record');
			}
		} catch (err) {
			console.log(err);
			setClearRecord(false);
		}
	};

	const onVehicleClick = (VIN) => {
		history(`/search/vehicles/${VIN}`);
	};

	useEffect(() => {
		const fetch = async () => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('View', {
						type: 'person',
						id: params.id,
					})
				).json();

				if (res) {
					setPerson(res);
					if (res?.convictions?.Charges && res?.convictions?.Charges.length > 0) {
						const chargeList = [];

						res?.convictions?.Charges.forEach((charge) => {
							const existingCharge = chargeList.findIndex((c) => c._id == charge._id);
							if (existingCharge > -1) {
								const existingData = chargeList[existingCharge];

								chargeList.splice(existingCharge, 1, {
									...charge,
									count: charge.count + existingData.count,
								});
							} else chargeList.push(charge);
						});

						setPrevConvictions(chargeList);
					} else setPrevConvictions(null);

					if (res?.Parole && res.Parole?.end > Date.now()) {
						const monthsRemaining = Math.ceil(moment.duration(res.end - Date.now(), 'ms').asMinutes());
						setParole(monthsRemaining);
					} else setParole(null);
				} else toast.error('Unable to Load');
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load');
				setErr(true);
			}
			setLoading(false);
		};
		fetch();
	}, []);

	const incidentReport = ReportTypes.find((rt) => rt.value == 0);
	const canCreateReport = hasPermission(incidentReport?.requiredCreatePermission, false);

	return (
		<div>
			{loading || (!person && !err) ? (
				<div className={classes.wrapper} style={{ position: 'relative' }}>
					<Loader static text="Loading" />
				</div>
			) : err ? (
				<Grid className={classes.wrapper} container>
					<Grid item xs={12}>
						<Alert variant="outlined" severity="error">
							Invalid State ID
						</Alert>
					</Grid>
				</Grid>
			) : (
				<>
					<Grid className={classes.wrapper} container spacing={2}>
						<Grid item xs={12}>
							<ButtonGroup fullWidth>
								<Button onClick={() => setEditFlags(true)}>Flags</Button>
								<Button disabled={isGovernment(person.data?.Jobs)} onClick={onEditMugshot}>
									Mugshot
								</Button>
								<Button onClick={onSearch}>Related Reports</Button>
								{canCreateReport && <Button onClick={onCreate}>Create Report</Button>}
								{hasPermission('DOJ_JUDGE') && (
									<Button fullWidth onClick={() => setEditLawyer(true)}>
										Certifications
									</Button>
								)}
								{hasPermission('DOJ_JUDGE') && (
									<Button fullWidth onClick={() => setEditSuspended(true)}>
										Suspensions
									</Button>
								)}
								{hasPermission('system-admin') && (
									<Button fullWidth onClick={() => setClearRecord(true)}>
										Expunge
									</Button>
								)}
								{hasPermission('system-admin') && (
									<Button fullWidth onClick={() => setViewingLogs(true)}>
										Logs
									</Button>
								)}
							</ButtonGroup>
						</Grid>
						{warrants.length > 0 && (
							<Grid item xs={12}>
								<Alert variant="filled" severity="error">
									Active
									{warrants.length == 1 ? ' Warrant ' : ' Warrants '}
									For {`${person.data.First} ${person.data.Last}. `}
									{warrants.map((w) => {
										return (
											<Link
												key={`warrant-${w._id}`}
												className={classes.link}
												to={`/warrants/${w._id}`}
											>
												View Warrant #{w.ID}
											</Link>
										);
									})}
								</Alert>
							</Grid>
						)}
						<Grid item xs={4}>
							<Avatar
								className={classes.mugshot}
								src={person.data.Mugshot ? person.data.Mugshot : null}
								alt={person.data.First}
							/>
							<List>
								{isGovernment(person.data?.Jobs) && (
									<>
										<ListItemText primary="Government Employee" />
										<Chip
											className={`${classes.item} ${classes.jobChip}`}
											label={`${isGovernment(person.data?.Jobs)?.Workplace?.Name} - ${
												isGovernment(person.data?.Jobs)?.Grade?.Name
											}`}
											icon={null}
										/>
									</>
								)}
								<ListItem>
									<ListItemText primary="Employment Information" />
								</ListItem>
								{person.data?.Jobs?.filter((j) => !govJobs.includes(j.Id) && !j.Hidden).map((j) => {
									return (
										<Chip
											key={j.Id}
											className={`${classes.item} ${classes.jobChip}`}
											label={`${j.Workplace?.Name ?? j.Name} - ${j.Grade?.Name ?? 'Employee'}`}
											icon={
												person.ownedBusinesses?.includes(j.Id) ? (
													<FontAwesomeIcon icon={['fas', 'crown']} />
												) : null
											}
										/>
									);
								})}
								{person.vehicles.length > 0 && (
									<ListItem>
										<ListItemText primary="Owned Vehicles" />
									</ListItem>
								)}
								{person.vehicles.map((v) => {
									return (
										<Chip
											key={v.VIN}
											className={`${classes.item} ${classes.vehicleChip}`}
											icon={
												<FontAwesomeIcon
													icon={['fas', VehicleIcons[v.Type] ?? 'car-mirrors']}
												/>
											}
											label={`${v.Make} ${v.Model} [${v.RegisteredPlate}]`}
											onClick={() => onVehicleClick(v.VIN)}
										/>
									);
								})}
							</List>
						</Grid>
						<Grid item xs={4}>
							<List>
								<ListItem>
									<ListItemText
										primary="Name"
										secondary={`${person.data.First} ${person.data.Last}`}
									/>
								</ListItem>
								<ListItem>
									<ListItemText primary="State ID" secondary={person.data.SID} />
								</ListItem>
								<ListItem>
									<ListItemText primary="Sex" secondary={person.data.Gender ? 'Female' : 'Male'} />
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Date of Birth"
										secondary={moment(person.data.DOB * 1000).format('LL')}
									/>
								</ListItem>
								{parole && (
									<ListItem>
										<ListItemText primary="Remaining Parole" secondary={`${parole} Month(s)`} />
									</ListItem>
								)}
								<ListItem>
									<ListItemText
										primary="Violent"
										secondary={person.data.Flags?.Violent ? 'Yes' : 'No'}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Gang Affiliation"
										secondary={(person.data.Flags?.Gang && person.data.Flags?.Gang?.length > 0) ? person.data.Flags?.Gang : 'None'}
									/>
								</ListItem>
								{person.data.Attorney && (
									<ListItem>
										<ListItemText primary="Bar Certified Attorney" secondary="Yes" />
									</ListItem>
								)}
								{person?.data?.Licenses &&
									Object.keys(person.data.Licenses).map((license) => {
										const licenseData = person.data.Licenses[license];
										if (licenseData.Active || licenseData.Suspended) {
											return (
												<ListItem>
													<ListItemText
														primary={`${license} License`}
														secondary={getLicenceStatus(licenseData)}
													/>
												</ListItem>
											);
										} else return null;
									})}
							</List>
						</Grid>
						<Grid item xs={4}>
							<div className={classes.header}>Criminal Record</div>
							<List
								style={{
									maxHeight: 650,
									height: '100%',
									overflowY: 'auto',
									overflowX: 'hidden',
								}}
							>
								{prevConvictions ? (
									prevConvictions
										.sort((a, b) => b.jail + b.fine - (a.jail - a.fine))
										.map((c, k) => {
											return (
												<Chip
													key={`charge-${k}`}
													className={`${classes.charge} type-${c.type}`}
													label={`${c.title} x${c.count}`}
												/>
											);
										})
								) : (
									<ListItem>
										<Alert severity="info">
											{person.data.First} {person.data.Last} Has No Past Convictions 🙂
										</Alert>
									</ListItem>
								)}
							</List>
						</Grid>
					</Grid>
					<Modal
						open={mugshot}
						title="Update Mugshot"
						onSubmit={onMugshotSave}
						onClose={() => setMugshot(false)}
					>
						<Avatar className={classes.mugshot} src={pendingMugshot} alt={person.data.First} />
						<TextField
							fullWidth
							required
							variant="outlined"
							name="mugshot"
							value={pendingMugshot}
							onChange={(e) => setPendingMugshot(e.target.value)}
							label="Image URL"
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										{pendingMugshot != '' && (
											<IconButton onClick={() => pendingMugshot('')}>
												<FontAwesomeIcon icon={['fas', 'xmark']} />
											</IconButton>
										)}
									</InputAdornment>
								),
							}}
						/>
					</Modal>
					<Modal
						open={editFlags}
						title="Update Flags"
						onSubmit={onFlagsSave}
						onClose={() => setEditFlags(false)}
					>
						<FormGroup>
							<FormControlLabel
								label="Violent"
								control={
									<Switch
										color="primary"
										name="violent"
										defaultChecked={person.data.Flags?.Violent}
									/>
								}
							/>
						</FormGroup>
						<FormGroup>
							{/* <FormControlLabel
								label="Gang Affiliated"
								control={
									<Switch color="primary" name="gang" defaultChecked={person.data.Flags?.Gang} />
								}
							/> */}

							<TextField
								className={classes.editorField}
								name="gang"
								label="Gang Affiliated"
								fullWidth
								defaultValue={typeof(person.data.Flags?.Gang) == 'string' ? person.data.Flags?.Gang : ''}
							/>
						</FormGroup>
					</Modal>
					<Modal
						open={editLawyer}
						title="Update Qualifications"
						onSubmit={onLawyerSave}
						onClose={() => setEditLawyer(false)}
					>
						<FormGroup>
							<FormControlLabel
								label="Bar Certified Attorney"
								control={
									<Switch color="primary" name="attorney" defaultChecked={person.data.Attorney} />
								}
							/>
						</FormGroup>
					</Modal>
					<Modal
						open={editSuspended}
						title="License Suspensions"
						onSubmit={onSuspensionSave}
						onClose={() => setEditSuspended(false)}
					>
						<p>Turn off the sliders to revoke a license suspension. This will reset drivers license points.</p>
						<FormGroup>
							{Object.keys(person.data.Licenses).map((license) => {
								const licenseData = person.data.Licenses[license];
								if (licenseData?.Suspended) {
									return (
										<FormControlLabel
											label={`${license} License`}
											control={
												<Switch color="primary" name={license} defaultChecked={true} />
											}
										/>
									);
								} else return null;
							})}
						</FormGroup>
					</Modal>
					<Modal
						open={clearRecord}
						title="Criminal Record Expungement"
						onSubmit={onRecordClear}
						onClose={() => setClearRecord(false)}
					>
						<p>This will expunge an invidual and clear their criminal record completely.</p>
						<FormGroup>
							<FormControlLabel
								label="Confirmation"
								control={
									<Switch color="primary" name="confirm" defaultChecked={false} />
								}
							/>
						</FormGroup>
					</Modal>
					<Modal
						open={viewingLogs}
						title="View System Logs"
						onClose={() => setViewingLogs(false)}
					>
						<List className={classes.items}>
							{person?.data?.MDTHistory ? person.data.MDTHistory.sort((a, b) => b.Time - a.Time).map(h => {
								return <ListItem className={classes.itemWrapper}>
									<ListItemText
										primary={h.Log}
										secondary={`${h.Char > - 1 ? `SID ${h.Char}` : 'System'} | ${moment(h.Time).format('lll')}`}
									/>
								</ListItem>
							}) : null}
						</List>
					</Modal>
				</>
			)}
		</div>
	);
};
