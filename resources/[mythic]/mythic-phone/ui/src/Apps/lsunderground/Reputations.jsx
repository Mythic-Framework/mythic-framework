import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { AppBar, Grid, Tooltip, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Reputation from './component/Reputation';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
		height: '88.75%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

const lsuReps = ['Racing'];

export default ({ myReputations, loading, onRefresh }) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<div className={classes.body}>
				{!Boolean(myReputations) ? (
					<Loader static text="Loading" />
				) : myReputations.length > 0 ? (
					myReputations.map((rep) => {
						return (
							<Reputation
								key={`lsu-${rep.id}`}
								rep={rep}
								disabled={loading}
							/>
						);
					})
				) : (
					<div className={classes.emptyMsg}>No Reputation Built</div>
				)}
			</div>
		</div>
	);
};
