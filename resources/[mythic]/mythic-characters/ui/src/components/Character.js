/* eslint-disable react/prop-types */
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import Moment from 'react-moment';
import { List, ListItem, Collapse, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		display: 'block',
		padding: 25,
		color: theme.palette.text.main,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		transition: 'background ease-in 0.15s',
		userSelect: 'none',
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
		'&:hover': {
			borderColor: '#2f2f2f',
			transition: 'border-color ease-in 0.15s',
			cursor: 'pointer',
		},
		'&.selected': {
			background: theme.palette.secondary.light,
		},
	},
	highlight: {
		color: theme.palette.primary.main,
	},
	left: {
		display: 'inline-block',
		width: '75%',
	},
	right: {
		display: 'inline-block',
		width: '25%',
		textAlign: 'right',
	},
	actionButton: {
		display: 'inline-block',
		width: '40%',
	},
	details: {
		display: 'block',
	},
}));

export default ({ character }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const selected = useSelector((state) => state.characters.selected);

	const onClick = () => {
		if (selected?.ID == character.ID) {
			dispatch({
				type: 'DESELECT_CHARACTER',
			});
		} else {
			dispatch({
				type: 'SELECT_CHARACTER',
				payload: {
					character: character,
				},
			});
		}
	};

	return (
		<ListItem
			button
			className={`${classes.wrapper}${selected?.ID == character?.ID ? ' selected' : ''}`}
			onClick={onClick}
		>
			<div>
				<div>
					<span className={classes.headerText}>
						{character.First} {character.Last}
					</span>
				</div>
				<div>
					<span>
						Last Played:{' '}
						{+character.LastPlayed === -1 ? (
							<span className={classes.highlight}>Never</span>
						) : (
							<span className={classes.highlight}>
								<small>
									<Moment date={+character.LastPlayed} format="M/D/YYYY h:mm:ss A" withTitle />
								</small>
							</span>
						)}
					</span>
				</div>
			</div>
			<Collapse in={selected?.ID == character?.ID} collapsedSize={0}>
				<div className={classes.details}>
					<List>
						<ListItem>
							<ListItemText primary="State ID" secondary={character.SID} />
						</ListItem>
						{character?.Jobs?.length > 0 ? 
							character.Jobs.map((job, index) => {
								return (
									<ListItem>
										<ListItemText
											primary={`Job #${index + 1}`}
											secondary={job.Workplace ? `${job.Workplace.Name} - ${job.Grade.Name}` : `${job.Name} - ${job.Grade.Name}`}
										/>
									</ListItem>
								)
							})
							:
							<ListItem>
								<ListItemText
									primary="Job"
									secondary="Unemployed"
								/>
							</ListItem>
						}
					</List>
				</div>
			</Collapse>
		</ListItem>
	);
};
