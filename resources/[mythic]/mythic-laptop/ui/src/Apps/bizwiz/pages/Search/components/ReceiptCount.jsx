import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ report }) => {
	const classes = useStyles();

	return (
		<ListItem className={classes.wrapper}>
			<Grid container spacing={1}>
				<Grid item xs={2}>
					<ListItemText
						primary={'Employee'}
						secondary={`${report.char?.First} ${report.char?.Last} (${report.char?.SID})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Receipts Created"
						secondary={`${report.created}`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Receipts Assisted"
						secondary={`${report.assisted}`}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Receipt Types"
						secondary={Object.keys(report.types).map(type => {
							return `${type}: ${report.types[type]};  `;
						})}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Latest Receipt"
						secondary={<Moment date={report.latest} fromNow />}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
