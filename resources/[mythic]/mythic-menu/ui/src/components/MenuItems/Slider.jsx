import React, { useState } from 'react';
import Nui from '../../util/Nui';
import {
    Slider as MSlider,
    Tooltip,
    Grid,
    useTheme,
} from '@material-ui/core';
import { CheckCircle } from '@material-ui/icons';
import { experimentalStyled as styled } from '@material-ui/core/styles';
import { withStyles, makeStyles } from '@material-ui/styles';

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
        padding: '10px 20px',
        marginBottom: 5,
        borderRadius: 3,
    },
    label: {
        display: 'block',
        width: '100%',
    },
    slider: {
        display: 'block',
        position: 'relative',
        top: '25%',
    },
    saveContainer: {
        textAlign: 'right',
        color: '#38b58fab',
        '&:hover': {
            color: '#38b58f59',
        },
    },
    icon: {
        width: '0.75em',
        height: '100%',
        fontSize: '1.25rem',
        float: 'right',
    },
}));

function ValueLabelComponent(props) {
    const { children, open, value } = props;

    return (
        <Tooltip open={open} enterTouchDelay={0} placement="top" title={value}>
            {children}
        </Tooltip>
    );
}

const XSlider = withStyles(theme => ({
    color: theme.palette.primary.main,
    height: 8,
    '& .MuiSlider-thumb': {
        height: 24,
        width: 24,
        backgroundColor: '#fff',
        border: '2px solid currentColor',
        marginTop: -8,
        marginLeft: -12,
        '&:focus, &:hover, &.Mui-active': {
            boxShadow: 'inherit',
        },
    },
    '& .MuiSlider-valueLabel': {
        left: 'calc(-50% + 4px)',
    },
    '& .MuiSlider-track': {
        height: 8,
        borderRadius: 4,
    },
    '& .MuiSlider-rail': {
        height: 8,
        borderRadius: 4,
    },
}))(MSlider);

export default ({ data }) => {
    const classes = useStyles();

    const [currValue, setCurrValue] = useState(data.options.current);
    const [savedValue, setSavedValue] = useState(currValue);

    const onChange = (event, newValue) => {
        if (!data.disabled) {
            setCurrValue(newValue);
        }
    };

    const onSave = () => {
        if (!data.disabled && currValue != savedValue) {
            setSavedValue(currValue);
            Nui.send('FrontEndSound', { sound: 'SELECT' });
            Nui.send('Selected', {
                id: data.id,
                data: { value: currValue },
            });
        }
    };

    var cssClass = data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    var style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <Grid container>
                <Grid item xs={2}></Grid>
                <Grid item xs={8}>
                    <span>{data.label}</span>
                </Grid>
                <Grid
                    item
                    xs={2}
                    className={classes.saveContainer}
                    onClick={onSave}
                >
                    {currValue == savedValue ? null : (
                        <CheckCircle className={classes.icon} />
                    )}
                </Grid>
                <Grid item xs={12}>
                    <XSlider
                        valueLabelDisplay="auto"
                        className={classes.slider}
                        onChange={onChange}
                        components={{
                            ValueLabel: ValueLabelComponent,
                        }}
                        defaultValue={0}
                        value={currValue}
                        step={data.options.step != null ? data.options.step : 1}
                        min={data.options.min}
                        max={data.options.max}
                        component="div"
                    />
                </Grid>
            </Grid>
        </div>
    );
};
