import React, { useEffect, useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Fade, Grid, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import useInterval from 'react-useinterval';
import { useDispatch } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import useSound from '../../hooks/useSound';
import Nui from '../../util/Nui';
import Alley from './components/Alley';

const shuffle = (array) => {
    let currentIndex = array.length,
        randomIndex;

    // While there remain elements to shuffle.
    while (currentIndex != 0) {
        // Pick a remaining element.
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex--;

        // And swap it with the current element.
        [array[currentIndex], array[randomIndex]] = [
            array[randomIndex],
            array[currentIndex],
        ];
    }

    return array;
};

const MAX_PROCESS_STAGES = 3;

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            width: 'fit-content',
            minWidth: 260 * game.difficulty + 30 * (game.difficulty - 1),
            height: '85%',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            background: theme.palette.secondary.dark,
        },
        timer: {
            textAlign: 'center',
            margin: 'auto',
            fontSize: 18,
            color: theme.palette.text.main,
            textShadow: '0 0 5px #000',
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
            background: `${theme.palette.secondary.dark}`,
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
        progress: {
            height: 8,
        },
        progressbar: {
            transition: 'none !important',
        },
        alleyContainer: {
            height: '100%',
            display: 'flex',
            justifyContent: 'center',
            gap: 30,
            paddingTop: 30,
        },
        strikeContainer: {
            display: 'flex',
            height: 20,
            justifyContent: 'space-between',
            gap: 6,
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
    }));

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const [alleys, setAlleys] = useState(
        game.shuffled
            ? shuffle([...Array(game.difficulty).keys()])
            : [...Array(game.difficulty).keys()],
    );
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [process, setProcess] = useState(0);
    const [fails, setFails] = useState(0);

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const pct = (time / game.limit) * 100;

    useEffect(() => {
        if (finished || failed) {
            setTo(
                setTimeout(() => {
                    setFin(false);
                }, 2000),
            );
        }
    }, [finished, failed]);

    useEffect(() => {
        if (to) {
            clearTimeout(to);
        }

        setCount(Boolean(game?.countdown) ? game.countdown : 5);

        setAlleys(
            game.shuffled
                ? shuffle([...Array(game.difficulty).keys()])
                : [...Array(game.difficulty).keys()],
        );

        setTime(0);
    }, [started]);

    useEffect(() => {
        if (fails > game.chances) {
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        }
    }, [fails]);

    const onProcess = () => {
        setProcess(process + 1);
    };

    const onCountdown = () => {
        setCount(count - 1);
    };

    const onTick = () => {
        if (finished || failed) return;

        if (game.limit && time > game.limit) {
            Nui.send('Minigame:Finish', {
                state: 1,
            });
            soundEffect('positive');
            dispatch({
                type: 'FINISH_GAME',
            });
        } else {
            setTime(time + 10);
        }
    };

    useInterval(onProcess, process < MAX_PROCESS_STAGES ? 4000 : null);
    useInterval(
        onCountdown,
        process >= MAX_PROCESS_STAGES && count >= 0 ? 1000 : null,
    );
    useInterval(onTick, process >= MAX_PROCESS_STAGES && count < 0 ? 10 : null);

    const onFail = () => {
        setFails(fails + 1);
    };

    const hide = () => {
        setProcess(0);
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    const generateStrikes = () => {
        let arr = Array();

        for (let i = 0; i < game.chances; i++) {
            arr.push(
                <div
                    key={`strike-${i}`}
                    className={`${classes.strike}${fails > i ? ' filled' : ''}`}
                ></div>,
            );
        }

        return arr;
    };

    return (
        <Fade in={fin} onExited={hide}>
            <div className={classes.wrapper}>
                {process == 0 ? (
                    <div className={classes.countdown}>
                        <small>Attempting Security Bypass</small>
                        <span>
                            <FontAwesomeIcon icon={['fas', 'spinner']} spin />
                        </span>
                    </div>
                ) : process == 1 ? (
                    <div className={classes.countdown}>
                        <small>Error Bypassing, Reconfiguring</small>
                        <span>
                            <FontAwesomeIcon
                                style={{ color: 'red' }}
                                icon={['fas', 'circle-exclamation']}
                            />
                        </span>
                    </div>
                ) : process == 2 ? (
                    <div className={classes.countdown}>
                        <small>Manual Verification Required</small>
                        <span>
                            <FontAwesomeIcon icon={['fas', 'chart-simple']} />
                        </span>
                    </div>
                ) : count >= 0 ? (
                    <div className={classes.countdown}>
                        <small>Preparing System</small>
                        <span>{count == 0 ? 'Done' : count}</span>
                    </div>
                ) : null}
                {(finished || failed) && (
                    <div
                        className={`${classes.results} ${
                            finished ? 'success' : 'failed'
                        }`}
                    >
                        {finished ? (
                            <div className={classes.countdown}>
                                <small>Verification Completed</small>
                                <span>
                                    <FontAwesomeIcon
                                        color="green"
                                        icon={['fas', 'circle-check']}
                                    />
                                </span>
                            </div>
                        ) : failed ? (
                            <div className={classes.countdown}>
                                <small>Verification Failed</small>
                                <span>
                                    <FontAwesomeIcon
                                        color="red"
                                        icon={['fas', 'circle-xmark']}
                                    />
                                </span>
                            </div>
                        ) : null}
                    </div>
                )}

                {count < 0 &&
                    !finished &&
                    !failed &&
                    process >= MAX_PROCESS_STAGES && (
                        <Grid
                            container
                            style={{
                                height: '100%',
                                width:
                                    260 * game.difficulty +
                                    15 * (game.difficulty - 1),
                            }}
                        >
                            <Grid item xs={12} style={{ marginBottom: 20 }}>
                                <div className={classes.strikeContainer}>
                                    {generateStrikes()}
                                </div>
                            </Grid>
                            <Grid
                                item
                                xs={12}
                                className={classes.timer}
                                style={{ textAlign: 'center' }}
                            >
                                {count < 0 ? (
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
                                ) : null}
                            </Grid>
                            <Grid
                                item
                                xs={12}
                                style={{ height: 'calc(100% - 56px)' }}
                            >
                                <div className={classes.alleyContainer}>
                                    {alleys.map((i) => {
                                        return (
                                            <Alley
                                                key={`alley-${i}`}
                                                alleyId={i}
                                                game={game}
                                                onFail={onFail}
                                            />
                                        );
                                    })}
                                </div>
                            </Grid>
                        </Grid>
                    )}
            </div>
        </Fade>
    );
};
