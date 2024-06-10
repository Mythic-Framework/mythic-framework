import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router';
import {
	experimentalStyled as styled,
	List,
	AppBar,
	Grid,
	IconButton,
	Accordion as MuiAccordion,
	AccordionSummary as MuiAccordionSummary,
	AccordionDetails as MuiAccordionDetails,
	ListItem,
	ListItemText,
	ButtonBase,
	Tooltip,
	TextField,
	FormControl,
	InputLabel,
	Select,
	OutlinedInput,
	MenuItem,
	Button,
	Checkbox,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Truncate from 'react-truncate';
import NumberFormat from 'react-number-format';

import Nui from '../../util/Nui';
import { useAlert, useCompanyUpgrades } from '../../hooks';
import { Modal, Confirm, Loader } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	content: {
		height: '83.6%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	workplaceAction: {
		fontSize: 14,
	},
	management: {
		fontSize: 14,
		color: 'gold',
		marginRight: 5,
	},
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	editorField: {
		marginBottom: 15,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	ownerBtn: {
		display: 'block',
		'&:not(:last-of-type)': {
			marginBottom: 15,
		},
	},
}));

const Accordion = styled((props) => (
	<MuiAccordion
		TransitionProps={{ unmountOnExit: true }}
		disableGutters
		elevation={0}
		square
		{...props}
	/>
))(({ theme }) => ({
	background: 'transparent',
	borderBottom: `1px solid ${theme.palette.border.divider}`,
	'&:before': {
		display: 'none',
	},
}));

const AccordionSummary = styled((props) => (
	<MuiAccordionSummary
		expandIcon={<FontAwesomeIcon icon={['fas', 'caret-down']} />}
		{...props}
	/>
))(({ theme }) => ({
	width: '100%',
	background: 'transparent',
	flexDirection: 'row-reverse',
	'& .MuiAccordionSummary-expandIconWrapper': {
		fontSize: 20,
		color: theme.palette.primary.main,
		transform: 'rotate(-90deg)',
		transition: '0.25s',
		'&.Mui-expanded': {
			transform: 'rotate(0deg)',
		},
	},
	'& .MuiAccordionSummary-content': {
		margin: 0,
		marginLeft: theme.spacing(1),
	},
}));

const AccordionDetails = styled(MuiAccordionDetails)(({ theme }) => ({
	padding: theme.spacing(0),
	borderTop: '1px solid rgba(0, 0, 0, .125)',
}));

export default ({ refreshRoster, jobData, playerJob }) => {
	const classes = useStyles();
	const sendAlert = useAlert();
	const history = useHistory();
	const hasUpgrade = useCompanyUpgrades();
	const player = useSelector((state) => state.data.data.player);

	const jobPermissions = useSelector((state) => state.data.data.NamedJobPermissions);

	const isOwner = player.SID == jobData?.Owner;

	const initialGrade = {
		Id: '',
		Name: '',
		Level: 1,
		Permissions: Object(),
	};

	const [ownerMenu, setOwnerMenu] = useState(false);
	const [renaming, setRenaming] = useState(false);
	const [disband, setDisband] = useState(false);
	const [transfer, setTransfer] = useState(null);
	const [xferConf, setXferConf] = useState(false);

	const [loading, setLoading] = useState(false);
	const [workplace, setWorkplace] = useState(null);
	const [grade, setGrade] = useState(null);
	const [deleteConf, setDeleteConf] = useState(false);
	const [deleteGradeConf, setDeleteGradeConf] = useState(false);

	const [expanded, setExpanded] = useState(false);
	const handleChange = (panel) => (event, isExpanded) => {
		setExpanded(isExpanded ? panel : false);
	};

	const home = () => {
		history.goBack();
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		setLoading(true);
		try {
			let res = await (
				await Nui.send('EditWorkplace', {
					JobId: workplace.JobId,
					WorkplaceId: workplace.Id,
					NewName: workplace.Name,
				})
			).json();

			if (res.success) {
				sendAlert('Workplace Updated');
				refreshRoster();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					case 'MISSING_JOB':
						sendAlert('Workplace Doesn\'t Exist');
						break;
					default:
					case 'ERROR':
						sendAlert('Unable to Update Workplace');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Update Workplace');
		}
		setLoading(false);
	};

	const onSubmitGrade = async (e) => {
		e.preventDefault();

		setLoading(true);
		try {
			let res = await (
				await Nui.send(grade.edit ? 'EditGrade' : 'CreateGrade', grade)
			).json();

			if (res.success) {
				sendAlert(`Grade ${grade.edit ? 'Updated' : 'Created'}`);
				refreshRoster();
			} else {
				switch (res.code) {
					default:
					case 'ERROR':
						sendAlert(
							`Unable To ${
								grade.edit ? 'Update' : 'Create'
							} Grade`,
						);
						break;
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert(`Unable to ${grade.edit ? 'Update' : 'Create'} Grade`);
		}
		setLoading(false);
	};

	const onDeleteGrade = async () => {
		setDeleteGradeConf(false);
		setLoading(true);
		try {
			let res = await (
				await Nui.send('DeleteGrade', grade)
			).json();

			if (res.success) {
				sendAlert('Grade Deleted');
				refreshRoster();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					case 'JOB_OCCUPIED':
						sendAlert('Cannot Delete a Grade With Employees In');
						break;
					case 'MISSING_JOB':
						sendAlert('Grade Doesn\'t Exist');
						break;
					default:
					case 'ERROR':
						sendAlert('Unable to Delete Grade');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Delete Grade');
		}
		setLoading(false);
	};

	const onSubmitRename = async (e) => {
		e.preventDefault();
		if (!isOwner) return;

		setLoading(true);
		try {
			let res = await (
				await Nui.send('RenameCompany', e.target.name.value)
			).json();

			if (res.success) {
				sendAlert('Company Name Updated');
				refreshRoster();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					default:
					case 'ERROR':
						sendAlert('Unable To Edit Company');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Edit Company');
		}
		setLoading(false);
	};

	const onDisband = async (e) => {
		e.preventDefault();
		if (!isOwner) return;

		setLoading(true);
		try {
			let res = await (await Nui.send('DisbandCompany')).json();

			if (res.success) {
				sendAlert('Company Has Been Deleted');
				home();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					default:
					case 'ERROR':
						sendAlert('Unable to Disband Company');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Disband Company');
		}
		setDisband(false);
		setLoading(false);
	};

	const onTransfer = async (e) => {
		e.preventDefault();
		if (!isOwner) return;

		setLoading(true);
		try {
			let res = await (
				await Nui.send('TransferCompany', {
					target: transfer.target,
				})
			).json();

			if (res.success) {
				sendAlert('Company Ownership Has Been Transfered');
				refreshRoster();
			} else {
				switch (res.code) {
					case 'INVALID_PERMISSIONS':
						sendAlert('Not Authorized');
						break;
					default:
					case 'ERROR':
						sendAlert('Unable to Disband Company');
						break;
				}
			}
		} catch (err) {
			console.log(err);
			sendAlert('Unable To Transfer Company Ownership');
		}
		setXferConf(false);
		setTransfer(null);
		setLoading(false);
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7}>
						<Truncate lines={1}>{jobData.Name}</Truncate>
					</Grid>
					<Grid item xs={5} className={classes.headerAction}>
						{isOwner && (
							<Tooltip title="Company Owner Menu">
								<IconButton onClick={() => setOwnerMenu(true)}>
									<FontAwesomeIcon icon={['fas', 'gear']} />
								</IconButton>
							</Tooltip>
						)}
						{!jobData.Workplaces && <Tooltip title="Create New Grade">
							<IconButton
								onClick={() => setGrade({
									JobId: jobData.Id,
									WorkplaceId: null,
									...initialGrade,
								})}
							>
								<FontAwesomeIcon icon={['fas', 'plus']} />
							</IconButton>
						</Tooltip>}
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
			</AppBar>
			<div className={classes.content}>
				{(jobData.Workplaces && jobData.Workplaces.length > 0) ? (
					jobData.Workplaces.map((wp) => {
						return (
							<Accordion
								key={`wp-${wp.Id}`}
								expanded={expanded == wp.Id}
								onChange={handleChange(wp.Id)}
							>
								<ButtonBase style={{ width: '100%' }}>
									<AccordionSummary
										expandIcon={
											<FontAwesomeIcon
												icon={['fas', 'caret-down']}
											/>
										}
									>
										<List dense>
											<ListItem>
												<ListItemText
													primary={wp.Name}
													secondary={`${wp.Grades.length} Grades`}
												/>
											</ListItem>
										</List>
									</AccordionSummary>
								</ButtonBase>
								<AccordionDetails>
									<List>
										<ListItem>
											<Grid
												container
												style={{
													textAlign: 'center',
												}}
											>
												<Grid item xs={6}>
													<Tooltip title="Create New Grade">
														<IconButton
															onClick={() =>
																setGrade({
																	...initialGrade,
																	JobId: jobData.Id,
																	WorkplaceId: wp.Id,
																})
															}
															className={
																classes.workplaceAction
															}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'plus',
																]}
															/>
														</IconButton>
													</Tooltip>
												</Grid>
												<Grid item xs={6}>
													<Tooltip title="Edit Workplace">
														<IconButton
															onClick={() =>
																setWorkplace({
																	JobId: jobData.Id,
																	...wp,
																	edit: true,
																})
															}
															className={
																classes.workplaceAction
															}
														>
															<FontAwesomeIcon
																icon={[
																	'fas',
																	'pen-to-square',
																]}
															/>
														</IconButton>
													</Tooltip>
												</Grid>
											</Grid>
										</ListItem>
										<ListItem>
											<ListItemText primary="Grades" />
										</ListItem>
										<ListItem>
											<List style={{ width: '100%' }}>
												{wp.Grades.sort((a, b) => a.Level - b.Level).map((grade) => {
													return (
														<ListItem
															button={grade.Level < playerJob.Grade.Level || isOwner}
															key={`grade-${grade.Id}`}
															onClick={grade.Level < playerJob.Grade.Level || isOwner
																? () => setGrade({
																	...grade,
																	JobId: jobData.Id,
																	WorkplaceId: wp.Id,
																	edit: true,
																}) : null
															}
															className={
																classes.item
															}
														>
															<ListItemText
																primary={
																	<span>
																		{grade?.Permissions?.JOB_MANAGEMENT && (
																			<FontAwesomeIcon
																				className={classes.management}
																				icon={[
																					'fas',
																					'user-shield',
																				]}
																			/>
																		)}
																		{grade.Name}
																	</span>
																}
																secondary={`${
																	Object.keys(grade.Permissions).filter(perm => grade.Permissions[perm]).length
																} Permissions`}
															/>
														</ListItem>
													);
												})}
											</List>
										</ListItem>
									</List>
								</AccordionDetails>
							</Accordion>
						);
					})
				) : (
					<List>
						<ListItem>
							<ListItemText primary="Grades" />
						</ListItem>
						<ListItem>
							<List style={{ width: '100%' }}>
								{jobData.Grades.map((grade) => {
									return (
										<ListItem
											button={grade.Level < playerJob.Grade.Level || isOwner}
											key={`grade-${grade.Id}`}
											onClick={
												grade.Level < playerJob.Grade.Level || isOwner
												? () => setGrade({
													...grade,
													JobId: jobData.Id,
													WorkplaceId: null,
													edit: true,
												}) : null
											}
											className={classes.item}
										>
											<ListItemText
												primary={
													<span>
														{grade?.Permissions?.JOB_MANAGEMENT && (
															<FontAwesomeIcon
																className={classes.management}
																icon={[
																	'fas',
																	'user-shield',
																]}
															/>
														)}
														{grade.Name}
													</span>
												}
												secondary={`${
													Object.keys(grade.Permissions).filter((perm) => grade.Permissions[perm]).length
												} Permissions`}
											/>
										</ListItem>
									);
								})}
							</List>
						</ListItem>
					</List>
				)}
				<Confirm
					title="Delete Grade?"
					open={deleteGradeConf}
					confirm="Yes"
					decline="No"
					onConfirm={onDeleteGrade}
					onDecline={() => setDeleteGradeConf(false)}
				>
					<p>
						Deleting this grade will remove all permissions related to it and cannot be undone, are you sure?
					</p>
				</Confirm>
				<Modal
					form
					formStyle={{ position: 'relative' }}
					disabled={loading}
					open={workplace != null}
					title={'Edit Workplace'}
					onAccept={onSubmit}
					onClose={() => setWorkplace(null)}
					submitLang={'Edit'}
				>
					{workplace != null && (
						<>
							{loading && <Loader static text="Submitting" />}
							<TextField
								fullWidth
								required
								label="Workplace Name"
								name="Name"
								disabled={loading}
								className={classes.editorField}
								value={workplace.Name}
								onChange={(e) =>
									setWorkplace({
										...workplace,
										Name: e.target.value,
									})
								}
							/>
						</>
					)}
				</Modal>
				<Modal
					disabled={loading}
					form
					formStyle={{ position: 'relative' }}
					open={grade != null}
					title={`${grade?.edit ? 'Edit' : 'Create'} Grade`}
					onAccept={onSubmitGrade}
					onClose={() => setGrade(null)}
					onDelete={
						grade?.edit && !grade?.Owner
							? () => setDeleteGradeConf(true)
							: null
					}
					submitLang={grade?.edit ? 'Edit' : 'Create'}
				>
					{grade != null && (
						<>
							{loading && <Loader static text="Submitting" />}
							<TextField
								fullWidth
								required
								label="Grade Name"
								name="Name"
								disabled={loading}
								className={classes.editorField}
								value={grade.Name}
								onChange={(e) =>
									setGrade({
										...grade,
										Name: e.target.value,
									})
								}
							/>
							<NumberFormat
								fullWidth
								required
								label="Grade Level"
								helperText="This determines where in the rank heirarchy this grade falls"
								name="Level"
								disabled={grade.Owner || loading}
								className={classes.editorField}
								value={grade.Level}
								onChange={(e) =>
									setGrade({
										...grade,
										Level: e.target.value,
									})
								}
								type="tel"
								isNumericString
								customInput={TextField}
							/>

							<FormControl
								fullWidth
								className={classes.editorField}
							>
								<InputLabel id="grade-perms">
									Permissions
								</InputLabel>
								<Select
									labelId="grade-perms"
									multiple
									fullWidth
									disabled={grade.Owner || loading}
									value={Object.keys(grade.Permissions)}
									onChange={(e) => {
										let t = Object();
										e.target.value.map((p) => {
											t[p] = true;
										});
										setGrade({
											...grade,
											Permissions: t,
										});
									}}
									input={
										<OutlinedInput
											fullWidth
											label="Permissions"
										/>
									}
									// renderValue={(selected) => (
									// 	<Box
									// 		style={{
									// 			display: 'flex',
									// 			flexWrap: 'wrap',
									// 		}}
									// 	>
									// 		{selected.map((k) => {
									// 			return (
									// 				<Chip
									// 					key={k}
									// 					label={jobPermissions[k]?.name ?? k}
									// 					style={{ margin: 2 }}
									// 				/>
									// 			);
									// 		})}
									// 	</Box>
									// )}
									renderValue={(selected) => selected.map(k => jobPermissions[k]?.name ?? k).join(', ')}
								>
									{Object.keys(jobPermissions).filter(p => {
										const pData = jobPermissions[p]
										return !pData.restricted || pData.restricted?.includes(jobData?.Id)
									}).sort().map((key) => {
										let perm = jobPermissions[key];
										return (
											<MenuItem key={`perm-${key}`} value={key}>
												<Checkbox checked={Object.keys(grade.Permissions).indexOf(key) > -1} />
												<ListItemText primary={perm?.name ?? key} />
											</MenuItem>
										);
									})}
								</Select>
							</FormControl>
						</>
					)}
				</Modal>
				{isOwner && (
					<>
						<Modal
							open={ownerMenu}
							title="Owner Actions"
							onClose={() => setOwnerMenu(false)}
							hideClose
						>
							<>
								<Button
									fullWidth
									variant="contained"
									className={classes.ownerBtn}
									onClick={() => setRenaming(true)}
								>
									Rename Company
								</Button>
								<Button
									fullWidth
									variant="contained"
									className={classes.ownerBtn}
									disabled
									onClick={() => setDisband(true)}
								>
									Disband Company
								</Button>
								<Button
									fullWidth
									variant="contained"
									className={classes.ownerBtn}
									disabled
									onClick={() => setTransfer({ target: '' })}
								>
									Transfer Company Ownership
								</Button>
							</>
						</Modal>
						<Modal
							form
							formStyle={{ position: 'relative' }}
							disabled={loading}
							open={renaming}
							title={`Rename ${jobData.Name}`}
							onAccept={onSubmitRename}
							onClose={() => setRenaming(false)}
							submitLang="Submit"
						>
							<>
								{loading && <Loader static text="Submitting" />}
								<TextField
									fullWidth
									required
									label="Company Name"
									name="name"
									disabled={loading}
									className={classes.editorField}
									defaultValue={jobData.Name}
								/>
							</>
						</Modal>
						{Boolean(transfer) && (
							<>
								<Modal
									form
									formStyle={{ position: 'relative' }}
									disabled={loading}
									open={true}
									title={`Transfer ${jobData.Name} Ownership`}
									onAccept={() => setXferConf(true)}
									onClose={() => setTransfer(null)}
									submitLang="Transfer Ownership"
								>
									<>
										{loading && (
											<Loader static text="Submitting" />
										)}
										<NumberFormat
											fullWidth
											required
											label="Target State ID"
											name="target"
											className={classes.editorField}
											value={transfer.target}
											disabled={loading}
											onChange={(e) =>
												setTransfer({
													...transfer,
													target: e.target.value,
												})
											}
											type="tel"
											isNumericString
											customInput={TextField}
										/>
									</>
								</Modal>
								<Confirm
									title="Transfer Company?"
									open={xferConf}
									confirm="Yes"
									decline="No"
									onConfirm={onTransfer}
									onDecline={() => setXferConf(false)}
								>
									<p>
										Transfering company will transfer full
										ownership of company & associated
										assets.
									</p>
									<p>
										This is not reversable, if you proceed
										you will lose all control over the
										company.
									</p>
								</Confirm>
							</>
						)}
						<Confirm
							title="Disband Company?"
							open={disband}
							confirm="Yes"
							decline="No"
							onConfirm={onDisband}
							onDecline={() => setDisband(false)}
						>
							<p>
								Disbanding the company will remove everyone
								employed, grades, upgrades, or any data or assets
								associated with your company.
							</p>
							<p>
								This is not reversable, if you proceed this
								company will be lost forever and you{' '}
								<b>
									<i>WILL NOT</i>
								</b>{' '}
								get any sort of refund for anything purchased
								for your company.
							</p>
						</Confirm>
					</>
				)}
			</div>
		</div>
	);
};
