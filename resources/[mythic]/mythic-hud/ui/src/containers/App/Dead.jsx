import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Location, Status, Vehicle } from '../../components';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'absolute',
        height: '100%',
        width: '100%',
        background: '#000000e6',
    },
}));

export default () => {
    const classes = useStyles();
    const isBlindfolded = useSelector((state) => state.app.blindfolded);
    const isDead = useSelector((state) => state.status.isDead);

    return (
        <Fade in={isDead && !isBlindfolded}>
            <div className={classes.wrapper}></div>
        </Fade>
    );
};
