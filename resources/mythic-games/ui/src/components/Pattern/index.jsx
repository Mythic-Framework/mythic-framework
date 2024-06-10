import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Button, Fade, Grid, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useInterval from 'react-useinterval';
import _ from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';
import useSound from '../../hooks/useSound';

const random = (min, max) => {
    return Math.floor(Math.random() * (max - min)) + min;
};

const MAX_PROCESS_STAGES = 1;

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
            width: 620,
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
        progress: {
            height: 20,
            borderRadius: 4,
        },
        progress2: {
            height: 5,
            borderRadius: 4,
        },
        progressbar: {
            transition: 'none !important',
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
        charContainer: {
            fontSize: 28,
        },
        character: {
            display: 'inline-block',
            width: 56,
            height: 56,
            lineHeight: '56px',
            textAlign: 'center',

            '&.selected': {
                color: theme.palette.primary.main,
            },

            // '&.answer': {
            //     color: `${theme.palette.success.main} !important`,
            // },
        },
        answerContainer: {
            width: 'fit-content',
            margin: 'auto',
            fontSize: 36,
            padding: 30,
        },
        answer: {
            display: 'inline-block',
            width: 56,
            height: 56,
            lineHeight: '56px',
            textAlign: 'center',
        },
    }));

    const tickRate = 10;

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const [submitting, setSubmitting] = useState(false);
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [process, setProcess] = useState(0);
    const [time, setTime] = useState(0);
    const [selected, setSelected] = useState(9);
    const [charArray, setCharArray] = useState(Array());
    const [answerArray, setAnswerArray] = useState(Array());
    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const onProcess = () => {
        setProcess(process + 1);
    };

    const onCountdown = () => {
        setCount(count - 1);
    };

    const pct = (time / game.limit) * 100;

    const onTick = () => {
        if (finished || failed || submitting) return;

        if (game.limit && time > game.limit) {
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setTime(time + tickRate);
        }
    };

    const onShift = () => {
        if (!submitting)
            setCharArray([
                ...charArray.map((_, i, a) => a[(i + 1) % a.length]),
            ]);
    };

    useInterval(onProcess, process < MAX_PROCESS_STAGES ? 4000 : null);
    useInterval(
        onCountdown,
        process >= MAX_PROCESS_STAGES && count >= 0 ? 1000 : null,
    );
    useInterval(
        onTick,
        process >= MAX_PROCESS_STAGES && count < 0 ? tickRate : null,
    );
    useInterval(onShift, 1500);

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setTo(null);
        setFin(true);

        var arr = Array();

        var puzzleSize = game.size * 10;
        var answerStart = random(0, puzzleSize);

        for (let i = 0; i < puzzleSize; i++) {
            var isAnswer =
                (i >= answerStart && i < answerStart + game.difficulty) ||
                (answerStart + game.difficulty >= puzzleSize - 1 &&
                    i < answerStart + game.difficulty - puzzleSize);

            let character = '';
            for (let j = 0; j < game.difficulty2; j++) {
                character += game.chance.charAt(random(0, game.chance.length));
            }

            arr.push({
                character,
                isAnswer,
            });
        }
        setCharArray(arr);
        setAnswerArray([...arr.filter((c) => Boolean(c.isAnswer))]);
        setSelected(random(0, puzzleSize));

        setTime(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
    }, [started]);

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

    useKeypress(['w', 'W'], () => {
        onChange(-10);
    });

    useKeypress(['s', 'S'], () => {
        onChange(10);
    });

    useKeypress(['a', 'A'], () => {
        onChange(-1);
    });

    useKeypress(['d', 'D'], () => {
        onChange(1);
    });

    useKeypress([' ', 'Enter'], () => {
        if (!submitting && process >= MAX_PROCESS_STAGES && count < 0) {
            setSubmitting(true);

            for (let i = 0; i < game.difficulty; i++) {
                let k = selected + i;
                if (k >= charArray.length) {
                    k = selected + i - charArray.length;
                }

                if (!charArray[k]?.isAnswer) {
                    Nui.send('Minigame:Finish', { state: 0 });
                    soundEffect('negative');
                    dispatch({
                        type: 'FAIL_GAME',
                    });
                    return;
                }
            }

            Nui.send('Minigame:Finish', {
                state: 1,
            });
            soundEffect('positive');
            dispatch({
                type: 'FINISH_GAME',
            });
        }
    });

    const onChange = (v) => {
        if (selected + v >= charArray.length) {
            setSelected(selected + v - charArray.length);
        } else if (selected + v <= 0) {
            setSelected(charArray.length - 1);
        } else {
            setSelected(selected + v);
        }
    };

    const generateAnswer = () => {
        let grid = Array();
        answerArray.map((char, i) => {
            grid.push(
                <div key={`answer-${i}`} className={classes.answer}>
                    {count < 0 &&
                        !finished &&
                        !failed &&
                        process >= MAX_PROCESS_STAGES && (
                            <span>{char.character}</span>
                        )}
                </div>,
            );
        });
        return grid;
    };

    const generateGrid = () => {
        let grid = Array();
        charArray.map((char, i) => {
            var isSelected =
                (i >= selected && i < selected + game.difficulty) ||
                (selected + game.difficulty >= charArray.length - 1 &&
                    i < selected + game.difficulty - charArray.length);

            grid.push(
                <div
                    key={`char-${i}`}
                    className={`${classes.character}${
                        isSelected ? ' selected' : ''
                    }`}
                >
                    {count < 0 &&
                        !finished &&
                        !failed &&
                        process >= MAX_PROCESS_STAGES && (
                            <span>{char.character}</span>
                        )}
                </div>,
            );
        });
        return grid;
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
                        <small>Manual Input Required</small>
                        <span>
                            <FontAwesomeIcon icon={['fas', 'grid-4']} />
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
                        {count < 0 &&
                        !finished &&
                        !failed &&
                        process >= MAX_PROCESS_STAGES ? (
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
                        <div className={classes.answerContainer}>
                            {generateAnswer()}
                        </div>
                    </Grid>
                    <Grid item xs={12}>
                        <div className={classes.charContainer}>
                            {generateGrid()}
                        </div>
                    </Grid>
                </Grid>
            </div>
        </Fade>
    );
};
