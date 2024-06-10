import React from 'react';
import { Box } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	tabPanel: {
		background: theme.palette.secondary.main,
		height: '100%',
		overflow: 'auto',
	},
}));

export default ({ children, value, index, ...other }) => {
	const classes = useStyles();

	if (value !== index) return null;
	return (
		<Box className={classes.tabPanel} p={0}>
			{children}
		</Box>
	);
};
