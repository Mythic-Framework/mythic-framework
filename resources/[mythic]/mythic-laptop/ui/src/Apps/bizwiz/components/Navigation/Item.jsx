import React from 'react';
import { ListItem, ListItemIcon, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    link: {
        //paddingLeft: props.nested ? `15%	 !important` : null,
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

export default ({ onClick, active, icon, label }) => {
	const classes = useStyles();

	return (
		<ListItem button onClick={onClick} className={`${classes.link} ${active ? 'active' : null}`}>
			<ListItemIcon>
				<FontAwesomeIcon icon={icon} />
			</ListItemIcon>
            <ListItemText primary={label} />
		</ListItem>
	);
};
