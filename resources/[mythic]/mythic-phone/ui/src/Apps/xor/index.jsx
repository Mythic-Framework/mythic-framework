import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default (props) => {
	const classes = useStyles();

	return <div className={classes.wrapper}>Coming ... Someday</div>;
};
