import React, { useMemo, useState, useEffect } from 'react';
import {
	Grid,
	TextField,
	Autocomplete,
	ListItem,
	ListItemText,
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _, { debounce } from 'lodash';
import { toast } from 'react-toastify';
import Moment from 'react-moment';

import Nui from '../../../../util/Nui';
import { ChargeCalculator, Modal } from '../../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	editorField: {
		marginBottom: 10,
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
}));

export const PleaTypes = [
	{
		label: 'Guilty',
		value: 'guilty',
	},
	{
		label: 'Not Guilty',
		value: 'not-guilty',
	},
	{
		label: 'No Contest',
		value: 'no-contest',
	},
	{
		label: 'Unknown',
		value: 'unknown',
	},
];

export const initialState = {
	suspectInput: '',
	suspect: null,
	charges: Array(),
	plea: 'unknown',
};

export default ({ open, onSubmit, onEdit, onCancel, suspect = null }) => {
	const classes = useStyles();
	const [characters, setCharacters] = useState(Array());
	const [state, setState] = useState(initialState);
	const [loading, setLoading] = useState(false);

	useEffect(() => {
		setState(Boolean(suspect) ? suspect : initialState);
	}, [suspect]);

	const fetch = useMemo(
		() =>
			debounce(async (v) => {
				setLoading(true);
				try {
					let res = await (
						await Nui.send('Search', {
							type: 'people',
							term: v,
						})
					).json();
					setCharacters(res);
				} catch (err) {
					setCharacters(Array());
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		if (state?.suspectInput && state.suspectInput.length > 0) {
			setLoading(true);
			setCharacters(Array());

			fetch(state.suspectInput);
		} else {
			setLoading(false);
			setCharacters(Array());
		}
	}, [state.suspectInput]);

	const onChargeAdd = (charge) => {
		if (state.charges.filter((c) => c._id == charge._id).length > 0) {
			setState({
				...state,
				charges: state.charges.map((c) => {
					if (c._id == charge._id)
						return { ...c, count: c.count + 1, description: null };
					else return c;
				}),
			});
		} else {
			setState({
				...state,
				charges: [...state.charges, { ...charge, count: 1, description: null }],
			});
		}
	};

	const onChargeRemove = (charge) => {
		setState({
			...state,
			charges: state.charges.filter((c) => c._id != charge._id),
		});
	};

	const validate = (e) => {
		e.preventDefault();
		if (state.suspect == null) {
			toast.error('Must Select Suspect');
		} else if (state.plea == '') {
			toast.error('Must Select Plea');
		} else if (state.charges.length == 0) {
			toast.error('Must Add Charges');
		} else {
			Boolean(suspect) ? onEdit(state) : onSubmit(state);
			setState(initialState);
		}
	};

	const cancel = () => {
		onCancel();
	};

	return (
		<Modal
			open={open}
			maxWidth="lg"
			title={`${Boolean(suspect) ? 'Edit' : 'Add'} Suspect`}
			acceptLang={`${Boolean(suspect) ? 'Edit' : 'Add'} Suspect`}
			closeLang="Cancel"
			onAccept={validate}
			onClose={cancel}
		>
			<div className={classes.wrapper}>
				<Grid container style={{ height: '100%' }}>
					<Grid item xs={12}>
						<Grid container spacing={2}>
							<Grid item xs={6}>
								{Boolean(suspect) ? (
									<TextField
										fullWidth
										className={classes.editorField}
										disabled={true}
										label="Suspect"
										value={`${suspect.suspect.First} ${suspect.suspect.Last}`}
									/>
								) : (
									<Autocomplete
										loading={loading}
										fullWidth
										className={classes.editorField}
										getOptionLabel={(option) => {
											return `${option.First} ${option.Last} [${option.SID}]`;
										}}
										options={characters}
										autoComplete
										includeInputInList
										autoHighlight
										filterSelectedOptions
										name="suspect"
										value={state.suspect}
										onChange={(e, nv) =>{
											if (nv) {
												setState({
													...state,
													suspect: {
														...nv,
														Qualifications: null,
														Jobs: null,
														Origin: null,
														MDTHistory: null,
													},
												})
											} else {
												setState({
													...state,
													suspect: nv,
												})
											}
										}}
										onInputChange={(e, nv) =>
											setState({
												...state,
												suspectInput: nv,
											})
										}
										renderInput={(params) => (
											<TextField
												{...params}
												name="suspectInput"
												label="Suspect"
												fullWidth
											/>
										)}
										renderOption={(props, option) => {
											return (
												<ListItem
													{...props}
													key={`${option.SID}`}
													className={`${
														classes.option
													}${
														state.suspect?.SID ==
														option.SID
															? ' selected'
															: ''
													}`}
												>
													<ListItemText
														primary={`${option.First} ${option.Last} [${option.SID}]`}
														secondary={<span>DOB: <Moment date={option.DOB * 1000} format="LL"/></span>}
													/>
												</ListItem>
											);
										}}
									/>
								)}
							</Grid>
							<Grid item xs={6}>
								<div>
									<TextField
										select
										fullWidth
										label="Plea"
										className={classes.editorField}
										value={state.plea}
										onChange={(e) =>
											setState({
												...state,
												plea: e.target.value,
											})
										}
									>
										{PleaTypes.map((option) => (
											<MenuItem
												key={option.value}
												value={option.value}
											>
												{option.label}
											</MenuItem>
										))}
									</TextField>
								</div>
							</Grid>
						</Grid>
					</Grid>
					<Grid item xs={12} style={{ height: '60%' }}>
						<ChargeCalculator
							wrapperClass={classes.calculator}
							selected={state.charges}
							onChange={onChargeAdd}
							onRemove={onChargeRemove}
						/>
					</Grid>
				</Grid>
			</div>
		</Modal>
	);
};
