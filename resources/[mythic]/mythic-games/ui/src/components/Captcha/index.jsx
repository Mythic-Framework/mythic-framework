import React, { useEffect, useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Alert, Fade, Grid, TextField, LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import useInterval from 'react-useinterval';
import { useDispatch } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import useSound from '../../hooks/useSound';
import Nui from '../../util/Nui';

const randomInt = (max) => Math.floor(Math.random() * Math.floor(max));
const sample = (arr) => arr[randomInt(arr.length)];

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

const SHAPES = ['square', 'triangle', 'rectangle', 'circle'];
const COLORABLE = ['background', 'colortext', 'shapetext', 'number', 'shape'];
const COLOR_CODES = [
    '#000000',
    '#FFFFFF',
    '#2195ee',
    '#7b0100',
    '#fceb3d',
    '#fd9802',
    '#4cae4f',
    '#9926ac0',
];

export const COLORS = {
    black: '#000000',
    white: '#FFFFFF',
    blue: '#2195ee',
    red: '#7b0100',
    yellow: '#fceb3d',
    orange: '#fd9802',
    green: '#4cae4f',
    purple: '#9926ac',
};

// functions that return answers from PuzzleData class
const QUESTIONS = {
    'background color': (d) => d.colors['background'],
    'color text color': (d) => d.colors['colortext'],
    'shape text color': (d) => d.colors['shapetext'],
    'number color': (d) => d.colors['number'],
    'shape color': (d) => d.colors['shape'],
    'color text': (d) => d.text[0],
    'shape text': (d) => d.text[1],
    shape: (d) => d.shape,
};

const SHAPE_SVG = {
    square: (c) => (
        <rect fill={c} stroke="#000" strokeWidth="1" width="150" height="150" />
    ),
    triangle: (c) => (
        <polygon
            fill={c}
            stroke="#000"
            strokeWidth="1"
            points="0 150 75 0 150 150 0 150"
        />
    ),
    rectangle: (c) => (
        <rect
            y="30"
            fill={c}
            stroke="#000"
            strokeWidth="1"
            className="shape"
            width="150"
            height="90"
        />
    ),
    circle: (c) => (
        <circle fill={c} stroke="#000" strokeWidth="1" cx="75" cy="75" r="75" />
    ),
};

const createText = (text, outline, color, size, weight, y, font) => {
    return (
        <text
            stroke={outline}
            fill={color}
            strokeWidth="0.35"
            style={{ fontSize: size }}
            fontWeight={weight}
            fontFamily={`${font || 'Archivo Black'}, sans-serif`}
            x="50%"
            y={`${y}%`}
            dominantBaseline="middle"
            textAnchor="middle"
        >
            {text}
        </text>
    );
};

class PuzzlePiece {
    constructor(index, shape, number, text, colors) {
        this.index = index;
        this.shape = shape;
        this.number = number;
        this.text = text;
        this.colors = colors;
    }
}

const randomizePiece = (i) => {
    const shape = sample(SHAPES);
    const number = randomInt(9) + 1;

    let topText = sample(Object.keys(COLORS));
    let bottomText = sample(SHAPES);

    const colors = COLORABLE.reduce((obj, color) => {
        obj[color] = sample(Object.keys(COLORS));
        return obj;
    }, {});

    // ensure color and shape text don't blend with background
    while (
        ['colortext', 'shapetext']
            .map((i) => colors[i])
            .includes(colors['background'])
    )
        colors['background'] = sample(Object.keys(COLORS));

    // ensure nothing blends with shape
    while (
        ['background', 'colortext', 'shapetext', 'number']
            .map((i) => colors[i])
            .includes(colors['shape'])
    ) {
        colors['shape'] = sample(Object.keys(COLORS));
    }

    // convert to hex color values
    Object.keys(colors).forEach((k) => (colors[k] = COLORS[colors[k]]));

    return new PuzzlePiece(i, shape, number, [topText, bottomText], colors);
};

export function generateQuestionAndAnswer(numAnswers, nums, puzzles) {
    let questions = Array();
    let answers = Array();

    for (let i = 0; i < numAnswers; i++) {
        let pos = null;
        do {
            pos = randomInt(nums.length);
        } while (
            !Boolean(pos) ||
            questions.filter((q) => q.position == pos).length > 0
        );

        let que = null;
        do {
            que = sample(Object.keys(QUESTIONS));
        } while (
            !Boolean(que) ||
            questions.filter((q) => q.question == que).length > 0
        );

        let t = QUESTIONS[que](puzzles.filter((p) => p.index == pos)[0]);
        answers.push(Object.keys(COLORS).find((k) => COLORS[k] === t) || t);

        questions.push({
            question: que,
            position: pos,
        });
    }

    const question = (
        <span>
            ENTER
            {questions.map((q, i) => {
                return (
                    <span key={`question-${i}`}>
                        <b>
                            {q.question} ( {q.position} )
                        </b>
                        {i < questions.length - 1 && 'AND'}
                    </span>
                );
            })}
        </span>
    );

    const answer = answers.join(' ');

    return [question, answer];
}

const MAX_PROCESS_STAGES = 3;

export default ({ game }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        wrapper: {
            width: 'fit-content',
            minWidth: 400 * game.difficulty + 15 * (game.difficulty - 1),
            height: 'fit-content',
            minHeight: 510,
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
        progressbar2: {
            transition: 'background ease-in 1s',
        },
        puzzleContainer: {
            margin: 'auto',
            display: 'flex',
            gap: 15,
            justifyContent: 'space-evenly',
            textAlign: 'center',
            lineHeight: 1.3,
            width: 'fit-content',
        },
        puzzlePiece: {
            height: 400,
            width: 400,
            padding: 30,
            background: theme.palette.secondary.light,
            border: `1px solid ${theme.palette.border.divider}`,
            color: theme.palette.text.main,
            position: 'relative',

            '& span': {
                fontSize: 75,
                display: 'block',
                height: 'fit-content',
                width: 'fit-content',
                position: 'absolute',
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                margin: 'auto',
            },
        },
        timer: {
            paddingTop: 30,
            paddingBottom: 30,
        },
        qa: {
            width: 'fit-content',
            margin: 'auto',
        },
        question: {
            padding: 15,
            textTransform: 'uppercase',

            '& span': {
                fontWeight: 200,
                fontSize: 18,
            },
            '& b': {
                fontWeight: 'bold',
                fontSize: 24,
                marginLeft: 6,
                marginRight: 6,
            },
        },
        input: {},
    }));

    const classes = useStyles();
    const dispatch = useDispatch();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

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

        soundEffect('stop');
        setPreview(Boolean(game?.timer) ? game.timer : 5000);
        setShrink(2000);

        let nums = shuffle([...Array(game.difficulty)].map((v, i) => i + 1));

        let f = [
            ...nums.map((i) => {
                return randomizePiece(i);
            }),
        ];

        let ans = generateQuestionAndAnswer(game.difficulty2, nums, f);

        setPuzzle(f);
        setAnswer(ans);
        setTime(0);
        setSubmitted(false);
    }, [started]);

    const inputRef = useRef();

    const [submitted, setSubmitted] = useState(false);
    const [puzzle, setPuzzle] = useState(Array());
    const [answer, setAnswer] = useState(Array());
    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);
    const [time, setTime] = useState(0);
    const [process, setProcess] = useState(0);

    const [count, setCount] = useState(
        Boolean(game?.countdown) ? game.countdown : 5,
    );
    const [preview, setPreview] = useState(
        Boolean(game?.timer) ? game.timer : 5000,
    );
    const [shrink, setShrink] = useState(2000);

    const pct = (time / game.limit) * 100;
    const pct2 = ((preview + shrink) / (2000 + game.timer)) * 100;

    useEffect(() => {
        if (preview < 0 && shrink < 0) {
            soundEffect('tick');
            inputRef.current.focus();
        }
    }, [preview, shrink]);

    const onProcess = () => {
        setProcess(process + 1);
    };

    const onCountdown = () => {
        setCount(count - 1);
    };

    const onPreview = () => {
        setPreview(preview - 10);
    };

    const onShrink = () => {
        setShrink(shrink - 10);
    };

    const onTick = () => {
        if (finished || failed || submitted) return;

        if (game.limit && time > game.limit) {
            soundEffect('stop');
            Nui.send('Minigame:Finish', { state: 0 });
            soundEffect('negative');
            dispatch({
                type: 'FAIL_GAME',
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
    useInterval(
        onPreview,
        process >= MAX_PROCESS_STAGES && count < 0 && preview >= 0 ? 10 : null,
    );
    useInterval(
        onShrink,
        process >= MAX_PROCESS_STAGES && count < 0 && preview < 0 && shrink >= 0
            ? 10
            : null,
    );
    useInterval(
        onTick,
        process >= MAX_PROCESS_STAGES && count < 0 && preview < 0 && shrink < 0
            ? 10
            : null,
    );

    const hide = () => {
        setProcess(0);
        setCount(Boolean(game?.countdown) ? game.countdown : 5);
        dispatch({
            type: 'HIDE_GAME',
        });
    };

    const onSubmit = (e) => {
        e.preventDefault();

        if (finished || failed || submitted) return;

        setSubmitted(true);
        soundEffect('stop');
        if (e.target.answer.value.toLowerCase() == answer[1].toLowerCase()) {
            Nui.send('Minigame:Finish', {
                state: 1,
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

    const generateSquares = () => {
        return puzzle.map((square) => {
            return (
                <div
                    key={`pzl-${square.index}`}
                    className={classes.puzzlePiece}
                    style={
                        preview < 0 && shrink < 0
                            ? {
                                  backgroundColor: square.colors.background,
                              }
                            : null
                    }
                >
                    {preview < 0 && shrink < 0 ? (
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 150 150"
                        >
                            {SHAPE_SVG[square.shape](square.colors.shape)}
                            {createText(
                                square.text[0].toUpperCase(),
                                'black',
                                square.colors.colortext,
                                24,
                                'bold',
                                25,
                            )}
                            {createText(
                                square.text[1].toUpperCase(),
                                'black',
                                square.colors.shapetext,
                                24,
                                'bold',
                                70,
                            )}
                            {createText(
                                square.number,
                                'black',
                                square.colors.number,
                                55,
                                'bold',
                                50,
                                100,
                                50,
                                'Arial, Helvetica',
                            )}
                        </svg>
                    ) : (
                        <span
                            style={
                                preview < 0 && shrink < 0
                                    ? { color: square.colors.number }
                                    : preview < 0 && shrink >= 0
                                    ? {
                                          transition: 'transform ease-in 2s',
                                          transform: `scale(0)`,
                                      }
                                    : null
                            }
                        >
                            {preview < 0 && shrink < 0
                                ? square.number
                                : square.index}
                        </span>
                    )}
                </div>
            );
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
                            <FontAwesomeIcon icon={['fas', 'pen-field']} />
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
                                width:
                                    400 * game.difficulty +
                                    15 * (game.difficulty - 1),
                            }}
                        >
                            <Grid item xs={12}>
                                <div className={classes.puzzleContainer}>
                                    {generateSquares()}
                                </div>
                            </Grid>
                            <Grid
                                item
                                xs={12}
                                className={classes.timer}
                                style={{ textAlign: 'center' }}
                            >
                                {count < 0 && (preview >= 0 || shrink >= 0) ? (
                                    <LinearProgress
                                        className={classes.progress}
                                        style={{
                                            transition: 'none !important',
                                        }}
                                        classes={{
                                            determinate: classes.progressbar,
                                            bar: classes.progressbar,
                                            bar1: classes.progressbar,
                                        }}
                                        variant="determinate"
                                        color="success"
                                        value={pct2}
                                    />
                                ) : count < 0 && preview < 0 && shrink < 0 ? (
                                    <LinearProgress
                                        className={classes.progress}
                                        classes={{
                                            determinate: classes.progressbar2,
                                            bar: classes.progressbar2,
                                            bar1: classes.progressbar2,
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
                            {preview < 0 && shrink < 0 && (
                                <Grid
                                    item
                                    xs={12}
                                    style={{ textAlign: 'center' }}
                                >
                                    <div className={classes.qa}>
                                        <div className={classes.question}>
                                            {answer[0]}
                                        </div>
                                        <div className={classes.input}>
                                            <form onSubmit={onSubmit}>
                                                <TextField
                                                    autoFocus
                                                    ref={inputRef}
                                                    disabled={
                                                        finished ||
                                                        failed ||
                                                        submitted
                                                    }
                                                    style={{
                                                        width: 200,
                                                    }}
                                                    label="Answer"
                                                    name="answer"
                                                />
                                            </form>
                                        </div>
                                    </div>
                                </Grid>
                            )}
                        </Grid>
                    )}
            </div>
        </Fade>
    );
};
