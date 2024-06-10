import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import useKeypress from 'react-use-keypress';

import useSound from '../../../hooks/useSound';
import useInterval from 'react-useinterval';

export default ({ alleyId, game, onFail }) => {
    const soundEffect = useSound();

    const useStyles = makeStyles((theme) => ({
        alley: {
            height: '100%',
            width: 260,
            borderLeft: `1px solid ${theme.palette.border.divider}`,
            borderRight: `1px solid ${theme.palette.border.divider}`,
            borderBottom: `1px solid ${theme.palette.border.divider}`,
            position: 'relative',
            overflow: 'hidden',
        },
        keyZone: {
            height: '10%',
            width: '100%',
            position: 'absolute',
            bottom: '10%',
            left: 0,
            right: 0,
            margin: 'auto',
            borderTop: `1px solid ${theme.palette.info.main}`,
            borderBottom: `1px solid ${theme.palette.info.main}`,
        },
        key: {
            height: 45,
            width: 45,
            position: 'absolute',
            left: 0,
            right: 0,
            margin: 'auto',
            border: `1px solid ${theme.palette.border.divider}`,
            borderRadius: 4,
            textAlign: 'center',
            lineHeight: '40px',
            fontSize: 24,
            background: theme.palette.secondary.light,

            transition: 'border-color ease-in 0.15s',
            '&.pressed': {
                borderColor: theme.palette.info.main,
            },
        },
    }));

    const classes = useStyles();

    const [first, setFirst] = useState(true);
    const [pressed, setPressed] = useState(false);
    const [falling, setFalling] = useState(false);
    const [fallingSpeed, setFallingSpeed] = useState(
        Math.random() * (game.timer[1] - game.timer[0]) + game.timer[0],
    );
    const [fallingOffset, setFallingOffset] = useState(0);

    useEffect(() => {
        setTimeout(() => {
            setPressed(false);
        }, 250);
    }, [pressed]);

    useEffect(() => {
        if (!falling) {
            setFallingOffset(0);
            setFallingSpeed(
                Math.random() * (game.timer[1] - game.timer[0]) + game.timer[0],
            );
            setTimeout(() => {
                setFalling(true);
            }, (first && alleyId == 1 ? 100 : 300) * (Math.random() * 3 + 1));

            setFirst(false);
        }
    }, [falling]);

    useEffect(() => {
        if (fallingOffset >= fallingSpeed) {
            setFalling(false);
            soundEffect('negative');
            onFail();
        }
    }, [fallingOffset]);

    const onFalling = () => {
        setFallingOffset(fallingOffset + 10);
    };

    useInterval(onFalling, falling ? 10 : null);

    useKeypress(game.key[alleyId], () => {
        if (!falling) return;

        setPressed(true);

        const pct = (fallingOffset / fallingSpeed) * 100;
        const valid = pct >= 76 && pct <= 88;
        setFalling(false);
        if (valid) {
            soundEffect();
        } else {
            soundEffect('negative');
            onFail();
        }
    });

    return (
        <div className={classes.alley}>
            {falling && (
                <div
                    className={classes.key}
                    style={{ top: `${(fallingOffset / fallingSpeed) * 100}%` }}
                >
                    {game.key[alleyId][1]}
                </div>
            )}
            <div className={classes.keyZone}>
                <div
                    className={`${classes.key}${pressed ? ' pressed' : ''}`}
                    style={{
                        top: 0,
                        bottom: 0,
                    }}
                >
                    {game.key[alleyId][1]}
                </div>
            </div>
        </div>
    );
};
