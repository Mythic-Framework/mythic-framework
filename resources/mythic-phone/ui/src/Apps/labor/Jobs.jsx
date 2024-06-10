import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { AppBar, Grid, Tooltip, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Job from './component/Job';

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

export default ({ jobs, groups, myGroup, loading, onRefresh }) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={8}>
						Labor
					</Grid>
					<Grid item xs={4} className={classes.headerAction}>
						<Tooltip title="Refresh Jobs">
							<IconButton onClick={onRefresh}>
								<FontAwesomeIcon
									className={`fa ${loading ? 'fa-spin' : ''}`}
									icon={['fas', 'arrows-rotate']}
								/>
							</IconButton>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
			<div className={classes.body}>
				{!Boolean(jobs) ? (
					<Loader static text="Loading" />
				) : Object.keys(jobs).length > 0 ? (
					Object.keys(jobs).map((k) => {
						return (
							<Job
								key={`labor-${k}`}
								job={jobs[k]}
								myGroup={myGroup}
								disabled={loading}
							/>
						);
					})
				) : (
					<div className={classes.emptyMsg}>No Jobs Available</div>
				)}
			</div>
		</div>
	);
};
