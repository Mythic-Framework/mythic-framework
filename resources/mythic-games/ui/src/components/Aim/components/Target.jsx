import React, { useRef, useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import useInterval from 'react-useinterval';
import mojs from '@mojs/core';

const random = (min, max) => {
    return Math.floor(Math.random() * (max - min)) + min;
};

const useStyles = makeStyles((theme) => ({
    target: {
        position: 'absolute',
        height: 0,
        width: 0,
        borderRadius: 100,
        background: theme.palette.secondary.light,
        border: `2px solid ${theme.palette.primary.dark}`,
        zIndex: 10,

        '&:hover': {
            cursor: 'pointer',
        },
    },
}));

export default ({ parentRef, target, game, onClick, onFail }) => {
    const classes = useStyles();
    const animRef = useRef();
    const aidsRef = useRef();

    useEffect(() => {
        if (!Boolean(aidsRef.current)) return;
        onMove();

        return () => {
            animRef.current.stop();
        };
    }, [aidsRef]);

    const [grow, setGrow] = useState(0);
    const onGrow = () => {
        setGrow(grow + 1);
    };

    useEffect(() => {
        if (grow >= game.maxSize) {
            onFail(target.id);
        }
    }, [grow]);

    useInterval(onGrow, grow < game.maxSize ? game.difficulty : null);

    const onMove = () => {
        if (!Boolean(aidsRef?.current) || !game.isMoving) return;

        let top = aidsRef.current.offsetTop;
        let left = aidsRef.current.offsetLeft;
        let new_top = random(10, parentRef.current.clientHeight - 100);
        let new_left = random(10, parentRef.current.clientWidth - 100);
        let diff_top = new_top - top;
        let diff_left = new_left - left;
        let duration = random(25, 50) * 100;

        animRef.current = new mojs.Html({
            el: '#' + aidsRef.current.id,
            x: {
                0: diff_left,
                duration: duration,
                easing: 'linear.none',
            },
            y: {
                0: diff_top,
                duration: duration,
                easing: 'linear.none',
            },
            duration: duration + 50,
            onComplete() {
                if (!Boolean(aidsRef.current)) return;

                if (
                    aidsRef?.current?.offsetTop === 0 &&
                    aidsRef?.current?.offsetLeft === 0
                ) {
                    this.pause();
                    return;
                }

                aidsRef.current.style = `background: ${
                    target.color
                }; top: ${new_top}px; left: ${new_left}px; transform: none; height: ${
                    (game.size || 30) + grow
                }; width: ${(game.size || 30) + grow}`;
                onMove();
            },
            onUpdate() {
                //if (game_started === false) this.pause();
            },
        }).play();
    };

    return (
        <div
            id={`target-${target.id}`}
            ref={aidsRef}
            className={classes.target}
            style={{
                left: target.width,
                top: target.height,
                height: (game.size || 30) + grow,
                width: (game.size || 30) + grow,
            }}
            onClick={() => onClick(target.id)}
        ></div>
    );
};
