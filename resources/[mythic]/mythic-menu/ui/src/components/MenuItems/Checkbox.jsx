/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { Grid, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { CheckBox, CheckBoxOutlineBlank } from '@material-ui/icons';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        userSelect: 'none',
        textAlign: 'center',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        borderRadius: 3,
        '&:hover': {
            background: theme.palette.secondary.light,
            filter: 'brightness(0.7)',
        },
    },
    left: {
        display: 'inline-block',
        width: '10%',
        marginTop: 3,
    },
    icon: {
        width: '0.75em',
        height: '100%',
        fontSize: '1.25rem',
    },
    right: {
        width: '90%',
        textAlign: 'center',
        float: 'right',
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [selected, setSelected] = useState(data.options.selected);

    const onClick = () => {
        setSelected(!selected);
        Nui.send('FrontEndSound', { sound: 'SELECT' });
        Nui.send('Selected', {
            id: data.id,
            data: { selected: !selected },
        });
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            <Grid container>
                <Grid item xs={2}>
                    {selected ? (
                        <CheckBox className={classes.icon} />
                    ) : (
                        <CheckBoxOutlineBlank className={classes.icon} />
                    )}
                </Grid>
                <Grid item xs={8}>
                    <span>{data.label}</span>
                </Grid>
                <Grid item xs={2}></Grid>
            </Grid>
        </Button>
    );
};
