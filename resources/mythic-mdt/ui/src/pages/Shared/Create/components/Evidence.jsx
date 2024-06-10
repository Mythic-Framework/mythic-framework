import React, { useState } from 'react';
import { Chip, Grid, IconButton, Tooltip } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { EvidenceTypes } from './EvidenceForm';
import Evidenceitem from './EvidenceItem';

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
}));

export default ({ evidence, onClick, onDelete }) => {
	const classes = useStyles();

	const [hover, setHover] = useState(false);

	if (evidence && evidence.length > 0) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.label}>Evidence</div>
				<div className={classes.body}>
					{evidence.map((item, k) => {
						return (
							<Evidenceitem
								key={`evidence-${k}`}
								item={item}
								onView={() => onClick(k)}
								onDelete={onDelete}
							/>
						);
					})}
				</div>
			</div>
		);
	} else return null;
};
