import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, List, IconButton, Slide } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';
import ListItem from './components/ListItem';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        width: '100%',
        maxWidth: 400,
        height: '100%',
        maxHeight: 'calc(100% - 300px)',
        position: 'absolute',
        //top: "40%",
        //bottom: 0,
        //right: 0,
        //left: 10,
        top: 10,
        right: 0,
        left: 0,
        margin: 'auto',
    },
    list: {
        paddingTop: 0,
        paddingBottom: 0,
        maxHeight: '100%',
        border: `1px solid ${theme.palette.border.divider}`,
        //borderTop: 'none',
        overflowY: 'auto',
        overflowX: 'hidden',
        '&::-webkit-scrollbar': {
            width: 6,
        },
        '&::-webkit-scrollbar-thumb': {
            background: theme.palette.primary.main,
            transition: 'background ease-in 0.15s',
        },
        '&::-webkit-scrollbar-thumb:hover': {
            background: theme.palette.primary.dark,
        },
        '&::-webkit-scrollbar-track': {
            background: theme.palette.secondary.main,
        },
    },
}));

export default () => {
    const classes = useStyles();
    const dispatch = useDispatch();
    const showing = useSelector((state) => state.infoOverlay.showing);

    const info = useSelector((state) => state.infoOverlay.info);

    //if (!showing || !Boolean(info)) return null;
    return (
        <Slide direction="down" in={showing} timeout={500} mountOnEnter unmountOnExit>
            <div className={classes.wrapper}>
                <List className={classes.list}>
                    <ListItem
                        item={info}
                    />
                </List>
            </div>
        </Slide>
    );
};
