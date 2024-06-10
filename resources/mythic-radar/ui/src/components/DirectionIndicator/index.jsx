import React from 'react';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles(theme => ({
    directionContainer: {
        height: '100%',
        fontSize: `${20 * theme.scale}px`,
    },
    directionIcon: {
        padding: '5px',
        color: '#010000',
    },
    directionIconActive: {
        color: theme.palette.speedDisplays.orange.text,
        textShadow: theme.palette.speedDisplays.orange.textShadow,
    }
}));

export default (props) => {
    const classes = useStyles();

    return <Grid
        className={classes.directionContainer}
        container
        direction="column"
        justify="center"
        alignItems="center"
    >
        <FontAwesomeIcon className={`${classes.directionIcon} ${props.direction === 'up' && classes.directionIconActive}`} icon={'fa-solid fa-up'} />
        <FontAwesomeIcon className={`${classes.directionIcon} ${props.direction === 'down' && classes.directionIconActive}`} icon={'fa-solid fa-down'} />
    </Grid>
};
