import React, { useEffect, useState } from 'react';
import { TextField, MenuItem, Slider, Box, Button } from '@mui/material';
import { LoadingButton } from '@mui/lab';
import { makeStyles } from '@mui/styles';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import { useSelector, useDispatch } from 'react-redux';

import Nui from '../../../../../util/Nui';
import { useAlert } from '../../../../../hooks';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

const editables = [
	{
		value: 'garage',
		label: 'Garage',
	},
	{
		value: 'backdoor',
		label: 'Backdoor',
	}
]

export default ({ open, property, onSubmit, onClose }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alert = useAlert();
	const [loading, setLoading] = useState(false);
	const [type, setType] = useState(editables[0].value);

	const onShowLocation = async () => {
        try {
            let res = await (
                await Nui.send('Dyn8ShowPropertyLocations', {
					property: property._id,
				})
            ).json();

            if (res) {
				alert('Started Showing Locations');
            } else throw res;
        } catch (err) {
			alert('Error Showing Locations');
            console.log(err);
		}
	};

	const onChangeLocation = async () => {
		setLoading(true);

		try {
            let res = await (
                await Nui.send('Dyn8ChangePropertyLocations', {
					property: property._id,
					location: type,
				})
            ).json();

            if (res) {
				alert('Successfully Updated Location');
            } else throw res;
			setLoading(false);
        } catch (err) {
			alert('Error Updating Location');

            console.log(err);
			setLoading(false);
		}
	};

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Edit ${property?.label}`}
			onClose={onClose}
		>
			<p>Property: {property?.label}</p>
			<p>Property ID: {property?._id}</p>
			<br></br>
			<Button className={classes.editorField} variant="outlined" fullWidth onClick={onShowLocation}>
				Show Current Locations
			</Button>
			<br></br>
			<TextField
				required
				select
				fullWidth
				name="type"
				label="Type"
				className={classes.editorField}
				value={type}
				onChange={e => setType(e.target.value)}
				disabled={loading}
			>
				{editables.map((option) => (
					<MenuItem key={option.value} value={option.value}>
						{option.label}
					</MenuItem>
				))}
			</TextField>
			<LoadingButton variant="outlined" loading={loading} fullWidth onClick={onChangeLocation}>
				Update Location (To Standing Position)
			</LoadingButton>
		</Modal>
	);
};
