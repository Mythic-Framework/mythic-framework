import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
	Tab,
	Tabs,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import Window from '../../components/Window';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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
			
		</div>
	);
};
