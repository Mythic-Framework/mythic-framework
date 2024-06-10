import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, List, IconButton, Slide, Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import ReactMomentCountDown from 'react-moment-countdown';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        width: 340,
        height: 'fit-content',
        position: 'absolute',
        top: 0,
        right: 0,
        left: 0,
        margin: 'auto',
        textAlign: 'center',
        background: theme.palette.secondary.dark,
        padding: 15,
    },
    gametype: {
        fontSize: 14,
    },
    timer: {
        fontSize: 24,
    },
    teamInfo: {
        textAlign: 'center',
    },
    teamname: {
        fontSize: 14,
    },
    objective: {
        fontSize: 24,
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const showing = useSelector((state) => state.arcade.showing);
    const info = useSelector((state) => state.arcade.matchInfo);
    const team1 = useSelector((state) => state.arcade.team1);
    const team2 = useSelector((state) => state.arcade.team2);

    //if (!showing || !Boolean(info)) return null;
    return (
        <Fade
            direction="down"
            in={showing}
            timeout={500}
            mountOnEnter
            unmountOnExit
        >
            <div>
                <Grid container className={classes.wrapper}>
                    <Grid item xs={3} className={classes.teamInfo}>
                        <div className={classes.teamname}>Team 1</div>
                        <div className={classes.objective}>
                            {team1.current} / {team1.max}
                        </div>
                    </Grid>
                    <Grid item xs={6}>
                        <div className={classes.gametype}>
                            {info.matchLabel}
                        </div>
                        <div className={classes.timer}>
                            <ReactMomentCountDown
                                className={classes.highlight}
                                toDate={new Date(info.matchEnd)}
                                targetFormatMask="m:ss"
                            />
                        </div>
                    </Grid>
                    <Grid item xs={3} className={classes.teamInfo}>
                        <div className={classes.teamname}>Team 2</div>
                        <div className={classes.objective}>
                            {team2.current} / {team2.max}
                        </div>
                    </Grid>
                </Grid>
            </div>
        </Fade>
    );
};
