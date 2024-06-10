import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import {
	Fab,
	IconButton,
	List,
	ListItem,
	ListItemSecondaryAction,
	ListItemText,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import ChopItem from './component/ChopItem';
import { Loader, Modal } from '../../components';
import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'relative',
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'auto',
	},
	body: {
		padding: 10,
		height: '100%',
	},
	fab: {
		position: 'absolute',
		bottom: 25,
		right: 25,
	},
}));

export default ({ items }) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
			<List className={classes.body}>

			</List>
		</div>
	);
};
