import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade, TextField, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Typist from 'react-typist';

import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		textAlign: 'center',
	},
	header: {
		fontSize: 28,
		fontWeight: 'bold',
		color: theme.palette.primary.main,
	},
	body: {
		padding: 30,
	},
}));

export default (props) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const myState = useSelector((state) => state.data.data.myState);
	const alias = useSelector((state) => state.data.data.player.Alias?.redline);

	const [show, setShow] = useState(false);
	const onAnimEnd = () => {
		setShow(true);
	};

	const onSubmit = async (e) => {
		e.preventDefault();
		let alias = e.target.alias.value;
		try {
			let res = await (
				await Nui.send('UpdateAlias', {
					app: 'redline',
					alias,
					unique: true,
				})
			).json();
			showAlert(res ? 'Alias Created' : 'Unable to Create Alias');

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'player',
						id: 'Alias',
						key: 'redline',
						data: alias,
					},
				});
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable to Create Alias');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.header}>
				<Typist onTypingDone={onAnimEnd}>
					<span>Welcome Racer</span>
				</Typist>
			</div>
			<Fade in={show}>
				<div className={classes.body}>
					<p>Set your alias to get started</p>
					<form onSubmit={onSubmit}>
						<TextField
							className={classes.creatorInput}
							fullWidth
							label="Alias"
							name="alias"
							variant="outlined"
							required
							inputProps={{
								maxLength: 32,
							}}
						/>
						<Button
							type="submit"
							fullWidth
							variant="contained"
							color="primary"
						>
							Submit
						</Button>
					</form>
					<p>
						<code>Think hard, you may not change this</code>
					</p>
				</div>
			</Fade>
		</div>
	);
};
