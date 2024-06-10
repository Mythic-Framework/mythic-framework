import React from 'react';
import { useDispatch } from 'react-redux';
import {
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Typography,
	List,
	ListItem,
	ListItemText,
	AccordionActions,
	Button,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../../util/Nui';
import { useAlert, useJobPermissions, useMyJob } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	item: {
		background: theme.palette.secondary.dark,
	},
	positive: {
		color: theme.palette.success.main,
		fontWeight: 'bold',
	},
	positive: {
		color: theme.palette.error.main,
		fontWeight: 'bold',
	},
}));

export default ({ property, expanded, onClick, onSell }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const hasJobPerm = useJobPermissions();
	const isMyJob = useMyJob();

	const onMark = async () => {
		try {
			let res = await (
				await Nui.send('Dyn8:MarkProperty', property._id)
			).json();
			showAlert(res ? 'GPS Marked' : 'Unable to Mark GPS');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Mark GPS');
		}
	};

	return (
		<Accordion
			className={classes.item}
			expanded={expanded}
			onChange={onClick}
		>
			<AccordionSummary
				expandIcon={<FontAwesomeIcon icon={['fas', 'chevron-down']} />}
			>
				<Typography className={classes.heading}>
					{property.label}
				</Typography>
			</AccordionSummary>
			<AccordionDetails>
				<List>
					<ListItem>
						<ListItemText
							primary="Address"
							secondary={property.label}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Sold"
							secondary={property.sold ? 'Yes' : 'No'}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Home Owner"
							secondary={
								Boolean(property.owner)
									? `${property.owner.First} ${property.owner.Last}`
									: 'No Owner'
							}
						/>
					</ListItem>
				</List>
			</AccordionDetails>
			<AccordionActions>
				{!property.sold && (
					<Button onClick={onMark}>Mark Property</Button>
				)}
				{!property.sold &&
					hasJobPerm('JOB_SELL', 'realestate')
					&& (
						<Button onClick={() => onSell(property)}>
							Sell Property
						</Button>
					)}
			</AccordionActions>
		</Accordion>
	);
};
