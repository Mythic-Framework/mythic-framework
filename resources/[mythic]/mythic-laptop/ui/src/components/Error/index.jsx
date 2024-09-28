import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        display: 'flex',
        height: '100%',
        overflow: 'hidden',
    },
    textWrapper: {
        textAlign: 'center',
        fontSize: 22,
        fontWeight: 'bold',
        width: '100%',
    }
}));

export default ((props) => {
    const classes = useStyles();
    return (
        <div className={classes.wrapper}>
            <div className={classes.textWrapper}>
                <h1>{props.code}</h1>
                <h3>{props.message}</h3>
            </div>
        </div>
    )
});