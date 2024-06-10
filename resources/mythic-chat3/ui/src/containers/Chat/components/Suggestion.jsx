import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Fade, List, ListItem, ListItemText } from '@mui/material';
import { makeStyles } from '@mui/styles';

const useStyles = makeStyles((theme) => ({
    wrapper: {
    },
    active: {
        color: theme.palette.text.main,
        fontSize: 14,
    },
    inactive: {
        color: theme.palette.text.alt,
        fontSize: 14,
    },
    param: {
        marginLeft: 4,
        color: theme.palette.text.alt,
        fontSize: 14,
    },
    activeParam: {
        marginLeft: 4,
        color: theme.palette.text.main,
        fontSize: 14,
    },
    helper: {
        marginLeft: 10,
        color: theme.palette.text.alt,
        fontSize: 12,
        '&::before': {
            content: "'*'",
            color: theme.palette.primary.main,
            marginRight: 4,
        },
    },
}));

export default ({ suggestion, isFirst = false, parameterIndex = -1 }) => {
    const classes = useStyles();

    return (
        <ListItem dense className={classes.wrapper}>
            <ListItemText
                primary={
                    <span>
                        <span
                            className={
                                parameterIndex < 0
                                    ? classes.active
                                    : classes.inactive
                            }
                        >
                            {suggestion.name}
                        </span>
                        {isFirst &&
                        Boolean(suggestion.params) &&
                        suggestion.params.length > 0
                            ? suggestion.params.map((p, i) => (
                                  <span
                                      className={
                                          parameterIndex == i
                                              ? classes.activeParam
                                              : classes.param
                                      }
                                  >
                                      [{p.name}]
                                  </span>
                              ))
                            : ''}
                    </span>
                }
                secondary={
                    <span className={classes.helper}>
                        {parameterIndex < 0 ||
                        !isFirst ||
                        !Boolean(suggestion.params) ||
                        suggestion.params.length == 0
                            ? suggestion.help
                            : suggestion.params[
                                  parameterIndex < suggestion.params.length
                                      ? parameterIndex
                                      : suggestion.params.length - 1
                              ].help}
                    </span>
                }
            />
        </ListItem>
    );
};
