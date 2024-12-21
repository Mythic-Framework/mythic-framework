import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, List, IconButton, Slide, Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        width: '100%',
        height: '100%',
        position: 'absolute',
        top: 0,
        right: 0,
        left: 0,
        margin: 'auto',
    },
    blackBar: {
        height: 150,
        background: '#000',
        position: 'absolute',
        left: 0,
        right: 0,
        margin: 'auto',
        textAlign: 'center',
        lineHeight: '150px',

        '&.top': {
            top: 0,
            fontSize: 35,
        },
        '&.bottom': {
            bottom: 0,
            fontSize: 20,
        },
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const showing = useSelector((state) => state.gemTable.showing);
    const info = useSelector((state) => state.gemTable.info);

    if (!showing || !info) return null;

    const displayInfo =
        typeof info === 'object'
            ? info.quality ?? JSON.stringify(info)
            : info;

    return (
        <Fade in={showing} timeout={500} mountOnEnter unmountOnExit>
            <div className={classes.wrapper}>
                <div className={`${classes.blackBar} top`}>SAGMA Gem Table</div>
                <div className={`${classes.blackBar} bottom`}>
                    Appraised Gem Quality: {displayInfo}%
                </div>
            </div>
        </Fade>
    );
};
