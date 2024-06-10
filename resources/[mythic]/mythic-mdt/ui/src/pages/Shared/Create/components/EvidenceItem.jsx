import React, { useState } from 'react';
import { Chip, Grid, IconButton, Portal } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { EvidenceTypes } from './EvidenceForm';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		borderRadius: 4,
		border: `1px solid ${theme.palette.border.input}`,
		margin: 0,
		marginBottom: 10,
		display: 'inline-flex',
		minWidth: '100%',
		position: 'relative',
		flexDirection: 'column',
		verticalAlign: 'top',
		wordBreak: 'break-all',
		boxShadow:
			'inset 0 0 14px 0 rgba(0,0,0,.3), inset 0 2px 0 rgba(0,0,0,.2)',
	},
	label: {
		transform: 'translate(11px, -10px) scale(0.75)',
		top: 0,
		left: 0,
		position: 'absolute',
		transformOrigin: 'top left',
		color: 'rgba(255, 255, 255, 0.5)',
		fontSize: '1rem',
		background: '#111315',
		padding: '0 4px',
	},
	body: {},
	item: {
		margin: 4,
	},
	img: {
		position: 'fixed',
		width: 200,
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		border: '1px solid',
		p: 1,
		bgcolor: 'background.paper',
		position: 'fixed',
		width: 200,
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		border: '1px solid',
		p: 1,
		bgcolor: 'background.paper',
	},
}));

export default ({ item, onView, onDelete, ...rest }) => {
	const classes = useStyles();
	const eType = EvidenceTypes.filter((e) => e.value == item.type)[0];

	return (
		<div {...rest} style={{ display: 'inline-flex' }}>
			<Chip
				className={classes.item}
				style={eType.style}
				label={`${eType.label} [${item.label}]`}
				onDelete={onDelete ? () => onDelete(item) : null}
				onClick={onView}
			/>
		</div>
	);
};
