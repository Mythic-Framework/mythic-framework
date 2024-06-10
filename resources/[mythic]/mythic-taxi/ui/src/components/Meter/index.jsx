import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Fade, Grid } from '@material-ui/core';

import { CurrencyFormat } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: 'fit-content',
		width: 500,
		color: theme.palette.text.main,
		border: `1px solid ${theme.palette.border.input}`,
		fontWeight: 'bold',
		fontSize: 32,
		position: 'absolute',
		bottom: 0,
		right: 0,
		margin: 'auto',
		fontFamily: 'LCD',
	},
	block: {
		background: '#000',
		padding: 10,
		borderRight: `1px solid #1e1e1e`,
	},
	blockHeader: {
		fontSize: 25,
		color: theme.palette.text.alt,
	},
	blockContent: {
		textAlign: 'right',
		fontSize: 50,
		padding: 5,
	},
	smallBlockHeader: {
		fontSize: 16,
		color: theme.palette.text.alt,
	},
	smallBlockContent: {
		textAlign: 'right',
		fontSize: 28,
		padding: 5,
		'& small': {
			color: theme.palette.text.alt,
			fontSie: 14,
			marginLeft: 5,
		},
	},
}));

export default () => {
	const classes = useStyles();
	const rate = useSelector((state) => state.app.rate);
	const trip = useSelector((state) => state.app.trip);

	return (
		<Grid container className={classes.wrapper}>
			<Grid item xs={5} className={classes.block}>
				<div className={classes.blockHeader}>$ FARE</div>
				<div className={classes.blockContent}>
					{CurrencyFormat.format(Math.ceil((trip / 1609) * rate))}
				</div>
			</Grid>
			<Grid item xs={4} className={classes.block}>
				<div className={classes.blockHeader}>TRIP</div>
				<div className={classes.blockContent}>
					{(trip / 1609).toFixed(3)}
				</div>
			</Grid>
			<Grid item xs={3} className={classes.block}>
				<div className={classes.smallBlockHeader}>RATE</div>
				<div className={classes.smallBlockContent}>
					{CurrencyFormat.format(rate)}
				</div>
			</Grid>
			<Grid item xs={12}></Grid>
		</Grid>
	);
};
