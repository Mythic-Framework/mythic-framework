import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { List } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Item from './Item';
import { useJobPermissions } from '../../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#E95200',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	content: {
		height: '100%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '93.25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
}));

export default ({ onNavSelect, current, items }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasJobPerm = useJobPermissions();
	const onDuty = useSelector((state) => state.data.data.onDuty);
	const onClick = (id) => {
		onNavSelect(id);
	};

	return (
		<List>
			{items
				.filter(
					(item) =>
						!item.hidden &&
						(!item.permission ||
							hasJobPerm(item.permission, onDuty)),
				)
				.map((item) => {
					return (
						<Item
							key={item.id}
							id={item.id}
							icon={item.icon}
							label={item.label}
							active={item.id == current}
							onClick={() => onClick(item.id)}
						/>
					);
				})}
		</List>
	);
};
