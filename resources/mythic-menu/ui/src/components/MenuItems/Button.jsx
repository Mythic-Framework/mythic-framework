/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        borderRadius: 3,
        '&:hover': {
            background: theme.palette.secondary.light,
            filter: 'brightness(0.7)',
        },
    },
    error: {
        border: `2px solid ${theme.palette.border.dark}`,
        background: theme.palette.error.dark,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        borderRadius: 3,
        '&:hover': {
            background: theme.palette.error.main,
            //filter: 'brightness(0.7)',
        },
    },
    success: {
        border: `2px solid ${theme.palette.success.dark}`,
        background: theme.palette.success.main,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        borderRadius: 3,
        '&:hover': {
            background: theme.palette.success.main,
            filter: 'brightness(0.7)',
        },
    },
}));

export default ({ data }) => {
    const classes = useStyles();

    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'SELECT' });
            Nui.send('Selected', {
                id: data.id,
            });
        }
    };

    const cssClass = data.options.disabled
        ? `${data.options.success ? classes.success : classes.div} disabled`
        : data.options.success
        ? classes.success
        : data.options.error
        ? classes.error
        : classes.div;
    const style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <Button className={cssClass} style={style} onClick={onClick}>
            {data.label}
        </Button>
    );
};
