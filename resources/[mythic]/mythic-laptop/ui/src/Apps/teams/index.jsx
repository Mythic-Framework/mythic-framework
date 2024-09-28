import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { Grid } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import Window from '../../components/Window';
import MyTeam from '../teams/MyTeam';
import Available from './Available';
import Requests from './Requests';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		padding: 15,
	},
	header: {
		background: '#E95200',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	content: {
		height: '100%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '93.25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	return (
		<div className={classes.wrapper}>
			<Grid container>
				<MyTeam />
				<Available />
				<Requests />
			</Grid>
		</div>
	);
};
