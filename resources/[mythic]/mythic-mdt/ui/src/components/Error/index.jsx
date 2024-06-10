import React from 'react';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        textAlign: 'center',
        fontSize: 22,
        fontWeight: 'bold',
    },
    static: {
        width: 'fit-content',
        height: 'fit-content',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        textAlign: 'center',
        fontSize: 22,
        fontWeight: 'bold',
    }
}));

export default ((props) => {
    const classes = useStyles();
    return (
        <div className={props.static ? classes.static : classes.wrapper}>
            <h1>{props.code}</h1>
            <h3>{props.message}</h3>
        </div>
    )
});