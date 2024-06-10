import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { ListItem, ListItemText } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({}));

export default ({ property }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const charId = useSelector((state) => state.data.data.player.ID);
	const myKey = property.keys[charId];

	const onClick = () => {
		dispatch({
			type: 'SET_SELECTED_PROPERTY',
			payload: property.id,
		});
	};

	return (
		<ListItem divider button onClick={onClick}>
			<ListItemText primary={property.label} secondary={myKey?.Owner ? 'Owner' : 'Key Holder'} />
		</ListItem>
	);
};
