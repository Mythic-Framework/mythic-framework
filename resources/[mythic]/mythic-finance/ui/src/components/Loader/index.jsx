import React from 'react';
import { CircularProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { Dot } from 'react-animated-dots';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		textAlign: 'center',
		fontSize: 22,
		fontWeight: 'bold',
		position: 'relative',
		zIndex: 100,
	},
	static: {
		width: 'fit-content',
		height: 'fit-content',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		textAlign: 'center',
		fontSize: 22,
		fontWeight: 'bold',
		zIndex: 100,
	},
	subtext: {
		fontSize: 14,
	},
	timer: {
		position: 'absolute',
		left: 0,
		right: 0,
		top: '10%',
		margin: 'auto',
		height: 'fit-content',
		width: 'fit-content',
	},
	dot1: {
		color: theme.palette.primary.main,
	},
	dot2: {
		color: theme.palette.text.main,
	},
	dot3: {
		color: theme.palette.primary.main,
	},
}));

export default (props) => {
	const classes = useStyles();
	return (
		<div className={props.static ? classes.static : classes.wrapper}>
			<CircularProgress color="primary" size={70} />
			{Boolean(props.number) && (
				<span className={classes.timer}>{props.number}</span>
			)}
			<div>
				{props.text ? props.text : 'Loading Data'}
				<Dot className={classes.dot1}>.</Dot>
				<Dot className={classes.dot2}>.</Dot>
				<Dot className={classes.dot3}>.</Dot>
			</div>
			{props.subtext && (
				<div className={classes.subtext}>{props.subtext}</div>
			)}
		</div>
	);
};
