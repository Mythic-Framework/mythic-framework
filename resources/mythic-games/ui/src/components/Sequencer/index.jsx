import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Button, Fade, Grid, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useInterval from 'react-useinterval';
import _ from 'lodash';

import Nui from '../../util/Nui';
import useSound from '../../hooks/useSound';

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            width: 400,
            minHeight: 475,
            height: 'fit-content',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            background: theme.palette.secondary.dark,
        },
        results: {
            width: '100%',
            height: '100%',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            background: `${theme.palette.secondary.dark}b3`,
        },
        alert: {
            width: 300,
            height: 'fit-content',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            zIndex: 10,
        },
        btn: {
            textAlign: 'center',
            height: 75,
            lineHeight: '50px',
            background: 'transparent',
            transition: 'background ease-in 0.15s',
            borderRadius: 4,
            '&.flash': {
                background: 'rgb(255 215 0 / 50%)',
                color: theme.palette.text.main,
            },
            '& span': {
                fontSize: 42,
                fontFamily: 'LCD',
            },
        },
        ph: {
            display: 'block',
            width: '100%',
            height: 20,
            background: theme.palette.border.divider,
            borderRadius: 4,
        },
        progressbar: {
            transition: 'none !important',
        },
        progress: {
            height: 20,
            borderRadius: 4,
        },
        output: {
            width: '100%',
            textAlign: 'right',
            height: 75,
            lineHeight: '75px',
            fontFamily: 'LCD',
        },
        digit: {
            fontSize: 42,
            color: theme.palette.text.main,
            padding: 5,
        },
        noInput: {
            fontSize: 42,
            color: theme.palette.text.alt,
        },
        countdown: {
            position: 'absolute',
            width: '100%',
            height: 'fit-content',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',

            '& small': {
                fontSize: 28,
                fontFamily: 'LCD',
                display: 'block',
                margin: 'auto',
                width: 'fit-content',
                height: 'fit-content',
            },

            '& span': {
                fontSize: 135,
                fontFamily: 'LCD',
                display: 'block',
                margin: 'auto',
                width: 'fit-content',
                height: 'fit-content',
            },

            '& svg': {
                fontSize: 60,
            },
        },
    }));

    const tickRate = 10;

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const [delay, setDelay] = useState(null);
    const [entered, setEntered] = useState(Array());
    const [submitting, setSubmitting] = useState(false);
    const [flashing, setFlashing] = useState([game.chance[0]]);
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [pressed, setPressed] = useState(false);

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setPressed(false);
        setTo(null);
        setFin(true);
        setEntered(Array());
        setSubmitting(false);
        setDelay(null);
        setFlashing([game.chance[0]]);
        setTime(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
    }, [started]);

    const countdown = () => {
        setCount(count - 1);
    };

    const pct = (time / game.limit) * 100;

    const addFlashed = () => {
        if (game.chance.length == flashing.length) {
            setDelay(null);
            setSubmitting(true);
        } else {
            setFlashing([...flashing, game.chance[flashing.length]]);
        }
    };

    const onTick = () => {
        if (
            entered.length >= game.difficulty ||
            finished ||
            failed ||
            !submitting
        )
            return;

        if (game.limit && time > game.limit) {
            if (pressed) return;
            setPressed(true);
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setTime(time + tickRate);
        }
    };

    useInterval(countdown, count < 0 ? null : 1000);
    useInterval(addFlashed, delay);
    useInterval(onTick, tickRate);

    useEffect(() => {
        if (count < 0) setDelay(game.timer);
    }, [count]);

    useEffect(() => {
        if (entered.length == game.chance.length && count < 0) {
            onComplete();
        }
    }, [entered]);

    useEffect(() => {
        return () => {
            if (to) clearTimeout(to);
        };
    }, []);

    useEffect(() => {
        if (finished || failed) {
            setTo(
                setTimeout(() => {
                    setFin(false);
                }, 2000),
            );
        }
    }, [finished, failed]);

    const onBtnPress = (digit) => {
        if (entered.length >= game.difficulty || finished || failed) return;
        soundEffect();
        setEntered([...entered, digit]);
    };

    const onComplete = () => {
        if (pressed) return;
        setPressed(true);

        if (_.isEqual(game.chance, entered)) {
            Nui.send('Minigame:Finish', {
                state: pct <= 25 && Boolean(game.events.onPerfect) ? 2 : 1,
            });
            soundEffect('positive');
            dispatch({
                type: 'FINISH_GAME',
            });
        } else {
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        }
    };

    const generateButtons = () => {
        let btns = Array();
        for (let i = 1; i <= 12; i++) {
            btns.push(
                <Grid
                    key={`key-${i}`}
                    item
                    xs={4}
                    className={`${classes.btn}${
                        flashing[flashing.length - 1] == i &&
                        !submitting &&
                        count < 0
                            ? ' flash'
                            : ''
                    }`}
                >
                    <Button
                        style={{ height: '100%', width: '100%' }}
                        disabled={
                            entered.length >= game.difficulty ||
                            !submitting ||
                            finished ||
                            failed
                        }
                        color={
                            flashing[flashing.length - 1] == i && !submitting
                                ? 'inherit'
                                : 'primary'
                        }
                        onClick={() => onBtnPress(i)}
                    >
                        <span>{i}</span>
                    </Button>
                </Grid>,
            );
        }
        return btns;
    };

    const generateSequenceOutput = () => {
        return entered.map((digit, k) => {
            return (
                <span key={`outp-${k}`} className={classes.digit}>
                    {game.mask ? '*' : digit}
                </span>
            );
        });
    };

    const hide = () => {
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    return (
        <Fade in={fin} onExited={hide}>
            <div className={classes.wrapper}>
                {count >= 0 && (
                    <div className={classes.countdown}>
                        <small>Preparing System</small>
                        <span>{count == 0 ? 'Done' : count}</span>
                    </div>
                )}
                {(finished || failed) && (
                    <div
                        className={`${classes.results} ${
                            finished ? 'success' : 'failed'
                        }`}
                    >
                        {finished ? (
                            <Alert
                                className={classes.alert}
                                variant="filled"
                                severity="success"
                            >
                                Success!
                            </Alert>
                        ) : failed ? (
                            <Alert
                                className={classes.alert}
                                variant="filled"
                                severity="error"
                            >
                                You Failed
                            </Alert>
                        ) : null}
                    </div>
                )}

                {count < 0 && !finished && !failed && (
                    <>
                        <div className={classes.output}>
                            {entered.length > 0 ? (
                                generateSequenceOutput()
                            ) : (
                                <span className={classes.noInput}>
                                    No Input
                                </span>
                            )}
                        </div>
                        <Grid container className={classes.buttons}>
                            <Grid item xs={12} style={{ marginBottom: 20 }}>
                                {submitting && !failed && !finished ? (
                                    <LinearProgress
                                        className={classes.progress}
                                        classes={{
                                            determinate: classes.progressbar,
                                            bar: classes.progressbar,
                                            bar1: classes.progressbar,
                                        }}
                                        variant="determinate"
                                        color={
                                            pct < 33
                                                ? 'success'
                                                : pct < 66
                                                ? 'warning'
                                                : failed || finished
                                                ? 'secondary'
                                                : 'error'
                                        }
                                        value={100 - pct}
                                    />
                                ) : (
                                    <div className={classes.ph}></div>
                                )}
                            </Grid>
                            {generateButtons()}
                        </Grid>
                    </>
                )}
            </div>
        </Fade>
    );
};
