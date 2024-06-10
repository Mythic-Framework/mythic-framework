import React from 'react';
import {
	Avatar,
	ListItem,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@mui/material';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import { usePerson } from '../../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 20,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
		'&.active': {
			background: theme.palette.secondary.main,
		},
	},
	picture: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
		height: 60,
		width: 60,
	},
}));

export default ({ selected, officer, onSelect }) => {
	const classes = useStyles();
	const formatPerson = usePerson();
	const myJob = useSelector(state => state.app.govJob);
	const govJobData = officer.Jobs?.find(j => j.Id == myJob.Id);

	if (!govJobData) return null;

	return (
		<ListItem 
			className={`${classes.wrapper}${selected ? ' active' : ''}`}
			button
			onClick={() => onSelect(selected ? null : officer)}
		>
			<Grid container>
				<Grid item xs={2}>
					<ListItemAvatar>
						<Avatar
							className={classes.picture}
							src={officer?.Mugshot}
							alt={officer.First}
						/>
					</ListItemAvatar>
				</Grid>
				<Grid item xs={10}>
					<ListItemText
						primary={formatPerson(officer.First, officer.Last, officer.Callsign, officer.SID)}
						secondary={`${govJobData?.Workplace?.Name} - ${govJobData?.Grade?.Name}`}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
