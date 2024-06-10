import React from 'react';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

const useStyles = makeStyles(theme => ({
    settingsContainer: {
        height: '100%',
        fontSize: `${14 * theme.scale}px`,
    },
    setting: {
        padding: '0px',
        margin: 0,
        color: '#010000',
        textTransform: 'uppercase',
    },
    settingActive: {
        color: theme.palette.speedDisplays.orange.text,
        textShadow: theme.palette.speedDisplays.orange.textShadow,
    }
}));

export default (props) => {
    const classes = useStyles();

    return <Grid
        className={classes.settingsContainer}
        container
        direction="column"
        justify="center"
        alignItems="center"
    >
        { Object.keys(props.settings).map(setting => <p className={`${classes.setting} ${props.settings[setting] && classes.settingActive}`}>{ setting }</p>)}
    </Grid>
};
