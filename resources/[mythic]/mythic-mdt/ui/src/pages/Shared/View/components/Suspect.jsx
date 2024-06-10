import React, { useState, useEffect } from 'react';
import {
	Chip,
	Grid,
	IconButton,
	Tooltip,
	TextField,
	FormControlLabel,
	Switch,
	FormGroup,
	MenuItem,
	Divider,
	Fade,
	Skeleton,
	Alert,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useDispatch, useSelector } from 'react-redux';
import moment from 'moment';
import { toast } from 'react-toastify';
import Truncate from '@nosferatu500/react-truncate';

import Nui from '../../../../util/Nui';
import { CurrencyFormat } from '../../../../util/Parser';
import { Modal } from '../../../../components';
import { PleaTypes } from '../../Create/components/SuspectForm';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		borderRadius: 4,
		border: `1px solid ${theme.palette.border.input}`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		maxWidth: '100%',
		width: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		boxShadow: 'inset 0 0 14px 0 rgba(0,0,0,.3), inset 0 2px 0 rgba(0,0,0,.2)',
		marginTop: 15,
	},
	title: {
		fontSize: 18,
		lineHeight: '48px',
		'& small': {
			'&::before': {
				content: '" - "',
				color: theme.palette.text.alt,
			},
			fontSize: 14,
			color: theme.palette.primary.main,
		},
	},
	body: {
		padding: 10,
		borderTop: `1px solid ${theme.palette.border.input}`,
	},
	charge: {
		margin: 4,
		maxWidth: 150,
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
	points: {
		position: 'relative',
	},
	flags: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	flag: {
		fontSize: 18,
		height: 32,
		width: 32,
		color: theme.palette.error.light,
		'&:not(:last-of-type)': {
			marginRight: 5,
		},
	},
	sentenceFlag: {
		margin: 4,
		color: theme.palette.secondary.dark,
	},
	sentenced: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
		textTransform: 'uppercase',
		color: theme.palette.text.alt,
	},
	editorField: {
		marginBottom: 10,
	},
	link: {
		color: theme.palette.text.main,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
			cursor: 'pointer',
			textDecoration: 'none',
		},
	},
	reduction: {
		fontSize: 12,
		color: theme.palette.text.alt,
		marginLeft: 5,
	},
	popup: {
		maxHeight: `750px !important`,
	},
}));

export const ReductionTypes = [
	{
		label: 'Jail Time',
		value: 'months',
	},
	{
		label: 'Fine',
		value: 'fine',
	},
];

export const ParoleMultiplier = 1.5;

export default ({ index, data, report, refresh }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const warrants = useSelector((state) => state.data.data.warrants)?.filter((w) => w.report._id == report._id);
	const susWarrant = warrants?.filter((w) => w.suspect.SID == data.suspect.SID)[0];
	const breakpoints = useSelector((state) => state.app.pointBreakpoints);

	const months = data.charges.filter((c) => c.jail).reduce((a, b) => +a + +b.jail * b.count, 0);
	const fine = data.charges.filter((c) => c.fine).reduce((a, b) => +a + +b.fine * b.count, 0);
	const points = data.charges.filter((c) => c.points).reduce((a, b) => +a + +b.points * b.count, 0);
	const isFelony = data.charges.filter((c) => c.type > 2).length > 0;
	const isInfraction = data.charges.filter((c) => c.type > 1).length <= 0;

	const [warrant, setWarrant] = useState(false);
	const [open, setOpen] = useState(false);
	const [sentence, setSentence] = useState({
		type: false,
		value: 0,
		revoke: {
			weapons: false,
			hunting: false,
			fishing: false,
			drivers:
				data.suspect.Licenses?.Drivers?.Points + points >= breakpoints?.license &&
				data.suspect.Licenses?.Drivers?.Active,
		},
		doc: false,
		parole: false,
	});

	const [time, setTime] = useState(Date.now());
	useEffect(() => {
		let i = setInterval(() => {
			setTime(Date.now());
		}, 30000);
		return () => {
			clearInterval(i);
		};
	}, []);

	const [parole, setParole] = useState(null);
	const [loading, setLoading] = useState(false);
	useEffect(() => {
		const fetch = async () => {
			try {
				let res = await (
					await Nui.send('CheckParole', {
						index,
						SID: data.suspect.SID,
					})
				).json();
				if (res && res.end > Date.now()) {
					setParole({
						...res,
						remaining: Math.ceil(moment.duration(res.end - Date.now(), 'ms').asMinutes()),
					});
				} else {
					setParole(false);
				}
				setLoading(false);
			} catch (err) {
				console.log(err);
				setParole(false);
				setLoading(false);
			}
		};

		if (!data.sentence) {
			setLoading(true);
			fetch();
		}
	}, []);

	const onChange = (e) => {
		setSentence({
			...sentence,
			[e.target.name]: e.target.value,
		});
	};

	const onChangeCheck = (e) => {
		setSentence({
			...sentence,
			[e.target.name]: e.target.checked,
		});
	};

	const onSubmit = async (e) => {
		e.preventDefault();
		if (Boolean(data.sentence)) return;
		setLoading(true);
		setOpen(false);

		const jailTime = calculate('jail');
		const fine = calculate('fine');
		const totalParole = calculate('parole');
		const points = calculate('points');

		try {
			let res = await (
				await Nui.send('SentencePlayer', {
					report: report.ID,
					data,
					sentence,
					jail: jailTime,
					fine: fine,
					points: points,
					index,
					parole: !isInfraction
						? {
								end: moment(Date.now()).add(totalParole, 'minutes').unix() * 1000,
								total: totalParole,
								parole: Math.ceil(jailTime * (ParoleMultiplier - 1)),
								sentence: jailTime,
								fine: fine,
						  }
						: null,
				})
			).json();
			if (res) {
				refresh();
				toast.success('Sentenced Successfully');
				//setLoading(false);
			} else toast.error('Unable to Sentence');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Sentence');
		}

		setLoading(false);
	};

	const calculate = (key) => {
		switch (key) {
			case 'jail':
				return sentence.type == 'months'
					? Math.ceil((Boolean(parole) ? parole.parole : 0) + months * (1 - sentence.value / 100))
					: Math.ceil((Boolean(parole) ? parole.parole : 0) + months);
			case 'fine':
				return sentence.type == 'fine' ? Math.ceil(fine * (1 - sentence.value / 100)) : Math.ceil(fine);
			case 'parole':
				return Math.ceil(calculate('jail') * ParoleMultiplier);
			case 'points':
				return points;
		}
	};

	const onSubmitWarrant = async (e) => {
		e.preventDefault();

		try {
			let doc = {
				state: 'active',
				suspect: data.suspect,
				report: {
					_id: report._id,
					ID: report.ID,
				},
				time,
				expires: moment(time).add(7, 'days').unix() * 1000,
				notes: e.target.notes.value,
			};

			let res = await (
				await Nui.send('Create', {
					type: 'warrant',
					doc: doc,
				})
			).json();

			if (res) {
				setWarrant(false);
				toast.success('Warrant Created');
			} else toast.error('Unable to Create Warrant');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Create Warrant');
		}
	};

	if (loading) {
		return <Skeleton animation="wave" height={300} width="100%" />;
	} else {
		return (
			<div className={classes.wrapper}>
				<Grid container>
					<Grid item xs={8} className={classes.title}>
						<Link className={classes.link} to={`/search/people/${data.suspect.SID}`}>
							{data.suspect.First} {data.suspect.Last}
						</Link>
						<small>{PleaTypes.filter((p) => p.value == data.plea)[0].label}</small>
					</Grid>
					<Grid item xs={4} style={{ textAlign: 'right', position: 'relative' }}>
						{!Boolean(data.sentence) ? (
							<>
								{Boolean(susWarrant) ? (
									<Tooltip title="View Warrant">
										<IconButton component={Link} to={`/warrants/${susWarrant._id}`}>
											<FontAwesomeIcon icon={['fas', 'eye']} />
										</IconButton>
									</Tooltip>
								) : (
									<Tooltip title="Issue Warrant">
										<IconButton disabled={isInfraction} onClick={() => setWarrant(true)}>
											<FontAwesomeIcon icon={['fas', 'file-invoice']} />
										</IconButton>
									</Tooltip>
								)}
								<Tooltip title={`Charge ${data.suspect.First} ${data.suspect.Last}`}>
									<IconButton onClick={() => setOpen(true)}>
										<FontAwesomeIcon icon={['fas', 'triangle-exclamation']} />
									</IconButton>
								</Tooltip>
							</>
						) : (
							<small className={classes.sentenced}>Sentenced</small>
						)}
					</Grid>
					<Grid item xs={12} className={classes.body}>
						{data.charges
							.sort((a, b) => b.jail + b.fine - (a.jail - a.fine))
							.map((c, k) => {
								return (
									<Tooltip title={`${c.title} x${c.count}`}>
										<Chip
											key={`charge-${k}`}
											className={`${classes.charge} type-${c.type}`}
											label={<Truncate lines={1}>{`${c.title} x${c.count}`}</Truncate>}
										/>
									</Tooltip>
								);
							})}
					</Grid>

					{Boolean(data.sentence) && (
						<Grid item xs={12} className={classes.body}>
							<Grid container>
								<Grid item xs={12}>
									{data.sentence.doc && (
										<Tooltip title="Requested DOC Transport">
											<Chip
												color="primary"
												className={classes.sentenceFlag}
												icon={<FontAwesomeIcon icon={['fas', 'bus']} />}
												label="DOC Transport"
											/>
										</Tooltip>
									)}
									{data.sentence?.revoked.weapons && (
										<Tooltip title="Weapons Permit Revoked">
											<Chip
												color="primary"
												className={classes.sentenceFlag}
												icon={<FontAwesomeIcon icon={['fas', 'gun']} />}
												label="Permit Revoked"
											/>
										</Tooltip>
									)}
									{data.sentence?.revoked?.drivers && (
										<Tooltip title="Drivers License Revoked">
											<Chip
												color="primary"
												className={classes.sentenceFlag}
												icon={<FontAwesomeIcon icon={['fas', 'id-card']} />}
												label="License Revoked"
											/>
										</Tooltip>
									)}
									{Boolean(data.sentence?.reduction?.type) && (
										<Tooltip
											title={`${data.sentence.reduction.value}% Reduction Was Given For: ${
												ReductionTypes.filter((r) => r.value == data.sentence.reduction.type)[0]
													.label
											}`}
										>
											<Chip
												color="primary"
												className={classes.sentenceFlag}
												icon={<FontAwesomeIcon icon={['fas', 'percent']} />}
												label={`Reduction of ${data.sentence.reduction.value}%`}
											/>
										</Tooltip>
									)}
								</Grid>
							</Grid>
						</Grid>
					)}

					<Grid item xs={12} className={classes.body}>
						{Boolean(data.sentence) ? (
							<Grid container>
								<Grid item xs={4}>
									Months:{' '}
									<small>
										{data.sentence.months}
										{Boolean(data.sentence.reduction && data.sentence.reduction.type) &&
										data.sentence.reduction.type == 'months' ? (
											<span className={classes.reduction}>-{data.sentence.reduction.value}%</span>
										) : null}
									</small>
								</Grid>
								<Grid item xs={5}>
									Fine:{' '}
									<small>
										{CurrencyFormat.format(data.sentence.fine)}
										{Boolean(data.sentence.reduction && data.sentence.reduction.type) &&
										data.sentence.reduction.type == 'fine' ? (
											<span className={classes.reduction}>-{data.sentence.reduction.value}%</span>
										) : null}
									</small>
								</Grid>
								<Grid item xs={3} className={classes.points}>
									Points: <small>{points}</small>
								</Grid>
							</Grid>
						) : (
							<Grid container>
								<Grid item xs={4}>
									Months: <small>{months}</small>
								</Grid>
								<Grid item xs={4}>
									Fine: <small>{CurrencyFormat.format(fine)}</small>
								</Grid>
								<Grid item xs={4} className={classes.points}>
									<div>
										Points: <small>{points}</small>
										<div className={classes.flags}>
											{isFelony && data.suspect.Licenses.Weapons.Active && (
												<Tooltip title="This will result in this persons weapons permit being revoked">
													<IconButton className={classes.flag}>
														<FontAwesomeIcon icon={['fas', 'dagger']} />
													</IconButton>
												</Tooltip>
											)}
											{data.suspect.Licenses?.Drivers?.Points + points >=
												breakpoints?.license && (
												<Tooltip title="This will result in this persons drivers license being revoked">
													<IconButton className={classes.flag}>
														<FontAwesomeIcon icon={['fas', 'id-badge']} />
													</IconButton>
												</Tooltip>
											)}
										</div>
									</div>
								</Grid>
							</Grid>
						)}
					</Grid>
				</Grid>
				<Modal
					open={open}
					title={`Sentence ${data.suspect.First} ${data.suspect.Last}`}
					submitLang="Sentence"
					onSubmit={onSubmit}
					onClose={() => setOpen(false)}
				>
					<Grid container spacing={2}>
						<Grid item xs={12}>
							{!isInfraction ? (
								<Grid container style={{ textAlign: 'center' }}>
									<Grid item xs={3}>
										Months: <small>{calculate('jail')}</small>
									</Grid>
									<Grid item xs={3}>
										Parole: <small>{calculate('parole')}</small>
									</Grid>
									<Grid item xs={3}>
										Fine: <small>{CurrencyFormat.format(calculate('fine'))}</small>
									</Grid>
									<Grid item xs={3} className={classes.points}>
										<div>
											Points: <small>{calculate('points')}</small>
										</div>
									</Grid>
								</Grid>
							) : (
								<Grid container style={{ textAlign: 'center' }}>
									<Grid item xs={6}>
										Fine: <small>{CurrencyFormat.format(calculate('fine'))}</small>
									</Grid>
									<Grid item xs={6} className={classes.points}>
										<div>
											Points: <small>{calculate('points')}</small>
										</div>
									</Grid>
								</Grid>
							)}
						</Grid>

						{/* {Boolean(parole) && (
              <Grid item xs={12}>
                <h4>Applied Deferred Sentence</h4>
                <Grid container style={{ textAlign: "center" }}>
                  <Grid item xs={6}>
                    Months: <small>{calculateDiff("jail")}</small>
                  </Grid>
                  <Grid item xs={6}>
                    Fine:{" "}
                    <small>
                      {CurrencyFormat.format(calculateDiff("fine"))}
                    </small>
                  </Grid>
                </Grid>
              </Grid>
            )} */}
						{!isInfraction && Boolean(parole) && (
							<Grid item xs={12}>
								<Alert variant="filled" severity="info">
									{data.suspect.First} {data.suspect.Last} currently has {parole.remaining} months of
									parole remaining, {parole.parole} months has been added to their jail time
								</Alert>
							</Grid>
						)}
						{!isInfraction && (
							<Grid item xs={6}>
								<TextField
									select
									fullWidth
									label="Reduction Type"
									name="type"
									className={classes.editorField}
									value={sentence.type}
									onChange={onChange}
								>
									<MenuItem key={'none'} value={false}>
										No Reduction
									</MenuItem>
									{ReductionTypes.map((option) => (
										<MenuItem key={option.value} value={option.value}>
											{option.label}
										</MenuItem>
									))}
								</TextField>
								<TextField
									fullWidth
									label="Reduction Percent"
									name="value"
									helperText={`Max: ${breakpoints?.reduction}%`}
									type="number"
									disabled={sentence.type == ''}
									className={classes.editorField}
									value={sentence.value}
									onChange={(e) => {
										if (e.target.value > breakpoints?.reduction)
											e.target.value = breakpoints?.reduction;
										else if (e.target.value < 0) e.target.value = 0;
										onChange(e);
									}}
									InputProps={{
										inputProps: {
											min: 0,
											max: breakpoints?.reduction,
											pattern: '0-9',
										},
									}}
								/>
							</Grid>
						)}
						<Grid item xs={6}>
							<FormGroup className={classes.editorField}>
								<FormControlLabel
									control={
										<Switch
											value={sentence.revoke.drivers}
											onChange={(e) => {
												setSentence({
													...sentence,
													revoke: {
														...sentence.revoke,
														drivers: e.target.checked,
													},
												});
											}}
											color="primary"
											name="drivers"
											disabled={
												data.suspect.Licenses?.Drivers?.Points + points <
													breakpoints?.license || !data.suspect.Licenses?.Drivers?.Active
											}
										/>
									}
									label="Revoke Driver's License?"
								/>
							</FormGroup>
							{!isInfraction && (
								<FormGroup className={classes.editorField}>
									<FormControlLabel
										control={
											<Switch
												value={sentence.revoke.weapons}
												onChange={(e) => {
													setSentence({
														...sentence,
														revoke: {
															...sentence.revoke,
															weapons: e.target.checked,
														},
													});
												}}
												color="primary"
												name="weapons"
												disabled={data.suspect.Licenses?.Weapons?.Suspended || !isFelony}
												//defaultChecked={isFelony && data.suspect.Licenses?.Weapons?.Active}
											/>
										}
										label="Revoke Weapons Permit?"
									/>
								</FormGroup>
							)}
							<FormGroup className={classes.editorField}>
								<FormControlLabel
									control={
										<Switch
											value={sentence.revoke.hunting}
											onChange={(e) => {
												setSentence({
													...sentence,
													revoke: {
														...sentence.revoke,
														hunting: e.target.checked,
													},
												});
											}}
											color="primary"
											name="hunting"
											disabled={data.suspect.Licenses?.Hunting?.Suspended}
										/>
									}
									label="Revoke Hunting License?"
								/>
							</FormGroup>
							<FormGroup className={classes.editorField}>
								<FormControlLabel
									control={
										<Switch
											value={sentence.revoke.fishing}
											onChange={(e) => {
												setSentence({
													...sentence,
													revoke: {
														...sentence.revoke,
														fishing: e.target.checked,
													},
												});
											}}
											color="primary"
											name="fishing"
											disabled={data.suspect.Licenses?.Fishing?.Suspended}
										/>
									}
									label="Revoke Fishing License?"
								/>
							</FormGroup>
							{!isInfraction && (
								<FormGroup className={classes.editorField}>
									<FormControlLabel
										control={
											<Switch
												value={sentence.doc}
												onChange={onChangeCheck}
												color="primary"
												name="doc"
											/>
										}
										label="Requested DOC Transport?"
									/>
								</FormGroup>
							)}
						</Grid>
						<Grid item xs={12}>
							<Alert variant="filled" severity="warning">
								Once sentenced, the charges brought upon{' '}
								<b>
									{data.suspect.First} {data.suspect.Last}
								</b>{' '}
								cannot be edited or removed.
							</Alert>
						</Grid>
					</Grid>
				</Modal>
				<Modal
					maxWidth="md"
					open={warrant}
					title={`Issue Arrest Warrant For ${data.suspect.First} ${data.suspect.Last}`}
					submitLang="Create Warrant"
					onSubmit={onSubmitWarrant}
					onClose={() => setWarrant(false)}
				>
					<TextField
						fullWidth
						disabled
						className={classes.editorField}
						label="Suspect"
						name="suspect"
						value={`${data.suspect.First} ${data.suspect.Last} (${data.suspect.SID})`}
					/>
					<TextField
						fullWidth
						disabled
						className={classes.editorField}
						label="Expires"
						name="expires"
						value={moment(time).add(7, 'days').format('LLLL')}
					/>
					<TextField
						fullWidth
						disabled
						className={classes.editorField}
						label="Referenced Report"
						name="report"
						value={`${report.title} [Case #${report.ID}]`}
					/>
					<TextField
						fullWidth
						multiline
						minRows={6}
						className={classes.editorField}
						label="Warrant Notes"
						name="notes"
					/>
				</Modal>
			</div>
		);
	}
};
