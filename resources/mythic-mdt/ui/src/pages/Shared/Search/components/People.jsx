import React from 'react';
import {
	Avatar,
	List,
	ListItem,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	mugshot: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
		height: 60,
		width: 60,
	}
}));

export default ({ person }) => {
	const classes = useStyles();
	const history = useNavigate();
	const govJobs = useSelector(state => state.data.data.governmentJobs);

	const onClick = () => {
		history(`/search/people/${person.SID}`);
	};

	const jobCount = person.Jobs?.length ?? 0
	let isGovernment = false;

	if (jobCount > 0 && govJobs?.length > 0) {
		isGovernment = person.Jobs?.find(j => govJobs.includes(j.Id));
	}

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={1}>
					<ListItemAvatar>
						<Avatar className={classes.mugshot} src={person.Mugshot} alt={person.First} />
					</ListItemAvatar>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Name"
						secondary={`${person.First} ${person.Last}`}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText primary="State ID" secondary={person.SID} />
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary="Sex"
						secondary={person.Gender ? 'Female' : 'Male'}
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Date of Birth"
						secondary={moment(person.DOB * 1000).format('LL')}
					/>
				</Grid>
				{isGovernment && <Grid item xs={4}>
					<ListItemText
						primary="Government Employee"
						secondary={`${isGovernment?.Workplace?.Name ?? isGovernment.Name} - ${isGovernment.Grade?.Name}`}
					/>
				</Grid>}
			</Grid>
		</ListItem>
	);
};
