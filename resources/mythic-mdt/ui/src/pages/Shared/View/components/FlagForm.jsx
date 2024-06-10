import React, { useEffect, useState } from 'react';
import { TextField, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Modal } from '../../../../components';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, flagTypes, existing = null, onSubmit, onClose }) => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);

	const initalState = {
		Date: Date.now(),
		Author: {
			Callsign: user.Callsign,
			SID: user.SID,
			First: user.First,
			Last: user.Last,
		},
		Type: '',
		Description: '',
	};

	const [state, setState] = useState({
		...initalState,
		Type: Boolean(existing) ? existing.Type : '',
		Description: Boolean(existing) ? existing.Description : '',
	});

	useEffect(() => {
		setState({
			...state,
			...existing,
		});
	}, [existing]);

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(state);
		setState({ ...initalState });
	};

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	return (
		<Modal
			open={open}
			maxWidth="sm"
			title="Add New Flag"
			submitLang="Create"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<TextField
				required
				select
				fullWidth
				name="Type"
				label="Type"
				className={classes.editorField}
				value={state.Type}
				onChange={onChange}
			>
				{flagTypes.map((option) => (
					<MenuItem key={option.value} value={option.value}>
						{option.label}
					</MenuItem>
				))}
			</TextField>
			<TextField
				required
				fullWidth
				multiline
				minRows={4}
				name="Description"
				label="Description"
				className={classes.editorField}
				value={state.Description}
				onChange={onChange}
			/>
		</Modal>
	);
};
