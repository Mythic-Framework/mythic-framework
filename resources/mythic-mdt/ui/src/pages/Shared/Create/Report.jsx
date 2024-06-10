import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Grid,
	TextField,
	ListItem,
	ListItemText,
	ListItemSecondaryAction,
	ButtonGroup,
	Button,
	IconButton,
	Backdrop,
	List,
	Alert,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _ from 'lodash';
import { useNavigate, useLocation } from 'react-router';
import { toast } from 'react-toastify';
import qs from 'qs';
import moment from 'moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Lightbox from 'react-image-lightbox';

import Nui from '../../../util/Nui';
import { Loader, OfficerSearch, PersonSearch, Editor, Modal } from '../../../components';
import { ReportTypes, GetOfficerNameFromReportType, GetOfficerJobFromReportType } from '../../../data';
import { useGovJob, usePermissions, useQualifications } from '../../../hooks';

import SuspectForm from './components/SuspectForm';
import Suspect from './components/Suspect';
import EvidenceForm from './components/EvidenceForm';
import Evidence from './components/Evidence';

import Tags from './components/Tags';

import { initialState as susState } from './components/SuspectForm';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '95%',
	},
	editorField: {
		marginBottom: 10,
	},
	title: {
		fontSize: 22,
		color: theme.palette.text.main,
		textAlign: 'center',
	},
	option: {
		transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		'&:hover': {
			background: theme.palette.secondary.main,
			cursor: 'pointer',
		},
		'&.selected': {
			color: theme.palette.primary.main,
		},
	},
	calculator: {
		height: '100%',
	},
	col: {
		height: '100%',
		// overflowY: 'auto',
		// overflowX: 'hidden',
		padding: 5,
	},
	formActions: {
		paddingBottom: 10,
		marginBottom: 5,
		borderBottom: `1px inset ${theme.palette.border.divider}`,
	},
	positiveButton: {
		borderColor: `${theme.palette.success.main}80`,
		color: theme.palette.success.main,
		'&:hover': {
			borderColor: theme.palette.success.main,
			background: `${theme.palette.success.main}14`,
		},
	},
	infoButton: {
		borderColor: `${theme.palette.info.main}80`,
		color: theme.palette.info.main,
		'&:hover': {
			borderColor: theme.palette.info.main,
			background: `${theme.palette.info.main}14`,
		},
	},
	negativeButton: {
		borderColor: `${theme.palette.error.light}80`,
		color: theme.palette.error.light,
		'&:hover': {
			borderColor: theme.palette.error.light,
			background: `${theme.palette.error.light}14`,
		},
	},
	popup: {
		maxHeight: `750px !important`,
	},
	draftItem: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
	draftBtn: {
		'&:first-of-type': {
			marginRight: 10,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const location = useLocation();
	const history = useNavigate();
	const hasJob = useGovJob();
	const hasPermission = usePermissions();
	const hasQualification = useQualifications();

	const user = useSelector((state) => state.app.user);
	const me = {
		_id: user.ID,
		SID: user.SID,
		User: user.User,
		First: user.First,
		Last: user.Last,
		Gender: user.Gender,
		Origin: user.Origin,
		Job: user.Job,
		DOB: user.DOB,
		Callsign: user.Callsign,
		Phone: user.Phone,
		Licenses: user.Licenses,
	};
	const drafts = useSelector((state) => state.app.drafts);

	let qry = qs.parse(location.search.slice(1));
	const initialState = {
		type: ReportTypes.filter((r) => hasPermission(r.requiredCreatePermission, false))?.[0]?.value,
		title: '',
		notes: '',
		tagInput: '',
		tags: Array(),
		primariesInput: '',
		primaries: [me],
		assistingInput: '',
		assisting: Array(),
		suspects: Array(),
		peopleInput: '',
		people: Array(),
		evidence: Array(),
		evidenceCounter: 0,
	};

	const [evidence, setEvidence] = useState(false);
	const [editEvidence, setEditEvidence] = useState(null);

	const [pOpen, setPOpen] = useState(false);
	const [pIndex, setPIndex] = useState(0);

	const [loadDraft, setLoadDraft] = useState(false);
	const [loading, setLoading] = useState(false);
	const [state, setState] = useState(initialState);
	const [form, setForm] = useState(false);
	const [editing, setEditing] = useState(null);
	const [officers, setOfficers] = useState(Array());
	const [people, setPeople] = useState(Array());
	const [tags, setTags] = useState(Array());

	useEffect(() => {
		const f = async (id) => {
			const incidentReport = ReportTypes.find((rt) => rt.value == 0);
			if (!hasPermission(incidentReport.requiredCreatePermission, false)) return;
			setLoading(true);
			try {
				let res = await (
					await Nui.send('View', {
						type: 'person',
						id,
					})
				).json();
				if (res) {
					setState({
						...state,
						suspects: [
							...state.suspects,
							{
								...susState,
								suspect: res.data,
								plea: 'unknown',
							},
						],
					});
				}
			} catch (err) {}
			setLoading(false);
		};

		const f2 = async (id) => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('View', {
						type: 'report',
						id,
					})
				).json();
				if (res) {
					setState(res);
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load Report');
			}
			setLoading(false);
		};

		if (qry.draft) onLoad(+qry.draft);
		else if (qry.case) f2(qry.case);
		else if (qry.id) f(qry.id);
	}, [history]);

	useEffect(() => {
		const qryType = parseInt(qry.type);
		if (!isNaN(qryType) && qryType >= 0 && qryType < ReportTypes.length) {
			const reportType = ReportTypes.find((r) => r.value == qryType);
			if (reportType && hasPermission(reportType.requiredPermission, false)) {
				setState({
					...state,
					type: qryType,
				});
			}
		}
	}, [qry.type]);

	useEffect(() => {
		setLoadDraft(false);
	}, [qry.draft]);

	const onSave = () => {
		setLoading(true);
		if (qry.draft && drafts.filter((d) => d.draft == +qry.draft).length > 0) {
			dispatch({
				type: 'UPDATE_DRAFT',
				payload: {
					id: +qry.draft,
					draft: {
						...state,
						time: Date.now(),
					},
				},
			});
		} else {
			dispatch({
				type: 'ADD_DRAFT',
				payload: {
					...state,
					time: Date.now(),
				},
			});
		}
		let s = qs.parse(location.search.slice(1));
		delete s.draft;
		history({
			path: location.pathname,
			search: qs.stringify(s),
		});
		setState({ ...initialState });
		toast.success('Draft Saved');
		setTimeout(() => {
			setLoading(false);
		}, 10);
	};

	const onLoad = (id) => {
		setLoading(true);
		setLoadDraft(false);
		if (drafts.filter((d) => d.draft == id).length > 0) {
			let s = qs.parse(location.search.slice(1));
			s.draft = id;
			history({
				path: location.pathname,
				search: qs.stringify(s),
			});
			setState({ ...drafts.filter((d) => d.draft == id)[0] });
			toast.success('Draft Loaded');
		} else {
			let s = qs.parse(location.search.slice(1));
			delete s.draft;
			history(
				{
					path: location.pathname,
					search: qs.stringify(s),
				},
				{ replace: true },
			);
			toast.error('Unable to Load Draft');
		}

		setTimeout(() => {
			setLoading(false);
		}, 10);
	};

	const onDeleteDraft = (id) => {
		dispatch({
			type: 'REMOVE_DRAFT',
			payload: {
				id,
			},
		});
		let s = qs.parse(location.search.slice(1));
		if (s.draft && s.draft == id) {
			delete s.draft;
			history(
				{
					path: location.pathname,
					search: qs.stringify(s),
				},
				{ replace: true },
			);
			setState({ ...initialState });
		}
		toast.success('Draft Deleted');
	};

	const onSuspectCancel = () => {
		setForm(false);
		setEditing(null);
	};

	const onSuspectEdit = (suspect) => {
		setEditing(suspect);
	};

	const onSuspectDelete = (suspect) => {
		setState({
			...state,
			suspects: state.suspects.filter((s) => s.suspect.SID != suspect.suspect.SID),
		});
	};

	const onEditSuspect = (sState) => {
		setState({
			...state,
			suspects: state.suspects.map((s) => {
				if (s.suspect.SID == sState.suspect.SID) return sState;
				else return s;
			}),
		});
		onSuspectCancel();
	};

	const onAddSuspect = (sState) => {
		let exists = state.suspects.filter((s) => s.suspect.SID == sState.suspect.SID).length > 0;

		if (!exists) {
			setState({
				...state,
				suspects: [...state.suspects, sState],
			});
		} else {
			toast.error('Suspect Already Added To Report');
		}
		onSuspectCancel();
	};

	const onAddEvidence = (evidence) => {
		if (evidence._id) {
			setState({
				...state,
				evidence: state.evidence.map((e) => {
					if (e._id == evidence._id) return evidence;
					else return e;
				}),
			});
		} else {
			setState({
				...state,
				evidence: [
					...state.evidence,
					{
						...evidence,
						_id: state.evidenceCounter + 1,
					},
				],
				evidenceCounter: state.evidenceCounter + 1,
			});
		}
		setEvidence(false);
	};

	const onRemoveEvidence = (evidence) => {
		setState({
			...state,
			evidence: state.evidence.filter((e) => e._id != evidence._id),
		});
	};

	const onEvidenceOpen = (index) => {
		setPIndex(index);
		setPOpen(true);
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		if (state.type == 0 && state.suspects.length == 0) {
			toast.error('Must Select Suspect');
		} else if (state.title == '') {
			toast.error('Must Add Report Title');
		} else if (state.notes == '') {
			toast.error('Must Add Report Notes');
		} else {
			try {
				if (Boolean(state?._id)) {
					let res = await (
						await Nui.send('Update', {
							type: 'report',
							ID: state._id,
							Report: {
								type: state.type,
								title: state.title,
								notes: state.notes,
								time: state.time,
								evidence: state.evidence,
								suspects: state.suspects,
								primaries: state.primaries,
								assisting: state.assisting,
								tags: state.tags,
								people: state.people,
							},
						})
					).json();

					if (res) history(`/search/reports/${state._id}`);
					else toast.error('Unable to Create Report');
				} else {
					let res = await (
						await Nui.send('Create', {
							type: 'report',
							doc: {
								type: state.type,
								title: state.title,
								notes: state.notes,
								time: Date.now(),
								evidence: state.evidence,
								suspects: state.suspects,
								primaries: state.primaries,
								assisting: state.assisting,
								tags: state.tags,
								people: state.people,
							},
						})
					).json();

					if (res) {
						if (state.draft) {
							dispatch({
								type: 'REMOVE_DRAFT',
								payload: {
									id: state.draft,
								},
							});
						}

						history(`/search/reports/${res._id}`);
					} else toast.error('Unable to Create Report');
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Create Report');
			}
		}
	};

	const reportOfficerName = GetOfficerNameFromReportType(state.type);
	const reportOfficerType = GetOfficerJobFromReportType(state.type);

	return (
		<div className={classes.wrapper}>
			<Backdrop open={loading} style={{ zIndex: 100 }}>
				<Loader text="Loading" />
			</Backdrop>
			<Grid container style={{ height: '100%', paddingBottom: 10 }} spacing={2}>
				<Grid item xs={12}>
					<Grid container className={classes.formActions}>
						<Grid item xs={5}>
							<ButtonGroup fullWidth color="inherit">
								<Button
									className={classes.infoButton}
									variant="outlined"
									onClick={() => setEvidence(true)}
								>
									Add Evidence
								</Button>
								{state.type === 0 && (
									<Button
										className={classes.positiveButton}
										variant="outlined"
										onClick={() => setForm(true)}
									>
										Add Suspect
									</Button>
								)}
							</ButtonGroup>
						</Grid>
						<Grid item xs={2}>
							<div className={classes.title}>
								{Boolean(state?._id) ? `Report #${state?.ID}` : `New Report`}
							</div>
						</Grid>
						<Grid item xs={5} style={{ textAlign: 'right' }}>
							<ButtonGroup fullWidth color="inherit">
								{drafts.length > 0 && !qry.case && (
									<Button className={classes.infoButton} onClick={() => setLoadDraft(true)}>
										Drafts
									</Button>
								)}
								<Button
									className={classes.positiveButton}
									onClick={onSave}
									disabled={_.isEqual(state, initialState) || Boolean(qry.case)}
								>
									Save Draft
								</Button>
								<Button className={classes.positiveButton} onClick={onSubmit}>
									{`${Boolean(state?._id) ? 'Edit' : 'Submit'} Report`}
								</Button>
							</ButtonGroup>
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={6} className={classes.col}>
					<TextField
						select
						fullWidth
						label="Report Type"
						disabled={Boolean(state?._id)}
						name="type"
						className={classes.editorField}
						value={state.type}
						onChange={(e) => setState({ ...state, type: e.target.value })}
					>
						{ReportTypes.filter((r) => hasPermission(r.requiredCreatePermission, false)).map((option) => (
							<MenuItem key={option.value} value={option.value}>
								{option.label}
							</MenuItem>
						))}
					</TextField>
					<TextField
						className={classes.editorField}
						label="Report Title"
						fullWidth
						placeholder="Report Title"
						value={state.title}
						onChange={(e) => setState({ ...state, title: e.target.value })}
					/>
					{state.type === 0 && (
						<OfficerSearch
							disableSelf
							label={`Primary Officers`}
							placeholder="200, 201, 202 etc..."
							value={state.primaries}
							inputValue={state.primariesInput}
							options={officers}
							setOptions={setOfficers}
							onChange={(e, nv) => {
								if (nv.length == 0) {
									setState({
										...state,
										primaries: [user],
										primariesInput: '',
									});
								} else {
									setState({
										...state,
										primaries: nv,
										primariesInput: '',
									});
								}
							}}
							onInputChange={(e, nv) => setState({ ...state, primariesInput: nv })}
						/>
					)}
					{state.type === 0 && (
						<OfficerSearch
							label="Assisting Officers"
							placeholder="200, 201, 202 etc..."
							value={state.assisting}
							inputValue={state.assistingInput}
							options={officers}
							setOptions={setOfficers}
							onChange={(e, nv) => {
								setState({
									...state,
									assisting: nv,
									assistingInput: '',
								});
							}}
							onInputChange={(e, nv) => setState({ ...state, primariesInput: nv })}
						/>
					)}
					<Evidence
						evidence={state.evidence}
						onClick={(index) => {
							onEvidenceOpen(index);
						}}
						onDelete={onRemoveEvidence}
					/>
					{!loading && (
						<Editor
							allowMedia
							name="notes"
							title="Report Notes"
							placeholder={'Enter Report Notes'}
							disabled={loading}
							value={state.notes}
							onChange={(e) => {
								setState({ ...state, notes: e.target.value });
							}}
						/>
					)}
				</Grid>
				<Grid item xs={6} className={classes.col}>
					<Tags
						label="Report Tags"
						value={state.tags}
						inputValue={state.tagInput}
						options={tags}
						setOptions={setTags}
						onChange={(nv) => {
							if (nv.length == 0) {
								setState({
									...state,
									tags: [],
									tagInput: '',
								});
							} else {
								setState({
									...state,
									tags: nv,
									tagInput: '',
								});
							}
						}}
						onInputChange={(e, nv) => setState({ ...state, tagInput: nv })}
					/>
					{state.type !== 0 && (
						<OfficerSearch
							disableSelf
							job={reportOfficerType}
							label={`${reportOfficerName} Involved`}
							//placeholder=""
							value={state.primaries}
							inputValue={state.primariesInput}
							options={officers}
							setOptions={setOfficers}
							onChange={(e, nv) => {
								if (nv.length == 0) {
									setState({
										...state,
										primaries: [user],
										primariesInput: '',
									});
								} else {
									setState({
										...state,
										primaries: nv,
										primariesInput: '',
									});
								}
							}}
							onInputChange={(e, nv) => setState({ ...state, primariesInput: nv })}
						/>
					)}
					{state.type !== 0 && (
						<PersonSearch
							label="People Involved"
							placeholder="John Doe, Jane Doe etc..."
							value={state.people}
							inputValue={state.peopleInput}
							options={people}
							setOptions={setPeople}
							onChange={(e, nv) => {
								if (nv.length == 0) {
									setState({
										...state,
										people: [],
										peopleInput: '',
									});
								} else {
									setState({
										...state,
										people: nv,
										peopleInput: '',
									});
								}
							}}
							onInputChange={(e, nv) => setState({ ...state, peopleInput: nv })}
						/>
					)}
					{state.suspects.length > 0
						? state.suspects.map((suspect, k) => {
								return (
									<Suspect
										key={`suspect-${k}`}
										data={suspect}
										onEdit={() => onSuspectEdit(suspect)}
										onDelete={() => onSuspectDelete(suspect)}
									/>
								);
						  })
						: state.type === 0 && (
								<Alert variant="outlined" severity="info" style={{ margin: 25 }}>
									Please Add A Suspect To Your Report
								</Alert>
						  )}
				</Grid>
			</Grid>
			<SuspectForm
				open={form || Boolean(editing)}
				suspect={editing}
				onSubmit={onAddSuspect}
				onCancel={onSuspectCancel}
				onEdit={onEditSuspect}
			/>

			<EvidenceForm
				open={evidence}
				existing={editEvidence}
				onSubmit={onAddEvidence}
				onClose={() => setEvidence(false)}
			/>
			<Modal open={loadDraft} title="Load Draft" onClose={() => setLoadDraft(false)}>
				<List>
					{drafts.length > 0 ? (
						drafts
							.sort((a, b) => b.time - a.time)
							.map((draft, k) => {
								return (
									<ListItem key={`draft-${draft.draft}`} className={classes.draftItem}>
										<ListItemText
											primary={`Report Draft #${draft.draft}`}
											secondary={`Saved: ${moment(draft.time).format('LLLL')}`}
										/>
										<ListItemSecondaryAction>
											<IconButton
												edge="end"
												className={classes.draftBtn}
												onClick={() => onLoad(draft.draft)}
											>
												<FontAwesomeIcon icon={['fas', 'cloud-arrow-down']} />
											</IconButton>
											<IconButton
												edge="end"
												className={classes.draftBtn}
												onClick={() => onDeleteDraft(draft.draft)}
											>
												<FontAwesomeIcon icon={['fas', 'trash']} />
											</IconButton>
										</ListItemSecondaryAction>
									</ListItem>
								);
							})
					) : (
						<Alert variant="outlined" severity="info">
							You Have No Saved Drafts
						</Alert>
					)}
				</List>
			</Modal>
			{state.evidence.length > 0 && pOpen && (
				<Lightbox
					mainSrc={state.evidence[pIndex].value}
					nextSrc={state.evidence[(pIndex + 1) % state.evidence.length].value}
					prevSrc={state.evidence[(pIndex + state.evidence.length - 1) % state.evidence.length].value}
					onCloseRequest={() => setPOpen(false)}
					onMovePrevRequest={() => setPIndex((pIndex + state.evidence.length - 1) % state.evidence.length)}
					onMoveNextRequest={() => setPIndex((pIndex + 1) % state.evidence.length)}
				/>
			)}
		</div>
	);
};
