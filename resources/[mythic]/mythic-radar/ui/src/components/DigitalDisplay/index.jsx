import React from 'react';
import { makeStyles } from '@material-ui/styles';


const specificSpeedDisplayStyling = (colour, label) => makeStyles(theme => ({
    displayContainer: {
        display: 'grid',
        height: label ? '75%' : '100%',
        width: '100%',
        gridTemplateColumns: '1fr',
        background: theme.palette.speedDisplays[colour]?.background,
        border: '3px solid #000000',
    },
    labelContainer: {
        height: '25%',
        width: '100%',
        background: '#000000',
    },
    labelText: {
        color: theme.palette.text.light,
        textAlign: 'center',
        fontSize: `${13 * theme.scale}px`,
        textTransform: 'uppercase',
        margin: 0,
    },
    mainText: {
        gridRowStart: 1,
        gridColumnStart: 1,
        margin: 'auto 0',
        fontSize: `${42 * theme.scale}px`,
        fontFamily: 'Segment7Standard',
        textAlign: 'center',
        color: theme.palette.speedDisplays[colour]?.text,
        textShadow: theme.palette.speedDisplays[colour]?.textShadow,
        userSelect: 'none',
    },
    ghostText: {
        color: theme.palette.speedDisplays[colour]?.ghostText,
        textShadow: 'none',
    }
}));

export default (props) => {
    const classes = specificSpeedDisplayStyling(props.colour ?? 'red', props.label)();
    let value;
    if (props.speed) {
        value = props.value?.toString().padStart(3, '0');
    } else {
        value = props.value?.toString().toUpperCase().padEnd(3, String.fromCharCode(183));
    }

    return <>
        <div className={classes.displayContainer}>
            <p className={`${classes.mainText} ${classes.ghostText}`}>{ '8'.repeat(value ? value.length : 3) }</p>
            <p className={classes.mainText}>{ value }</p>
        </div>
        { props.label && (
            <div className={classes.labelContainer}>
                <p className={classes.labelText}>{ props.label }</p>
            </div>
        )}
    </>
};
