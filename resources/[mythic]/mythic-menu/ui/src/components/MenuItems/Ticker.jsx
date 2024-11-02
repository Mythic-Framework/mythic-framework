import React, { useState } from 'react';
import Nui from '../../util/Nui';
import { IconButton, TextField } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { ChevronLeft, ChevronRight } from '@material-ui/icons';

const useStyles = makeStyles(theme => ({
    div: {
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 84,
        width: '100%',
        textAlign: 'center',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        lineHeight: '38px',
        verticalAlign: 'middle',
        borderRadius: 3,
    },
    slider: {
        display: 'block',
        position: 'relative',
        top: '25%',
    },
    action: {
        height: 86,
        position: 'relative',
        lineHeight: '100px',
        '&:hover': {
            filter: 'brightness(0.6)',
            transition: 'filter ease-in 0.15s',
        },
    },
    actionBtn: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        height: 'fit-content',
        width: 'fit-content',
    },
    textField: {
        width: 25,
        '& input': {
            textAlign: 'center',
            color: theme.palette.primary.main,
        },
        '& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button': {
            display: 'none',
        },
    },
    wrapper: {
        display: 'grid',
        gridGap: 0,
        gridTemplateColumns: '20% 60% 20%',
        gridTemplateRows: '40px 40px',
    },
}));

const Ticker = props => {
    const classes = useStyles();
    const [value, setValue] = useState(props.data.options.current);

    const onLeft = () => {
        if (
            (props.data.options.min && value - 1 < props.data.options.min) ||
            value - 1 < 0
        ) {
            setValue(props.data.options.max);
        } else {
            setValue(value - 1);
        }
        Nui.send('FrontEndSound', { sound: 'UPDOWN' });
        Nui.send('Selected', {
            id: props.data.id,
            data: { 
                value: 
                    value === props.data.options.min 
                        ? props.data.options.max 
                        : value - 1,
            },
        });
    };

    const onRight = () => {
        if (value + 1 > props.data.options.max) {
            setValue(props.data.options.min ? props.data.options.min : 0);
        } else {
            setValue(value + 1);
        }

        Nui.send('FrontEndSound', { sound: 'UPDOWN' });
        Nui.send('Selected', {
            id: props.data.id,
            data: {
                value:
                    value === props.data.options.max
                        ? props.data.options.min
                        : value + 1,
            },
        });
    };

    const updateIndex = event => {
        if (!props.data.options.disabled) {
            let v = parseInt(event.target.value, 10);

            if (isNaN(v)) {
                setValue(props.data.options.min);
                Nui.send('Selected', {
                    id: props.data.id,
                    data: { value: props.data.options.min },
                });
                return;
            } else {
                if (event.target.value > props.data.options.max) {
                    v = props.data.options.max;
                } else if (event.target.value < props.data.options.min) {
                    v = props.data.options.max;
                }
                setValue(v);
                Nui.send('Selected', {
                    id: props.data.id,
                    data: { value: v },
                });
            }
        }
    };

    var cssClass = props.data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    var style = props.data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <div className={classes.wrapper}>
                <div style={{ gridColumn: 2, gridRow: 1 }}>
                    {props.data.label}
                </div>
                <div
                    className={classes.action}
                    style={{ gridColumn: 1, gridRow: '1 / 2' }}
                >
                    <IconButton className={classes.actionBtn} onClick={onLeft}>
                        <ChevronLeft />
                    </IconButton>
                </div>
                <div style={{ gridColumn: 2, gridRow: 2 }}>
                    <TextField
                        variant="standard"
                        value={value}
                        className={classes.textField}
                        onChange={updateIndex}
                        disabled={props.data.options.disabled}
                        type="number"
                        inputProps={{
                            min: props.data.options.min,
                            max: props.data.options.max,
                            step: 1,
                        }}
                    />{' '}
                    / {props.data.options.max}
                </div>
                <div
                    className={classes.action}
                    style={{ gridColumn: 3, gridRow: '1 / 2' }}
                >
                    <IconButton className={classes.actionBtn} onClick={onRight}>
                        <ChevronRight />
                    </IconButton>
                </div>
            </div>
        </div>
    );
};

export default Ticker;
