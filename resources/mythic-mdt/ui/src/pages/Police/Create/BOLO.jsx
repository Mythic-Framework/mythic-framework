import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Grid,
	TextField,
	MenuItem,
	Backdrop,
	ButtonGroup,
	Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _ from 'lodash';
import { useNavigate } from 'react-router';
import { toast } from 'react-toastify';

import Nui from '../../../util/Nui';
import { Loader } from '../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '95%',
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
	col: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 5,
	},
	positiveButton: {
		borderColor: `${theme.palette.success.main}80`,
		color: theme.palette.success.main,
		'&:hover': {
			borderColor: theme.palette.success.main,
			background: `${theme.palette.success.main}14`,
		},
	},
	popup: {
		maxHeight: `750px !important`,
	},
}));

export const BOLOTypes = [
	{
		label: 'Person',
		value: 'user',
	},
	{
		label: 'Vehicle',
		value: 'car',
	},
];

const initialState = {
	title: '',
	summary: '',
	description: '',
	type: 'user',
};

export default (props) => {
	const classes = useStyles();
	const history = useNavigate();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.app.user);

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState({
		...initialState,
		primaries: [user.Callsign],
	});

	const onChange = (e) => {
		setState({ ...state, [e.target.name]: e.target.value });
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await await Nui.send('Create', {
				type: 'BOLO',
				doc: { ...state, time: Date.now() },
			});

			if (res) {
				toast.success('BOLO Created');
				history(-1);
			} else {
				toast.error('Unable to Create BOLO');
			}
		} catch (err) {
			console.log(err);
			toast.error('Unable to Create BOLO');
		}
	};

	const onCancel = () => {
		history(-1);
	};

	return (
		<div className={classes.wrapper}>
			<Backdrop open={loading} style={{ zIndex: 100 }}>
				<Loader text="Loading" />
			</Backdrop>
			<form onSubmit={onSubmit}>
				<Grid container style={{ height: '100%' }}>
					<Grid item xs={12} className={classes.col}>
						<TextField
							required
							fullWidth
							className={classes.editorField}
							label="BOLO Title"
							name="title"
							value={state.title}
							onChange={onChange}
							inputProps={{ maxLength: 64 }}
						/>
						<TextField
							required
							fullWidth
							select
							label="Type"
							name="type"
							className={classes.editorField}
							value={state.type}
							onChange={onChange}
						>
							{BOLOTypes.map((option) => (
								<MenuItem
									key={option.value}
									value={option.value}
								>
									{option.label}
								</MenuItem>
							))}
						</TextField>
						<TextField
							required
							fullWidth
							className={classes.editorField}
							label="BOLO Summary"
							name="summary"
							value={state.summary}
							onChange={onChange}
							inputProps={{ maxLength: 72 }}
						/>
						<TextField
							required
							fullWidth
							className={classes.editorField}
							label="BOLO Description"
							multiline
							minRows={4}
							name="description"
							value={state.description}
							onChange={onChange}
						/>
					</Grid>
					<Grid item xs={12} className={classes.col}>
						<ButtonGroup fullWidth>
							<Button onClick={onCancel}>Cancel</Button>
							<Button type="submit">Submit</Button>
						</ButtonGroup>
					</Grid>
				</Grid>
			</form>
		</div>
	);
};
