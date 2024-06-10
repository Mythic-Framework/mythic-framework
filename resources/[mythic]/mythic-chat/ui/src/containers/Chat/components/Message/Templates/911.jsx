import React from 'react';
import { makeStyles } from '@mui/styles';

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
    author: {
        color: theme.palette.text.alt,
        borderBottom: `1px solid ${theme.palette.border.divider}`,
        marginBottom: 5,
        paddingBottom: 5,

        '& small': {
            marginLeft: 4,
        },
    },
    tag: {
        color: theme.palette.info.main,
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
            {Boolean(message.author.Anonymous) ? (
                <div className={classes.author}>
                    <span className={classes.tag}>[911 Anonymous]</span>
                    {Boolean(message.author.SID) && (
                        <small>({message.author.SID})</small>
                    )}
                </div>
            ) : Boolean(message.author.Reply) ? (
                <div className={classes.author}>
                    <span className={classes.tag}>
                        [911r -&gt; {message.author.Reply}]
                    </span>{' '}
                    {message.author.First} {message.author.Last}
                    <small>({message.author.SID})</small>
                </div>
            ) : (
                <div className={classes.author}>
                    <span className={classes.tag}>[911]</span>{' '}
                    {message.author.First} {message.author.Last}
                    <small>({message.author.SID} - {message.author.Phone})</small>
                </div>
            )}
            <div className={classes.content}>{message.message}</div>
        </div>
    );
};
