import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Divider, List, ListItem, ListItemText, Grid, Alert, Button, ButtonGroup } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import Moment from 'react-moment';
import { Link, useNavigate } from 'react-router-dom';
import Lightbox from 'react-image-lightbox';
import { useParams } from 'react-router';

import { Loader, UserContent } from '../../../components';
import Nui from '../../../util/Nui';
import Evidence from './components/Evidence';
import Tags from './components/Tags';
import Suspect from './components/Suspect';
import { usePerson, usePermissions } from '../../../hooks';

import { ReportTypes, GetOfficerNameFromReportType, GetOfficerJobFromReportType } from '../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	notes: {
		color: theme.palette.text.alt,
		padding: '8px 16px',
		whiteSpace: 'pre-line',
		'& img': {
			width: '100%',
			maxWidth: 300,
		},
	},
	link: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
	},
	officerLink: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
		'&:not(:last-of-type)': {
			content: '", "',
			color: theme.palette.text.main,
		},
	},
}));

export default ({ match }) => {
	const classes = useStyles();
	const history = useNavigate();
	const hasPerms = usePermissions();
	const formatPerson = usePerson();
	const params = useParams();
	const attorney = useSelector((state) => state.app.attorney);

	const [err, setErr] = useState(false);
	const [loading, setLoading] = useState(false);
	const [report, setReport] = useState(null);

	const [pOpen, setPOpen] = useState(false);
	const [pIndex, setPIndex] = useState(0);

	const onEdit = () => {
		history(`/create/report?case=${report._id}`);
	};

	const onDelete = async () => {
		if (hasPerms(true)) {
			try {
				let res = await (
					await Nui.send('Delete', {
						type: 'report',
						id: report._id,
					})
				).json();
				if (res) {
					toast.success('Report Deleted');
					history(`/search/reports`);
				} else toast.error('Unable to Delete Report');
			} catch (err) {
				console.log(err);
				toast.error('Unable to Delete Report');
			}
		}
	};

	const onEvidenceLocker = async () => {
		try {
			let res = await (await Nui.send('EvidenceLocker', report?.ID)).json();
			if (res) Nui.send('Close');
			else toast.error('Unable to Open Evidence Locker');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Open Evidence Locker');
		}
	};

	const onEvidenceOpen = (index) => {
		setPIndex(index);
		setPOpen(true);
	};

	const getReportTypeHasEvidence = (reportType) => {
		return ReportTypes.find((r) => r.value == reportType)?.hasEvidence;
	};

	const getReportTypeName = (reportType) => {
		return ReportTypes.find((r) => r.value == reportType)?.label ?? 'Incident Report';
	};

	const canEditReport = (reportType) => {
		return hasPerms(ReportTypes.find((r) => r.value == reportType)?.requiredCreatePermission, false);
	};

	const fetch = async () => {
		// setReport({
		//   _id: 0,
		//   ID: 69,
		//   type: 1,
		//   title: 'This is a report title',
		//   notes: '<p><a title=\"sedfsdf\" href=\"https://google.com\">https://google.com</a></p>',
		//   primariesInput: '',
		//   author: {},
		//   primaries: [
		//     {
		//       _id: '6088b90c93a7b379e0c83ef2',
		//       SID: 1,
		//       User: '606c22a749c1c980e8289b35',
		//       First: 'Testy',
		//       Last: 'McTest',
		//       Gender: 0,
		//       Origin: 'United States',
		//       Job: {
		//         Workplace: {
		//           Id: 'sasp',
		//           Name: 'San Andreas State Police',
		//         },
		//         Name: 'Police',
		//         Grade: {
		//           Id: 'superint',
		//           Name: 'Superintendent',
		//         },
		//         Id: 'police',
		//       },
		//       DOB: '1991-01-01T07:59:59.000Z',
		//       Callsign: 404,
		//       Phone: '121-195-9016',
		//     },
		//     {
		//       _id: '6088b90c93a7b379e0c83ef2',
		//       SID: 2,
		//       User: '606c22a749c1c980e8289b35',
		//       First: 'Testy',
		//       Last: 'McTest',
		//       Gender: 0,
		//       Origin: 'United States',
		//       Job: {
		//         Workplace: {
		//           Id: 'sasp',
		//           Name: 'San Andreas State Police',
		//         },
		//         Name: 'Police',
		//         Grade: {
		//           Id: 'superint',
		//           Name: 'Superintendent',
		//         },
		//         Id: 'police',
		//       },
		//       DOB: '1991-01-01T07:59:59.000Z',
		//       Callsign: 404,
		//       Phone: '121-195-9016',
		//     },
		//   ],
		//   tags: [1],
		//   assistingInput: '',
		//   assisting: [],
		//   suspects: [
		//     {
		//       plea: 'guilty',
		//       charges: [],
		//       suspect: {
		//         _id: '6088b90c93a7b379e0c83ef2',
		//         SID: 1,
		//         User: '606c22a749c1c980e8289b35',
		//         First: 'Testy',
		//         Last: 'McTest',
		//         Gender: 0,
		//         Origin: 'United States',
		//         Job: {
		//           Workplace: {
		//             Id: 'sasp',
		//             Name: 'San Andreas State Police',
		//           },
		//           Name: 'Police',
		//           Grade: {
		//             Id: 'superint',
		//             Name: 'Superintendent',
		//           },
		//           Id: 'police',
		//         },
		//         DOB: '1991-01-01T07:59:59.000Z',
		//         Callsign: 404,
		//         Phone: '121-195-9016',
		//         Licenses: [],
		//       },
		//     }
		//   ],
		//   evidence: new Array(20).fill({
		//     type: 'fragment',
		//     _id: 'f',
		//     label: 'cunt',
		//     value: 'double cunt',
		//   }),
		//   evidenceCounter: 1,
		//   time: 1621518551812,
		//   draft: 9,
		//   lastUpdated: {
		//     SID: 3,
		//     Callsign: 302,
		//     First: 'Shit',
		//     Last: 'Cunt',
		//     Time: 1628967582 * 1000,
		//   }
		// });
		// return

		setLoading(true);
		try {
			let res = await (
				await Nui.send('View', {
					type: 'report',
					id: params.id,
				})
			).json();

			if (res) setReport(res);
			else toast.error('Unable to Load');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Load');
			setErr(true);
		}
		setLoading(false);
	};

	useEffect(() => {
		fetch();
	}, []);

	const refresh = () => {
		fetch();
	}

	return (
		<div>
			{loading || (!report && !err) ? (
				<div className={classes.wrapper} style={{ position: 'relative' }}>
					<Loader static text="Loading" />
				</div>
			) : err ? (
				<Grid className={classes.wrapper} container>
					<Grid item xs={12}>
						<Alert variant="outlined" severity="error">
							Invalid Report ID
						</Alert>
					</Grid>
				</Grid>
			) : (
				<>
					<Grid className={classes.wrapper} container spacing={2}>
						<Grid item xs={12}>
							<ButtonGroup fullWidth>
								<Button onClick={fetch} disabled={loading}>
									Refresh
								</Button>
								{!attorney && getReportTypeHasEvidence(report?.type) ? (
									<Button onClick={onEvidenceLocker}>Evidence Locker</Button>
								) : null}
								{!attorney && (
									<Button disabled={!canEditReport} onClick={onEdit}>
										Edit Report
									</Button>
								)}
								{hasPerms(true) && <Button onClick={onDelete}>Delete Report</Button>}
							</ButtonGroup>
						</Grid>
						<Grid item xs={12}>
							<Grid container spacing={2}>
								<Grid item xs={2}>
									<ListItem>
										<ListItemText
											primary={`Report #${report.ID}`}
											secondary={getReportTypeName(report?.type)}
										/>
									</ListItem>
								</Grid>
								<Grid item xs={4}>
									<ListItem>
										<ListItemText primary="Report Title" secondary={report.title} />
									</ListItem>
								</Grid>
								<Grid item xs={3}>
									<ListItemText
										primary={
											<span>
												Created <Moment date={report.time} fromNow />
											</span>
										}
										secondary={
											<span>
												By&nbsp;
												<Link
													to={`/roster?id=${report.author.SID}`}
													className={classes.officerLink}
												>
													{formatPerson(
														report.author.First,
														report.author.Last,
														report.author.Callsign,
														report.author.SID,
														false,
														true,
													)}
												</Link>
												&nbsp;on&nbsp;
												<Moment date={report.time} format="LLL" />
											</span>
										}
									/>
								</Grid>
								<Grid item xs={3}>
									{report.lastUpdated && (
										<ListItemText
											primary={
												<span>
													Last Updated <Moment date={report.lastUpdated?.Time} fromNow />
												</span>
											}
											secondary={
												<span>
													By&nbsp;
													<Link
														to={`/roster?id=${report.lastUpdated.SID}`}
														className={classes.officerLink}
													>
														{formatPerson(
															report.lastUpdated.First,
															report.lastUpdated.Last,
															report.lastUpdated.Callsign,
															report.lastUpdated.SID,
															false,
															true,
														)}
													</Link>
													&nbsp;on&nbsp;
													<Moment date={report.lastUpdated?.Time} format="LLL" />
												</span>
											}
										/>
									)}
								</Grid>
							</Grid>
							<Divider flexItem />
						</Grid>
						<Grid item xs={8}>
							<List>
								<Tags tags={report.tags} />
								<ListItem>
									<ListItemText primary="Report Notes" />
								</ListItem>
								<div className={classes.notes}>
									<UserContent wrapperClass={classes.notes} content={report.notes} />
								</div>
								{report.type === 0 && (
									<Evidence
										evidence={report.evidence}
										onClick={(index) => {
											onEvidenceOpen(index);
										}}
									/>
								)}
							</List>
						</Grid>
						<Grid item xs={4}>
							<Grid container spacing={2}>
								<Grid item xs={6}>
									<ListItem>
										<ListItemText
											primary={
												report.type === 0
													? `Primary ${GetOfficerNameFromReportType(report.type)}`
													: `${GetOfficerNameFromReportType(report.type)} Involved`
											}
											secondary={
												<span>
													{report.primaries.map((o) => {
														return (
															<Link
																key={`primary-${o.SID}`}
																className={classes.officerLink}
																to={`/roster?id=${o.SID}`}
															>
																{formatPerson(o.First, o.Last, o.Callsign, o.SID)}
																<br></br>
															</Link>
														);
													})}
												</span>
											}
										/>
									</ListItem>
								</Grid>
								{report.type === 0 ? (
									<Grid item xs={6}>
										<ListItem>
											<ListItemText
												primary={`Assisting ${GetOfficerNameFromReportType(report.type)}`}
												secondary={
													report.assisting.length > 0 ? (
														<span>
															{report.assisting.map((o) => {
																return (
																	<Link
																		key={`assisting-${o.SID}`}
																		className={classes.officerLink}
																		to={`/roster?id=${o.SID}`}
																	>
																		{formatPerson(
																			o.First,
																			o.Last,
																			o.Callsign,
																			o.SID,
																		)}
																		<br></br>
																	</Link>
																);
															})}
														</span>
													) : (
														`No Assisting ${GetOfficerNameFromReportType(report.type)}`
													)
												}
											/>
										</ListItem>
									</Grid>
								) : (
									<Grid item xs={6}>
										<ListItem>
											<ListItemText
												primary="People Involved"
												secondary={
													report.people?.length > 0 ? (
														<span>
															{report.people.map((p) => {
																return (
																	<Link
																		key={`invovled-${p.SID}`}
																		className={classes.officerLink}
																		to={`/search/people/${p.SID}`}
																	>
																		{formatPerson(p.First, p.Last, false, p.SID)}
																		<br></br>
																	</Link>
																);
															})}
														</span>
													) : (
														'No People Involved'
													)
												}
											/>
										</ListItem>
									</Grid>
								)}
								{report.type === 0 ? (
									<Grid item xs={12}>
										{report.suspects.length > 0 ? (
											report.suspects.map((suspect, k) => {
												return (
													<Suspect
														key={`sus-${suspect.suspect._id}`}
														report={report}
														index={k}
														data={suspect}
														refresh={refresh}
													/>
												);
											})
										) : (
											<ListItem>
												<Alert variant="outlined" severity="info">
													Report Has No Suspects
												</Alert>
											</ListItem>
										)}
									</Grid>
								) : (
									<Grid item xs={12}>
										<Evidence
											evidence={report.evidence}
											onClick={(index) => {
												onEvidenceOpen(index);
											}}
										/>
									</Grid>
								)}
							</Grid>
						</Grid>
					</Grid>
					{report.evidence.length > 0 && pOpen && (
						<Lightbox
							mainSrc={report.evidence[pIndex].value}
							nextSrc={report.evidence[(pIndex + 1) % report.evidence.length].value}
							prevSrc={
								report.evidence[(pIndex + report.evidence.length - 1) % report.evidence.length].value
							}
							onCloseRequest={() => setPOpen(false)}
							onMovePrevRequest={() =>
								setPIndex((pIndex + report.evidence.length - 1) % report.evidence.length)
							}
							onMoveNextRequest={() => setPIndex((pIndex + 1) % report.evidence.length)}
						/>
					)}
				</>
			)}
		</div>
	);
};
