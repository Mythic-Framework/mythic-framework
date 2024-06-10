import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Paper, Button, LinearProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: theme.palette.secondary.dark,
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
	details: {
		position: 'absolute',
		width: '100%',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	title: {
		fontSize: 20,
		color: theme.palette.primary.main,
		fontWeight: 'bold',
        textAlign: 'center',
	},
	progressLabel: {
		fontSize: 16,
        textAlign: 'center',
	},
	duty: {
		fontSize: 16,
		fontWeight: 'bold',
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	actions: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
    progressContainer: {
        padding: 10,
    }
}));

export default ({ rep, myGroup, disabled }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();

    const normalise = (value = 500) => {
        const min = rep?.current?.value ?? 0;
        const max = rep?.next?.value ?? 1000;
        return ((value - min) * 100) / (max - min);
    };

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={12} style={{ position: 'relative', height: 38 }}>
					<div className={classes.details}>
						<div className={classes.title}>{rep.label}</div>
					</div>
				</Grid>
			</Grid>
            <Grid container>
                <Grid item xs={2} style={{ position: 'relative' }}>
                    <div className={classes.progressLabel}>{rep.current?.label ?? 'No Rank'}</div>
				</Grid>
				<Grid item xs={8} style={{ position: 'relative' }}>
                    <div className={classes.progressContainer}>
                        <LinearProgress variant="determinate" value={normalise(rep.value)} />
                    </div>
				</Grid>
                <Grid item xs={2} style={{ position: 'relative' }}>
                    <div className={classes.progressLabel}>{rep.next?.label ?? 'Unknown'}</div>
				</Grid>
			</Grid>
		</Paper>
	);
};
