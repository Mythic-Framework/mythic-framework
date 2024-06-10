import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Paper, Button } from '@material-ui/core';
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
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	title: {
		fontSize: 20,
		color: theme.palette.primary.main,
		fontWeight: 'bold',
	},
	pay: {
		fontSize: 16,
		color: theme.palette.success.main,
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
}));

export default ({ job, myGroup, disabled }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const onStart = async () => {
		try {
			let res = await (
				await Nui.send('StartLaborJob', {
					job: job.Id,
					isWorkgroup: Boolean(myGroup),
				})
			).json();
			if (res) {
				showAlert(`Started ${job.Name}`);
			} else showAlert('Unable to Start Job');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Start Job');
		}
	};

	const onQuit = async () => {
		try {
			let res = await (await Nui.send('QuitLaborJob', job.Id)).json();
			if (res) {
				showAlert(`Quit ${job.Name}`);
			} else showAlert('Unable to Quit Job');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Quit Job');
		}
	};

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={7} style={{ position: 'relative', height: 65 }}>
					<div className={classes.details}>
						<div className={classes.title}>{job.Name}</div>
						{job.Salary > 0 && (
							<div className={classes.pay}>${job.Salary}</div>
						)}
					</div>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<div className={classes.duty}>
						{job.Limit == 0 ? job.OnDuty.length : `${job.OnDuty.length} / ${job.Limit}`}
					</div>
				</Grid>
				<Grid item xs={3} style={{ position: 'relative' }}>
					{job.OnDuty.filter((p) => p.Joiner == player.Source)
						.length > 0 ||
					(Boolean(myGroup) &&
						job.OnDuty.filter((p) => p.Joiner == myGroup.Creator.ID)
							.length > 0) ? (
						<Button
							variant="text"
							className={classes.actions}
							disabled={
								(Boolean(myGroup) &&
									myGroup.Creator.ID != player.Source) ||
								disabled
							}
							onClick={onQuit}
						>
							Quit
						</Button>
					) : (
						<Button
							variant="text"
							className={classes.actions}
							disabled={
								(Boolean(myGroup) &&
									myGroup.Creator.ID != player.Source) ||
								Boolean(player.TempJob) ||
								disabled
							}
							onClick={onStart}
						>
							Start
						</Button>
					)}
				</Grid>
			</Grid>
		</Paper>
	);
};
