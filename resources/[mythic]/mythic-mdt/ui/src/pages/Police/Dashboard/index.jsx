import React from 'react';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { BOLO, Warrant } from './blocks';
import { NoticeBoard } from '../../../components';

const useStyles = makeStyles(theme => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
	},
}));

export default () => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<Grid container spacing={2}>
				<NoticeBoard />
				<BOLO />
				<Warrant />
			</Grid>
		</div>
	);
};
