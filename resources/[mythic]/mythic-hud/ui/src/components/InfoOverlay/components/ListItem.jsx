import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
    ListItem,
    ListItemText,
    ListItemSecondaryAction,
    IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';

import Nui from '../../../util/Nui';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Sanitize } from '../../../util/Parser';
import { faBullseye } from '@fortawesome/free-solid-svg-icons';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        background: theme.palette.secondary.main,
        transition: 'background ease-in 0.15s',
        '&.clickable:hover': {
            background: theme.palette.secondary.dark,
        },
    },
    primaryText: {
        fontSize: 22
    },
    secondaryText: {
        fontSize: 16,
    }
}));

export default ({ index, item }) => {
    const classes = useStyles();
    const dispatch = useDispatch();

    return (
        <ListItem 
            button={false}
            disabled={Boolean(item.disabled)}
            divider
            className={classes.wrapper}
            onClick={null}
        >
            <ListItemText
                primary={<span className={classes.primaryText}>{item.label}</span>}
                secondary={<span className={classes.secondaryText}>{Sanitize(item.description)}</span>}
            />
        </ListItem>
    );
};
