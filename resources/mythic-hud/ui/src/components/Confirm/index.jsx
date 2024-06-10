import React from 'react';
import { useSelector } from 'react-redux';
import {
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import useKeypress from 'react-use-keypress';

import Nui from '../../util/Nui';
import { Sanitize } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
    wrapper: {},
    input: {
        marginTop: 15,
    },
}));

export default () => {
    const classes = useStyles();
    const confirm = useSelector((state) => state.confirm);

    const onAccept = () => {
        Nui.send('Confirm:Yes', {
            event: confirm.yes,
            data: confirm.data,
        });
    };

    const onClose = () => {
        Nui.send('Confirm:No', {
            event: confirm.no,
            data: confirm.data,
        });
    };

    useKeypress(['Escape'], () => {
        onClose();
    });

    return (
        <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose}>
            <DialogTitle>{confirm.title}</DialogTitle>
            {Boolean(confirm.description) && (
                <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>
                    {Sanitize(confirm.description)}
                </DialogContent>
            )}
            <DialogActions>
                <Button onClick={onClose} color="error">
                    {confirm.denyLabel ?? 'No'}
                </Button>
                <Button onClick={onAccept} color="success">
                    {confirm.acceptLabel ?? 'Yes'}
                </Button>
            </DialogActions>
        </Dialog>
    );
};
