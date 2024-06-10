import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { ListItem, ListItemText } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
}));

export default ({ team }) => {
	const classes = useStyles();
	const items = useSelector((state) => state.data.data.items);

	return (
		<ListItem divider className={classes.wrapper}>
			<ListItemText primary="Team #" secondary={team._id} />
			<ListItemText primary="Team Name" secondary={team.name} />
			<ListItemText
				primary="Members"
				secondary={<span>{team.members.length} Members</span>}
			/>
		</ListItem>
	);
};
