import React from 'react';
import {
	Avatar,
	ListItem,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@mui/material';
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

export default ({ selectedJob, selected, officer, onSelect }) => {
	const classes = useStyles();
	const formatPerson = usePerson();
	const selectedJobData = officer.Jobs?.find(j => j.Id == selectedJob);

	if (!selectedJobData) return null;

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
						secondary={`${selectedJobData?.Workplace?.Name} - ${selectedJobData?.Grade?.Name}`}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
