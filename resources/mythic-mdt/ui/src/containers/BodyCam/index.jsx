import React from 'react';
import { useSelector } from 'react-redux';
import { Fade, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

import AxonLogo from '../../assets/img/axon.png';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	container: {
		fontFamily: ['Share Tech Mono', 'monospace'],
		fontSize: 14,
		position: 'absolute',
		top: '-4.5%',
		right: '-4.5%',
		background: 'rgba(0,0,0,0.5)',
		borderRadius: 10,
		width: 400,
		height: 'fit-content',
	},
	axon: {
		width: 75,
		height: 75,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	recordIcon: {
		color: theme.palette.error.main,
	},
}));

export default () => {
	const classes = useStyles();
	const job = useSelector((state) => state.app.govJob);
	const showing = useSelector((state) => state.bodycam.show);
	const mdtHidden = useSelector((state) => state.app.hidden);
	const dispatchShowing = useSelector((state) => state.alerts.showing);
	const cData = useSelector((state) => state.app.user);

	if (!Boolean(cData) || !Boolean(job) || (job.Id != 'police' && job.Id != 'ems')) return null;
	return (
		<Fade in={showing && mdtHidden && !dispatchShowing}>
			<Grid className={classes.container} container>
				<Grid item xs={9} style={{ textAlign: 'right', padding: 10 }}>
					<div>
						REC <FontAwesomeIcon className={classes.recordIcon} fade icon={['fas', 'circle']} /> XION
						CHASE-CAM™
					</div>
					<div>
						{cData.First[0]}. {cData.Last} [{Boolean(cData.Callsign) ? cData.Callsign : 'NOTSET'}]
					</div>
					<div>{job.Workplace.Name}</div>
					<Grid container>
						<Grid item xs={8}>
							<Moment interval={60000} format="MMMM Do YYYY" />
						</Grid>
						<Grid item xs={4}>
							<Moment interval={1000} format="hh:mm:ss a" />
						</Grid>
					</Grid>
				</Grid>
				<Grid item xs={3} style={{ position: 'relative' }}>
					<img src={AxonLogo} alt="Axon" className={classes.axon} />
				</Grid>
			</Grid>
		</Fade>
	);
};
