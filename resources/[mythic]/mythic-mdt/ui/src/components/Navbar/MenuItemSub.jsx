import React from 'react';
import { makeStyles } from '@mui/styles';
import {
	List,
	ListItem,
	ListItemIcon,
	ListItemText,
	Collapse,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NavLink } from 'react-router-dom';

import MenuItem from './MenuItem';

const useStyles = makeStyles((theme) => ({
	link: {
		color: theme.palette.text.main,
		height: 60,
		transition: 'color ease-in 0.15s, background-color ease-in 0.15s',
		'& svg': {
			fontSize: 20,
			transition: 'color ease-in 0.15s',
		},
		'&:hover': {
			color: `${theme.palette.primary.main}`,
			cursor: 'pointer',
			'& svg': {
				color: `${theme.palette.primary.main}`,
			},
		},
		'&.active': {
			color: theme.palette.primary.main,
			'& svg': {
				color: theme.palette.primary.main,
				'--fa-secondary-opacity': 1.0,
			},
		},
	},
	icon: {
        fontSize: '0.75vh',
        transition: '.5s',
        color: theme.palette.primary.main,
	},
}));

export default (props) => {
	const classes = useStyles();

	return (
		<>
			<ListItem
				className={classes.link}
				component={NavLink}
				end={props.link.exact}
				to={props.link.path}
				name={props.link.name}
				onClick={props.onClick}
				button
			>
				<ListItemIcon>
					<FontAwesomeIcon icon={props.link.icon} />
				</ListItemIcon>
				<ListItemText primary={props.link.label} />
				{Boolean(props.link.items) && props.link.items.length > 0 ? (
					<FontAwesomeIcon
						className={classes.icon}
						icon={
							props.open === props.link.name
								? 'chevron-up'
								: 'chevron-down'
						}
					/>
				) : null}
			</ListItem>
			<Collapse in={props.open === props.link.name}>
				<List component="div" disablePadding>
					{props.link.items.map((sublink, j) => {
						return (
							<MenuItem
								key={`sub-${props.link.name}-${j}`}
								link={sublink}
								onClick={props.handleMenuClose}
								nested
							/>
						);
					})}
				</List>
			</Collapse>
		</>
	);
};
