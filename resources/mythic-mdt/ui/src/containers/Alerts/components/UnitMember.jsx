import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Menu, MenuItem, Tooltip, Chip } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	item: {
		margin: 0,
		cursor: 'pointer',
		// transition: 'background ease-in 0.15s',
		// border: `1px solid ${theme.palette.border.divider}`,
		// margin: 7.5,
		// transition: 'filter ease-in 0.15s',
		// '&:hover': {
		// 	filter: 'brightness(0.8)',
		// 	cursor: 'pointer',
		// },
	},
}));

export default ({ callsign, isLast, isPrimary, isTow = null }) => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const emergencyMembers = useSelector((state) => state.alerts.emergencyMembers);

	const memberData = Boolean(isTow)
		? emergencyMembers.find((m) => m?.SID === isTow)
		: emergencyMembers.find((m) => m?.Callsign === callsign);
	if (!memberData) return null;

	if (user.SID === memberData.SID) {
		return (
			<Tooltip
				placement={isPrimary ? 'top' : 'bottom'}
				title={`${memberData.First[0]}. ${memberData.Last} (You)`}
			>
				<b className={classes.item}>{`${
					Boolean(isTow) ? `${memberData.First[0]}. ${memberData.Last}` : callsign
				} (You)${!isPrimary && !isLast ? ', ' : ''}`}</b>
			</Tooltip>
		);
	} else {
		return (
			<Tooltip placement={isPrimary ? 'top' : 'bottom'} title={`${memberData.First[0]}. ${memberData.Last}`}>
				<span className={classes.item}>{`${callsign}${!isPrimary && !isLast ? ', ' : ''}`}</span>
			</Tooltip>
		);
	}
};
