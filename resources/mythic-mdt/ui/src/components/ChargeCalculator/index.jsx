import React, { useEffect, useState } from 'react';
import {
	Divider,
	Grid,
	IconButton,
	TextField,
	InputAdornment,
	List,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import Truncate from '@nosferatu500/react-truncate';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CSSTransition, TransitionGroup } from 'react-transition-group';

import { Modal } from '../';
import { ChargeTypes } from '../../data';
import { CurrencyFormat } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		borderRadius: 4,
		border: `1px solid ${theme.palette.border.input}`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		boxShadow:
			'inset 0 0 14px 0 rgba(0,0,0,.3), inset 0 2px 0 rgba(0,0,0,.2)',
	},
	label: {
		transform: 'translate(11px, -10px) scale(0.75)',
		top: 0,
		left: 0,
		position: 'absolute',
		transformOrigin: 'top left',
		color: 'rgba(255, 255, 255, 0.5)',
		fontSize: '1rem',
		background: '#111315',
		padding: '0 4px',
	},
	charges: {
		height: '100%',
	},
	chargesHeader: {
		height: '15%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		padding: 5,
		marginBottom: 10,
		alignItems: 'center',
	},
	chargesBody: {
		height: '85%',
		maxHeight: 425,
		display: 'flex',
		flexDirection: 'row',
		flexWrap: 'wrap',
		placeContent: 'flex-start',
		gap: 5,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	charge: {
		width: '49%',
		marginBottom: 5,
		padding: 10,
		height: 70,
		userSelect: 'none',
		position: 'relative',
		color: theme.palette.text.main,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
		transition: 'filter ease-in 0.15s',
		'& small': {
			fontSize: 12,
			color: theme.palette.text.alt,
		},
		'&:hover': {
			filter: 'brightness(0.75)',
			cursor: 'pointer',
		},
		'&.type-1': {
			borderLeft: `5px solid ${theme.palette.info.main}`,
		},
		'&.type-2': {
			borderLeft: `5px solid ${theme.palette.warning.main}`,
		},
		'&.type-3': {
			borderLeft: `5px solid ${theme.palette.error.main}`,
		},
		'&-enter': {
			opacity: 0,
		},
		'&-enter-active': {
			opacity: 1,
			transition: 'opacity 500ms ease-in',
		},
		'&-exit': {
			opacity: 1,
		},
		'&-exit-active': {
			opacity: 0,
			transition: 'opacity 500ms ease-in',
		},
	},
	selected: {
		height: '100%',
	},
	selectedHeader: {
		height: '15%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		padding: 13,
		marginBottom: 10,
		alignItems: 'center',
	},
	selectedBody: {
		height: 380,
		maxHeight: '75%',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	selectedFooter: {
		height: '10%',
	},
	selectedCharge: {
		position: 'relative',
		lineHeight: '25px',
		padding: 5,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	removeBtn: {
		fontSize: 14,
		height: 22,
		width: 22,
		position: 'absolute',
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
		color: theme.palette.error.main,
	},
	key: {
		fontSize: 12,
		color: theme.palette.text.alt,
		display: 'inline-flex',
		marginLeft: 10,
		height: 'fit-content',
	},
	keyTitle: {
		fontSize: 18,
		color: theme.palette.text.main,
		marginRight: 10,
	},
	keyItem: {
		display: 'inline-block',
		padding: 5,
		'& svg': {
			marginRight: 2,
		},
	},
	infractionKey: {
		color: theme.palette.info.main,
	},
	misdemeanorKey: {
		color: theme.palette.warning.main,
	},
	felonyKey: {
		color: theme.palette.error.main,
	},
	suspending: {
		color: theme.palette.error.main,
	},
	detailsbtn: {
		position: 'absolute',
		fontSize: 15,
		right: 0,
		//top: 0,
		bottom: 0,
		margin: 'auto',
		height: 'fit-content',
		width: 'fit-content',
		zIndex: 5,
	},
}));

export default ({ selected, onChange, onRemove, wrapperClass }) => {
	const classes = useStyles();
	const charges = useSelector((state) => state.data.data.charges);

	const months = selected
		.filter((c) => c.jail)
		.reduce((a, b) => +a + +b.jail * b.count, 0);
	const fine = selected
		.filter((c) => c.fine)
		.reduce((a, b) => +a + +b.fine * b.count, 0);
	const points = selected
		.filter((c) => c.points)
		.reduce((a, b) => +a + +b.points * b.count, 0);
	const isFelony = selected.filter((c) => c.type > 2).length > 0;

	const [filtered, setFiltered] = useState(Array());
	const [search, setSearch] = useState('');
	const [selCharge, setSelCharge] = useState(null);

	useEffect(() => {
		if (search != '') {
			setFiltered(
				charges.filter((c) =>
					c.title.toUpperCase().includes(search.toUpperCase()),
				),
			);
		} else {
			setFiltered(charges);
		}
	}, [search]);

	useEffect(() => {
		setFiltered(
			charges.filter((c) =>
				c.title.toUpperCase().includes(search.toUpperCase()),
			),
		);
	}, [charges]);

	return (
		<div className={`${classes.wrapper} ${wrapperClass}`}>
			<div className={classes.label}>Charge Calculator</div>
			<Grid container spacing={2} style={{ height: '100%' }}>
				<Grid item xs={8} style={{ height: '100%' }}>
					<div className={classes.charges}>
						<Grid container className={classes.chargesHeader}>
							<Grid item xs={6}>
								<div className={classes.key}>
									<div className={classes.keyTitle}>
										Charges
									</div>
									<Divider orientation="vertical" flexItem />
									<div className={classes.keyItem}>
										<FontAwesomeIcon
											icon={['fas', 'square']}
											className={classes.infractionKey}
										/>
										<span>Infraction</span>
									</div>
									<div className={classes.keyItem}>
										<FontAwesomeIcon
											icon={['fas', 'square']}
											className={classes.misdemeanorKey}
										/>
										<span>Misdemeanor</span>
									</div>
									<div className={classes.keyItem}>
										<FontAwesomeIcon
											icon={['fas', 'square']}
											className={classes.felonyKey}
										/>
										<span>Felony</span>
									</div>
								</div>
							</Grid>
							<Grid item xs={6} style={{ textAlign: 'right' }}>
								<TextField
									size="small"
									placeholder="Search Charges"
									value={search}
									onChange={(e) => setSearch(e.target.value)}
									InputProps={{
										endAdornment: (
											<InputAdornment position="end">
												<IconButton
													onClick={() =>
														setSearch('')
													}
													disabled={search == ''}
												>
													<FontAwesomeIcon
														icon={['fas', 'xmark']}
													/>
												</IconButton>
											</InputAdornment>
										),
									}}
								/>
							</Grid>
						</Grid>
						<TransitionGroup className={classes.chargesBody}>
							{filtered
								.sort((a, b) => a.fine - b.fine)
								.sort((a, b) => a.jail - b.jail)
								.sort((a, b) => a.type - b.type)
								.map((charge) => {
									return (
										<CSSTransition
											key={`avail-${charge._id}`}
											timeout={500}
											classNames="item"
										>
											<div
												className={`${classes.charge} type-${charge.type}`}
												title={charge.title}
												onClick={() => onChange(charge)}
											>
												<Truncate lines={1}>
													{charge.title}
												</Truncate>
												<div>
													<small>
														{charge.jail
															? `Time: ${charge.jail} `
															: null}
														{charge.fine
															? `Fine: ${CurrencyFormat.format(
																	charge.fine,
															  )} `
															: null}
														{charge.points
															? `Points: ${charge.points}`
															: null}
													</small>
												</div>
												<IconButton
													className={
														classes.detailsbtn
													}
													onClick={(e) => {
														e.stopPropagation();
														setSelCharge(charge);
													}}
												>
													<FontAwesomeIcon
														icon={[
															'fas',
															'circle-question',
														]}
													/>
												</IconButton>
											</div>
										</CSSTransition>
									);
								})}
						</TransitionGroup>
					</div>
				</Grid>
				<Grid item xs={4} style={{ height: '100%' }}>
					<div className={classes.selected}>
						<Grid container className={classes.selectedHeader}>
							<Grid item xs={12}>
								Current Charges
							</Grid>
						</Grid>
						<ul className={classes.selectedBody}>
							{selected.map((charge) => {
								return (
									<li
										key={`selected-${charge._id}`}
										className={classes.selectedCharge}
									>
										{charge.title} x{charge.count}
										<IconButton
											className={classes.removeBtn}
											onClick={() => onRemove(charge)}
										>
											<FontAwesomeIcon
												icon={['fas', 'circle-xmark']}
											/>
										</IconButton>
									</li>
								);
							})}
						</ul>
						<div className={classes.selectedFooter}>
							<Grid container>
								<Grid item xs={points > 0 ? 4 : 6}>
									Months: <small>{months}</small>
								</Grid>
								<Grid item xs={points > 0 ? 5 : 6}>
									Fine:{' '}
									<small>{CurrencyFormat.format(fine)}</small>
								</Grid>
								{points > 0 && (
									<Grid
										item
										xs={3}
										className={
											points >= 12
												? classes.suspending
												: null
										}
									>
										Points: <small>{points}</small>
									</Grid>
								)}
							</Grid>
						</div>
					</div>
				</Grid>
			</Grid>
			<Modal
				open={selCharge != null}
				title={
					Boolean(selCharge) ? `${selCharge.title} Details` : 'UNK'
				}
				closeLang="Close"
				onClose={() => setSelCharge(null)}
			>
				{Boolean(selCharge) && (
					<List>
						<ListItem>
							<ListItemText
								primary="Charge Type"
								secondary={
									ChargeTypes.filter(
										(t) => t.value == selCharge.type,
									)[0].label
								}
							/>
						</ListItem>
						<ListItem>
							<ListItemText
								primary="Charge Name"
								secondary={selCharge.title}
							/>
						</ListItem>
						<ListItem>
							<ListItemText
								style={{ whiteSpace: 'pre-line' }}
								primary="Charge Description"
								secondary={selCharge.description}
							/>
						</ListItem>
						{Boolean(selCharge.fine) && (
							<ListItem>
								<ListItemText
									primary="Fine"
									secondary={CurrencyFormat.format(
										selCharge.fine,
									)}
								/>
							</ListItem>
						)}
						{Boolean(selCharge.jail) && (
							<ListItem>
								<ListItemText
									primary="Jail Sentence"
									secondary={`${selCharge.jail} Months`}
								/>
							</ListItem>
						)}
						{Boolean(selCharge.points) && (
							<ListItem>
								<ListItemText
									primary="License Points"
									secondary={`${selCharge.points} Points`}
								/>
							</ListItem>
						)}
					</List>
				)}
			</Modal>
		</div>
	);
};
