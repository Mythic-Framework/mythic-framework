import React, { useEffect, useState } from 'react';
import { TextField, MenuItem, Slider, Box, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, property, onSubmit, onClose }) => {
	const classes = useStyles();

	const initialState = {
		SID: '',
	}

	const [state, setState] = useState({
		...initialState,
	});

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(state);
		setState({ ...initialState });
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
			maxWidth="md"
			title={`Transfer ${property?.label}`}
			submitLang="Transfer Property"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Property: {property?.label}</p>
			<p><i>Please make sure personal belongings and vehicles are removed from the property before transfer.</i></p>
			<br></br>
			<TextField
				required
				fullWidth
				name="SID"
				label="State ID of New Owner"
				className={classes.editorField}
				value={state.SID}
				onChange={onChange}
			/>
		</Modal>
	);
};
