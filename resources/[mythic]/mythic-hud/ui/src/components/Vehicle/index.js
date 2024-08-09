import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { Fade, useTheme } from '@mui/material';
import { makeStyles } from '@mui/styles';
import ReactHtmlParser from 'react-html-parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        position: 'absolute',
        left: 0,
        right: 0,
        margin: 'auto',
        width: 'fit-content',
        filter: `drop-shadow(0 0 2px ${theme.palette.secondary.dark}e0)`,
        fontSize: 30,
        color: theme.palette.text.main,
        textAlign: 'center',
    },
    speed: {},
    speedText: {
        fontSize: 50,
        color: theme.palette.text.main,
        display: 'inline-block',
        transition: 'color ease-in 0.15s',
        '& .filler': {
            color: theme.palette.text.alt,
        },
    },
    speedTextOff: {
        fontSize: 50,
        color: theme.palette.primary.main,
        textTransform: 'uppercase',
        display: 'inline-block',
    },
    speedMeasure: {
        fontSize: 25,
        color: theme.palette.text.alt,
        marginLeft: 10,
    },
    icons: {
        display: 'flex',
        gridGap: 0,
        justifyContent: 'center',
    },
    seatbeltIcon: {
        fontSize: 25,
        color: theme.palette.warning.dark,
        animation: '$flash linear 1s infinite',
    },
    checkEngine: {
        margin: '0 30px',
        fontSize: 25,
        color: theme.palette.warning.dark,
        animation: '$flash linear 1s infinite',
    },
    cruiseIcon: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.primary.main,
    },
    fuel100: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.success.dark,
    },
    fuel75: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.success.main,
    },
    fuel50: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.warning.main,
    },
    fuel25: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.error.main,
        animation: '$flash linear 1.5s infinite',
    },
    fuel10: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.error.main,
        animation: '$flash linear 1s infinite',
    },
    fuel0: {
        margin: '0 15px',
        fontSize: 25,
        color: theme.palette.error.main,
        animation: '$flash linear 0.5s infinite',
    },
    iconWrapper: {
        position: 'relative',
        height: 50,
        width: 50,
        '&.low': {
            animation: '$flash linear 0.5s infinite',
        },
    },
    iconProg: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        margin: 'auto',
        zIndex: 5,
    },
    iconAvatar: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        margin: 'auto',
        background: theme.palette.secondary.dark,
        '& svg': {
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            margin: 'auto',
            color: theme.palette.text.main,
        },
    },
    '@keyframes flash': {
        '0%': {
            opacity: 1,
        },
        '50%': {
            opacity: 0.1,
        },
        '100%': {
            opacity: 1,
        },
    },
}));

export default () => {
    const classes = useStyles();

    const config = useSelector((state) => state.hud.config);
    const showing = useSelector((state) => state.vehicle.showing);
    const ignition = useSelector((state) => state.vehicle.ignition);
    const speed = useSelector((state) => state.vehicle.speed);
    const speedMeasure = useSelector((state) => state.vehicle.speedMeasure);
    const seatbelt = useSelector((state) => state.vehicle.seatbelt);
    const checkEngine = useSelector(state => state.vehicle.checkEngine);
    const seatbeltHide = useSelector((state) => state.vehicle.seatbeltHide);
    const cruise = useSelector((state) => state.vehicle.cruise);
    const [speedStr, setSpeedStr] = useState(speed.toString());

    useEffect(() => {
        if (speed === 0) {
            setSpeedStr(`<span class="filler">000</span>`);
        } else if (speed < 10) {
            setSpeedStr(`<span class="filler">00</span>${speed.toString()}`);
        } else if (speed < 100) {
            setSpeedStr(`<span class="filler">0</span>${speed.toString()}`);
        } else {
            setSpeedStr(speed.toString());
        }
    }, [speed]);

    return (
        <Fade in={showing}>
            <div
                className={classes.wrapper}
                style={{
                    bottom:
                        config.statusIcons || config.statusNumbers ? 50 : 20,
                }}
            >
                <Fade in={ignition}>
                    <div className={classes.icons}>
                        <Fade in={!seatbelt && !seatbeltHide}>
                            <span>
                                <FontAwesomeIcon
                                    className={classes.seatbeltIcon}
                                    style={{ gridColumn: 1 }}
                                    icon={['fas', 'triangle-exclamation']}
                                />
                            </span>
                        </Fade>
                        <Fade in={checkEngine}>
                            <span>
                                <FontAwesomeIcon
                                    className={classes.checkEngine}
                                    style={{ gridColumn: 1 }}
                                    icon={['fas', 'screwdriver-wrench']}
                                />
                            </span>
                        </Fade>
                        {cruise && (
                            <Fade in={cruise}>
                                <span>
                                    <FontAwesomeIcon
                                        className={classes.cruiseIcon}
                                        style={{ gridColumn: 1 }}
                                        icon={['fas', 'gauge']}
                                    />
                                </span>
                            </Fade>
                        )}
                    </div>
                </Fade>
                <div className={classes.speed}>
                    {ignition ? (
                        <div>
                            <span className={classes.speedText}>
                                {ReactHtmlParser(speedStr)}
                            </span>
                            <span className={classes.speedMeasure}>
                                {speedMeasure}
                            </span>
                        </div>
                    ) : (
                        <span className={classes.speedTextOff}>Off</span>
                    )}
                </div>
            </div>
        </Fade>
    );
};
