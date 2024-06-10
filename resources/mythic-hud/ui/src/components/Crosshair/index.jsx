import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    penis: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        height: 8,
        width: 8,
        background: theme.palette.text.alt,
        border: `1px solid ${theme.palette.secondary.dark}`,
        borderRadius: 100,
    },
}));

export default () => {
    const classes = useStyles();
    const scopeShowing = useSelector((state) => state.app.sniper);
    const isArmed = useSelector((state) => state.app.armed);
    const showing = useSelector((state) => state.thirdEye.showing);

    return (
        <Fade in={isArmed && !showing && !scopeShowing}>
            <div className={classes.penis}></div>
        </Fade>
    );
};
