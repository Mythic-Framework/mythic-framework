import React from 'react';
import { ListItem, ListItemText, Grid, ListItemSecondaryAction, IconButton } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { useNavigate } from 'react-router';

import { PropertyTypes } from '../../../../data';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ property }) => {
	const classes = useStyles();
	const history = useNavigate();

	const onGPSMark = async () => {
		try {
            let res = await (
                await Nui.send('Dyn8MarkProperty', property._id)
            ).json();

            if (res) {
                toast.success('Marked Successfully');
            } else {
                toast.error('Error Marking GPS');
            };
        } catch (err) {
            console.log(err);
			toast.error('Error Marking GPS');
        }
	};

	return (
		<ListItem className={classes.wrapper} button>
			<Grid container>
				<Grid item xs={6}>
					<ListItemText
						primary="Address"
						secondary={`${property.label}`}
					/>
				</Grid>
				{property.owner ?
					<Grid item xs={4}>
						<ListItemText
							primary="Owner"
							secondary={`${property.owner?.First} ${property.owner?.Last} (${property.owner?.SID})`}
						/>
					</Grid>
					:
					<Grid item xs={4}>
						<ListItemText
							primary="Owner"
							secondary={`Dynasty 8`}
						/>
					</Grid>
				}
				<Grid item xs={2}>
					<ListItemText
						primary="Type"
						secondary={PropertyTypes[property.type] ?? 'Property'}
					/>
				</Grid>
			</Grid>
			<ListItemSecondaryAction>
				<IconButton onClick={onGPSMark}>
					<FontAwesomeIcon
						icon={['fas', 'location-crosshairs']}
					/>
				</IconButton>
			</ListItemSecondaryAction>
		</ListItem>
	);
};
