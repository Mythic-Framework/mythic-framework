import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Fade } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'absolute',
        height: '100%',
        width: '100%',
        background: '#ffffff',
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const flashbanged = useSelector((state) => state.app.flashbanged);

    const [to, setTo] = useState(false);
    const [showing, setShowing] = useState(false);

    useEffect(() => {
        if (Boolean(to)) clearTimeout(to);
        if (Boolean(flashbanged)) {
            if (!showing) {
                setShowing(true);
            } else {
                setTo(
                    setTimeout(() => {
                        setShowing(false);
                    }, flashbanged?.duration || 3000),
                );
            }
        } else {
            setShowing(false);
        }

        return () => {
            if (Boolean(to)) clearTimeout(to);
        };
    }, [flashbanged]);

    const onEntered = () => {
        setTo(
            setTimeout(() => {
                setShowing(false);
            }, flashbanged?.duration || 3000),
        );
    };

    const onExited = () => {
        dispatch({
            type: 'CLEAR_FLASHBANGED',
        });
    };

    return (
        <Fade in={showing} onEntered={onEntered} onExited={onExited}>
            <div>
                <div
                    className={classes.wrapper}
                    style={{ opacity: flashbanged?.strength || 0 }}
                ></div>
            </div>
        </Fade>
    );
};
