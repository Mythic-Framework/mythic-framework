import React from 'react';
import { Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Nui from '../../util/Nui';
import { useDispatch } from 'react-redux';

const useStyles = makeStyles(theme => ({
    div: {
        width: '100%',
        border: `2px solid ${theme.palette.error.dark}`,
        background: theme.palette.error.main,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        '&:hover': {
            background: theme.palette.error.main,
            filter: 'brightness(0.7)',
        },
    },
}));

export default ({ data }) => {
    const classes = useStyles();
	const dispatch = useDispatch();

    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'BACK' });
            Nui.send('Selected', {
                id: data.id,
            });

            dispatch({
                type: 'SUBMENU_BACK',
            });
        }
    };

    return (
        <Button className={classes.div} onClick={onClick}>
            {data.label}
        </Button>
    );
};
