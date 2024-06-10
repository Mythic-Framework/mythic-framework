/* eslint-disable jsx-a11y/no-static-element-interactions */
/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable react/prop-types */
import React from 'react';
import { makeStyles } from '@material-ui/styles';

import { Sanitize } from '../../util/Parser';

const useStyles = makeStyles(theme => ({
    '@import':
        'url("https://fonts.googleapis.com/css2?family=Inconsolata&display=swap")',
    defaultStyle: {
        textAlign: 'left',
        fontSize: 12,
        fontWeight: 'normal',
    },
    heading: {
        fontSize: 22,
        padding: '15px 0',
        borderBottom: `1px solid ${theme.palette.primary.main}`,
    },
    textSmall: {
        fontSize: 8,
    },
    textMedium: {
        fontSize: 12,
    },
    textLarge: {
        fontSize: 18,
    },
    textExtraLarge: {
        fontSize: 24,
    },
    code: {
        fontFamily: ['Inconsolata'],
    },
    right: {
        textAlign: 'left',
    },
    center: {
        textAlign: 'center',
    },
    right: {
        textAlign: 'right',
    },
    bold: {
        fontWeight: 'bold',
    },
    pad: {
        padding: 15,
    },
    colorPrimary: {
        color: theme.palette.primary.main,
    },
    colorError: {
        color: theme.palette.error.main,
    },
    colorWarning: {
        color: theme.palette.warning.main,
    },
    colorSuccess: {
        color: theme.palette.success.light,
    },
}));

export default props => {
    const classes = useStyles();

    let style = '';

    if (
        props.data.options.classes != null &&
        props.data.options.classes.length > 0
    )
        props.data.options.classes.map(css => {
            style += ` ${classes[css]}`;
        });

    return (
        <div className={`${classes.defaultStyle} ${style}`}>
            {Sanitize(props.data.label)}
        </div>
    );
};
