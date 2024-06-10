import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { Grid, Switch, Avatar, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { UpdateSetting } from '../actions';

const useStyles = makeStyles(theme => ({
	rowWrapper: {
		background: theme.palette.secondary.main,
        padding: 12,
        marginBottom: 5,
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	appIcon: {
		fontSize: 25,
		width: 50,
		height: 50,
		margin: 'auto',
		color: '#fff',
    },
    appLabel: {
		display: 'block',
        fontSize: 20,
		fontWeight: 'bold',
        lineHeight: '50px',
        textAlign: 'left',
    },
	arrow: {
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
}));

export default connect(null, { UpdateSetting })((props) => {
    const classes = useStyles();
    const settings = useSelector(state => state.data.data.player.PhoneSettings);
    
    const [enabled, setEnabled] = useState(settings.appNotifications[props.app.name] == null);

    const toggle = () => {
        if (!settings.notifications) return;

        props.UpdateSetting('appNotifications', enabled ? {
            ...settings.appNotifications,
            [props.app.name]: true
        } : Object.keys(settings.appNotifications).reduce((result, key) => {
            if (key !== props.app.name) {
                result[key] = settings.appNotifications[key];
            }
            return result;
        }, {}))
        setEnabled(!enabled);
    }

    return (
        <Paper className={classes.rowWrapper} onClick={toggle}>
            <Grid item xs={12}>
                <Grid container>
                    <Grid item xs={2} style={{ position: 'relative' }}>
                        <Avatar
                            variant="rounded"
                            className={classes.appIcon}
                            style={{
                                background: `${props.app.color}`,
                            }}
                        >
                            <FontAwesomeIcon
                                icon={props.app.icon}
                            />
                        </Avatar>
                    </Grid>
                    <Grid item xs={8} style={{ paddingLeft: 5, position: 'relative' }}>
                        <span className={classes.appLabel}>{props.app.label}</span>
                    </Grid>
                    <Grid item xs={2} style={{ position: 'relative' }}>
                        <Switch
                            className={classes.arrow}
                            checked={enabled && settings.notifications}
                            disabled={!settings.notifications}
                            color="primary"
                        />
                    </Grid>
                </Grid>
            </Grid>
        </Paper>
    );
});
