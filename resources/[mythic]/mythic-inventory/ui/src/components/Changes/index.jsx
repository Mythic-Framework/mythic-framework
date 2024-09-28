import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { TextField, InputAdornment, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Alert from './Alert';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: 175,
		margin: 'auto',
		height: 125,
		width: 125,
		// width: 'fit-content',
		display: 'flex',
		flexDirection: 'row',
		gap: 20,
		justifyContent: 'center',
	},
}));

export default () => {
	const classes = useStyles();
	const items = useSelector((state) => state.inventory.items);
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const changes = useSelector((state) => state.changes.alerts);

	if (!itemsLoaded || Object.keys(items).length == 0) return null;
	return (
		<div className={classes.wrapper}>
			{changes
				.sort((a, b) => a.id - b.id)
				.slice(0, 4)
				.map((alert) => {
					return <Alert key={`alert-${alert.id}`} alert={alert} />;
				})}
		</div>
	);
};
