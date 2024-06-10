import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Fade } from '@material-ui/core';
import { Meter } from '../../components';

const useStyles = makeStyles((theme) => ({}));

export default () => {
	const classes = useStyles();
	const isHidden = useSelector((state) => state.app.hidden);

	return (
		<Fade in={!isHidden}>
			<div>
				<Meter />
			</div>
		</Fade>
	);
};
