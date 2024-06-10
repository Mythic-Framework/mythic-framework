import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
    Alert,
    Button,
    ButtonGroup,
    Fade,
    Grid,
    LinearProgress,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useInterval from 'react-useinterval';
import _ from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

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
        finish: {
            fontSize: 22,
            fontFamily: 'LCD',
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
        progressbar: {
            transition: 'none !important',
        },
    }));

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const tickRate = 10;

    const [time, setTime] = useState(0);
    const [entered, setEntered] = useState(Array());
    const [pressed, setPressed] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const countdown = () => {
        setCount(count - 1);
    };

    const pct = (time / game.limit) * 100;
    const onTick = () => {
        if (finished || failed || (Boolean(game.countdown) && count >= 0))
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

    useInterval(countdown, !Boolean(game.countdown) || count < 0 ? null : 1000);
    useInterval(onTick, Boolean(game.limit) && count < 0 ? tickRate : null);

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setPressed(false);
        setTo(null);
        setFin(true);
        setEntered(Array());
        setSubmitting(false);
    }, [started]);

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
        if (entered.length >= game.difficulty || finished || failed) return;
        soundEffect();
        setEntered([...entered, digit]);
    };

    const onBackspace = () => {
        if (entered.length > 0) {
            soundEffect('back');
            setEntered(entered.filter((_, i) => i !== entered.length - 1));
        }
    };

    const onComplete = async () => {
        if (pressed) return;

        setPressed(true);

        soundEffect('confirm');
        try {
            if (_.isEqual(game.chance, entered)) {
                Nui.send('Minigame:Finish', {
                    state: 1,
                    entered: entered.join(''),
                });
                soundEffect('positive');
                dispatch({
                    type: 'FINISH_GAME',
                });
            } else {
                Nui.send('Minigame:Finish', {
                    state: 0,
                    entered: entered.join(''),
                });
                soundEffect('negative');
                dispatch({
                    type: 'FAIL_GAME',
                });
            }
        } catch (err) {
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        }
    };

    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);

    const generateButtons = () => {
        let btns = Array();
        for (let i = 1; i <= 10; i++) {
            btns.push(
                <Grid
                    key={`key-${i}`}
                    item
                    xs={i == 10 ? 12 : 4}
                    className={classes.btn}
                >
                    <Button
                        style={{ height: '100%', width: '100%' }}
                        disabled={
                            entered.length >= game.difficulty ||
                            (Boolean(game.countdown) && count >= 0)
                        }
                        onClick={() => onBtnPress(i == 10 ? 0 : i)}
                    >
                        {i == 10 ? 0 : i}
                    </Button>
                </Grid>,
            );
        }
        return btns;
    };

    const generateKeypadOutput = () => {
        if (game.mask) {
            return entered.map((digit, k) => {
                return (
                    <span key={`outp-${k}`} className={classes.digit}>
                        *
                    </span>
                );
            });
        } else {
            return entered.map((digit, k) => {
                return (
                    <span key={`outp-${k}`} className={classes.digit}>
                        {digit}
                    </span>
                );
            });
        }
    };

    const hide = () => {
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    return (
        <Fade in={fin} onExited={hide}>
            <div className={classes.wrapper}>
                {Boolean(game.countdown) && count >= 0 && (
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

                <div className={classes.output}>
                    {entered.length > 0 ? (
                        generateKeypadOutput()
                    ) : (
                        <span className={classes.noInput}>No Input</span>
                    )}
                </div>
                <Grid container className={classes.buttons}>
                    <Grid item xs={12} style={{ marginBottom: 20 }}>
                        {count < 0 &&
                        Boolean(game.limit) &&
                        !failed &&
                        !finished ? (
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
                    <Grid item xs={12} style={{ marginTop: 20 }}>
                        <ButtonGroup variant="contained" fullWidth>
                            <Button
                                className={classes.finish}
                                style={{
                                    display: 'block',
                                    height: '100%',
                                    width: '25%',
                                }}
                                color="error"
                                disabled={
                                    finished || failed || entered.length == 0
                                }
                                onClick={onBackspace}
                            >
                                <FontAwesomeIcon
                                    icon={['fas', 'delete-left']}
                                />
                            </Button>

                            <Button
                                className={classes.finish}
                                style={{ height: '100%', width: '75%' }}
                                color="success"
                                disabled={
                                    finished ||
                                    failed ||
                                    entered.length < game.chance.length
                                }
                                onClick={onComplete}
                            >
                                ENTER
                            </Button>
                        </ButtonGroup>
                    </Grid>
                </Grid>
            </div>
        </Fade>
    );
};
