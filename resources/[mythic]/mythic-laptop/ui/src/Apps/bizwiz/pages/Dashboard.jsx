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

import BusinessNotices from '../components/BusinessNotice';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
	},
}));

export default ({ onNav }) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={2}>
				<BusinessNotices onNav={onNav} />
			</Grid>
		</div>
	);
};