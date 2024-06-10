import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';
import useInterval from 'react-useinterval';
import { useDispatch } from 'react-redux';
import useKeypress from 'react-use-keypress';

import useSound from '../../hooks/useSound';
import Nui from '../../util/Nui';

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            width: '75%',
            height: '65%',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            background: theme.palette.secondary.dark,
        },
        bars: {
            padding: 10,
            height: '100%',
            background: theme.palette.secondary.main,
            display: 'flex',
            gap: 5,
        },
        bar: {
            height: '100%',
            width: `${100 / game.total}%`,
            background: theme.palette.error.dark,
            position: 'relative',
            '&.valid': {
                background: theme.palette.info.dark,
            },
            '&.gold': {
                background: 'gold',
            },
            '&.active': {
                background: theme.palette.success.main,
            },
            '&.ended': {
                transition: 'background ease-in 0.15s',
                background: theme.palette.secondary.light,
            },
        },
        hotkey: {
            fontSize: 50,
            color: theme.palette.secondary.dark,
            height: 'fit-content',
            width: 'fit-content',
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',
            textShadow: `0 0 5px ${theme.palette.secondary.light}`,
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
        countdown: {
            position: 'absolute',
            width: '100%',
            height: '100%',
            background: 'rgba(0, 0, 0, 0.25)',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            margin: 'auto',
            zIndex: 100,

            '& div': {
                width: 'fit-content',
                height: 'fit-content',
                position: 'absolute',
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                margin: 'auto',
            },

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

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const [pressed, setPressed] = useState(false);

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

    useEffect(() => {
        if (to) {
            clearTimeout(to);
            setPressed(false);
        }
        setFin(true);
        setStopped(false);
        setTime(0);
        let r = Math.ceil(Math.random() * (game.total - 1));
        setChange(r == game.total - 1 ? -1 : 1);
        setCurrent(r);
    }, [started]);

    useKeypress(game.key, () => {
        if (pressed) return;
        if (count >= 0) return;

        setPressed(true);
        setStopped(true);
        if (
            current >= game.chance - game.difficulty &&
            current <= game.chance + game.difficulty
        ) {
            Nui.send('Minigame:Finish', {
                state:
                    current == game.chance && Boolean(game.events.onPerfect)
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
    });

    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [change, setChange] = useState(1);
    const [current, setCurrent] = useState(0);
    const [stopped, setStopped] = useState(false);
    const [time, setTime] = useState(0);

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const countdown = () => {
        setCount(count - 1);
    };

    useEffect(() => {
        if (current >= game.total) {
            setChange(-1);
        } else if (current <= 1) {
            setChange(1);
        }
    }, [current]);

    const onTick = () => {
        if (stopped || finished || failed) return;

        if (game.limit && time > game.limit) {
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setCurrent(current + change);
            setTime(time + game.timer);
        }
    };

    useInterval(countdown, count < 0 ? null : 1000);
    useInterval(onTick, count < 0 ? game.timer : null);

    const generateBars = () => {
        let bars = Array();
        for (let i = 1; i <= game.total; i++) {
            if (
                i >= game.chance - game.difficulty &&
                i <= game.chance + game.difficulty &&
                count < 0
            ) {
                if (i == game.chance && Boolean(game.events.onPerfect)) {
                    bars.push(
                        <div
                            key={i}
                            className={`${classes.bar}${
                                current == i ? ' active' : ''
                            } gold${finished || failed ? ' ended' : ''}`}
                        >
                            {!finished && !failed && (
                                <div className={classes.hotkey}>
                                    {game.key[0].toUpperCase()}
                                </div>
                            )}
                        </div>,
                    );
                } else {
                    bars.push(
                        <div
                            key={i}
                            className={`${classes.bar}${
                                current == i ? ' active' : ''
                            } valid${finished || failed ? ' ended' : ''}`}
                        >
                            {!finished && !failed && i == game.chance && (
                                <div className={classes.hotkey}>
                                    {game.key[0].toUpperCase()}
                                </div>
                            )}
                        </div>,
                    );
                }
            } else {
                bars.push(
                    <div
                        key={i}
                        className={`${classes.bar}${
                            current == i && count < 0 ? ' active' : ''
                        }${finished || failed ? ' ended' : ''}`}
                    ></div>,
                );
            }
        }
        return bars;
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
                        <div>
                            <small>Preparing System</small>
                            <span>{count == 0 ? 'Done' : count}</span>
                        </div>
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
                <div className={classes.bars}>{generateBars()}</div>
                {Boolean(game.limit) && (
                    <div className={classes.timer}>{`${time / 1000}s / ${
                        game.limit / 1000
                    }s`}</div>
                )}
            </div>
        </Fade>
    );
};
