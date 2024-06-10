import React from 'react';
import Nui from '../../util/Nui';
import { Grid, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

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
    left: {
        display: 'inline-block',
        width: '50%',
        textAlign: 'left',
        paddingLeft: 10,
    },
    right: {
        display: 'inline-block',
        width: '50%',
        textAlign: 'right',
        paddingRight: 10,
    },
}));

export default ({ data }) => {
    const classes = useStyles();

    const onClick = () => {
        Nui.send('FrontEndSound', { sound: 'SELECT' });
        Nui.send('Selected', {
            id: data.id,
        });
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            <Grid container>
                <Grid item xs={2}>
                    {data.options.secondaryLabel}
                </Grid>
                <Grid item xs={8}>
                    {data.label}
                </Grid>
                <Grid item xs={2}></Grid>
            </Grid>
        </Button>
    );
};
