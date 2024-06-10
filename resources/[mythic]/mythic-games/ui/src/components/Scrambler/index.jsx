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
            height: 'fit-content',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            border: '5px solid transparent',
            background: theme.palette.secondary.dark,
            '&.critical': {
                '-webkit-animation':
                    'critical 1s infinite, critical-border 1s infinite',
            },
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
            '&.selected': {
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
            transition: 'none !important',
        },
        ph2: {
            display: 'block',
            width: '100%',
            height: 5,
            background: theme.palette.border.divider,
            borderRadius: 4,
        },
        progress2: {
            height: 5,
            borderRadius: 4,
        },
        output: {
            width: '100%',
            marginBottom: 10,
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
        strikeWrapper: {
            '&:not(:last-of-type)': {
                paddingRight: 5,
            },
        },
        strike: {
            display: 'block',
            width: '100%',
            margin: 'auto',
            height: 20,
            background: theme.palette.border.divider,
            borderRadius: 4,
            transition: 'background ease-in 0.15s',
            '&.filled': {
                background: theme.palette.primary.main,
            },
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

    const [entered, setEntered] = useState(Array());
    const [submitting, setSubmitting] = useState(false);
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [time2, setTime2] = useState(0);
    const [sequence, setSequence] = useState(Array());
    const [strikes, setStrikes] = useState(Array());
    const [pressed, setPressed] = useState(false);

    const pct =
        (time / game.limit) * 100 > 100 ? 100 : (time / game.limit) * 100;
    const pct2 =
        (time2 / game.timer) * 100 > 100 ? 100 : (time2 / game.timer) * 100;

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const countdown = () => {
        setCount(count - 1);
    };

    const generateSequence = () => {
        let c = Array();
        while (c.length < game.difficulty) {
            var r = Math.floor(Math.random() * game.difficulty) + 1;
            if (c.indexOf(r) === -1) c.push(r);
        }
        setSequence(c);
    };

    const onTick2 = () => {
        if (
            entered.length >= game.difficulty ||
            finished ||
            failed ||
            count >= 0 ||
            !submitting
        )
            return;

        if (game.timer && time2 > game.timer) {
            setSubmitting(false);
            setTime2(0);
            generateSequence();
        } else {
            setTime2(time2 + tickRate);
        }
    };

    const onTick = () => {
        if (
            entered.length >= game.difficulty ||
            finished ||
            failed ||
            count >= 0
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
    useInterval(onTick, count < 0 && !finished && !failed ? tickRate : null);
    useInterval(onTick2, count < 0 && !finished && !failed ? tickRate : null);

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setPressed(false);
        setTo(null);
        setFin(true);
        setEntered(Array());
        setSubmitting(false);
        setTime(0);
        setTime2(0);
        setStrikes(Array());
        setCount(Boolean(game?.countdown) ? game.countdown : 5);

        generateSequence();
    }, [started]);

    useEffect(() => {
        if (submitting) return;
        setTimeout(() => {
            setSubmitting(true);
        }, 1000);
    }, [submitting]);

    useEffect(() => {
        if (entered.length >= game.difficulty) {
            onComplete();
        }
    }, [entered]);

    useEffect(() => {
        return () => {
            if (to) clearTimeout(to);
            setPressed(false);
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
        if (
            entered.length >= game.difficulty ||
            finished ||
            failed ||
            pct2 >= 100
        )
            return;

        if (entered.length + 1 == digit) {
            soundEffect();
            setEntered([...entered, digit]);
        } else {
            if (strikes.length >= game.chance) {
                if (pressed) return;
                setPressed(true);
                Nui.send('Minigame:Finish', { state: 0 });
                soundEffect('negative');
                dispatch({
                    type: 'FAIL_GAME',
                });
            } else {
                soundEffect('negative');
                setStrikes([...strikes, true]);
            }
        }
    };

    const onComplete = () => {
        if (pressed) return;
        setPressed(true);

        if (
            _.isEqual(
                sequence.sort((a, b) => a - b),
                entered.sort((a, b) => a - b),
            )
        ) {
            Nui.send('Minigame:Finish', {
                state:
                    strikes.length == 0 && Boolean(game.events.onPerfect)
                        ? 2
                        : 1,
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
        return sequence.map((digit) => {
            return (
                <Grid key={`key-${digit}`} item xs={3} className={classes.btn}>
                    <Button
                        style={{ height: '100%', width: '100%' }}
                        disabled={
                            entered.length >= game.difficulty ||
                            finished ||
                            failed ||
                            count >= 0 ||
                            entered.length >= digit
                        }
                        color={entered.length >= digit ? 'info' : 'primary'}
                        variant={entered.length >= digit ? 'contained' : 'text'}
                        onClick={() => onBtnPress(digit)}
                    >
                        {count < 0 && <span>{digit}</span>}
                    </Button>
                </Grid>
            );
        });
    };

    const generateStrikes = () => {
        let arr = Array();

        for (let i = 0; i < game.chance; i++) {
            arr.push(
                <Grid
                    item
                    xs={12 / game.chance}
                    className={classes.strikeWrapper}
                >
                    <div
                        className={`${classes.strike}${
                            strikes.length > i ? ' filled' : ''
                        }`}
                    ></div>
                </Grid>,
            );
        }

        return arr;
    };

    const hide = () => {
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    return (
        <Fade in={fin} onExited={hide}>
            <div
                className={`${classes.wrapper}${
                    !failed &&
                    !finished &&
                    (pct >= 66 || strikes.length == game.chance)
                        ? ' critical'
                        : ''
                }`}
            >
                {count >= 0 && (
                    <div className={classes.countdown}>
                        <small>Preparing Device</small>
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

                <Grid container className={classes.output}>
                    {generateStrikes()}
                </Grid>
                <Grid container className={classes.buttons}>
                    <Grid item xs={12} style={{ marginBottom: 20 }}>
                        {!failed && !finished && count < 0 ? (
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
                    <Grid item xs={12}>
                        {!failed && !finished && count < 0 ? (
                            <LinearProgress
                                className={classes.progress2}
                                classes={{
                                    determinate: classes.progressbar,
                                    bar: classes.progressbar,
                                    bar1: classes.progressbar,
                                }}
                                variant="determinate"
                                color="info"
                                value={100 - pct2}
                            />
                        ) : (
                            <div className={classes.ph2}></div>
                        )}
                    </Grid>
                </Grid>
            </div>
        </Fade>
    );
};
