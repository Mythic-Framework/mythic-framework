import React, { useEffect, useState } from 'react';
import {
	Divider,
	Button,
	Grid,
	IconButton,
	TextField,
	InputAdornment,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import Truncate from '@nosferatu500/react-truncate';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import { toast } from 'react-toastify';

import { Modal } from '../../components';
import { CurrencyFormat } from '../../util/Parser';
import { ChargeTypes } from '../../data';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		height: '100%',
	},
	chargesWrapper: {
		height: '90%',
		display: 'flex',
		flexDirection: 'row',
		flexWrap: 'wrap',
		placeContent: 'flex-start',
		gap: 5,
		overflowY: 'auto',
		overflowX: 'hidden',
		justifyContent: 'space-between',
	},
	charge: {
		width: '49%',
		marginBottom: 5,
		padding: 10,
		height: 70,
		userSelect: 'none',
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
	field: {
		marginBottom: 15,
	},
	key: {
		fontSize: 16,
		color: theme.palette.text.alt,
		display: 'inline-flex',
		marginLeft: 10,
		height: 'fit-content',
	},
	keyTitle: {
		fontSize: 26,
		color: theme.palette.text.main,
		marginRight: 16,
	},
	keyItem: {
		display: 'inline-block',
		padding: '8px 16px',
		'& svg': {
			marginRight: 5,
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
}));

const initialState = {
	type: 1,
	title: '',
	description: '',
	fine: '',
	jail: '',
	points: '',
};

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const charges = useSelector((state) => state.data.data.charges);
	const breakpoints = useSelector((state) => state.app.pointBreakpoints);

	const [search, setSearch] = useState('');
	const [selected, setSelected] = useState(null);
	const [filtered, setFiltered] = useState(Array());

	useEffect(() => {
		setFiltered(
			charges.filter((c) =>
				c.title.toUpperCase().includes(search.toUpperCase()),
			),
		);
	}, [search]);

	useEffect(() => {
		setFiltered(
			charges.filter((c) =>
				c.title.toUpperCase().includes(search.toUpperCase()),
			),
		);
	}, [charges]);

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send(selected._id ? 'Update' : 'Create', {
					type: 'charge',
					doc: selected,
				})
			).json();

			if (res) {
				toast.success(`Charge ${selected._id ? 'Edited' : 'Created'}`);
				setSelected(null);
			} else
				toast.error(
					`Unable to ${selected._id ? 'Edit' : 'Create'} Charge`,
				);
		} catch (err) {
			console.log(err);
			toast.error(`Unable to ${selected._id ? 'Edit' : 'Create'} Charge`);
		}
	};

	const onChange = (e) => {
		setSelected({
			...selected,
			[e.target.name]: e.target.value,
		});
	};

	const onDisable = async () => {
		try {
			let res = await (
				await Nui.send('Update', {
					type: 'charge',
					doc: {
						...selected,
						active: false,
					},
				})
			).json();

			if (res) {
				toast.success(`Charge Disabled`);
				setSelected(null);
			} else toast.error('Unable to Disable Charge');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Disable Charge');
		}
	};

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={2} className={classes.field}>
				<Grid item xs={6}>
					<div className={classes.key}>
						<div className={classes.keyTitle}>
							Edit Charges
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
				<Grid item xs={4}>
					<TextField
						fullWidth
						variant="outlined"
						name="search"
						value={search}
						onChange={(e) => setSearch(e.target.value)}
						label="Search Charge"
						InputProps={{
							endAdornment: (
								<InputAdornment position="end">
									{search != '' && (
										<IconButton
											type="button"
											onClick={() => setSearch('')}
										>
											<FontAwesomeIcon
												icon={['fas', 'xmark']}
											/>
										</IconButton>
									)}
								</InputAdornment>
							),
						}}
					/>
				</Grid>
				<Grid item xs={2}>
					<Button
						fullWidth
						variant="outlined"
						style={{ height: '100%' }}
						onClick={() => setSelected(initialState)}
					>
						Create Charge
					</Button>
				</Grid>
			</Grid>
			<TransitionGroup className={classes.chargesWrapper}>
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
									onClick={() => setSelected(charge)}
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
								</div>
							</CSSTransition>
						);
					})}
			</TransitionGroup>
			<Modal
				open={selected != null}
				title={`${selected?._id ? 'Edit' : 'Create'} Charge`}
				submitLang={selected?._id ? 'Edit' : 'Create'}
				deleteLang="Disable"
				onSubmit={onSubmit}
				onClose={() => setSelected(null)}
				//onDelete={selected?._id ? onDisable : null}
			>
				{Boolean(selected) ? (
					<>
						<TextField
							fullWidth
							required
							className={classes.field}
							label="Title"
							name="title"
							value={selected.title}
							onChange={onChange}
						/>
						<TextField
							fullWidth
							required
							multiline
							minRows={6}
							className={classes.field}
							label="Charge Description"
							name="description"
							value={selected.description}
							onChange={onChange}
						/>

						<TextField
							select
							fullWidth
							required
							label="Charge Type"
							name="type"
							className={classes.field}
							value={selected.type}
							onChange={onChange}
						>
							{ChargeTypes.map((option) => (
								<MenuItem
									key={option.value}
									value={option.value}
								>
									{option.label}
								</MenuItem>
							))}
						</TextField>
						<Grid container spacing={2}>
							<Grid item xs={4}>
								<TextField
									fullWidth
									className={classes.field}
									label="Jail Time"
									name="jail"
									type="number"
									value={selected.jail}
									onChange={onChange}
								/>
							</Grid>
							<Grid item xs={4}>
								<TextField
									fullWidth
									className={classes.field}
									label="Fine"
									name="fine"
									type="number"
									value={selected.fine}
									onChange={onChange}
								/>
							</Grid>
							<Grid item xs={4}>
								<TextField
									fullWidth
									className={classes.field}
									helperText={`${breakpoints?.license} Points Will Revoke Drivers License`}
									label="License Points"
									name="points"
									type="number"
									value={selected.points}
									onChange={onChange}
								/>
							</Grid>
						</Grid>
					</>
				) : null}
			</Modal>
		</div>
	);
};
