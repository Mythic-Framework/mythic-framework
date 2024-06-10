import React, { useEffect, useState, useRef } from 'react';
import { useSelector } from 'react-redux';
import { Fade, useTheme } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useDispatch } from 'react-redux';
import useKeypress from 'react-use-keypress';
import { useInterval } from 'usehooks-ts';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        width: 'fit-content',
        height: 'fit-content',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
    },
    canvas: {},
}));

let g_start, g_end;

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min); //The maximum is inclusive and the minimum is inclusive
}

export default ({ game }) => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const theme = useTheme();
    const started = useSelector((state) => state.game.started);
    const finished = useSelector((state) => state.game.finished);
    const failed = useSelector((state) => state.game.failed);

    const canvasRef = useRef();

    const [degrees, setDegrees] = useState(0);
    const [correct, setCorrect] = useState(false);
    const [pressed, setPressed] = useState(false);

    const [fin, setFin] = useState(true);
    const [to, setTo] = useState(null);

    const aids = () => {
        let ctx = canvasRef.current.getContext('2d');
        let W = canvasRef.current.width;
        let H = canvasRef.current.height;

        ctx.clearRect(0, 0, W, H);

        // Background 360 degree arc
        ctx.beginPath();
        ctx.strokeStyle = theme.palette.secondary.dark;
        ctx.lineWidth = 18;
        ctx.shadowBlur = 6;
        ctx.arc(W / 2, H / 2, 100, 0, Math.PI * 2, false);
        ctx.stroke();

        // Green zone
        ctx.beginPath();
        ctx.strokeStyle = correct
            ? theme.palette.success.main
            : pressed
            ? theme.palette.error.main
            : theme.palette.info.main;
        ctx.lineWidth = 18;
        ctx.shadowBlur = 0;
        ctx.arc(
            W / 2,
            H / 2,
            100,
            g_start - (90 * Math.PI) / 180,
            g_end - (90 * Math.PI) / 180,
            false,
        );
        ctx.stroke();

        // Angle in radians = angle in degrees * PI / 180
        let radians = (degrees * Math.PI) / 180;
        ctx.beginPath();
        ctx.strokeStyle = theme.palette.text.main;
        ctx.lineWidth = 36;
        ctx.shadowBlur = 0;
        ctx.arc(
            W / 2,
            H / 2,
            100,
            radians - 0.07 - (90 * Math.PI) / 180,
            radians - (90 * Math.PI) / 180,
            false,
        );
        ctx.stroke();

        // Adding the key_to_press
        ctx.fillStyle = theme.palette.text.main;
        ctx.font = '75px Oswald';
        let text_width = ctx.measureText(game.key[0]).width;
        ctx.fillText(game.key[0], W / 2 - text_width / 2, H / 2 + 30);
        ctx.shadowColor = 'black';
        ctx.shadowBlur = 15;
    };

    useKeypress(game.key, () => {
        if (pressed) return;

        setPressed(true);

        let d_start = (180 / Math.PI) * g_start;
        let d_end = (180 / Math.PI) * g_end + 5;
        setCorrect(degrees >= d_start && degrees <= d_end);
        if (degrees < d_start || degrees > d_end) {
            Nui.send('Minigame:Finish', { state: 0 });
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            Nui.send('Minigame:Finish', { state: 1 });
            dispatch({
                type: 'FINISH_GAME',
            });
        }
    });

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
        setFin(true);
        if (to) {
            clearTimeout(to);
            setPressed(false);
        }

        g_start = getRandomInt(20, 40) / 10;
        g_end = game.difficulty / 10;
        g_end = g_start + g_end;

        setCorrect(false);
        setDegrees(0);
    }, [started]);

    useEffect(() => {
        aids();
    }, [degrees, correct, pressed]);

    const tick = () => {
        if (failed || finished) return;

        if (degrees + game.rate > 360) {
            setPressed(true);
            setCorrect(false);
            Nui.send('Minigame:Finish', { state: 0 });
            dispatch({
                type: 'FAIL_GAME',
            });
        } else {
            setDegrees(degrees + game.rate);
        }
    };

    const hide = () => {
        dispatch({
            type: 'HIDE_GAME',
        });
        setPressed(false);
        setCorrect(false);
        setDegrees(0);
    };

    useInterval(tick, !pressed ? 10 : null);

    return (
        <Fade in={fin} duration={250} onExited={hide}>
            <div className={classes.wrapper}>
                <canvas
                    className={classes.canvas}
                    ref={canvasRef}
                    id="canvas"
                    width="250"
                    height="250"
                ></canvas>
            </div>
        </Fade>
    );
};
