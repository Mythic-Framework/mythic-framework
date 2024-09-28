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
import moment from 'moment';

import Nui from '../../../../util/Nui';
import { Loader, Editor, Modal } from '../../../../components';
import { useJobPermissions, useAlert } from '../../../../hooks';

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

export default ({ onNav, data }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alert = useAlert();
	const hasJobPerm = useJobPermissions();
    const onDuty = useSelector((state) => state.data.data.onDuty);

	const initialState = {
		title: '',
		notes: '',
		pinned: false,
	};

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState(initialState);

	const canPin = hasJobPerm('LAPTOP_PIN_DOCUMENT', onDuty);

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
                alert('Unable to Load Document');
			}
			setLoading(false);
		};

		if (data?.id) f(data.id);
	}, []);

	const onSubmit = async (e) => {
		e.preventDefault();

		if (state.title == '') {
            alert('Must Add Title');

		} else if (state.notes == '') {
            alert('Must Add Content');

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

					if (res) {
                        //history(`/business/search/document/${state._id}`)
                        onNav('View/Document', { id: state._id });
                    } else {
                        alert('Unable to Update Document');
                    };
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
                        onNav('View/Document', { id: res._id });
					} else {
                        alert('Unable to Create Document');
                    }
				}
			} catch (err) {
				console.log(err);
                alert('Unable to Create Document');
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
							style={{maxHeight: 300, overflowY: "scroll"}}
						/>
					)}
				</Grid>
			</Grid>
		</div>
	);
};
