import React from 'react';
import { CircularProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	loader: {
		width: '100%',
		height: '100%',
		position: 'relative',
	},
	loaderBlocks: {
		width: 200,
		height: 200,
		display: 'inline-block',
		overflow: 'hidden',
		background: 'transparent',
	},
}));

export default (props) => {
	const classes = useStyles();

	return (
		<div className={classes.loaderBlocks}>
			<CircularProgress className={classes.loader} color="primary" size={125} />
		</div>
	);
};
