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
	cityLogo: {
		width: 80,
		padding: 4,
		alignSelf: 'center',
	},
	branding: {
		height: '100%',
		padding: 10,
		fontSize: 18,
		'& small': {
			display: 'block',
			fontSize: 12,
			color: theme.palette.text.alt,
		},
	},
}));

export default ({ items }) => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const logo = useSelector((state) => state.data.data.businessLogo);
    const onDuty = useSelector((state) => state.data.data.onDuty);

	const jobs = useSelector((state) => state.data.data.player.Jobs);
    const jobData = jobs?.find(j => j.Id == onDuty);

	return (
		<Grid container direction="row">
			<Grid item xs={4} style={{ display: 'flex' }}>
				<img src={logo} className={classes.cityLogo} />
			</Grid>
			<Grid item xs={8}>
				<div className={classes.branding}>
					<span>
						{jobData?.Name}
						<small>{jobData?.Grade?.Name}</small>
					</span>
				</div>
			</Grid>
        </Grid>
	);
};
