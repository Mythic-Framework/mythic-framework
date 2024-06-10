import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Grid,
	TextField,
	ButtonGroup,
	Button,
	Backdrop,
	FormControlLabel,
	Checkbox,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _ from 'lodash';
import { useNavigate, useLocation } from 'react-router';
import { toast } from 'react-toastify';
import moment from 'moment';
import { useParams } from 'react-router';

import Nui from '../../util/Nui';
import { Loader, Editor, Modal } from '../../components';
import { usePermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '95%',
	},
	editorField: {
		marginBottom: 10,
	},
	title: {
		fontSize: 22,
		color: theme.palette.text.main,
		textAlign: 'center',
	},
	col: {
		height: '100%',
		padding: 5,
	},
	formActions: {
		paddingBottom: 10,
		marginBottom: 5,
		borderBottom: `1px inset ${theme.palette.border.divider}`,
	},
	positiveButton: {
		borderColor: `${theme.palette.success.main}80`,
		color: theme.palette.success.main,
		'&:hover': {
			borderColor: theme.palette.success.main,
			background: `${theme.palette.success.main}14`,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const params = useParams();
	const history = useNavigate();
	const hasPermission = usePermissions();

	const initialState = {
		title: '',
		notes: '',
		pinned: false,
	};

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState(initialState);

	const canPin = hasPermission('TABLET_PIN_DOCUMENT', false);

	useEffect(() => {
		const f = async (id) => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('BusinessDocumentView', {
						id,
					})
				).json();
				if (res) {
					setState(res);
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load Document');
			}
			setLoading(false);
		};

		if (params.id) f(params.id);
	}, [history]);

	const onSubmit = async (e) => {
		e.preventDefault();

		if (state.title == '') {
			toast.error('Must Add Title');
		} else if (state.notes == '') {
			toast.error('Must Add Notes');
		} else {
			try {
				if (Boolean(state?._id)) {
					let res = await (
						await Nui.send('BusinessDocumentUpdate', {
							id: state._id,
							Report: {
								title: state.title,
								pinned: state.pinned,
								notes: state.notes,
								time: state.time,
								author: state.author,
							},
						})
					).json();

					if (res) history(`/business/search/document/${state._id}`);
					else toast.error('Unable to Create Document');
				} else {
					let res = await (
						await Nui.send('BusinessDocumentCreate', {
							doc: {
								title: state.title,
								pinned: state.pinned,
								notes: state.notes,
								time: Date.now(),
							},
						})
					).json();

					if (res) {
						history(`/business/search/document/${res._id}`);
					} else toast.error('Unable to Create Document');
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Create Document');
			}
		}
	};

	return (
		<div className={classes.wrapper}>
			<Backdrop open={loading} style={{ zIndex: 100 }}>
				<Loader text="Loading" />
			</Backdrop>
			<Grid container style={{ height: '100%', paddingBottom: 10 }} spacing={2}>
				<Grid item xs={12}>
					<Grid container className={classes.formActions}>
						<Grid item xs={1} style={{ textAlign: 'left' }}>
							<FormControlLabel
								control={
								<Checkbox
									checked={state.pinned}
									onChange={(e) => {
										setState({ ...state, pinned: e.target.checked });
									}}
									disabled={!canPin}
									name="pinned"
									color="primary"
								/>}
								label="Pinned"
							/>
						</Grid>
						<Grid item xs={9}>
							<div className={classes.title}>
								{Boolean(state?._id) ? `${state?.title}` : `New Document`}
							</div>
						</Grid>
						<Grid item xs={2} style={{ textAlign: 'right' }}>
							<ButtonGroup fullWidth color="inherit">
								<Button className={classes.positiveButton} onClick={onSubmit}>
									{`${Boolean(state?._id) ? 'Edit' : 'Create'} Document`}
								</Button>
							</ButtonGroup>
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={12} className={classes.col}>
					<TextField
						className={classes.editorField}
						label="Document Title"
						fullWidth
						placeholder="Document Title"
						value={state.title}
						onChange={(e) => setState({ ...state, title: e.target.value })}
					/>

					{!loading && (
						<Editor
							allowMedia
							name="notes"
							title="Document Notes"
							placeholder={'Enter Document Content'}
							disabled={loading}
							value={state.notes}
							onChange={(e) => {
								setState({ ...state, notes: e.target.value });
							}}
						/>
					)}
				</Grid>
			</Grid>
		</div>
	);
};
