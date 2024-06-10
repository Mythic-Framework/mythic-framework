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
	MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import _ from 'lodash';
import { useNavigate, useLocation } from 'react-router';
import { toast } from 'react-toastify';
import moment from 'moment';
import { useParams } from 'react-router';

import Nui from '../../util/Nui';
import { Loader, Editor, Modal, BusinessSearch } from '../../components';
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

const recTypes = [
	{
		value: 'General',
		jobs: false,
	},
	{
		value: 'Regular Repair',
		jobs: ['redline', 'hayes', 'ottos', 'dreamworks'],
	},
	{
		value: 'Full Repair',
		jobs: ['redline', 'hayes', 'autoexotics', 'ottos', 'dreamworks'],
	},
	{
		value: 'Lockpick',
		jobs: ['redline', 'hayes', 'autoexotics', 'ottos', 'dreamworks'],
	},
	{
		value: 'Performance Upgrades',
		jobs: ['redline', 'hayes', 'autoexotics', 'ottos', 'dreamworks'],
	},
	{
		value: 'PD/EMS Repair',
		jobs: ['autoexotics'],
	},
	{
		value: 'Repair Kits',
		jobs: ['redline', 'hayes', 'autoexotics', 'ottos', 'dreamworks'],
	},
];

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const params = useParams();
	const history = useNavigate();
	const job = useSelector((state) => state.app.govJob);
	const hasPermission = usePermissions();

	const initialState = {
		notes: '',
		type: recTypes.filter(r => !r.jobs || r.jobs.includes(job?.Id))[0]?.value,
		customerName: '',
		customerNumber: '',
		paymentAmount: '',
		paymentPaid: '',
		workers: Array(),
		workersInput: '',
	};

	const [loading, setLoading] = useState(false);
	const [state, setState] = useState(initialState);
	const [workers, setWorkers] = useState(Array());

	useEffect(() => {
		const f = async (id) => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('BusinessReceiptView', {
						id,
					})
				).json();
				if (res) {
					setState(res);
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load Receipt');
			}
			setLoading(false);
		};

		if (params.id) f(params.id);
	}, [history]);

	const onSubmit = async (e) => {
		e.preventDefault();

		if (state.customerName == '') {
			toast.error('Must Add Customer Name');
		} else {
			try {
				if (Boolean(state?._id)) {
					let res = await (
						await Nui.send('BusinessReceiptUpdate', {
							id: state._id,
							Report: {
								type: state.type,
								customerName: state.customerName,
								customerNumber: state.customerNumber,
								paymentAmount: state.paymentAmount,
								paymentPaid: state.paymentPaid,
								workers: state.workers,
								notes: state.notes,
								time: state.time,
								author: state.author,
							},
						})
					).json();

					if (res) history(`/business/search/receipt/${state._id}`);
					else toast.error('Unable to Update');
				} else {
					let res = await (
						await Nui.send('BusinessReceiptCreate', {
							doc: {
								type: state.type,
								customerName: state.customerName,
								customerNumber: state.customerNumber,
								paymentAmount: state.paymentAmount,
								paymentPaid: state.paymentPaid,
								workers: state.workers,
								notes: state.notes,
								time: Date.now(),
							},
						})
					).json();

					if (res) {
						history(`/business/search/receipt/${res._id}`);
					} else toast.error('Unable to Create');
				}
			} catch (err) {
				console.log(err);
				toast.error('Unable to Create');
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
						<Grid item xs={10}>
							<div className={classes.title}>
								{Boolean(state?._id) ? `Edit Receipt` : `New Receipt`}
							</div>
						</Grid>
						<Grid item xs={2} style={{ textAlign: 'right' }}>
							<ButtonGroup fullWidth color="inherit">
								<Button className={classes.positiveButton} onClick={onSubmit}>
									{`${Boolean(state?._id) ? 'Edit' : 'Create'} Receipt`}
								</Button>
							</ButtonGroup>
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={6} className={classes.col}>
					<TextField
						select
						fullWidth
						label="Receipt Type"
						disabled={Boolean(state?._id)}
						name="type"
						className={classes.editorField}
						value={state.type}
						onChange={(e) => setState({ ...state, type: e.target.value })}
					>
						{recTypes.filter(r => !r.jobs || r.jobs.includes(job?.Id)).map((option) => (
							<MenuItem key={option.value} value={option.value}>
								{option.value}
							</MenuItem>
						))}
					</TextField>
					<TextField
						className={classes.editorField}
						label="Customer Name"
						fullWidth
						placeholder="Customer Name"
						value={state.customerName}
						onChange={(e) => setState({ ...state, customerName: e.target.value })}
					/>
					<TextField
						className={classes.editorField}
						label="Customer Phone Number"
						fullWidth
						placeholder="Customer Phone Number"
						value={state.customerNumber}
						onChange={(e) => setState({ ...state, customerNumber: e.target.value })}
					/>
					<TextField
						className={classes.editorField}
						label="Payment Charged"
						fullWidth
						placeholder="Payment Charged"
						value={state.paymentAmount}
						onChange={(e) => setState({ ...state, paymentAmount: e.target.value })}
					/>
					<TextField
						className={classes.editorField}
						label="Payment Paid"
						fullWidth
						placeholder="Payment Paid"
						value={state.paymentPaid}
						onChange={(e) => setState({ ...state, paymentPaid: e.target.value })}
					/>
				</Grid>
				<Grid item xs={6} className={classes.col}>
					<BusinessSearch
						disableSelf
						label={`Additional Employees`}
						placeholder="Bob, Tim, Dave"
						value={state.workers}
						inputValue={state.workersInput}
						options={workers}
						setOptions={setWorkers}
						job={job?.Id ?? 'fuck'}
						onChange={(e, nv) => {
							if (nv.length == 0) {
								setState({
									...state,
									workers: [],
									workersInput: '',
								});
							} else {
								setState({
									...state,
									workers: nv,
									workersInput: '',
								});
							}
						}}
						onInputChange={(e, nv) => setState({ ...state, workersInput: nv })}
					/>
					{!loading && (
						<Editor
							allowMedia
							name="notes"
							title="Additional Notes"
							placeholder={'Enter Content'}
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
