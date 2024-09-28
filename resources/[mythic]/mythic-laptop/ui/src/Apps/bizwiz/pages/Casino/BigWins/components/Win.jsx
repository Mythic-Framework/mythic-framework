import React from 'react';
import { ListItem, ListItemText, Grid } from '@mui/material';
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

export default ({ win, onClick }) => {
	const classes = useStyles();

	const onInternalClick = () => {
		onClick();
	};

    const onSecondary = (e) => {
        e.stopPropagation();
    };

	return (
		<ListItem className={classes.wrapper} button onClick={onInternalClick}>
			<Grid container spacing={1}>
				<Grid item xs={2}>
					<ListItemText primary={'Type'} secondary={win?.Type.toUpperCase()} />
				</Grid>
				<Grid item xs={6}>
					<ListItemText primary={'Prize'} secondary={`${win?.Prize}`} />
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary={'Winner'}
						secondary={`${win?.Winner?.First} ${win?.Winner?.Last} (${win?.Winner?.SID})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Time"
						secondary={<Moment unix date={win?.Time} fromNow />}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
