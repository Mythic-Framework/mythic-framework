import React from 'react';
import { TextField, MenuItem, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Nui from '../../util/Nui';

const useStyles = makeStyles(theme => ({
    div: {
        border: `2px solid ${theme.palette.border.divider}`,
        background: theme.palette.secondary.light,
        color: '#fff',
        fontSize: 13,
        height: 84,
        width: '100%',
        textAlign: 'center',
        textDecoration: 'none',
        whiteSpace: 'nowrap',
        verticalAlign: 'middle',
        userSelect: 'none',
        transition: 'filter ease-in 0.15s',
        lineHeight: '38px',
        marginBottom: 5,
        borderRadius: 3,
        padding: '10px 20px',
    },
    item: {
        width: '100%',
        textAlign: 'left',
    },
}));

export default ({ data }) => {
    const classes = useStyles();
    const [value, setValue] = React.useState(data.options.current);

    const handleChange = event => {
        setValue(event.target.value);
        Nui.send('Selected', {
            id: data.id,
            data: { value: event.target.value },
        });
    };

    const cssClass = data.options.disabled
        ? `${classes.div} disabled`
        : classes.div;
    const style = data.options.disabled ? { opacity: 0.5 } : {};

    return (
        <div className={cssClass} style={style}>
            <TextField
                variant="standard"
                className={classes.item}
                select
                disabled={data.options.disabled}
                label={data.label}
                value={value}
                onChange={handleChange}
            >
                {data.options.list.map(option => (
                    <MenuItem
                        key={option.value}
                        value={option.value}
                        selected={false}
                    >
                        {option.label}
                    </MenuItem>
                ))}
            </TextField>
        </div>
    );
};
