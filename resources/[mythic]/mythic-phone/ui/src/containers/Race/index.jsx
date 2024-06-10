import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useStopwatch } from 'react-use-stopwatch';
import { Slide, Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import useCountDown from 'react-countdown-hook';
import parseMilliseconds from 'parse-ms';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'absolute',
		bottom: '1%',
		right: '1%',
		width: 300,
		padding: 20,
		background: `${theme.palette.secondary.dark}80`,
		textShadow: '0 0 10px #000',
		color: theme.palette.text.main,
	},
	label: {
		fontSize: 18,
		fontWeight: 'bold',
	},
	value: {
		fontSize: 20,
		fontWeight: 'bold',
		textAlign: 'right',
	},
	footer: {
		textAlign: 'right',
		fontSize: 12,
		fontFamily: 'monospace',
		marginTop: 10,
	},
}));

Number.prototype.pad = function (size) {
	var s = String(this);
	while (s.length < (size || 2)) {
		s = '0' + s;
	}
	return s;
};

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const alias = useSelector((state) => state.data.data.player.Alias?.redline);
	const trackDetails = useSelector((state) => state.track);

	const [lapTime, lapStart, lapStop, lapReset] = useStopwatch();
	const [total, start, stop, reset] = useStopwatch();
	const [dnfTimer, dnfFuncs] = useCountDown(300 * 1000, 10);
	const dnf = parseMilliseconds(dnfTimer);
	const [fastest, setFastest] = useState(null);

	useEffect(() => {
		start();
		return () => {
			stop();
		};
	}, []);

	useEffect(() => {
		if (trackDetails.dnf) {
			setTimeout(() => {
				dispatch({
					type: 'RACE_END',
				});
			}, 3000);
		}
	}, [trackDetails.dnf]);

	useEffect(() => {
		if (trackDetails.dnfTime != null) {
			dnfFuncs.start(trackDetails.dnfTime * 1000);
		} else {
			dnfFuncs.pause();
		}
	}, [trackDetails.dnfTime]);

	const finishLap = () => {
		dispatch({
			type: 'ADD_LAP_TIME',
			payload: { ...{ ...lapTime, lapStart: trackDetails.lapStart, lapEnd: Date.now() }, alias },
		});
		if (lapTime.time > 0 && (!fastest || lapTime.time < fastest.time)) {
			setFastest(lapTime);
		}
	};

	useEffect(() => {
		if (lapTime.time > 0) {
			finishLap();
		}
		lapReset();
		lapStart();
	}, [trackDetails.lap]);

	const onHide = () => {
		finishLap();
		dispatch({
			type: 'RACE_HUD_END',
		});
	};

	return (
		<Slide
			direction="up"
			in={trackDetails.render}
			mountOnEnter
			unmountOnExit
			onExited={onHide}
		>
			{trackDetails.dnf ? (
				<Grid container className={classes.wrapper}>
					<Grid item xs={12} className={classes.label}>
						You DNF'd, Better Luck Next Time
					</Grid>
				</Grid>
			) : (
				<Grid container className={classes.wrapper}>
					{Boolean(trackDetails.dnfTime) && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									DNF
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{`${dnf.hours.pad(2)}:${dnf.minutes.pad(
										2,
									)}:${dnf.seconds.pad(2)}.${(
										dnf.milliseconds / 10
									).pad(2)}`}
								</Grid>
							</Grid>
						</Grid>
					)}
					{trackDetails.isLaps && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{trackDetails.lap} /{' '}
									{trackDetails.totalLaps}
								</Grid>
							</Grid>
						</Grid>
					)}
					<Grid item xs={6} className={classes.label}>
						Checkpoint
					</Grid>
					<Grid item xs={6} className={classes.value}>
						{trackDetails.checkpoint} /{' '}
						{trackDetails.totalCheckpoints}
					</Grid>
					{trackDetails.isLaps && (
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={6} className={classes.label}>
									Current Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{lapTime.format}
								</Grid>
								<Grid item xs={6} className={classes.label}>
									Fastest Lap
								</Grid>
								<Grid item xs={6} className={classes.value}>
									{fastest ? (
										fastest.format
									) : (
										<span>--:--:--.--</span>
									)}
								</Grid>
							</Grid>
						</Grid>
					)}
					<Grid item xs={6} className={classes.label}>
						Total Time
					</Grid>
					<Grid item xs={6} className={classes.value}>
						{total.format}
					</Grid>
				</Grid>
			)}
		</Slide>
	);
};
