import React from 'react';
import { ListItem, ListItemText, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
//import Moment from 'react-moment';
import { useNavigate } from 'react-router';
import { usePerson } from '../../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ firearm }) => {
	const classes = useStyles();
	const history = useNavigate();
	const formatPerson = usePerson();

	const onClick = () => {
		history(`/search/firearms/${firearm._id}`);
	};

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={4}>
					<ListItemText primary="Serial Number" secondary={firearm.Serial} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText primary="Firearm Model" secondary={firearm.Model ?? 'Unknown'} />
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary="Registered Owner"
						secondary={
							Boolean(firearm.Owner?.Company)
								? firearm.Owner?.Company
								: formatPerson(
										firearm.Owner?.First,
										firearm.Owner?.Last,
										false,
										firearm.Owner?.SID,
										true,
										true,
										true,
								  )
						}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
