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
            width: 'fit-content',
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
        phi: {
            display: 'block',
            width: '100%',
            height: 20,
            background: 'transparent',
            borderRadius: 4,
        },
        ph: {
            display: 'block',
            width: '100%',
            height: 20,
            background: theme.palette.border.divider,
            borderRadius: 4,
        },
        strikeWrapper: {
            '&:not(:last-of-type)': {
                paddingRight: 5,
            },
        },
        strikei: {
            display: 'block',
            width: '100%',
            margin: 'auto',
            height: 20,
            background: 'transparent',
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
        progress: {
            height: 20,
            borderRadius: 4,
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
        progressbar: {
            transition: 'none !important',
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
        row: {
            display: 'flex',
            justifyContent: 'space-around',
            gap: 4,
            marginBottom: 12,
        },
        invis: {
            width: 75,
            height: 75,
            background: 'transparent',
        },
        item: {
            width: 75,
            height: 75,
            background: theme.palette.secondary.light,
            border: `1px solid ${theme.palette.border.divider}`,
            '&.clickable:hover': {
                border: `1px solid ${theme.palette.primary.main}`,
            },
            '&.preview': {
                background: theme.palette.info.main,
            },
            '&.highlight': {
                background: theme.palette.success.main,
            },
            '&.wrong': {
                background: theme.palette.error.main,
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
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [time2, setTime2] = useState(0);
    const [strikes, setStrikes] = useState(0);

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );
    const [pressed, setPressed] = useState(false);

    const countdown = () => {
        setCount(count - 1);
    };

    const pct = (time / game.limit) * 100;
    const pct2 = Boolean(delay) ? (time2 / delay) * 100 : 0;

    const onTick2 = () => {
        if (finished || failed || submitting || !Boolean(delay) || isDone())
            return;

        if (game.timer && time2 > game.timer) {
            setSubmitting(true);
            setDelay(null);
        } else {
            setTime2(time2 + tickRate);
        }
    };

    const onTick = () => {
        if (finished || failed || !submitting || isDone()) return;

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
    useInterval(onTick, count < 0 && submitting ? tickRate : null);
    useInterval(onTick2, count < 0 && !submitting ? tickRate : null);

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setPressed(false);
        setTo(null);
        setFin(true);
        setDelay(null);
        setSubmitting(false);
        setEntered(Array());
        setStrikes(Array());
        setTime(0);
        setTime2(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
    }, [started]);

    useEffect(() => {
        return () => {
            if (to) clearTimeout(to);
            setPressed(false);
        };
    }, []);

    useEffect(() => {
        if (count < 0) {
            setDelay(game.timer);
        }
    }, [count]);

    useEffect(() => {
        if (isDone()) {
            onComplete();
        }
    }, [entered]);

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
        if (isDone() || finished || failed) return;
        soundEffect();
        if (game.chance.indexOf(digit) === -1) setStrikes([...strikes, digit]);
        setEntered([...entered, digit]);
    };

    const isDone = () => {
        let f = entered.filter((digit) => {
            if (game.chance.indexOf(digit) === -1) return false;
            else return true;
        });

        return (
            _.isEqual(
                game.chance.sort((a, b) => a - b),
                f.sort((a, b) => a - b),
            ) || strikes.length >= game.errors
        );
    };

    const onComplete = () => {
        if (pressed) return;

        setPressed(true);

        if (isDone() && strikes.length < game.errors) {
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

    const generateStrikes = () => {
        let arr = Array();

        for (let i = 0; i < game.errors; i++) {
            arr.push(
                <Grid item xs={12 / game.errors}>
                    <div
                        className={`${
                            count < 0 ? classes.strike : classes.strikei
                        }${strikes.length > i ? ' filled' : ''}`}
                    ></div>
                </Grid>,
            );
        }

        return arr;
    };

    const generateGrid = () => {
        let grid = Array();

        for (let i = 0; i < game.cols; i++) {
            let row = Array();
            for (let j = 0; j < game.rows; j++) {
                let digit = i * game.cols + (j + 1);
                let isClicked = entered.indexOf(digit) !== -1;
                let isClickable =
                    submitting &&
                    count < 0 &&
                    !(isClicked || finished || failed);
                row.push(
                    <div
                        key={`col-${i}-${j}`}
                        onClick={isClickable ? () => onBtnPress(digit) : null}
                        className={`${
                            count < 0 ? classes.item : classes.invis
                        }${
                            isClicked && count < 0
                                ? game.chance.indexOf(digit) !== -1
                                    ? ' highlight'
                                    : ' wrong'
                                : Boolean(delay) &&
                                  game.chance.indexOf(digit) !== -1
                                ? ' preview'
                                : isClickable
                                ? ' clickable'
                                : ''
                        }`}
                    ></div>,
                );
            }
            grid.push(
                <div key={`col-${i}`} className={classes.row}>
                    {row}
                </div>,
            );
        }

        return grid;
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

                <Grid container className={classes.buttons}>
                    <Grid item xs={12} style={{ marginBottom: 20 }}>
                        <Grid container spacing={1}>
                            {generateStrikes()}
                        </Grid>
                    </Grid>
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
                            <div
                                className={count < 0 ? classes.ph : classes.phi}
                            ></div>
                        )}
                    </Grid>
                    <Grid item xs={12}>
                        {generateGrid()}
                    </Grid>
                    <Grid item xs={12} style={{ height: 5 }}>
                        {Boolean(delay) && count < 0 && (
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
                        )}
                    </Grid>
                </Grid>
            </div>
        </Fade>
    );
};
