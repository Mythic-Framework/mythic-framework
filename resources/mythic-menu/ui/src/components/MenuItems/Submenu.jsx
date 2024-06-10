import React from 'react';
import { Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        width: '100%',
        border: `2px solid ${theme.palette.info.main}`,
        background: theme.palette.info.dark,
        color: theme.palette.text.main,
        fontSize: 13,
        height: 42,
        width: '100%',
        textAlign: 'center',
        transition: 'filter ease-in 0.15s',
        marginBottom: 5,
        '&:hover': {
            background: theme.palette.info.dark,
            filter: 'brightness(0.7)',
        },
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const onClick = () => {
        if (!data.options.disabled) {
            Nui.send('FrontEndSound', { sound: 'SELECT' });
            Nui.send('MenuOpen', {
                id: data.id,
            });
        }
    };

    const style = data.options.disabled ? { opacity: 0.5 } : {};
    return (
        <Button className={classes.div} style={style} onClick={onClick}>
            {data.label}
        </Button>
    );
};
