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

const useStyles = makeStyles((theme) => ({
    wrapper: {
        background: theme.palette.secondary.main,
        transition: 'background ease-in 0.15s',
        '&.clickable:hover': {
            background: theme.palette.secondary.dark,
        },
    },
    action: {
        fontSize: 14,
    },
    phw: {
        pointerEvents: 'none !important',
    },
    ph: {
        fontSize: 14,
        color: `${theme.palette.primary.main} !important`,
    },
}));

export default ({ index, item }) => {
    const classes = useStyles();
    const dispatch = useDispatch();

    const onClick = () => {
        if (item.submenu) {
            Nui.send('ListMenu:SubMenu', {
                submenu: item.submenu,
            });
            dispatch({
                type: 'CHANGE_MENU',
                payload: {
                    menu: item.submenu,
                },
            });
        } else if (item.event) {
            Nui.send('ListMenu:Clicked', {
                event: item.event,
                data: item.data,
            });
        }
    };

    const onAction = (event) => {
        Nui.send('ListMenu:Clicked', {
            event: event,
            data: item.data,
        });
    };

    return (
        <ListItem
            button={
                !Boolean(item.actions) &&
                (Boolean(item.event) || Boolean(item.submenu))
            }
            disabled={Boolean(item.disabled)}
            divider
            className={`${classes.wrapper}${
                !Boolean(item.actions) &&
                (Boolean(item.event) || Boolean(item.submenu))
                    ? ' clickable'
                    : ''
            }`}
            onClick={
                !Boolean(item.actions) &&
                (Boolean(item.event) || Boolean(item.submenu))
                    ? onClick
                    : null
            }
        >
            <ListItemText
                primary={item.label}
                secondary={<span>{Sanitize(item.description)}</span>}
            />
            {Boolean(item.submenu) ? (
                <ListItemSecondaryAction className={classes.phw}>
                    <IconButton disabled className={classes.ph}>
                        <FontAwesomeIcon icon={['fas', 'chevron-right']} />
                    </IconButton>
                </ListItemSecondaryAction>
            ) : Boolean(item.actions) ? (
                <ListItemSecondaryAction>
                    {item.actions.map((action, k) => {
                        return (
                            <IconButton
                                key={`${index}-action-${k}`}
                                onClick={() => onAction(action.event)}
                                className={classes.action}
                            >
                                <FontAwesomeIcon icon={['fas', action.icon]} />
                            </IconButton>
                        );
                    })}
                </ListItemSecondaryAction>
            ) : null}
        </ListItem>
    );
};
