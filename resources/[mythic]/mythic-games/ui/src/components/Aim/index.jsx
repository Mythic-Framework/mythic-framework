import React, { useEffect, useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Fade, Grid, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useInterval from 'react-useinterval';
import _ from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import useSound from '../../hooks/useSound';
import Target from './components/Target';

const MAX_PROCESS_STAGES = 3;

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            minHeight: 600,
            maxHeight: 800,
            minWidth: 1500,
            maxWidth: 1700,
            width: '100%',
            height: '100%',
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
        aimContainer: {
            height: 'calc(100% - 40px)',
            minHeight: 600,
            maxHeight: 800,
            minWidth: 1500,
            maxWidth: 1700,
            position: 'relative',
        },
        clickHandler: {
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',
            zIndex: 5,
        },
        innerAimContainer: {
            height: 'calc(100% - 150px)',
            width: 'calc(100% - 150px)',
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',
        },
        scoreboard: {
            padding: 10,
            textAlign: 'center',
            fontSize: 22,
        },
    }));

    const tickRate = 10;

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const aimContainer = useRef();

    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);

    const [hit, setHit] = useState(0);
    const [missed, setMissed] = useState(0);
    const [targets, setTargets] = useState(Array());

    const [process, setProcess] = useState(0);
    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setTo(null);
        setFin(true);
        setMissed(0);
        setHit(0);
        setTargets(Array());
        setTime(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
    }, [started]);

    const onProcess = () => {
        setProcess(process + 1);
    };

    const onCountdown = () => {
        setCount(count - 1);
    };

    const pct =
        (time / game.limit) * 100 > 100 ? 100 : (time / game.limit) * 100;

    const accuracy =
        hit + missed > 0 ? Math.floor((hit / (hit + missed)) * 100) : 0;

    const onTick = () => {
        if (finished || failed) return;

        if (time > game.limit) {
            if (accuracy >= game.accuracy) {
                Nui.send('Minigame:Finish', { state: accuracy == 100 ? 2 : 1 });
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
        } else {
            setTime(time + tickRate);
        }
    };

    const onGenerate = () => {
        let width = Math.random() * aimContainer.current.clientWidth;
        let height = Math.random() * aimContainer.current.clientHeight;
        setTargets([...targets, { id: targets.length, width, height }]);
    };

    useInterval(onProcess, process < MAX_PROCESS_STAGES ? 4000 : null);
    useInterval(
        onCountdown,
        Boolean(aimContainer.current) &&
            process >= MAX_PROCESS_STAGES &&
            count >= 0
            ? 1000
            : null,
    );

    useInterval(
        onGenerate,
        !failed &&
            !finished &&
            Boolean(aimContainer.current) &&
            process >= MAX_PROCESS_STAGES &&
            count < 0
            ? targets.length == 0
                ? game.timer / 4
                : game.timer
            : null,
    );
    useInterval(
        onTick,
        Boolean(aimContainer.current) &&
            process >= MAX_PROCESS_STAGES &&
            count < 0
            ? tickRate
            : null,
    );

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

    const onClickTarget = (id) => {
        setHit(hit + 1);
        soundEffect();
        setTargets([
            ...targets.map((t) => {
                if (t.id == id) return { ...t, clicked: true };
                else return t;
            }),
        ]);
    };

    const onFailTarget = (id) => {
        setMissed(missed + 1);
        soundEffect('negative');
        setTargets([
            ...targets.map((t) => {
                if (t.id == id && !t.clicked) return { ...t, failed: true };
                else return t;
            }),
        ]);
    };

    const onMiss = () => {
        if (
            !failed &&
            !finished &&
            Boolean(aimContainer.current) &&
            count < 0
        ) {
            setMissed(missed + 1);
        }
    };

    const hide = () => {
        setProcess(0);
        dispatch({
            type: 'HIDE_GAME',
        });
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
                            <FontAwesomeIcon
                                icon={['fas', 'location-crosshairs']}
                            />
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

                {count < 0 && (
                    <Grid container className={classes.scoreboard}>
                        <Grid item xs={6}>
                            Hits: {hit}, Misses: {missed}
                        </Grid>
                        <Grid item xs={6}>
                            <span>Accuracy: {accuracy}%</span>, Required:{' '}
                            {game.accuracy}%
                        </Grid>
                    </Grid>
                )}

                {count < 0 && (
                    <div style={{ marginBottom: 20 }}>
                        {!failed && !finished ? (
                            <LinearProgress
                                className={classes.progress}
                                variant="determinate"
                                classes={{
                                    determinate: classes.progressbar,
                                    bar: classes.progressbar,
                                    bar1: classes.progressbar,
                                }}
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
                    </div>
                )}
                <div className={classes.aimContainer}>
                    <div
                        className={classes.clickHandler}
                        onClick={onMiss}
                    ></div>
                    {!failed && !finished && (
                        <div
                            className={classes.innerAimContainer}
                            ref={aimContainer}
                        >
                            {targets
                                .filter(
                                    (c) =>
                                        !Boolean(c.clicked) &&
                                        !Boolean(c.failed),
                                )
                                .map((target) => {
                                    return (
                                        <Target
                                            key={`trg-${target.id}`}
                                            parentRef={aimContainer}
                                            target={target}
                                            game={game}
                                            onClick={onClickTarget}
                                            onFail={onFailTarget}
                                        />
                                    );
                                })}
                        </div>
                    )}
                </div>
            </div>
        </Fade>
    );
};
