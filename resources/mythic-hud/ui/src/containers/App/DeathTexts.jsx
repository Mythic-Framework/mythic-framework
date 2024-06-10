import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';
import ReactMomentCountDown from 'react-moment-countdown';
import Nui from '../../util/Nui';
import { useEffect } from 'react';

const useStyles = makeStyles((theme) => ({
    container: {
        width: 'fit-content',
        height: 'fit-content',
        position: 'absolute',
        bottom: 150,
        left: 0,
        right: 0,
        margin: 'auto',
        fontSize: 24,
        textShadow: '0 0 3px #000000',
        textAlign: 'center',
    },
    highlight: {
        marginLeft: 6,
        color: theme.palette.primary.main,
        fontWeight: 'bold',
    },
    small: {
        display: 'block',
        fontSize: 16,
        marginLeft: 6,
        color: theme.palette.text.main,
    },
    smallHighlight: {
        color: theme.palette.primary.main,
        fontWeight: 'bold',
    },
}));

export default () => {
    const classes = useStyles();

    const isDeathTexts = useSelector((state) => state.app.isDeathTexts);
    const isReleasing = useSelector((state) => state.app.isReleasing);
    const deathTime = useSelector((state) => state.app.deathTime);
    const releaseType = useSelector((state) => state.app.releaseType);
    const releaseTimer = useSelector((state) => state.app.releaseTimer);
    const releaseKey = useSelector((state) => state.app.releaseKey);
    const helpKey = useSelector((state) => state.app.helpKey);
    const medicalPrice = useSelector((state) => state.app.medicalPrice);

    const [force, setForce] = useState(Math.random());
    const onEnd = () => {
        setForce(Math.random());
    };

    const getTypeText = () => {
        switch (releaseType) {
            case 'knockout':
                if (Date.now() > releaseTimer) {
                    if (isReleasing) {
                        return <span>Standing Up...</span>;
                    } else {
                        return (
                            <span>
                                Press{' '}
                                <span className={classes.highlight}>
                                    [{releaseKey}]
                                </span>{' '}
                                To Stand Up
                            </span>
                        );
                    }
                } else {
                    if (isReleasing) {
                        return <span>Standing Up...</span>;
                    } else {
                        return (
                            <span>
                                Unconscious. Can Stand Up In
                                <ReactMomentCountDown
                                    className={classes.highlight}
                                    toDate={new Date(releaseTimer)}
                                    onCountdownEnd={onEnd}
                                    targetFormatMask="m:ss"
                                />
                            </span>
                        );
                    }
                }
            case 'death':
                if (Date.now() > releaseTimer) {
                    if (isReleasing) {
                        return <span>Respawning...</span>;
                    } else {
                        return (
                            <span>
                                Press{' '}
                                <span className={classes.highlight}>
                                    [{releaseKey}]
                                </span>{' '}
                                To Respawn (${medicalPrice})
                                {deathTime + 1000 * 60 * 2 > Date.now() ? (
                                    <small class={classes.small}>
                                        (Call For Medical Available In{' '}
                                        <ReactMomentCountDown
                                            className={classes.smallHighlight}
                                            toDate={
                                                new Date(
                                                    deathTime + 1000 * 60 * 2,
                                                )
                                            }
                                            onCountdownEnd={onEnd}
                                            targetFormatMask="m:ss"
                                        />
                                        )
                                    </small>
                                ) : (
                                    <small class={classes.small}>
                                        (
                                        <span
                                            className={classes.smallHighlight}
                                        >
                                            [{helpKey}]
                                        </span>{' '}
                                        To Call For Medical Assistance)
                                    </small>
                                )}
                            </span>
                        );
                    }
                } else {
                    if (isReleasing) {
                        return <span>Respawning...</span>;
                    } else {
                        return (
                            <span>
                                Downed. Respawn Available
                                <ReactMomentCountDown
                                    className={classes.highlight}
                                    toDate={new Date(releaseTimer)}
                                    onCountdownEnd={onEnd}
                                    targetFormatMask="m:ss"
                                />
                                {deathTime + 1000 * 60 * 2 > Date.now() ? (
                                    <small class={classes.small}>
                                        (Call For Medical Available In{' '}
                                        <ReactMomentCountDown
                                            className={classes.smallHighlight}
                                            toDate={
                                                new Date(
                                                    deathTime + 1000 * 60 * 2,
                                                )
                                            }
                                            onCountdownEnd={onEnd}
                                            targetFormatMask="m:ss"
                                        />
                                        )
                                    </small>
                                ) : (
                                    <small class={classes.small}>
                                        (
                                        <span
                                            className={classes.smallHighlight}
                                        >
                                            [{helpKey}]
                                        </span>{' '}
                                        To Call For Medical Assistance)
                                    </small>
                                )}
                            </span>
                        );
                    }
                }
            case 'hospital':
                if (Date.now() > releaseTimer) {
                    if (isReleasing) {
                        return <span>Getting Up...</span>;
                    } else {
                        return (
                            <span>
                                Press{' '}
                                <span className={classes.highlight}>
                                    [{releaseKey}]
                                </span>{' '}
                                To Get Out Of Bed
                            </span>
                        );
                    }
                } else {
                    if (isReleasing) {
                        return <span>Getting Up...</span>;
                    } else {
                        return (
                            <span>
                                Being Treated
                                <ReactMomentCountDown
                                    className={classes.highlight}
                                    toDate={new Date(releaseTimer)}
                                    onCountdownEnd={onEnd}
                                    targetFormatMask="m:ss"
                                />
                            </span>
                        );
                    }
                }
            case 'hospital_rp':
                return (
                    <span>
                        Press{' '}
                        <span className={classes.highlight}>
                            [{releaseKey}]
                        </span>{' '}
                        To Get Out Of Bed
                    </span>
                );
        }
    };

    if (
        !Boolean(isDeathTexts) ||
        !Boolean(releaseType) ||
        !Boolean(releaseTimer)
    )
        return <div></div>;
    return (
        <div key={force} className={classes.container}>
            {getTypeText()}
        </div>
    );
};
