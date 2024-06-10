import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Button, Grid, TextField, MenuItem } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Modal } from '../';
import { toast } from 'react-toastify';
import Nui from '../../util/Nui';
import Loader from '../Loader';

const useStyles = makeStyles((theme) => ({
	btn: {
		width: '95%',
		fontSize: 12,
		marginTop: '5%',
		color: theme.palette.text.main,
		borderTopLeftRadius: 0,
		borderBottomLeftRadius: 0,
		display: 'block',
		'& small': {
			display: 'block',
			fontSize: 12,
			color: theme.palette.primary.main,
			'&::before': {
				color: theme.palette.text.alt,
				content: '"Balance: $"',
			},
		},
	},
	btnIcon: {
		fontSize: 14,
		marginRight: 5,
		color: theme.palette.text.alt,
	},
	field: {
		marginBottom: 15,
	},
}));

const Types = [
	{
		value: 'personal_savings',
		label: 'Personal Saving',
	},
];

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const app = useSelector((state) => state.app.app);
	const user = useSelector((state) => state.data.data.character);
	const accounts = useSelector((state) => state.data.data.accounts);

	const [creating, setCreating] = useState(false);
	const [loading, setLoading] = useState(false);

	const onSubmit = async (e) => {
		e.preventDefault();

		if (
			accounts.filter(
				(a) => a.Owner == user.SID && a.Type == 'personal_savings',
			).lenght > 0
		) {
			toast.error('You May Only Own 1 Savings Account');
			setCreating(false);
			return;
		}

		try {
			setLoading(true);
			let res = await (
				await Nui.send('Bank:Register', {
					type: e.target.type.value,
					name: e.target.name.value,
				})
			).json();

			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'accounts',
					data: res,
				},
			});
			dispatch({
				type: 'SELECT_ACCOUNT',
				payload: {
					account: res._id,
				},
			});
		} catch (e) {
			console.log(e);
			toast.error('Unable To Open Account');
		}

		setLoading(false);
		setCreating(false);
	};

	return (
		<div>
			<Button
				className={classes.btn}
				color="primary"
				onClick={() => setCreating(true)}
			>
				<FontAwesomeIcon
					className={classes.btnIcon}
					icon={['fas', 'plus']}
				/>{' '}
				Open New Account
			</Button>
			<Modal
				open={creating}
				title="Open New Account"
				closeLang="Cancel"
				maxWidth={app == 'ATM' ? 'xs' : 'md'}
				onClose={() => setCreating(false)}
				onSubmit={onSubmit}
			>
				{loading && <Loader static text="Loading" />}
				<TextField
					select
					fullWidth
					required
					name="type"
					className={classes.field}
					disabled={true}
					label="Account Type"
					defaultValue="personal_savings"
				>
					{Types.map((option) => (
						<MenuItem key={option.value} value={option.value}>
							{option.label}
						</MenuItem>
					))}
				</TextField>
				<TextField
					fullWidth
					required
					name="name"
					className={classes.field}
					label="Account Name"
				/>
			</Modal>
		</div>
	);
};
