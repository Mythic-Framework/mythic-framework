import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Moment from 'react-moment';

import { CurrencyFormat } from '../../../../../util/Parser';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ data }) => {
	const classes = useStyles();

	console.log(data)

	return (
		<ListItem className={classes.wrapper}>
			<Grid container spacing={1}>
				<Grid item xs={2}>
					<ListItemText
						primary={'State ID'} 
						secondary={data.SID} 
					/>
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary={'Name'} 
						secondary={data.name} 
					/>
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary={'Eligible Loan'} 
						secondary={data.price ? CurrencyFormat.format(data.price) : 'Currently Not Eligible'} 
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary={'Credit Score'} 
						secondary={data.score} 
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
