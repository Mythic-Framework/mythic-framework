import React from 'react';
import { CircularProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
    loadingIcon: {
        width: 'fit-content',
        height: 'fit-content',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        fontSize: 70,
        color: theme.palette.primary.main,
    },
}));

export default (props) => {
    const classes = useStyles();

    return (
        <div className={classes.wrapper}>
            <div className={classes.loadingIcon}>
                <FontAwesomeIcon icon={props.app.icon} />
            </div>
			<CircularProgress color="primary" className={classes.loadingIcon} size={95} />
        </div>
    );
};
