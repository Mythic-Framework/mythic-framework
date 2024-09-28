import React, { useEffect, useRef, useState } from 'react';
import { useSelector } from 'react-redux';
import {
    Alert,
    Button,
    Fade,
    Grid,
    LinearProgress,
    TextField,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useInterval from 'react-useinterval';
import _ from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import useSound from '../../hooks/useSound';

const MAX_PROCESS_STAGES = 3;

const _icons = [
    'server',
    'computer',
    'atom',
    'terminal',
    'arrow-up-9-1',
    'code',
    'code-branch',
    'code-commit',
    'diagram-project',
    'circle-nodes',
    'code-merge',
    'microchip',
    'wrench',
    'arrows-split-up-and-left',
    'sitemap',
    'shield',
    'network-wired',
    'file-code',
    'code-pull-request',
    'notdef',
    'cubes',
    'brain',
    'bug',
    'barcode',
    'keyboard',
    'laptop-code',
    'bluetooth',
    'satellite-dish',
    'tower-cell',
    'poop',
];

const _colors = [
    { color: 'red', answer: ['red'] },
    { color: 'green', answer: ['green'] },
    { color: 'dodgerblue', answer: ['blue'] },
    { color: 'purple', answer: ['purple'] },
    { color: 'orange', answer: ['orange'] },
    { color: 'yellow', answer: ['yellow'] },
    { color: 'white', answer: ['white'] },
    { color: 'cyan', answer: ['cyan'] },
    { color: 'grey', answer: ['grey'] },
    { color: 'hotpink', answer: ['pink'] },
    { color: '#00ff8a', answer: ['mint'] },
];

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            width: 550,
            height: 'fit-content',
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            margin: 'auto',
            padding: 30,
            background: theme.palette.secondary.dark,
            transition: 'all ease-in 0.15s',
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
        icon: {
            fontSize: 36,
            textAlign: 'center',
        },
        selected: {
            fontSize: 124,
            color: theme.palette.text.main,
        },
    }));

    const tickRate = 10;

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const inputRef = useRef();

    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [process, setProcess] = useState(0);
    const [shuffle, setShuffle] = useState(0);
    const [delay, setDelay] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [correct, setCorrect] = useState(0);

    const [icons, setIcons] = useState(Array());
    const [selected, setSelected] = useState(null);
    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );

    const onProcess = () => {
        setProcess(process + 1);
    };

    const onCountdown = () => {
        setCount(count - 1);
    };

    const onShuffle = () => {
        setShuffle(shuffle + 1);
    };

    const pct = (time / game.limit) * 100;

    const onTick = () => {
        if (finished || failed || submitting) return;

        if (game.limit && time > game.limit) {
            soundEffect('stop');
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setTime(time + tickRate);
        }
    };

    useInterval(onProcess, process < MAX_PROCESS_STAGES ? 4000 : null);
    useInterval(
        onCountdown,
        process >= MAX_PROCESS_STAGES && count >= 0 ? 1000 : null,
    );
    useInterval(
        onShuffle,
        shuffle < game.timer && process >= MAX_PROCESS_STAGES && count < 0
            ? 1000
            : null,
    );
    useInterval(
        onTick,
        !submitting &&
            delay &&
            shuffle >= game.timer &&
            process >= MAX_PROCESS_STAGES &&
            count < 0
            ? tickRate
            : null,
    );

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        setTo(null);
        setFin(true);
        setDelay(false);
        setSubmitting(false);
        setTime(0);
        setIcons(Array());
        setSelected(null);
        setCorrect(0);
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

    useEffect(() => {
        let tmp = Array();
        for (let i = 0; i < game.difficulty; i++) {
            let icon = _icons.filter(
                (i) => tmp.filter((i2) => i2.icon == i).length == 0,
            )[
                Math.floor(
                    Math.random() *
                        _icons.filter(
                            (i) => tmp.filter((i2) => i2.icon == i).length == 0,
                        ).length,
                )
            ];
            tmp.push({
                icon,
                color: _colors[Math.floor(Math.random() * _colors.length)],
                solved: false,
            });
        }

        setSelected(tmp[Math.floor(Math.random() * tmp.length)]);
        setIcons(tmp);
        soundEffect();
    }, [shuffle]);

    useEffect(() => {
        if (shuffle >= game.timer && !delay) {
            setTimeout(() => {
                setDelay(true);
            }, game.delay);
        }
    }, [shuffle]);

    useEffect(() => {
        if (delay) {
            soundEffect('tick');
            inputRef.current.focus();
        }
    }, [delay]);

    useEffect(() => {
        if (correct >= game.difficulty2) {
            soundEffect('stop');
            Nui.send('Minigame:Finish', {
                state: 1,
            });
            soundEffect('positive');
            dispatch({
                type: 'FINISH_GAME',
            });
        }
    }, [correct]);

    const onSubmit = (e) => {
        e.preventDefault();
        setSubmitting(true);

        if (
            selected.color.answer
                .map((f) => f.toLowerCase())
                .includes(e.target.color.value.toLowerCase())
        ) {
            setCorrect(correct + 1);

            let tmp = [
                ...icons.map((i) => {
                    if (i.icon == selected.icon) return { ...i, solved: true };
                    else return i;
                }),
            ];

            setSelected(
                tmp.filter((i) => !i.solved)[
                    Math.floor(
                        Math.random() * tmp.filter((i) => !i.solved).length,
                    )
                ],
            );
            setIcons(tmp);
            soundEffect('positive');
            setSubmitting(false);
            e.target.reset();
        } else {
            soundEffect('stop');
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
            });
        }
    };

    const generateGrid = () => {
        return icons.map((icon, i) => (
            <Grid
                key={`icon-${i}`}
                className={classes.icon}
                item
                xs={3}
                style={{ color: icon.color.color }}
            >
                <FontAwesomeIcon 
                    icon={[icon.icon === 'bluetooth' ? 'fab' : 'fas', icon.icon]} 
                />
            </Grid>
        ));
    };

    const hide = () => {
        soundEffect('stop');
        setProcess(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    return (
        <Fade in={fin} onExited={hide}>
            <div>
                <div
                    className={classes.wrapper}
                    style={
                        count >= 0 || finished || failed
                            ? { minHeight: 400 }
                            : {
                                  minHeight: 'fit-content',
                              }
                    }
                >
                    {process == 0 ? (
                        <div className={classes.countdown}>
                            <small>Attempting Security Bypass</small>
                            <span>
                                <FontAwesomeIcon
                                    icon={['fas', 'spinner']}
                                    spin
                                />
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
                                <FontAwesomeIcon icon={['fas', 'icons']} />
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
                            <Grid container className={classes.buttons}>
                                {shuffle < game.timer || !delay ? (
                                    <Grid item xs={12}>
                                        <Grid container spacing={2}>
                                            <Grid
                                                item
                                                xs={12}
                                                style={{ textAlign: 'center' }}
                                            >
                                                {shuffle < game.timer ? (
                                                    <span>
                                                        Locating Input
                                                        Sequence...
                                                    </span>
                                                ) : (
                                                    <span>
                                                        Sequence Located,
                                                        Starting Decryption
                                                    </span>
                                                )}
                                            </Grid>
                                            {generateGrid()}
                                        </Grid>
                                    </Grid>
                                ) : (
                                    <Grid item xs={12}>
                                        <form onSubmit={onSubmit}>
                                            <Grid container spacing={2}>
                                                <Grid
                                                    item
                                                    xs={12}
                                                    className={classes.selected}
                                                    style={{
                                                        textAlign: 'center',
                                                    }}
                                                >
                                                    {Boolean(selected) && (
                                                        <FontAwesomeIcon
                                                            icon={[
                                                                'fas',
                                                                selected.icon,
                                                            ]}
                                                        />
                                                    )}
                                                </Grid>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        ref={inputRef}
                                                        name="color"
                                                        label="Color of Icon"
                                                    />
                                                </Grid>
                                            </Grid>
                                            <Grid
                                                item
                                                xs={12}
                                                style={{ marginTop: 20 }}
                                            >
                                                {!failed && !finished ? (
                                                    <LinearProgress
                                                        className={
                                                            classes.progress
                                                        }
                                                        classes={{
                                                            determinate:
                                                                classes.progressbar,
                                                            bar: classes.progressbar,
                                                            bar1: classes.progressbar,
                                                        }}
                                                        variant="determinate"
                                                        color={
                                                            pct < 33
                                                                ? 'success'
                                                                : pct < 66
                                                                ? 'warning'
                                                                : failed ||
                                                                  finished
                                                                ? 'secondary'
                                                                : 'error'
                                                        }
                                                        value={100 - pct}
                                                    />
                                                ) : (
                                                    <div
                                                        className={
                                                            count < 0
                                                                ? classes.ph
                                                                : classes.phi
                                                        }
                                                    ></div>
                                                )}
                                            </Grid>
                                        </form>
                                    </Grid>
                                )}
                            </Grid>
                        )}
                </div>
            </div>
        </Fade>
    );
};
