import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import BlidnfoldOverlay from '../../assets/blindfold.webp';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        display: 'block',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        height: '100vh',
        width: '100vw',
        backgroundColor: '#000000e6',
        backgroundImage: `url(${BlidnfoldOverlay})`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: '50% 0',
        backgroundSize: 'cover',
        opacity: 0.99,
    },
}));

export default () => {
    const classes = useStyles();
    const isBlindfolded = useSelector((state) => state.app.blindfolded);

    return (
        <Fade in={isBlindfolded}>
            <div>
                <div className={classes.wrapper}></div>
            </div>
        </Fade>
    );
};
