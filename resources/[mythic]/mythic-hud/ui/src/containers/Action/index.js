/* eslint-disable react/no-danger */
import React from 'react';
import { useSelector } from 'react-redux';
import ReactHtmlParser from 'react-html-parser';
import { Grow } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        color: theme.palette.text.main,
        textShadow: '0 0 3px #000000',
        borderBottom: `3px solid ${theme.palette.info.main}`,
        padding: 10,
        height: 'fit-content',
        position: 'absolute',
        bottom: '15%',
        right: 0,
        left: 0,
        margin: 'auto',
        width: 'fit-content',
        fontSize: 20,
        '& svg': {
            position: 'absolute',
            left: -15,
            bottom: -15,
            color: theme.palette.info.main,
            fontSize: 28,
            zIndex: 100,
        },
    },
    highlight: {
        color: '#3aaaf9',
        fontWeight: 500,
    },
    '.highlight': {
        color: '#3aaaf9',
        fontWeight: 500,
    },
    highlightSplit: {
        color: '#ffffff',
        fontWeight: 500,
    },
    key: {
        padding: 5,
        color: theme.palette.primary.main,
        borderRadius: 2,
        textTransform: 'capitalize',
        '&::before': {
            content: '"("',
        },
        '&::after': {
            content: '")"',
        },
    },
}));

export default () => {
    const classes = useStyles();
    const showing = useSelector((state) => state.action.showing);
    const message = useSelector((state) => state.action.message);

    const ParseButtonText = () => {
        let v = message;
        v = v.replace(/\{key\}/g, `<span class=${classes.key}>`);

        v = v.replace(/\{\/key\}/g, `</span>`);

        return v;
    };

    if (!Boolean(message)) return null;
    return (
        <Grow in={showing}>
            <div className={classes.wrapper}>
                {ReactHtmlParser(ParseButtonText())}
                <FontAwesomeIcon icon="circle-info" />
            </div>
        </Grow>
    );
};
