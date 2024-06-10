import React, { useRef } from 'react';
import { makeStyles } from '@mui/styles';
import { useEffect } from 'react';
import mojs from '@mojs/core';

const useStyles = makeStyles((theme) => ({
    target: {
        position: 'absolute',
        height: 0,
        width: 0,
        border: `2px solid ${theme.palette.border.input}`,
        zIndex: 10,
        textAlign: 'center',
        height: 100,
        width: 100,
        lineHeight: '100px',
        fontSize: 24,

        '&:hover': {
            cursor: 'pointer',
        },
    },
}));

const random = (min, max) => {
    return Math.floor(Math.random() * (max - min)) + min;
};

export default ({ parentRef, hidden, target, game, onClick }) => {
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

    const onMove = () => {
        if (!Boolean(aidsRef?.current)) return;

        let top = aidsRef.current.offsetTop;
        let left = aidsRef.current.offsetLeft;
        let new_top = random(10, parentRef.current.clientHeight - 100);
        let new_left = random(10, parentRef.current.clientWidth - 100);
        let diff_top = new_top - top;
        let diff_left = new_left - left;
        let duration = random(10, 40) * 100;

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

                aidsRef.current.style = `background: ${target.color}; top: ${new_top}px; left: ${new_left}px; transform: none;`;
                onMove();
            },
            onUpdate() {
                //if (game_started === false) this.pause();
            },
        }).play();
    };

    return (
        <div
            ref={aidsRef}
            id={`target-${target.id}`}
            className={classes.target}
            style={{
                left: target.width,
                top: target.height,
                background: target.color,
            }}
            onClick={hidden ? () => onClick(target.id) : null}
        >
            {!hidden && <span>{target.id}</span>}
        </div>
    );
};
