import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from "react-router-dom";
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles(theme => ({
    footer: {
        background: '#000000',
        height: '7%',
        borderBottomLeftRadius: 30,
        borderBottomRightRadius: 30,
        textAlign: 'center',
        color: '#ffffff',
        lineHeight: '65px',
        fontSize: '20px',
    },
    fButton: {
        '&:hover': {
            transition: 'color ease-in 0.15s',
            color: theme.palette.primary.main
        }
    }
}));

export default (props => {
    const classes = useStyles();
    const history = useHistory();
    const dispatch = useDispatch();
	const expanded = useSelector((state) => state.phone.expanded);

    const ToggleExpando = () => {
        dispatch({
            type: 'TOGGLE_EXPANDED'
        })
    }

    const GoHome = () => {
        history.push('/');
    }

    const GoBack = () => {
        history.goBack();
    }

    return (
        <Grid container className={classes.footer}>
            <Grid item xs={4} className={classes.fButton} onClick={ToggleExpando}>
                <FontAwesomeIcon icon={['fas', expanded ? 'minimize' : 'maximize']} />
            </Grid>
            <Grid item xs={4} className={classes.fButton} onClick={GoHome}>
                <FontAwesomeIcon icon={['fas', 'house']} />
            </Grid>
            <Grid item xs={4} className={classes.fButton} onClick={GoBack}>
                <FontAwesomeIcon icon='chevron-left' />
            </Grid>
        </Grid>
    );
});
