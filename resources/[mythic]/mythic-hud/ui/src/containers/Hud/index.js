import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { Location, Status, Vehicle } from '../../components';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'relative',
        height: '100%',
        width: '100%',
    },
}));

export default () => {
    const classes = useStyles();
    const showing = useSelector((state) => state.hud.showing);

    return (
        <Fade in={showing}>
            <div className={classes.wrapper}>
                <Location />
                <Status />
                <Vehicle />
            </div>
        </Fade>
    );
};
