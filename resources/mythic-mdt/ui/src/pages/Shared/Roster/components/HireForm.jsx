import React, { useEffect, useState, useMemo } from 'react';
import { useSelector } from 'react-redux';
import {
	Autocomplete,
	TextField,
	MenuItem,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { throttle } from 'lodash';
import Moment from 'react-moment';

import { usePermissions } from '../../../../hooks';
import { Modal } from '../../../../components';
import Nui from '../../../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
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
}));

export default ({ open, onUpdate, onClose }) => {
	const classes = useStyles();
	const hasPerm = usePermissions();

	const isHighCommand = hasPerm('PD_HIGH_COMMAND') || hasPerm('SAFD_HIGH_COMMAND');
	const canHire = hasPerm('MDT_HIRE') || isHighCommand;

	const myJob = useSelector(state => state.app.govJob);
	const jobData = useSelector(state => state.data.data.governmentJobsData)?.[myJob.Id];
	const defaultWorkplace = myJob.Id == 'police' ? 'lspd' : myJob.Workplace.Id;

	const [characters, setCharacters] = useState(Array());
	const [state, setState] = useState({
		person: null,
		personInput: '',
		JobId: myJob.Id,
		Workplace: jobData.Workplaces.find(w => w.Id == defaultWorkplace),
		Grade: jobData.Workplaces.find(w => w.Id == defaultWorkplace)?.Grades.sort((a, b) => a.Level - b.Level)[0],
	});

	const fetch = useMemo(
		() =>
			throttle(async () => {
				try {
					let res = await (
						await Nui.send('Search', {
							type: 'not-government',
						})
					).json();
					setCharacters(res);
				} catch (err) {
					console.log(err);
					setCharacters(Array());
				}
			}, 5000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const onSubmit = async (e) => {
		e.preventDefault();
		if (!canHire) return;

		try {
			let res = await (
				await Nui.send('HireEmployee', {
					SID: state.person.SID,
					JobId: state.JobId,
					WorkplaceId: state.Workplace.Id,
					GradeId: state.Grade.Id,
				})
			).json();
			if (res) {
				toast.success(`${state.person.First} ${state.person.Last} Has Been Hired As ${state.Workplace.Name} ${state.Grade.Name}`);
				onUpdate();
				onClose();
			} else throw res;
		} catch (err) {
			console.log(err);
			toast.error('Unable to Hire Person');
		}
	};

	return (
		<Modal
			open={open}
			title="Hire New"
			submitLang="Hire"
			onSubmit={onSubmit}
			onClose={onClose}
		>
			<Autocomplete
				fullWidth
				className={classes.editorField}
				getOptionLabel={(option) => {
					return `${option.First} ${option.Last} (State ID: ${option.SID})`;
				}}
				options={characters}
				autoComplete
				includeInputInList
				autoHighlight
				filterSelectedOptions
				name="person"
				value={state.person}
				onChange={(e, nv) =>
					setState({
						...state,
						person: nv,
					})
				}
				onInputChange={(e, nv) =>
					setState({
						...state,
						personInput: nv,
					})
				}
				renderInput={(params) => (
					<TextField
						{...params}
						name="personInput"
						label="Person"
						fullWidth
					/>
				)}
				renderOption={(props, option) => {
					return (
						<ListItem
							{...props}
							key={`${option.SID}`}
							className={`${classes.option}${state.person?.SID == option.SID ? ' selected' : ''}`}
						>
							<ListItemText
								primary={`${option.First} ${option.Last}`}
								secondary={`State ID: ${option.SID}`}
							/>
							<Moment date={option.DOB * 1000} format="LL" />
						</ListItem>
					);
				}}
			/>
			{(myJob.Id == 'police' || myJob.Id == 'government') && <TextField
				select
				fullWidth
				//disabled={!isHighCommand}
				label="Department"
				className={classes.editorField}
				value={state.Workplace.Id}
				onChange={(e) =>
					setState({
						...state,
						Workplace: jobData.Workplaces.find(
							(w) => w.Id == e.target.value,
						),
						Grade: jobData.Workplaces.find(
							(w) => w.Id == e.target.value,
						)?.Grades.sort((a, b) => a.Level - b.Level)[0],
					})
				}
			>
				{jobData.Workplaces.map((w) => (
					<MenuItem key={w.Id} value={w.Id}>
						{w.Name}
					</MenuItem>
				))}
			</TextField>}
			<TextField
				select
				fullWidth
				disabled
				label="Rank"
				className={classes.editorField}
				value={state.Grade?.Id}
			>
				<MenuItem
					key={state.Grade.Id}
					value={state.Grade.Id}
				>
					{state.Grade.Name}
				</MenuItem>
			</TextField>
		</Modal>
	);
};
