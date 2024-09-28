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

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	msg: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	return (
		<div className={classes.wrapper}>
			<div className={classes.msg}>
				You Have Been Banned From Supply Mate
			</div>
		</div>
	);
};
