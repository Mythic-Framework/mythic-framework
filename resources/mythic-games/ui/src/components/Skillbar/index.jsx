import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { LinearProgress, Fade, Grid } from '@mui/material';
import { makeStyles, withStyles } from '@mui/styles';
import useInterval from 'react-useinterval';
import { useDispatch } from 'react-redux';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        width: '100%',
        maxWidth: 500,
        height: 'fit-content',
        position: 'absolute',
        bottom: '10%',
        left: 0,
        right: 0,
        margin: 'auto',
    },
    label: {
        color: theme.palette.text.main,
        fontSize: 18,
        textShadow: '0 0 5px #000',
    },
    marker: {
        width: '100%',
        height: 8,
        background: theme.palette.primary.main,
        opacity: 0.8,
        position: 'absolute',
        bottom: 0,
        zIndex: 0,
    },
    progressbar: {
        transition: 'none !important',
    },
}));

export default ({ game }) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const [pressed, setPressed] = useState(false);

    useKeypress(['e', 'E'], () => {
        if (pressed) return;

        setPressed(true);
        let pct = Math.ceil((curr / game.timer) * 100);
        if (pct >= game.chance && pct <= game.chance + game.difficulty) {
            Nui.send('Minigame:Finish', { state: 1 });
            dispatch({
                type: 'FINISH_GAME',
            });
        } else {
            Nui.send('Minigame:Finish', { state: 0 });
            dispatch({
                type: 'FAIL_GAME',
            });
        }
    });

    useEffect(() => {
        return () => {
            if (to) clearTimeout(to);
            setPressed(false);
        };
    }, []);

    useEffect(() => {
        if (finished || failed) {
            setCurr(0);
            setTo(
                setTimeout(() => {
                    setFin(false);
                }, 2000),
            );
        }
    }, [finished, failed]);

    useEffect(() => {
        setCurr(0);
        setFin(true);
        if (to) {
            clearTimeout(to);
            setPressed(false);
        }
    }, [started]);

    const BorderLinearProgress = withStyles((theme) => ({
        root: {
            height: 8,
        },
        colorPrimary: {
            backgroundColor: theme.palette.secondary.dark,
        },
        bar: {
            zIndex: 1,
            borderRadius: 5,
            backgroundColor: failed
                ? theme.palette.primary.main
                : finished
                ? theme.palette.success.main
                : theme.palette.info.main,
        },
    }))(LinearProgress);

    const [curr, setCurr] = useState(0);
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);

    const tick = () => {
        if (failed || finished) return;

        if (curr + 5 > game.timer) {
            Nui.send('Minigame:Finish', { state: 0 });
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setCurr(curr + 5);
        }
    };

    const hide = () => {
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    useInterval(tick, curr > game.timer ? null : 5);
    return (
        <Fade in={fin} duration={250} onExited={hide}>
            <div className={classes.wrapper}>
                <Grid container className={classes.label}>
                    <Grid item xs={12}>
                        {finished
                            ? 'Success'
                            : failed
                            ? 'Failed'
                            : 'Press [E] When Bar Hits Highlighted Area'}
                    </Grid>
                </Grid>
                <BorderLinearProgress
                    variant="determinate"
                    classes={{
                        determinate: classes.progressbar,
                        bar: classes.progressbar,
                        bar1: classes.progressbar,
                    }}
                    style={{ transition: 'none !important' }}
                    value={finished || failed ? 100 : (curr / game.timer) * 100}
                />
                {!finished && !failed && (
                    <div
                        className={classes.marker}
                        style={{
                            maxWidth: `${game.difficulty}%`,
                            left: `${game.chance - game.difficulty / 4}%`,
                        }}
                    ></div>
                )}
            </div>
        </Fade>
    );
};
