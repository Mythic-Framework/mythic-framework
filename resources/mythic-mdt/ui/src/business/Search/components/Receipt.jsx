import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router';
import { TitleCase } from '../../../util/Parser';

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
	const history = useNavigate();

	const onClick = () => {
		history(`/business/search/receipt/${report._id}`);
	};

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container spacing={1}>
				<Grid item xs={2}>
					<ListItemText primary={'Type'} secondary={report.type} />
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary={'Submitted By'}
						secondary={`${report.author?.First} ${report.author?.Last} (${report.author?.SID})`}
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Created"
						secondary={<Moment date={report.time} fromNow />}
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Customer Info"
						secondary={`${report.customerName} - ${report.customerNumber}`}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
