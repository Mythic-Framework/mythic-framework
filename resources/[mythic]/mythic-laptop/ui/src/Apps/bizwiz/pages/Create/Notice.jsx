import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, TextField, MenuItem, Backdrop, ButtonGroup, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../../../util/Nui';
import { Loader, Editor } from '../../../../components';
import { useAlert } from '../../../../hooks';

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

const initialState = {
	title: '',
	description: '',
};

export default ({ useNav }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alert = useAlert();

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState({
		...initialState,
	});

	const onChangeNotice = (e) => {
		setState({ ...state, [e.target.name]: e.target.value });
	};

	const onSubmitSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await await Nui.send('CreateBusinessNotice', {
				doc: {
					...state,
					time: Date.now(),
				},
			});

			if (res) {
				alert('Notice Created');
				useNav('Dashboard');
			} else {
				alert('Unable to Create Notice');
			}
		} catch (err) {
			console.log(err);
			alert('Unable to Create Notice');
		}
	};

	const onCancelNotice = () => {
		useNav('Dashboard');
	};

	return (
		<div className={classes.wrapper}>
			<Backdrop open={loading} style={{ zIndex: 100 }}>
				<Loader text="Loading" />
			</Backdrop>
			<div>
				<Grid container style={{ height: '100%' }}>
					<Grid item xs={12} className={classes.col}>
						<TextField
							required
							fullWidth
							className={classes.editorField}
							label="Notice Title"
							name="title"
							value={state.title}
							onChange={onChangeNotice}
							inputProps={{ maxLength: 64 }}
						/>
						<Editor
							allowMedia
							name="description"
							title="Notice"
							placeholder={'Enter Notice'}
							disabled={loading}
							value={state.description}
							onChange={(e) => {
								setState({ ...state, description: e.target.value });
							}}
						/>
					</Grid>
					<Grid item xs={12} className={classes.col}>
						<ButtonGroup fullWidth>
							<Button onClick={onCancelNotice}>Go Back</Button>
							<Button onClick={onSubmitSubmit}>Create Notice</Button>
						</ButtonGroup>
					</Grid>
				</Grid>
			</div>
		</div>
	);
};
