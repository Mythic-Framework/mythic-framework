import React from 'react';
import { ListItem, ListItemText, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { useNavigate } from 'react-router';

import { VehicleTypes } from '../../../../data';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ vehicle }) => {
	const classes = useStyles();
	const history = useNavigate();

	const onClick = () => {
		history(`/search/vehicles/${vehicle.VIN}`);
	};

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container>
				<Grid item xs={2}>
					<ListItemText
						primary="VIN"
						secondary={vehicle.VIN}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText primary="Plate" secondary={vehicle.RegisteredPlate} />
				</Grid>
				<Grid item xs={3}>
					<ListItemText
						primary="Make / Model"
						secondary={`${vehicle.Make} ${vehicle.Model}`}
					/>
				</Grid>
				{vehicle.Owner?.Type === 0 ?
					<Grid item xs={2}>
						<ListItemText
							primary="Registered Owner"
							secondary={`State ID: ${vehicle.Owner?.Id}`}
						/>
					</Grid>
					:
					<Grid item xs={2}>
						<ListItemText
							primary="Registered Owner"
							secondary={`Organization/Business`}
						/>
					</Grid>
				}
				<Grid item xs={1}>
					<ListItemText
						primary="Type"
						secondary={VehicleTypes[vehicle.Type] ?? 'Vehicle'}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Registration Date"
						secondary={vehicle.RegistrationDate ? <Moment date={vehicle.RegistrationDate} unix format="LL" /> : 'Unknown'}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary="Impounded"
						secondary={vehicle.Storage?.Type === 0 ? 'Yes' : 'No'}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
