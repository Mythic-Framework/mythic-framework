import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { CurrencyFormat } from '../../../../../../util/Parser';

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

import { vehicleCategories } from '../data';

export default ({ vehicle, onClick, onSecondary }) => {
	const classes = useStyles();

	const onInternalClick = () => {
		onClick();
	};

    const onInternalSecondary = (e) => {
        e.stopPropagation();
		onSecondary(vehicle?.vehicle?.VIN)
    };

	return (
		<ListItem className={classes.wrapper} button onClick={onInternalClick}>
			<Grid container spacing={1}>
				<Grid item xs={1}>
					<ListItemText primary={'Type'} secondary={vehicle?.type == 'loan' ? 'Loan' : 'Cash'} />
				</Grid>
				<Grid item xs={2}>
					<ListItemText primary={'Vehicle'} secondary={`${vehicle?.vehicle?.data?.make} ${vehicle?.vehicle?.data?.model} (${vehicle?.vehicle?.data?.class})`} />
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary={'Category'}
						secondary={`${vehicleCategories.find(c => c.value == vehicle?.vehicle?.data?.category)?.label ?? 'Unknown'}`}
					/>
				</Grid>
                <Grid item xs={2}>
					<ListItemText
						primary={'Sale Price'}
						secondary={`${CurrencyFormat.format(vehicle?.salePrice)} (${CurrencyFormat.format(vehicle?.commission)})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary={'Seller'}
						secondary={`${vehicle?.seller?.First} ${vehicle?.seller?.Last} (${vehicle?.seller?.SID})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary={'Buyer'}
						secondary={`${vehicle?.buyer?.First} ${vehicle?.buyer?.Last} (${vehicle?.buyer?.SID})`}
					/>
				</Grid>
				<Grid item xs={2}>
					<ListItemText
						primary="Time"
						secondary={<Moment unix date={vehicle?.time} fromNow />}
					/>
					<ListItemSecondaryAction onClick={onInternalSecondary}>
                        <IconButton>
                            <FontAwesomeIcon
                                icon={['fas', 'magnifying-glass']}
                            />
                        </IconButton>
                    </ListItemSecondaryAction>
				</Grid>
			</Grid>
		</ListItem>
	);
};
