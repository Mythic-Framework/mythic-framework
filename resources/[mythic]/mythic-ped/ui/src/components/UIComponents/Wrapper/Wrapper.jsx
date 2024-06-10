import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 30,
		color: theme.palette.text.main,
		overflowX: 'hidden',
		overflowY: 'auto',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#131317',
		},
		'&::-webkit-scrollbar-track': {
			background: theme.palette.secondary.main,
		},
	},
}));
export default (props) => {
	const classes = useStyles();
	return <div className={classes.wrapper}>{props.children}</div>;
};
