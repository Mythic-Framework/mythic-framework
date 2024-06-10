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
		margin: 'auto',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		height: 'fit-content',
		width: 'fit-content',
	},
	body: {
		margin: 'auto',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		paddingTop: 75,
		height: 'fit-content',
		width: 'fit-content',
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

	return (
		<div className={classes.wrapper}>
			<div className={classes.header}>
				<Typist onTypingDone={onAnimEnd}>
					<span>You Are Not Authorized</span>
				</Typist>
			</div>
			{show && (
				<Fade in={true}>
					<div className={classes.body}>
						<Typist onTypingDone={onAnimEnd}>
							<span>Immediately Stop What You Are Doing</span>
						</Typist>
					</div>
				</Fade>
			)}
		</div>
	);
};
