import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import {
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    TextField,
    Button,
    MenuItem,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import useKeypress from 'react-use-keypress';
import NumberFormat from 'react-number-format';

import Nui from '../../util/Nui';

const useStyles = makeStyles((theme) => ({
    wrapper: {},
    input: {
        '&:first-of-type': {
            marginTop: 15,
        },
        '&:not(:last-of-type)': {
            marginBottom: 15,
        },
    },
}));

export default () => {
    const classes = useStyles();
    const input = useSelector((state) => state.input);

    const onSubmit = (e) => {
        e.preventDefault();

        let res = Object();
        input.inputs.forEach((inp) => {
            res[inp.id] = e.target[inp.id].value;
        });

        Nui.send('Input:Submit', {
            event: input.event,
            values: res,
            data: input.data,
        });
    };
    const onClose = () => {
        Nui.send('Input:Close');
    };

    useKeypress(['Escape'], () => {
        onClose();
    });

    const getInputType = (name, type, options, config) => {
        switch (type) {
            case 'number':
                return (
                    <NumberFormat
                        fullWidth
                        isNumericString
                        id={name}
                        name={name}
                        label={input.label}
                        className={classes.input}
                        customInput={TextField}
                        {...options}
                    />
                );
            case 'multiline':
                return (
                    <TextField
                        autoFocus
                        fullWidth
                        multiline
                        minRows={3}
                        id={name}
                        name={name}
                        label={input.label}
                        className={classes.input}
                        {...options}
                    />
                );
            case 'select':
                return (
                    <TextField
                        select
                        autoFocus
                        fullWidth
                        multiline
                        minRows={3}
                        id={name}
                        name={name}
                        label={input.label}
                        className={classes.input}
                        {...options}
                    >
                        {config.select.map((option) => (
                            <MenuItem key={option.value} value={option.value}>
                                {option.label}
                            </MenuItem>
                        ))}
                    </TextField>
                );
            case 'text':
            default:
                return (
                    <TextField
                        autoFocus
                        fullWidth
                        id={name}
                        name={name}
                        label={input.label}
                        className={classes.input}
                        {...options}
                    />
                );
        }
    };

    if (!input.showing) return null;
    return (
        <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose}>
            <form onSubmit={onSubmit}>
                <DialogTitle>{input.title}</DialogTitle>
                <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>
                    {input.inputs.map((inp) => {
                        return getInputType(inp.id, inp.type, inp.options, inp);
                    })}
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="inherit">
                        Cancel
                    </Button>
                    <Button type="submit">Submit</Button>
                </DialogActions>
            </form>
        </Dialog>
    );
};
