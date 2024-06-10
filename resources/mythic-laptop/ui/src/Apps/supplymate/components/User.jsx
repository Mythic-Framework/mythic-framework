import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { Button, Grid, Avatar } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		width: '100%',
		height: 85,
		background: theme.palette.secondary.dark,
		borderBottom: '1px solid #000',
	},
	userData: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 15,
		margin: 'auto',
		height: 'fit-content',
		width: 'fit-content',
	},
	user: {
		display: 'inline-block',
		marginRight: 10,
	},
	avatar: {
		display: 'inline-block',
	},
	controlBtn: {
		height: 85,

		'& svg': {
			marginRight: 6,
		},
	},
}));

export default ({ appState, onNav }) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const user = useSelector((state) => state.data.data.player);

	return (
		<Grid container className={classes.wrapper}>
			<Grid item xs={6}>
				{Boolean(appState?.selected) && (
					<Button
						variant="text"
						className={classes.controlBtn}
						onClick={() => onNav(null)}
					>
						<FontAwesomeIcon icon={['fas', 'chevron-left']} />
						Back
					</Button>
				)}
			</Grid>
			<Grid item xs={6} style={{ position: 'relative' }}>
				<div className={classes.userData}>
					<div className={classes.user}>
						{`${user.First[0]}${user.Last[0]}`}
					</div>
					<div className={classes.avatar}>
						<Avatar>{user.First[0]}</Avatar>
					</div>
				</div>
			</Grid>
		</Grid>
	);
};
