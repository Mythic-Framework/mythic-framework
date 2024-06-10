import React from 'react';
import { useSelector } from 'react-redux';
import {
	ListItem,
	ListItemText,
	Grid,
	Avatar,
	ListItemAvatar,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import moment from 'moment';
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
	},
}));

const warrantStates = {
	active: 'Active',
	void: 'Void',
	served: 'Served',
	expired: 'Expired',
}

export default ({ warrant }) => {
	const classes = useStyles();
	const history = useNavigate();
	const job = useSelector(state => state.app.govJob);

	const onClick = () => {
		if (job) {
			history(`/warrants/${warrant._id}`);
		}
	};
	
	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={2}>
					<ListItemText
						primary="State"
						secondary={`${warrantStates[warrant?.state] ?? 'Unknown'}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Subject"
						secondary={`${warrant.suspect.First} ${warrant.suspect.Last}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Issuing Officer"
						secondary={`${warrant.author.First} ${warrant.author.Last}`}
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Created"
						secondary={moment(warrant.time).format('LLLL')}
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Expires"
						secondary={moment(warrant.expires).format('LLLL')}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
