import React from 'react';
import { useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

import FullScope from '../../assets/fullscope.webp';

const useStyles = makeStyles((theme) => ({
    penis: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        width: '100vw   ',
        height: '100vh',
        backgroundImage: `url(${FullScope})`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'center',
        backgroundSize: 'cover',
        '& svg': {
            display: 'block',
            width: '100%',
            height: '100%',
            margin: '0 auto',
        },
        '& path': {
            transition: 'fill .5s',
            fill: '#E3DFD2',
            '&:hover': {
                fill: 'pink',
            },
        },
    },
    scope: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        display: 'block',
        height: '100%',
        width: '100%',
    },
}));

export default () => {
    const classes = useStyles();
    const scopeShowing = useSelector((state) => state.app.sniper);
    const isArmed = useSelector((state) => state.app.armed);
    const inVeh = useSelector((state) => state.vehicle.showing);

    return (
        <Fade in={isArmed && scopeShowing && !inVeh}>
            <div className={classes.penis}>
                {/* <img src={FullScope} className={classes.scope} /> */}
                {/* <svg width="100%" height="100%">
                    <defs>
                        <mask id="mask" x="0" y="0" width="100%" height="100%">
                            <rect
                                x="0"
                                y="0"
                                width="100%"
                                height="100%"
                                fill="#fff"
                            />
                            <circle cx="50%" cy="50%" r="26.5%" />
                        </mask>
                    </defs>
                    <rect
                        x="0"
                        y="0"
                        width="100%"
                        height="100%"
                        mask="url(#mask)"
                        fillOpacity="0.8"
                    />
                </svg> */}
            </div>
        </Fade>
    );
};
