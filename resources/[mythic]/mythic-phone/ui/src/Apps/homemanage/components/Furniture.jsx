import React from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Grid,
	Avatar,
	Accordion,
	AccordionSummary,
	AccordionDetails,
	Paper,
} from '@material-ui/core';
import { makeStyles, withStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';
import Nui from '../../../util/Nui';

const ExpansionPanel = withStyles({
	root: {
		border: '1px solid rgba(0, 0, 0, .25)',
		boxShadow: 'none',
		'&:not(:last-child)': {
			borderBottom: 0,
		},
		'&:before': {
			display: 'none',
		},
		'&$expanded': {
			margin: 'auto',
		},
	},
	expanded: {},
})(Accordion);

const useStyles = makeStyles((theme) => ({
	contact: {
		background: theme.palette.secondary.dark,
		'&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	paper: {
		background: theme.palette.secondary.dark,
	},
	expandoContainer: {
		textAlign: 'center',
		fontSize: 30,
	},
	expandoItem: {
		'&:hover': {
			color: theme.palette.primary.main,
			transition: 'color ease-in 0.15s',
		},
	},
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
	},
	avatarFav: {
		color: '#fff',
		height: 45,
		width: 45,
		border: '2px solid gold',
	},
	contactName: {
		fontSize: 18,
		color: theme.palette.text.light,
	},
	contactNumber: {
		fontSize: 14,
		color: theme.palette.text.main,
	},
	expanded: {
		margin: 0,
	},
}));

export default ({ onClick, index, expanded, furniture, onEdit, onFind, onClone, onDelete }) => {
	const classes = useStyles();
	const history = useHistory();

	return (
		<Paper className={classes.paper}>
			<ExpansionPanel
				className={classes.contact}
				expanded={expanded == index}
				onChange={onClick}
			>
				<AccordionSummary
					expandIcon={<FontAwesomeIcon icon={['fas', 'chevron-down']} />}
					style={{ padding: '0 12px' }}
				>
					<Grid container>
						<Grid item xs={12}>
							<div className={classes.contactName}>
								{furniture.name}
							</div>
							<div className={classes.contactNumber}>
                                ID: {furniture.id} | Dist: {Math.round(furniture.dist)}
							</div>
						</Grid>
					</Grid>
				</AccordionSummary>
				<AccordionDetails>
					<Grid container className={classes.expandoContainer}>
						<Grid
							item
							xs={3}
							className={classes.expandoItem}
							onClick={() => onEdit(furniture.id)}
						>
							<FontAwesomeIcon icon="arrows-up-down-left-right" />
						</Grid>
						<Grid
							item
							xs={3}
							className={classes.expandoItem}
							onClick={() => onFind(furniture.id)}
						>
							<FontAwesomeIcon icon="magnifying-glass" />
						</Grid>
						<Grid
							item
							xs={3}
							className={classes.expandoItem}
							onClick={() => onDelete(furniture.id)}
						>
							<FontAwesomeIcon icon="trash" />
						</Grid>
                        <Grid
							item
							xs={3}
							className={classes.expandoItem}
							onClick={() => onClone(furniture.cat, furniture.model)}
						>
							<FontAwesomeIcon icon="clone" />
						</Grid>
					</Grid>
				</AccordionDetails>
			</ExpansionPanel>
		</Paper>
	);
};
