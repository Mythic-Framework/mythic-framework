import React from 'react';
import { makeStyles } from '@mui/styles';

import { Sanitize } from '../../../../../util/Parser';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: 8,
        background: `${theme.palette.secondary.dark}a6`,
        border: `1px solid ${theme.palette.border.input}`,
        marginBottom: 4,
        minWidth: 200,
        width: 'fit-content',
        height: 'fit-content',
        borderRadius: 4,
    },
    tag: {
        color: '#cef048',
    },
    author: {
        color: theme.palette.warning.main,
        borderBottom: `1px solid ${theme.palette.border.divider}`,
        marginBottom: 5,
        paddingBottom: 5,
    },
    content: {
        marginLeft: 6,
        padding: 4,
        fontSize: '90%',
        textShadow: '0 0 #000',
    },
}));

export default ({ message }) => {
    const classes = useStyles();
    return (
        <div className={classes.wrapper}>
            <div className={classes.author}>
                <span className={classes.tag}>[DISPATCH]</span>
            </div>
            <div
                className={classes.content}
                dangerouslySetInnerHTML={{ __html: Sanitize(message.message) }}
            ></div>
        </div>
    );
};
