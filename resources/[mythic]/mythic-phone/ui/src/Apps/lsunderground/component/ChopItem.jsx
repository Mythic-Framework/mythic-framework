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
		'& svg': {
			marginRight: 6,
			color: 'gold',
		},
	},
}));

export default ({ chopRequest }) => {
	const classes = useStyles();

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={12} style={{ position: 'relative', height: 38 }}>
					<div className={classes.details}>
						<div className={classes.title}>
							{chopRequest.hv && (
								<FontAwesomeIcon
									icon={['fas', 'triangle-exclamation']}
								/>
							)}
							{chopRequest.name}
						</div>
					</div>
				</Grid>
			</Grid>
		</Paper>
	);
};
