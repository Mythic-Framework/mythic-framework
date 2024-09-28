import React from 'react';
import { ListItem, ListItemText, Grid, Slider, IconButton } from '@mui/material';
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

export default ({ name, min, max, current, onChange }) => {
	const classes = useStyles();

	return (
		<ListItem className={classes.wrapper}>
			<Grid container spacing={1}>
				<Grid item xs={4}>
					<ListItemText primary={name} />
				</Grid>
				<Grid item xs={6}>
					{/* <ListItemText
						primary={'Name'} 
						secondary={data.name} 
					/> */}
					<Slider
						size="small"
						value={current}
						name="downpayment"
						min={min}
						max={max}
						step={5}
						valueLabelDisplay="auto"
						onChange={onChange}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
