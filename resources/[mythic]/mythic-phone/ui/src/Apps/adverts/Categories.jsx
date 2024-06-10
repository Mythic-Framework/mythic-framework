import React, { useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Categories } from './data';
import Category from './components/Category';

import './editor.css';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 10,
    },
}));

export default connect()((props) => {
    const classes = useStyles();

    return (
        <div className={classes.wrapper}>
            {
                Categories.map((category, i) => {
                    return <Category key={`category-${i}`} category={category} />
                })
            }
        </div>
    );
});
