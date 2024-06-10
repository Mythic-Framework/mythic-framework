import React from 'react';
import { ListItem, ListItemIcon, ListItemText } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { NavLink } from 'react-router-dom';

export default (props) => {
	const useStyles = makeStyles((theme) => ({
		link: {
			paddingLeft: props.nested ? `15%	 !important` : null,
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
	}));
	const classes = useStyles();

	return (
		<ListItem
			button
			exact={props.link.exact}
			className={classes.link}
			component={NavLink}
			to={props.link.path}
			name={props.link.name}
			onClick={props.onClick}
		>
			<ListItemIcon>
				<FontAwesomeIcon icon={props.link.icon} />
			</ListItemIcon>
			{!props.compress ? (
				<ListItemText primary={props.link.label} />
			) : null}
		</ListItem>
	);
};
